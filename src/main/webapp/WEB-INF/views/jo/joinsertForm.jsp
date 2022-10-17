<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>** MakeJo Spring_MVC2 **</title>
	<link rel="stylesheet" type="text/css" href ="resources/mylib/myStyle.css">
</head>
<body>
<h2>** MakeJo Spring_MVC2 **</h2>
<form action="jinsert" method="post">
	<table>
		<tr height="40"><td bgcolor="lightblue">Group No</td>
			<td><input type="text" name="jno" id="jno" size="20"> </td></tr>
		<tr height="40"><td bgcolor="lightblue">Chief</td>
			<td><input type="text" name="chief" id="chief" size="20" placeholder="조장을 입력하세요">
			</td></tr>
		<tr height="40"><td bgcolor="lightblue">Group Name</td>
			<td><input type="text" name="jname" id="jname"></td></tr>
		<tr height="40"><td bgcolor="lightblue">Note</td>
			<td><input type="text" name="note" id="note"></td></tr>
		<tr>
			<td><input type="submit" value="가입">&nbsp;&nbsp;
				<input type="reset" value="취소">
			</td>
		</tr>
	</table>
</form>
<c:if test="${not empty message}">
	<hr>
	${message} <br>
</c:if>
<hr>
&nbsp;&nbsp;<a href="javascript:history.go(-1)">이전으로</a> 
&nbsp;&nbsp;<a href="home">[Home]</a>
</body>
</html>