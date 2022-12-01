<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>  
<%@ taglib uri="http://java.sun.com/jsp/jstl/fmt" prefix="fmt" %> 
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>** kakaoMap03 _ 여러위치 Marking & 설명 **</title>
<script src="resources/myLib/jquery-3.2.1.min.js"></script>
<script type="text/javascript" 
		src="//dapi.kakao.com/v2/maps/sdk.js?appkey=dd110a227c3d8de36931003064d64525&libraries=services">
</script>
<body>
<h2>** Map Test03 : 좌표로 위치와 설명 표시 **</h2>
<br><hr>
<div id="map" style="width:90%;height:400px;"></div>

<script>
// 이 스크립트는 BODY 영역에 작성 한다. 
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
    mapOption = {
        center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
        level: 3 // 지도의 확대 레벨
    };  

// 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 

// 복수개의 마커 와 설명(info)를 위한 Data
var positions = [
		{ content:'<div>카카오</div>',  // 마커 롤오버시 표시할 내용
		  latlng:new kakao.maps.LatLng(33.450705, 126.570677) },
		{ content:'<div>생태연못</div>',
		  latlng:new kakao.maps.LatLng(33.450936, 126.569477) },  
		{ content:'<div>텃밭</div>',
		  latlng:new kakao.maps.LatLng(33.450879, 126.569940) },
		{ content:'<div>근린공원</div>',
		  latlng:new kakao.maps.LatLng(33.451393, 126.570738) },  
	];

// alert('positions.length='+positions.length) ;

//마커 이미지의 이미지 주소입니다
var imageSrc = "http://t1.daumcdn.net/localimg/localimages/07/mapapidoc/markerStar.png"; 

// infoTest 2) 마커에 표시할 인포윈도우 생성 
// => zIndex : z-index 속성값 (jQuery 의 z-index 와 같은효과)
//    관련 함수들 : Marker, InfoWindow, CustomOverlay 에 setZIndex(), getZIndex
//              예) infowindow.setZIndex(3) , infowindow.getZIndex() 등       
var infowindow = new kakao.maps.InfoWindow({ zIndex:1 });  

// 지도의 중심좌표를 표시 위치에 따라 재설정 하기위해 추가	
var bounds = new kakao.maps.LatLngBounds();	

for (var i=0;i<positions.length;i++) {
	
	// 마커 이미지의 이미지 크기 입니다
    var imageSize = new kakao.maps.Size(24, 35); 
 	// 마커 이미지를 생성합니다    
    var markerImage = new kakao.maps.MarkerImage(imageSrc, imageSize); 
	
	// 마커를 생성	
	var marker = new kakao.maps.Marker({
					map: map, //마커를 표시할 지도
					position: positions[i].latlng, //마커위치
					title : positions[i].content, 
					// 마커에 마우스를 올리면 타이틀이 표시됨 -> 그러나 html 적용안됨
			        image : markerImage // 마커 이미지 
					});
	// marker 에 이벤트 등록
	//alert('i='+i+' , content='+positions[i].content) ;
	
	/* // infoTest 1) 무조건 표시 : 마커에 표시할 인포윈도우 생성   
   	var infowindow = new kakao.maps.InfoWindow({
	    	        content: positions[i].content // 인포윈도우에 표시할 내용 : html 적용됨
		    	    }); 
   	infowindow.open(map,marker); */
	
 	// infoTest 2) 마커에 mouseover, mouseout 이벤트 적용  
  	// => 이벤트 리스너로는 mouseover: Opener 와  mouseout: Closer 를 만들어 등록 
    var infoContent=positions[i].content ;
  	kakao.maps.event.addListener(marker,'mouseover',makeOverListener(map,marker,infowindow,infoContent));
  	kakao.maps.event.addListener(marker,'mouseout',makeOutListener(infowindow));
	
  	// 인수로 주어진 좌표를 포함하도록 영역 정보를 확장한다.
	bounds.extend(positions[i].latlng);
  	// bounds.extend(new kakao.maps.LatLng(data[i].y, data[i].x));

}// for

//지도의 중심좌표를 표시 장소를 기준으로 재설정	
map.setBounds(bounds);

// 인포윈도우를 표시하는 함수
function makeOverListener(map,marker,infowindow,infoContent) {
	return function() {
		// 이때 infowindow 는 상단에 전역으로 정의 해 놓음
		infowindow.setContent(infoContent);
		infowindow.open(map,marker);
	};
} // makeOverListener 	
 
//인포윈도우를 닫는 함수
function makeOutListener(infowindow) {
	return function() {
		infowindow.close();
	};
} // makeOverListener 	

</script> 
<br><hr><br>
<a href="home">[HOME]</a>
</body>
</html>