<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>** Spring SQLException Message **</title>
<link rel="stylesheet" type="text/css" href="resources/myLib/myStyle.css">
</head>
<body>
<h3>** Spring SQLException Message **</h3>
<h3>처리 도중  SQL Exception이 발생 했습니다 ~</h3>
<h3>exception Message => ${exception.message}</h3>
<%-- <h3>exception ToString => ${exception.toString}</h3>  --%>
<h2>다시 하세요 ~~~~~</h2>
<br><br>
<a href="#" onclick="history.back()">[다시 하기]</a>&nbsp;
<a href="home">[HOME]</a>
</body>
</html>