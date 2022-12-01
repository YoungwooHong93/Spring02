<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<html>
<head>
	<title>Home</title>
	<link rel="stylesheet" type="text/css" href="resources/myLib/myStyle.css">
</head>
<body>
<h1>Hello Spring !!!</h1>
<P>  The time on the server is ${serverTime}. </P>
<hr>
<c:if test="${not empty loginID}">
=> ${loginName} 님 안녕하세요 !!! <br>
</c:if>
<c:if test="${not empty message}">
=> ${message}<br>
</c:if>
<hr>
<img alt="main" src="resources/images/tulips.png" width="300" height="200">
<hr>
<!-- Login 전 --> 
<c:if test="${empty loginID}">
	&nbsp;<a href="loginf">LoginF</a>
	&nbsp;&nbsp;<a href="joinf">JoinF</a>
</c:if>
<!-- Login 후  -->
<c:if test="${not empty loginID}">
	&nbsp;<a href="logout">Logout</a>
	&nbsp;&nbsp;<a href="mdetail">내정보보기</a>
	&nbsp;&nbsp;<a href="mdetail?jCode=U">내정보수정</a>
	&nbsp;&nbsp;<a href="mdelete">회원탈퇴</a>
</c:if>
<br>
&nbsp;<a href="mlist">memberList</a>
&nbsp;&nbsp;<a href="mcrilist">MCriList</a>
&nbsp;&nbsp;<a href="blist">boardList</a>
&nbsp;&nbsp;<a href="bcrilist">BCriList</a>
&nbsp;&nbsp;<a href="jlist">joList</a><br>

&nbsp;<a href="axTestForm">AjaxTest</a>
&nbsp;&nbsp;<a href="bcrypt">Bcrypt</a>
&nbsp;&nbsp;<a href="calendarMain">FullCalendar</a>
&nbsp;&nbsp;<a href="mchecklist">mCheck</a>
&nbsp;&nbsp;<a href="bchecklist">bCheck</a><br>
&nbsp;<a href="greensn">GreenSN</a>
&nbsp;&nbsp;<a href="greenall">GreenAll</a>
&nbsp;&nbsp;<a href="jeju">JeJu</a>
&nbsp;&nbsp;<a href="gps">GPS</a><br>
&nbsp;<a href="echo">WS_Echo</a>
&nbsp;&nbsp;<a href="chat">WS_Chat</a>
&nbsp;&nbsp;<a href="log4jTest">log4jTest</a>
<!-- ** 공공DB 사용 Test  ** -->
&nbsp;&nbsp;<a href="gong">GongGong</a><br>

<!-- * 계층적 uri & viewName 생략 Test * 
		-> 요청명 : green/member/list  
		-> Test Controller : MemberController2.java -->
&nbsp;<a href="member/list">MemberList2</a>
<!-- 요청명 : green/member/list -->	
&nbsp;&nbsp;<a href="member/memberList2">vName생략1</a>
&nbsp;&nbsp;<a href="member/loginFormTest">vName생략2</a><br>

&nbsp;<a href="etest">Exception</a>

</body>
</html>
