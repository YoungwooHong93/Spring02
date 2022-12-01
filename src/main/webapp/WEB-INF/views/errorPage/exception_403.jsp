<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>** Spring Default Exception Message **</title>
<link rel="stylesheet" type="text/css" href="resources/jqLib/myStyle.css">
</head>
<body>
<h2>** Spring Security Exception Message (403) **</h2>
<br>
<h2> ~~ 당신은 접근 권한이 없습니다 !!! ~~~ </h2>
<h2>exception Message => ${SPRING_SECURITY_403_EXCEPTION.getMessage()}</h2>
<br><br>
<a href="#" onclick="history.back()">[이전으로 돌아가기]</a>&nbsp;
<a href="/green/home">[HOME]</a> 
 <!-- "member/list" , "member/memberList3" 접근하는경우를 위해 절대 경로 사용  -->
</body>
</html>