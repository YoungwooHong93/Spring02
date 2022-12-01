<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>** WebSocket Chatting Room **</title>
<link rel="stylesheet" type="text/css" href="resources/myLib/myStyle.css" >
<script src="resources/myLib/jquery-3.2.1.min.js"></script>
<script src="resources/myLib/axTest01.js"></script>
<script>
	var wsocket;
	// ** 서버연결
	function connect() {
		wsocket = new WebSocket("ws://192.168.0.99:8080/green/ws_chat");
							// "ws://localhost:8080/green/ws_chat"
							// "ws://192.168.0.99:8080/green/ws_chat"
							// "http://192.168.0.99:8080/green" 
							// -> 강사 : 객관적으로 user 들이 접속할 수 있는 url 로 실행 후 Test
							
		wsocket.onopen = onOpen;  // 연결시 콜백 함수
		wsocket.onmessage = onMessage; // 서버로부터 메시지 도착시 콜백 함수
		wsocket.onclose = onClose; // 종료시 콜백 함수
	} //connect
	
	// ** 연결종료
	function disConnect() {
		wsocket.close();
	}
	// ** CallBack function 들
	function onOpen() {
		appendMessage("~~ 연결 되었습니다. ~~");
	}
	function onMessage(e) {
		var data = e.data;
		if (data.substr(0, 4)=='msg:') {
			appendMessage(data.substr(4));
		}
	} //onMessage
	function onClose() {
		appendMessage("~~ 연결이 종료되었습니다. ~~");
	}
	// ** 실행 함수들
	function send() {
		wsocket.send("msg:"+$('#nickname').val()+":"+$('#message').val()) ;
		$('#message').val(''); // 전송후 Clear
	}
	function appendMessage(msg) {
		// Message Area 에 Message 를 추가  & scroll 이동
		$('#chatMessage').append(msg+'<br>');
		var caheight = $('#chatArea').height();
		var maxScroll = $('#chatMessage').height() - caheight ;
		$('#chatArea').scrollTop(maxScroll) ;
	} 
	// ** Main Script *****************************
$(function() {
	// ** enter_Key 로도 전송 보내기
	$('#message').keypress(function(event){
		// 입력된 key 확인 
		// => Javascript : event.keyCode , jQuery : event.which
		// => console 출력 결과를 보면 크롬에서는 아무거나 써도 될듯
		//    그러나 브라우져 마다 차이가 있을수 있기 때문에 아래 코드 사용 
		console.log('event.keyCode =>'+event.keyCode+'event.which =>'+event.which);
		var keycode = (event.keyCode ? event.keyCode : event.which);
				    // event.keyCode 가 있으면 event.keyCode 사용, 아니면 event.which 사용
		// enter 키 입력 시 전송 되도록  
		if(keycode == '13'){
			send();	
		}
		event.stopPropagation();
		// 부모 태그로의 이벤트 전파 (Bubble Up) 를 stop 중지 시켜줌
	}); //keypress
	
	$('#enterBtn').click(function(){ connect(); });  
	$('#exitBtn').click(function(){ disConnect(); });  
	$('#sendBtn').click(function(){ send(); });  
	
}); //ready	

</script>

<style>
  #chatArea {
		width: 300px; 
		height:200px;
		overflow-y: auto;
		border: 1px solid green
		}
</style>

</head>
<body>
<h2>** WebSocket Chatting Room **</h2>

I D : <input type="text" id="nickname">
	  <input type="button" id="enterBtn" value="입장하기">
	  <input type="button" id="exitBtn" value="나가기">
	
<h3 style="color:gray">~~~~ Chatting Area ~~~~</h3>	
<div id="chatArea">
	<div id="chatMessage"></div>
</div>
<br>
<input type="text" id="message" size="33">
<input type="button" id="sendBtn" value="전송">
<br><br><hr>

<a href="home" class="textLink">[HOME]</a>
</body>
</html>