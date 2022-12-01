<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%-- <%@ taglib uri="http://www.springframework.org/security/tags" prefix="s" %> --%>
<html>
<head>
<meta charset="UTF-8">
<%--
<s:csrfMetaTags/>
 ** Spring Security 적용에 따른 Post 요청시 csrf 처리 
 	=> meta Tag 에 csrf값 정의 _ <s:csrfMetaTags 는 아래 구문을 대신  
		<meta name="_csrf_header" content="${_csrf.headerName}"/> 
		<meta name="_csrf" content="${_csrf.token}"/>  
 	=> Srcipt 에서 csrf 값을 전역으로 받고
 	=> 각 Post 요청전에 beforeSend 에서 처리함  --%>
  
<title>** JQuery FullCalendar Test **</title>

<script src="resources/myLib/jquery-3.2.1.min.js"></script>

<link href='resources/myLib/fcLib/fullcalendar.min.css' rel='stylesheet' />
<link href='resources/myLib/fcLib/fullcalendar.print.min.css'
	rel='stylesheet' media='print' />

<script src='resources/myLib/fcLib/moment.min.js'></script>
<script src='resources/myLib/fcLib/fullcalendar.min.js'></script>
<!-- 한글화 위해 추가 -->
<script src='resources/myLib/fcLib/ko.js'></script>
<script src='resources/myLib/fcLib/jquery.bpopup.min.js'></script>
<link
	href="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/css/bootstrap.min.css"
	rel="stylesheet" id="bootstrap-css">
<script
	src="//maxcdn.bootstrapcdn.com/bootstrap/4.1.1/js/bootstrap.min.js"></script>

<script>

//var csrf = $("meta[name='_csrf']").attr("content");
//var csrfHeader = $("meta[name='_csrf_header']").attr("content");
// csrfHeader =>X-CSRF-TOKEN
// csrf =>db1f4412-5ce3-4890-baba-d56160d571f2  

$(document).ready(function() {
 	var test=[];
 	// 배열이름.push(값); -> 값을 배열 끝에 밀어넣음
 	// => body 하단에 hidden 으로 숨겨놓은 DB 에서 읽어온 Data (calendar Table)  를 배열에 담기
 	for(var i=0, test=[]; i<'${size}'; i++){
		test.push({  
					id:i,
					title:$('#title'+i).val(),
					start:$('#start_date'+i).val(),
					end:$('#end_date'+i).val()
					}); // push 
	}  
	
	$('#calendar').fullCalendar({
		header: {
			left: 'prev,next today',
			center: 'title',
			right: 'month,agendaWeek,agendaDay,listWeek'
		},
 		//defaultDate: '2020-08-02',
		navLinks: true, // can click day/week names to navigate views
		editable: true,
		eventLimit: true, // allow "more" link when too many events
		locale: "ko",
		//defaultView: "basicWeek", // 주간
		defaultView: "month",// 월간->디폴트값
		//defaultView: "listWeek", // 주간리스트
		events: test,
		// => 배열 test 의 Data(즉 일정)를 화면에 그려주는 function()
		//    실제 end (end_date) 보다 하루 적게 그려짐
		
		//드래그 & 드롭 : 일정 수정
 		eventDrop: function(event, delta, revertFunc){
 			
 			var calendar_start_date = event.start.format();
 			var calendar_end_date = event.end.format();
 			
 			calendar_start_date = timeTrunc(calendar_start_date) ;
 			calendar_end_date = timeTrunc(calendar_end_date) ;
 			
			$.ajax({
				type: 'POST',
				url: "calendarUpdate",
				data: {
					caid: $("#caid").html(),
					title: event.title, 
					start_date: calendar_start_date, 
					end_date: calendar_end_date
					},
				//cache: false;	//ajax로 통신 중 cache가 남아서 갱신된 데이터를 받아오지 못할 경우 사용
				//async: false;	//false로 선언시 ajax결과값이 끝난 다음에 함수가 진행됨
				/* beforeSend: function(xhr) {
					xhr.setRequestHeader(csrfHeader, csrf);
				}, */
				success: function (data) {
					closeMessage('winAlert');
					if (data.fCode=='200' ) {
						  alert('Update 되었습니다.');
					}else if (data.fCode=='201' ) {
						  alert('Update 오류 !!!');
					}else alert('~~ 로그인  후 다시 하세요 ~~ ') ;
					location.href = 'http://localhost:8080/green/calendarMain';
				} // success
			}) // ajax
		},	// eventDrop  
	
		// ** 일정 삭제
		eventClick: function(calEvent,jsEvent,view){
			if(!confirm("일정'"+calEvent.title+"'을 삭제하시겠습니까?")){
				return false;
			}
			$.ajax({
				type: 'POST',
				url: "calendarDelete",
				data: {
					caid: $("#caid").html(),
					title: calEvent.title
					/* caid: calEvent.caid -> null  */
					},
				/* beforeSend: function(xhr) {
					xhr.setRequestHeader(csrfHeader, csrf);
					}, */	
				success: function (data) {
					closeMessage('winAlert');
					if (data.fCode=='200' ) {
						  alert('Delete 되었습니다.');
					}else if (data.fCode=='201' ) {
						  alert('Delete 오류 !!!');
					}else alert('~~ 로그인  후 다시 하세요 ~~ ') ;
					location.href = 'http://localhost:8080/green/calendarMain';
				}
			})
		}
    });
}); //ready

