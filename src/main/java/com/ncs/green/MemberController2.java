package com.ncs.green;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.servlet.ModelAndView;

import lombok.extern.log4j.Log4j;
import service.MemberService;
import vo.MemberVO;

//** Test1) 클래스 level 의 @RequestMapping
// => 공통경로(member, board 등) 를 추가하여 요청url 을 계층적으로 적용
//    요청명: "mlist" -> /member/mlist 
// => resources 들의 접근경로가 변경되므로 절대경로로 지정해야함. 
//    resources : /resources/image...
// => 단, 반드시 Tomcat 서버의 루트경로 "/green" 을 "/" 로 변경
//    servers 탭 Server 더블클릭 ->  Modules -> Edit ( Path -> "/" 로 변경 )

//** Test2) mv.setViewName("..") 생략 Test

@RequestMapping(value = "/member") // "/member" 로 시작하는 모든 요청을 처리함.
@Log4j
@Controller
public class MemberController2 {
	
	@Autowired
	MemberService service ;
	
//** Test1) 클래스 level 의 @RequestMapping	
	@RequestMapping(value = "/list")
	//@RequestMapping -> 요청명과 메서드멸 동일한경우 생략가능하다고함 그러나 value 생략시 404 (확인필요함)
	// value = "/member/list" : /member 를 클래스 레벨로 처리함
	public ModelAndView list(ModelAndView mv) {
		
		log.info("** 클래스 level 의 @RequestMapping Test");
		
		List<MemberVO> list = service.selectList();
		if (list != null) mv.addObject("banana", list);
		else mv.addObject("message", "~~ 출력할 자료가 1건도 없습니다 ~~");
		mv.setViewName("member/memberList2");
		return mv;
	} //list
	
// ** Test2) mv.setViewName("..") 생략
// => view 를 지정하지 않은경우 요청명.jsp 를 찾는다
//    단, 폴더 위치를 지정하려면 요청명도 동일한 규칙으로 계층적으로 설계한다. ( member/memberList2 )
// => 아래 "/loginFormTest" 의 경우처럼 굳이 view 에 전달할 정보가 없다면 
//    setviewName 생략하고 return void 가능함.  	
	@RequestMapping(value = "/memberList2")
	public ModelAndView list2(ModelAndView mv) {
		
		List<MemberVO> list = service.selectList();
		if (list != null) mv.addObject("banana", list);
		else mv.addObject("message", "~~ 출력할 자료가 1건도 없습니다 ~~");
		
		// mv.setViewName("member/memberList2");
		// => 생략하면 요청명 ("member/memberList2") 이 viewName 으로 전달됨.
		return mv;
	} //list2
	
	@RequestMapping(value = "/loginFormTest")
	public void loginFormTest() {
		
	} //loginFormTest
	// => member/loginFormTest.jsp 를 찾음
} //class
