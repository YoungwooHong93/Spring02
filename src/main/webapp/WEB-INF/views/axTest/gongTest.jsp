<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>Spring_Mybatis MemberList</title>
</head>
<body>
<h3>** 공공자료 활용 : 성남사랑상품권 판매 현황 **</h3>
<br>
<c:if test="${not empty message}">
=> ${message}<br>
</c:if>
<hr>
<table width=100%>
<tr height="30" bgcolor="pink">
	<th>yyyyMm</th><th>guNm</th><th>admiNm</th><th>marketNm</th>
	<th>upjongNm</th><th>saleCnt</th><th>saleAmt</th>
</tr>	
<%-- <c:forEach var="list" items="${data}"> => JSON배열 OK --%>
<c:forEach var="list" items="${list}">
<tr  height="30" align="center">
	
	<td>${list.yyyyMm}</td><td>${list.guNm}</td><td>${list.admiNm}</td><td>${list.marketNm}</td>
	<td>${list.upjongNm}</td><td>${list.saleCnt}</td><td>${list.saleAmt}</td>
	 
</tr>
</c:forEach>
</table>
<hr>
<a href='javascript:history.go(-1)'>이전으로</a>&nbsp;&nbsp;
<a href="home" >[Home]</a>

</body>
</html>