/*  ** 일정등록 => 창열기 */
function addSchedule(){ 
	var scheduleContents="";
	scheduleContents +="<div style='width:100%; height:30px;'><div style='width:30%; float:left; padding-left:30px'>일정 명칭</div><div style='width:60%; float:right'><input type='text' id='calendar_title' value=''></div></div>";
	scheduleContents +="<div style='width:100%; height:30px;'><div style='width:30%; float:left; padding-left:30px'>시작 날짜</div><div style='width:60%; float:right'><input type='datetime-local' id='calendar_start_date' value=''></div></div>";
	scheduleContents +="<div style='width:100%; height:30px;'><div style='width:30%; float:left; padding-left:30px'>마침 날짜</div><div style='width:60%; float:right'><input type='datetime-local' id='calendar_end_date' value=''></div></div>";
	scheduleContents +="<div style='width:100%; text-align:center; height:30px; margin-bottom:15px; margin-top:10px'><button onclick= saveSchedule();>저장하기</button></div>";
	openPopup("일정 등록", scheduleContents, 400);
};
// ** 창열기
function openPopup(subject,contents,widths){
	$("#alert_subject").html(subject);
	$("#alert_contents").html(contents);
	openMessage('winAlert',widths)
};

/*  ** 일정등록 => ajax */
function saveSchedule(){
	var calendar_title = $("#calendar_title").val();
	var calendar_start_date = $("#calendar_start_date").val();
	var calendar_end_date = $("#calendar_end_date").val();
	
	// ** DateTime 에서 Time 자르기
	calendar_start_date = timeTrunc(calendar_start_date) ;
	calendar_end_date = timeTrunc(calendar_end_date) ;
	
	console.log("** _start_date =>"+calendar_start_date);
	console.log("** _end_date =>"+calendar_end_date);
	
	var caid = $("#caid").html();
	console.log("** id 확인=>"+caid);
/* 	console.log("** csrf =>"+csrf);
	console.log("** csrfHeader =>"+csrfHeader); */
	
	if(!calendar_title){
		alert("일정 명칭을 입력해 주세요.");
		return false;
	};
	
	if(!calendar_start_date){
		alert("시작 날짜를 입력해 주세요.");
		return false;
	};
	
	if(!calendar_end_date){
		alert("종료 날짜를 입력해 주세요.");
		return false;
	};
	alert("~~ Insert Test~~");
	$.ajax({
		type: 'POST',
		url: "calendarInsert", //저장하기버튼 눌렀을시 이동하는 컨트롤러 주소
		data: {
			caid: caid,
			title: calendar_title,
			start_date: calendar_start_date,
			end_date: calendar_end_date
			},
		cache: false,	//ajax로 통신 중 cache가 남아서 갱신된 데이터를 받아오지 못할 경우 사용
		async: false,	//false로 선언시 비동기식 처리 -> ajax결과값이 끝난 다음에 함수가 진행됨	
/* 		beforeSend: function(xhr) {
			xhr.setRequestHeader(csrfHeader, csrf);
			}, */	
		success: function (data) {
			
			closeMessage('winAlert');
			alert('Insert 처리 확인 data.fCode => '+data.fCode);
			
			if (data.fCode=='200' ) {
				  alert('Insert 처리되었습니다.');
			}else if (data.fCode=='201' ) {
				  alert('Insert 오류 !!!');
			}else alert('~~ 로그인  후 다시 하세요 ~~ ') ;
			location.href = 'http://localhost:8080/green/calendarMain';
		} // success
	}) // ajax
}; //saveSchedule()

function openMessage(IDS,widths){
	$('#'+IDS).css("width",widths+"px");
	$('#'+IDS).bPopup();
};

function closeMessage(IDS){
	$('#'+IDS).bPopup().close();
};

function timeTrunc(d) {
	var date = d.substr(0,10);
	date= date.replace(/-/g, "/");
	return date;
};

</script>
<style>
body {
	margin: 40px 10px;
	padding: 0;
	font-family: "Lucida Grande", Helvetica, Arial, Verdana, sans-serif;
	font-size: 14px;
}

#calendar {
	max-width: 700px; /* calendar의 width 최대값 : 이 범위내에서 100% 자동조절 */
	margin: 0 auto;
}
</style>
</head>
<body>
	<div>
		<!-- * <span id="caid"><s:authentication property="principal.username"/> -->
		 * <span id="caid">${loginID}</span>
		 		, ${loginName} 님의 일정 입니다~~ <br>
	</div>
	<div id='calendar'>
		<div style='float: right'>
			<button onclick="addSchedule()" class="btn btn-info btn-md">일정등록</button>
		</div>
	</div>
	
	<div class="box box-success"
		style="width: 500px; display: none; background-color: white"
		id="winAlert">
		<div class="box-header with-border"
			style="background-color: white; padding-left: 15px">
			<h3 class="box-title" id="alert_subject"
				style="background-color: white"></h3>
		</div>
		<div class="box-body" id="alert_contents"
			style="font-size: 15px; background-color: white"></div>
	</div>
	
	<div>
		<c:forEach var="myplan" items="${logIDcalendar}" varStatus="vs">
			<input type="hidden" id="title${vs.index}" value="${myplan.title}">
			<input type="hidden" id="start_date${vs.index}" value="${myplan.start_date}">
			<input type="hidden" id="end_date${vs.index}" value="${myplan.end_date}">
		</c:forEach>
	</div>
</body>
</html>