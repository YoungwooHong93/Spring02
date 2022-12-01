<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>** WebSocket Echo **</title>
<link rel="stylesheet" type="text/css" href="resources/myLib/myStyle.css" >
<script src="resources/myLib/jquery-3.2.1.min.js"></script>
<script src="resources/myLib/axTest01.js"></script>
<script>
$(function() {
	$('#sendBtn').click(function() {
		// WebSocket 을 이용한 서버와의 통신
		// => function 을 만들어 호출.
		sendMessage();
	}); //#sendBtn_click
}); //ready

// ** WebSocket 통신
var wsocket;
function sendMessage() {
	// 1) WebSocket 생성
	// 2) 연결
	// => 생성시 매개변수로 서버 url 지정
	//    프로토콜: ws 일반통신  /  wss 보안통신     
	//    요청명 : ws_echo 요청은 설정화일 에서 처리
	wsocket = new WebSocket("ws://localhost:8080/green/ws_echo");
						// "http://192.168.0.4:8080/green/ws_echo" 
						//  -> 강사 : 객관적으로 user들이 접속할 수 있는 url 로 실행 후 Test
						// "ws://localhost:8080/green/ws_echo"	
						
	// 3) message 서버로 전송 
	// => 웹소켓 open -> 전송
	wsocket.onopen = function() {
		wsocket.send($('#message').val());
	}
	// 4) 응답 ( 담당 메서드에 핸들러 function 지정 _ 이름만 지정하면 됨 )
	wsocket.onmessage = onMessage ;
	// 5) 연결종료 ( 종료시 호출할 function 지정 )
	wsocket.onclose = onClose;
	
} //sendMessage

// 이벤트 핸들러 function 의 첫번째 매개변수는 발생된 이벤트 객체를 전달 
function onMessage(e) {
	var data = e.data ;
	alert(" from Server => "+data);
	wsocket.close();
	// 응답 확인 후 종료 -> 종료 이벤트 발생시 onClose() 호출 됨  
} //onMessage

function onClose() {
	alert("** 연결 종료 **");
} //onClose

</script>
</head>
<body>
	<h2>** WebSocket Echo **</h2>
	<br><br>
	<input type="text" id="message">&nbsp;
	<input type="button" id="sendBtn" value="전송">
	<br><br><hr>
	<a href="home" class="textLink">[HOME]</a>
</body>
</html>