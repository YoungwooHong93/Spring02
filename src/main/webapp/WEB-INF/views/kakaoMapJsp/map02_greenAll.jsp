<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>** kakaoMap02_여러주소를 좌표로 변환하여 위치와 설명 표시 **</title>
<script src="resources/myLib/jquery-3.2.1.min.js"></script>
<style>
/* ** info Design ** */
.label {margin-bottom: 96px;}
.label * {display:inline-block; vertical-align:middle;}
.label .left {background: url("http://t1.daumcdn.net/localimg/localimages/07/2011/map/storeview/tip_l.png") no-repeat;display: inline-block;height: 20px;overflow: hidden;vertical-align:middle;width: 7px;}
.label .center {background: url(http://t1.daumcdn.net/localimg/localimages/07/2011/map/storeview/tip_bg.png) repeat-x;display: inline-block;height: 20px;font-size: 12px;font-weight:bold;line-height: 12px;}
.label .right {background: url("http://t1.daumcdn.net/localimg/localimages/07/2011/map/storeview/tip_r.png") -1px 0  no-repeat;display: inline-block;height: 20px;overflow: hidden;width: 6px;}
</style>		
</head>
<body>
<h2>** Map Test02 : 주소를 좌표로 변환하여 클릭시 위치와 설명 표시 **</h2>
<br><hr>
<div id="map" style="width:90%;height:400px;"></div>

<script type="text/javascript" 
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=dd110a227c3d8de36931003064d64525&libraries=services">
</script>
<script>
// 이 스크립트는 BODY 영역에 작성 한다. 
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = {
        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };  
// 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

// Test Data -> 주소와 Info
// From DB Data -> json 형태로 전달되면 ${Lemon} 처럼 전달 가능
// var add=${Lemon};
// var addrs = add;

var addrs = [
		{ content:'성남1_본관',  // 마커 롤오버시 표시할 내용
		  addr:'경기 성남시 분당구 구미동 7-2 (돌마로 46) 5층' },
		{ content:'성남2_별관',   
		  addr:'경기 성남시 분당구 금곡동 167 (돌마로 47) 이코노샤르망 5층' },  
		{ content:'강남1',  
		  addr:'서울시 강남구 역삼동 815-4 (강남대로 428) 만이빌딩 4층, 9층' },
		{ content:'강남2',  
		  addr:'서울시 강남구 역삼동 649-14 (테헤란로 119) 대호빌딩 8층' },
		{ content:'수원1',  
		  addr:'경기도 수원시 팔달구 매산로 1가 55-3 (매산로 12-1) 3~4층' },
		{ content:'수원2',   
		  addr:'경기도 수원시 팔달구 매산로1가 11-12, 아이메카빌딩 5층, 11층' },  
		{ content:'안양',   
		  addr:'경기 안양시 만안구 안양 4동 676 - 91 (안양로 303) 안양메쎄타워 2F' }
	];

// 주소-좌표 변환 객체를 생성합니다
var geocoder = new kakao.maps.services.Geocoder();

// 지도의 중심좌표를 표시 위치에 따라 재설정 하기위한 bounds 생성	
var bounds = new kakao.maps.LatLngBounds();	
// lat : 위도(latitude) , lng [long] : 경도(longitude)
// coordinate [coords] :  1.조직, 편성하다  2.(몸의 움직임을) 조정하다 
//                        3.(옷차림가구 등) 꾸미다[코디하다], 잘 어울리다[조화되다]
//                        4.수학 에서 좌표

// 주소를 좌표로 전환하기 
// => geocoder.addressSearch(...) 는 콜백함수를 사용하기 때문에 
//    배열 addrs가 addr 하나의 데이터 속성만 있다면 무관 하지만 
//    위의 경우처럼 content 가 있는경우에는 이 content 값은 마지막 값만 볼수 있게 된다
//    왜냐하면 반복문이 실행되는 동안 콜백 함수는 자신의 매개변수들을 차곡 차곡 보관해 놓고, 
//    반복문이 종료되어 더이상 매개변수가 전달되지 않으면 하나씩 실행이 시작되는 구조 이기 때문에
//    이 상황에서 i 는 마지막 값이고, content 역시 마지막 값이므로... 
// => 해결은 여러가지가 있겠지만, 데이터의 구조와 특징에 따라 구현하는것이 좋을듯
// => https://devtalk.kakao.com/t/addresssearch/44163/4

var total = addrs.length;
var counter = 0;

// Version01 -> i 대신 counter 변수를 사용하여 한번에 처리
// => 오류 : JS 의 콜백함수는 비동기 실행 을 하기 때문에  일정 순서대로 실행되지 않기 때문에
//          content 값의 순서와 다르다.
// => 결론 : DB에 자료를 보관할때 주소와 좌표를 모두 보관해야 정확하게 info를 DB에서 읽어 표시할 수 있다. 
for(var i=0; i<total; i++) {
	var address=addrs[i].addr ;
	geocoder.addressSearch(address, function(result, status) {
		if (status === kakao.maps.services.Status.OK) {
			
			var coords = new kakao.maps.LatLng(result[0].y, result[0].x);
			console.log('i='+i+'yLat[i]='+result[0].y+'xLng[i]='+result[0].x);
			console.log('address='+address);

			var marker = new kakao.maps.Marker({
				map: map,
				position: coords
			}); // marker
			
			// marking 좌표를 포함하도록 영역 정보를 확장한다.
			bounds.extend(coords);
			
			// 인포윈도우로 장소에 대한 설명을 표시합니다 
			//var content = addrs[counter].content;
			/* 인포윈도우 : BigBox 참고
			var content = '<div class ="label"><span class="left"></span><span class="center">'
				+addrs[counter].content+'<br><a href="https://map.kakao.com/link/map/'
				+addrs[counter].content+','+result[0].y+','+result[0].x
				+'" style="color:blue" target="_blank">Click</a></span><span class="right"></span></div>';
			*/
			// 인포윈도우 : info & link
			var content = '<div class ="label"><span class="left"></span><span class="center">'
				+'<a href="https://map.kakao.com/link/map/'
				+addrs[counter].content+','+result[0].y+','+result[0].x
				+'" style="color:blue" target="_blank">'+addrs[counter].content+'</a></span><span class="right"></span></div>';
			// console.log('counter='+counter+'info='+content);
			
			//infowindow.setContent(info);
			// => 전역으로 생성된 하나의 객체에 계속 OverWrite 되어 마지막 값만 표시됨
			//    아래처럼 매번 생성해야 한다.
			/*
			var infowindow = new kakao.maps.InfoWindow({
		        content: content
		        });
			infowindow.open(map,marker);
			*/
			// custom Info Design 을 사용하기 위헤 
			var customOverlay = new kakao.maps.CustomOverlay({
			    position: coords,
			    content: content   
			});
			// 항상 표시
			//customOverlay.setMap(map);
			/*  */
			// 마커에 마우스오버 이벤트를 등록합니다
			kakao.maps.event.addListener(marker, 'mouseover', function() {
			  // 마커에 마우스오버 이벤트가 발생하면 인포윈도우를 마커위에 표시합니다
			    customOverlay.setMap(map);
			});

			// 마커에 마우스아웃 이벤트를 등록합니다
			kakao.maps.event.addListener(marker, 'mouseout', function() {
			    // 마커에 마우스아웃 이벤트가 발생하면 인포윈도우를 제거합니다
				customOverlay.setMap(null);
			});
			
			counter++ ;
			// addressSearch 메서드의 매개변수 callBack 함수 특성상
			// for 구문 밖의 구문이 먼저 실행되기 때문에 메서드 내에서 종료를 확인하고 
			// 아래 구문을 처리 해야 함
			// ( 실행 순서 : for외의 모든 구문 - for 구문 - callBack 함수 )
			// 모든 marking 좌표를 포함하도록 영역을 확장
			if (total===counter) map.setBounds(bounds);
			
		} // if	
	}); // geocoder.addressSearch	
} // for	

/*
// Version02 -> 주소를 좌표로 변환하여 배열에 넣고 처리

var yLat = new Array(); // y 좌표를 담을 배열
var xLng = new Array(); // x 좌표를 담을 배열

for(var i=0; i<total; i++) {
	var address=addrs[i].addr ;
	geocoder.addressSearch(address, function(result, status) {
		if (status === kakao.maps.services.Status.OK) {
			yLat[counter] = result[0].y;
			xLng[counter] = result[0].x;
			console.log("counter=>"+counter+'i='+i+'result[0].y='+result[0].y+'result[0].x='+result[0].x );
			counter++;
			if (total===counter) {
				console.log("** geocoder.addressSearch END **");
				//모든 주소의 좌표가 배열로 옮겨졌으면 지도에 marking 한다. 
				markingMap(); 
			} 
		} // if	
	}); // geocoder.addressSearch	
} // for	

// 지도에 marking
function markingMap() {
//	  console.log("yLat=>"+yLat);
//	  console.log("xLat=>"+xLng);
	for(var i=0; i<total; i++) {
		
		var coords = new kakao.maps.LatLng(yLat[i], xLng[i]);
		console.log('i='+i+'yLat[i]='+yLat[i]+'xLng[i]='+xLng[i]);

		var marker = new kakao.maps.Marker({
			map: map,
			position: coords
		}); // marker
		
		// marking 좌표를 포함하도록 영역 정보를 확장한다.
		bounds.extend(coords);
		// 인포윈도우로 장소에 대한 설명을 표시합니다 
		var info = addrs[i].content;
		console.log('i='+i+'info='+info);
		
		//infowindow.setContent(info);
		// => 전역으로 생성된 하나의 객체에 계속 OverWrite 되어 마지막 값만 표시됨
		//    아래처럼 매번 생성해야 한다.
		var infowindow = new kakao.maps.InfoWindow({
	        content: info });
		infowindow.open(map,marker);
	} // for
	map.setBounds(bounds);
} // function markingMap
*/
</script> 
<br><hr><br>
<a href="home">[HOME]</a>
</body>
</html>