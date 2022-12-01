<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    

<html>
<head>
<title>** kakao_Map 01 **</title>
<style type="text/css">
	span { color: blue;
	 }
</style>
<script src="resources/myLib/jquery-3.2.1.min.js"></script>
	
<!--
** Kakao맵 API키 발급받기
=> 참고  https://apis.map.kakao.com/web/guide/
=> 참고  https://aljjabaegi.tistory.com/421
=> 카카오 개발자 페이지로 이동  : https://developers.kakao.com/

=> 회원가입(kakao 계정으로 kakao developers 에 가입), 로그인, 앱 만들기 , 
   -> 앱키 받고 (Javascript 키 copy 하기) , 
   -> 플랫폼 등록 (왼편메뉴의 앱키 아랫쪽에 있음 : http://localhost:8080 )
=> Javascript 키 : dd110a227c3d8de36931003064d64525 (적용)

=> http://apis.map.kakao.com/web/sample/ 
=> 객체및 사용법 안내 : https://apis.map.kakao.com/web/documentation/
-->	
<script type="text/javascript" 
	    src="//dapi.kakao.com/v2/maps/sdk.js?appkey=dd110a227c3d8de36931003064d64525&libraries=services">
</script>	

</head>
<body>
<h2>Welcome! 그린컴퓨터아카데미 </h2>
<font color="gray"><b>성남시 분당구 구미동 7-2(돌마로 46) 5층, 대표번호: 031.712.7447</b></font><br>
<br>
<div id="map" style="width:90%;height:60%;"></div><br>

<script>
//이 스크립트는 BODY 영역에 작성 한다. 

// 1) 기본값 초기화
var mapContainer = document.getElementById('map'), // 지도를 표시할 div 
	mapOption = {
    	center: new kakao.maps.LatLng(33.450701, 126.570667), // 지도의 중심좌표
    	level: 3 
    	// 지도의 확대 레벨 : 0~14 정수이며, 작을수록 확대되어보임 (클수록 넓은범위 표시됨) 
		};  
//lat : 위도(latitude) , lng [long] : 경도(longitude)

// 2) 지도를 생성합니다    
var map = new kakao.maps.Map(mapContainer, mapOption); 
 
// 3) 주소-좌표 변환 객체를 생성합니다
var geocoder = new kakao.maps.services.Geocoder();
//coordinate [coords]
//:  1.조직, 편성하다  2.(몸의 움직임을) 조정하다 
//   3.(옷차림가구 등) 꾸미다[코디하다], 잘 어울리다[조화되다]
//   4.수학 에서 좌표		

//주소로 좌표를 검색합니다
//제주특별자치도 제주시 첨단로 242 : KaKaoMap    
//경기 용인시 기흥구 민속촌로 90 : 용인 민속촌 
//경기 성남시 분당구 돌마로 46  :  그린 컴퓨터아카데미 , GreenComputer
//경기 성남시 분당구 금곡동 167 이코노샤르망 5층 : 그린_별관 , (이코노샤르망 5층) 
var address = '경기 성남시 분당구 돌마로 46' ;
var description = 'GreenComputer' ; // description: 설명,묘사
 
// geocoder.addressSearch(address, function(result, status) { ..});
geocoder.addressSearch(address, function(result, status) { 
	// 정상적으로 검색이 완료됐으면
	if (status === daum.maps.services.Status.OK) { 
		
		var coords = new daum.maps.LatLng(result[0].y, result[0].x);  
		// 결과값으로 받은 위치를 마커로 표시합니다
		var marker = new daum.maps.Marker({ map: map, position: coords }); 
		// 인포윈도우로 장소에 대한 설명을 표시합니다 
		var infowindow = new daum.maps.InfoWindow({ 
			//content: description });
			content: '<div style="width:150px;text-align:center;padding:6px 0;">'+description+'</div>' }); 
		infowindow.open(map, marker); 
		// 지도의 중심을 결과값으로 받은 위치로 이동시킵니다 
		map.setCenter(coords); 
	} // if
	}); // addressSearch
 </script>
<hr><br>
<a href="home">[HOME]</a>

</body>
</html>
