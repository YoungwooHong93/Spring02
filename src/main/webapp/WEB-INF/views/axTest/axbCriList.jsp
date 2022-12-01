<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c" %>    
<!DOCTYPE html>
<html>
<head>
	<meta charset="UTF-8">
	<title>** Ajax Board Cri_PageList **</title>
	<link rel="stylesheet" type="text/css" href="resources/myLib/myStyle.css">
	<script src="resources/myLib/jquery-3.2.1.min.js"></script>
	<script src="resources/myLib/axTest03.js"></script>
	<script>

	$(function() {
		// 1) SearchType 이 '전체' 면 keyword 클리어
		$('#searchType').change(function(){
			if ( $(this).val()=='n' ) $('#keyword').val('');
		}); //change
		
		$('#searchBtn').click(function(){
			let url = "axbcri"
					+"${pageMaker.makeQuery(1)}"
					+"&searchType="
					+$('#searchType').val()
					+"&keyword="
					+$('#keyword').val() ;
			$.ajax({
	 			type:'Get',
	 			url:url,
	 			success:function(resultPage){
	 				$('#resultArea1').html(resultPage);
	 			},
	 			error:function(){
	 				$('#resultArea2').html('~~ 서버 오류 !! 잠시후 다시 하세요 ~~');
	 			}
	 		}); //ajax
		}); //searchBtn_click
		
		$('.atag').click(function(){
			let url = $(this).attr('href');
			$.ajax({
	 			type:'Get',
	 			url:url,
	 			success:function(resultPage){
	 				$('#resultArea1').html(resultPage);
	 			},
	 			error:function(){
	 				$('#resultArea2').html('~~ 서버 오류 !! 잠시후 다시 하세요 ~~');
	 			}
	 		}); //ajax
	 		return false;
		}); //.atag_click
		
	}); //ready	
	</script>  
</head>
<body>
<h3>** Ajax Board Cri_PageList **</h3>
<br>
<c:if test="${not empty message}">
	${message}<br>
</c:if>
<hr>
<div id="searchBar">
	<select name="searchType" id="searchType">
		<!-- <option value="n" selected> 을 조건 (cri.searchType 의 값) 에 따라 작성하기 위한 삼항식 
			=> value="n" : ~~~~.cri.searchType==null ? 'selected':''  첫화면 출력시 초기값 으로 selected
		-->
		<option value="n" ${pageMaker.cri.searchType==null ? 'selected' : ''}>전체</option>
		<option value="t" ${pageMaker.cri.searchType=='t' ? 'selected' : ''}>Title</option>
		<option value="c" ${pageMaker.cri.searchType=='c' ? 'selected' : ''}>Content</option>
		<option value="i" ${pageMaker.cri.searchType=='i' ? 'selected' : ''}>ID(글쓴이)</option>
		<option value="r" ${pageMaker.cri.searchType=='r' ? 'selected' : ''}>RegDate</option>
		<option value="tc" ${pageMaker.cri.searchType=='tc' ? 'selected' : ''}>Title or Content</option>
		<option value="tci" ${pageMaker.cri.searchType=='tci' ? 'selected' : ''}>Title or Content or ID</option>
	</select>
	<input type="text" name="keyword" id="keyword" value="${pageMaker.cri.keyword}">	
	<button id="searchBtn">Search</button>
</div>
<br><hr>
<table width=100%> 
	<tr bgcolor="Gold" height="30">
		<th>Seq</th><th>Title</th><th>I D</th><th>RegDate</th><th>조회수</th>
	</tr>
	<c:if test="${not empty banana}">
		<c:forEach  var="board" items="${banana}" >
		<tr height="30">
			<td>${board.seq}</td>
			
			<td>
				<!-- 답글 등록후 indent 에 따른 들여쓰기 
						=> 답글인 경우에만 적용  -->
				<c:if test="${board.indent > 0}">
					<c:forEach begin="1" end="${board.indent}">
						<span>&nbsp;&nbsp;</span>
					</c:forEach>
					<span style="color:blue">re..</span>
				</c:if>
			
				<!-- 로그인 한 경우에만 title을 클릭하면 content를 볼 수 있도록 함
						=> bdetail 을 실행함 -->
				<c:if test="${not empty loginID}">
					<a href="bdetail?seq=${board.seq}">${board.title}</a>
				</c:if> 
				<c:if test="${empty loginID}">
				    ${board.title}
				</c:if>      
			</td>
			<td>
				<c:if test="${loginID=='admin'}">
					<a href="mdetail?id=${board.id}">${board.id}</a>
				</c:if> 
				<c:if test="${loginID!='admin'}">
				    ${board.id}
				</c:if>
			</td> 
			<td>${board.regdate}</td><td>${board.cnt}</td>
		</tr>	
		</c:forEach>
	</c:if>
</table>
<hr>
<!-- Cri_Page -->
<div align="center">
	<!-- First, Prev -->
	<c:choose>
		<c:when test="${pageMaker.prev && pageMaker.spageNo>1}">
			<a href="axbcri${pageMaker.searchQuery(1)}" class="atag" >FP</a>&nbsp;
			<a href="axbcri${pageMaker.searchQuery(pageMaker.spageNo-1)}" class="atag">&lt;</a>&nbsp;&nbsp; 
			<!-- EL 사용 주의 
				=> EL 은 주석내에 있어도 JSP가 처리하여 변수명등에 오류있으면 500 발생할 수 있음.  
			<a href="bcrilist?currPage=1&rowsPerPage=5">FP</a>&nbsp;   
			-->
		</c:when>
		<c:otherwise>
			<font color="Gray">FF&nbsp;&lt;&nbsp;&nbsp;</font>   
		</c:otherwise>
	</c:choose>	
	<!-- Displag PageNo -->
	<c:forEach  var="i" begin="${pageMaker.spageNo}" end="${pageMaker.epageNo}">
		<c:if test="${i==pageMaker.cri.currPage}">
			<font size="5" color="Orange">${i}</font>&nbsp;
		</c:if>
		<c:if test="${i!=pageMaker.cri.currPage}">
			<a href="axbcri${pageMaker.searchQuery(i)}" class="atag">${i}</a>&nbsp;
		</c:if>
	</c:forEach>
	<!-- Next, Last -->
	<c:choose>
		<c:when test="${pageMaker.next && pageMaker.epageNo>0}">
			<a href="axbcri${pageMaker.searchQuery(pageMaker.epageNo+1)}" class="atag">&nbsp;&gt;</a>  
			<a href="axbcri${pageMaker.searchQuery(pageMaker.lastPageNo)}" class="atag">&nbsp;LP</a> 
		</c:when>
		<c:otherwise>
			<font color="Gray">&nbsp;&gt;&nbsp;LP</font>   
		</c:otherwise>
	</c:choose>
</div>
<hr>
</body>
</html>