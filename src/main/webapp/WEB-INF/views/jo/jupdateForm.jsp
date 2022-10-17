<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>** Jo Update Spring_MVC2 **</title>
	<link rel="stylesheet" type="text/css" href="/resources/myLib/myStyle.css">
</head>
<body>
<h2>** Jo Update Spring_MVC2 **</h2>

<form action="jupdate" method="post">
	<table>
		<tr height="40"><td bgcolor="Khaki">Group No</td>
			<td><input type="text" name="jno" value="${apple.jno}" size="20"></td></tr>
								<!-- 서버에서 필요한 정보 -->
		<tr height="40"><td bgcolor="Khaki">I D</td>
			<td><input type="text" name="chief" value="${apple.chief}" size="20"></td></tr>
		<tr height="40"><td bgcolor="Khaki">Title</td> 
			<td><input type="text" name="jname" value="${apple.jname}"></td></tr>
								<!-- 서버에서 필요한 정보 -->
		<tr height="40"><td bgcolor="Khaki">Content</td>
			<td><textarea rows="5" cols="50" name="note" >${apple.note}</textarea></td>
								<!-- 서버에서 필요한 정보 -->
		</tr>
		<tr><td></td>
			<td><input type="submit" value="그룹수정">&nbsp;&nbsp;
				<input type="reset" value="취소">
			</td>
		</tr>
	</table>
</form>	
<c:if test="${not empty message}">
<hr>
${message}<br>
</c:if>
<hr>

&nbsp;&nbsp;<a href="jlist">JoList</a>
&nbsp;&nbsp;<a href="javascript:history.go(-1)">이전으로</a>
&nbsp;&nbsp;<a href="home">[Home]</a>
</body>
</html>