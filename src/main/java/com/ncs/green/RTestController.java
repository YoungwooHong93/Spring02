package com.ncs.green;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.apache.commons.collections.map.HashedMap;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.MediaType;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RestController;

import lombok.extern.log4j.Log4j;
import service.JoService;
import vo.JoVO;
import vo.RestVO;

//** REST API 
//=> REST 방식의 기본사항은 서버에서 순수 데이터만을 전송한다는 점.
//=> 그래서 @Controller 가 아닌 @RestController 사용

//** @Controller 와 @RestController 차이점
//=> @Controller
//	- String Return : View Name 으로 처리됨

//=> @RestController
//	- REST 컨트롤러임을 명시하며, 모든 매핑 메서드의 리턴타입이 기존과는 다르게 처리함을 의미
//	- String Return : 순수한 Data 로 처리됨 

//~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

@RestController
@RequestMapping("/rest")
@Log4j
public class RTestController {
	
	@Autowired
	JoService service;
	
	// ** RestController 의 다양한 Return Type
	// 1) Text Return
	@GetMapping(value="/getText", produces="text/plain; charset=UTF-8")
	// => produces 속성
	//	- 해당 메서드 결과물의 MIME Type을 의미 ( UI Content-Type 에 표시됨 )
	//	- 위처럼 문자열로 직접 지정 할수도 있고, 메서드내의 MediaType 클래스를 이용할 수도 있음
	//  - 필수속성은 아님
	public String getText() {
		
		log.info("** MIME Type: "+MediaType.TEXT_PLAIN_VALUE);
		return "~~ 안녕하세요 ~~ REST API !!! "; 
	} //getText
	
	// ~~ 여기부터는 pom 에 dependency 추가 해야함 ~~~~~~~~~~
	// 2) 사용자 정의 객체 
	// 2.1) 객체 Return1. : produces 지정한 경우
	@GetMapping( value="/getVO1", produces={MediaType.APPLICATION_JSON_VALUE,
											MediaType.APPLICATION_XML_VALUE} )
	// => produces : JSON 과 XML 방식의 데이터를 생성할 수 있도록 설정
	// => 요청 url의 확장자에 따라 다른 타입으로 서비스
	// 	- Test1) 브라우져에서 /rest/getVO1 호출 -> 위 둘중 XML 전송(default) 
	//	- Test2) 브라우져에서 /rest/getVO2.json 호출 -> JSON 전송  
	public RestVO getVO1() {
		return new RestVO(55,"snow","Christmas 조","Merry 성탄 !!!"); 
	} //getVO1
	
	// 2.2) 객체 Return2. : produces 지정하지 않은 경우  
	// => getVO2 , getVO2.json 호출 : 위1 과 동일한 결과  
	@GetMapping( value="/getVO2" )
	public RestVO getVO2() {
		return new RestVO(222,"rain","Christmas 조","Merry 성탄 !!!"); 
	} //getVO2
	
	// 3) Collection Return
	// 3.1) Map 
	// => XML로 Return하는 경우  Key값 주의
	//    UI(브라우져) 에서 Tag명이 되므로 반드시 문자로 한다. 
	//    ( 첫글자 숫자, 특수문자 모두 안됨 주의, 단 json Type 은 무관함 )
	//      -> 222, -Second, 2nd, ..... 등등, 그러나 한글은 허용
	@GetMapping( value="/getMap" )
	public Map<String, RestVO> getMap() {
		Map<String, RestVO> map = new HashMap<>();
		map.put("하나", new RestVO(111,"snow","Christmas 조","Merry 성탄 !!!"));
		map.put("Second", new RestVO(222,"rain","Christmas 조","Merry 성탄 !!!"));
		map.put("Third", new RestVO(333,"rain","Christmas 조","Merry 성탄 !!!"));
		return map; 
	} //getMap	
	
	// 3.2) List
	@GetMapping( value="/getList" )
	public List<JoVO> getList() {
		return service.selectList(); 
	} //getList		
	

} //class
