<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>** LoginForm Spring_MVC2 **</title>
<link rel="stylesheet" type="text/css" href="resources/myLib/myStyle.css">
<script src="resources/myLib/jquery-3.2.1.min.js"></script>
<script src="resources/myLib/inCheck.js"></script>
<script src="resources/myLib/axTest01.js"></script>
<script src="resources/myLib/axTest04.js"></script>
<script>
	let iCheck=false;
	let pCheck=false;
	
	$(function(){
		$('#id').focus();
		// ** ID
		$('#id').keydown(function(e){
			if ( e.which==13 ) {
				e.preventDefault();
				// => form 에 submit 이 있는경우
				// => enter 누르면 자동 submit 발생되므로 이를 제거함
				$('#password').focus();
			}
		}).focusout(function(){    
			iCheck=idCheck();
		}); //id
		
/* 		// ** Password
		$('#password').keydown(function(e){
			if ( e.which==13 ) {
				e.preventDefault();
				$('#password2').focus();
			}
		}).focusout(function(){    
			pCheck=	pwCheck();
		}); //password */
	}); //ready	
	
	function inCheck() {
		if (iCheck==false) { $('#iMessage').html(' id 를 확인하세요 !!');}
		if (pCheck==false) { $('#pMessage').html(' Password 를 확인하세요 !!');}
		
		if ( iCheck && pCheck ) return true; // submit 진행  
		else return false;
	} //inCheck		

</script>
</head>
<body>
<h2>** LoginForm Spring_MVC2 **</h2>
<br>
<form action="login" method="post">
<table>
	<tr><td bgcolor="PaleTurquoise">I D</td>
		<td><input type="text" name="id" id="id" value=""><br>
			<span id="iMessage" class="eMessage" ></span></td></tr>
	<tr><td bgcolor="PaleTurquoise ">Password</td>
		<td><input type="password" name="password" id="password" value=""><br>
 			<span id="pMessage" class="eMessage" ></td></tr>
	<tr><td></td>
		<td><input type="submit" value="Login" onclick="return inCheck()" >&nbsp;&nbsp;
			<input type="reset" value="Reset">&nbsp;&nbsp;
			<span id="axlogin" class="textLink">AxLogin</span>&nbsp;&nbsp;
			<span id="jslogin" class="textLink">JsLogin</span>&nbsp;&nbsp;
			<span id="rsdetail" class="textLink">axRSDetail</span>
		</td>
	</tr> 
</table>
</form><br>
<span id="message"></span><br>
<c:if test="${not empty message}">
<hr>
${message}<br>
</c:if>
<hr>
&nbsp;&nbsp;<a href="javascript:history.go(-1)">이전으로</a>
&nbsp;&nbsp;<a href="home">[Home]</a>
</body>
</html>