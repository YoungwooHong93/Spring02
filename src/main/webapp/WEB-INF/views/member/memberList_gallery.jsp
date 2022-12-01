<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Spring_Mybatis MemberList</title>
<style>
#imageList {
 	width: 200px;
	height:300px; 
	float: left;
}

#test {
	position:relative;
	top: 10px;
}
</style>

</head>
<body>
<h3>** Spring_Mybatis MemberList _ 갤러리형식 **</h3>
<br>
<c:if test="${not empty message}">
=> ${message}<br>
</c:if>
<hr>
<div id=test>
	<a href='javascript:history.go(-1)'>이전으로</a>&nbsp;&nbsp;
	<a href="home" >[Home]</a>
</div>
<br><hr>
<div>	
<c:forEach var="list" items="${banana}">
	<div id=imageList>
		<a href="mdetail?id=${list.id}"><img src="${list.uploadfile}" width="150" height="200"></a><br>
		${list.id}, ${list.name}<br>
		제조일자: ${list.birthd}<br>
		가격: ${list.point}<br>
		<hr>
	</div>
</c:forEach>
</div>
</body>
</html>