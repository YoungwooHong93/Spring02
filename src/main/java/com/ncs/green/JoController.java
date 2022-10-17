package com.ncs.green;

import java.util.ArrayList;
import java.util.List;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.servlet.ModelAndView;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import criTest.SearchCriteria;
import service.JoService;
import service.MemberService;
import vo.JoVO;

// ** Bean 생성하는 @
// Java : @Component
// Spring 세분화 됨
// => @Controller, @Service, @Repository

@Controller
public class JoController {
	// ** 전역변수 활용
	@Autowired
	JoService service;

	@Autowired
	MemberService mservice;

	// ** JoList
	@RequestMapping(value = "/jlist")
	public ModelAndView jlist(HttpServletRequest request, HttpServletResponse response, ModelAndView mv, RedirectAttributes rttr) {
		
		// ** RedirectAttributes 의 addFlashAttribute 로 전달된 값 확인
		// => insert 에서 : rttr.addFlashAttribute("mytest", "addFlashAttribute 메서드 test");
		System.out.println("**** Test => " + rttr.getFlashAttributes());
		System.out.println("**** Test => " + request.getSession().getAttribute("mytest"));
		
		List<JoVO> list = new ArrayList<JoVO>();
		list = service.selectList();
		if ( list!=null ) {
			mv.addObject("banana", list); //  request.setAttribute(..) 구문과 동일
		}else {
			mv.addObject("message", "~~ 출력 자료가 없습니다 ~~");
		}
		mv.setViewName("/jo/joList");
		//return "/member/memberList";
		return mv;
	}

	// ** JoDetail
	// => 아랫쪽에 조원 목록 출력
	// => memjo Table에서 selectOne -> banana
	// => memjo Table에서 조건검색 jno #{jno} -> banana
	@RequestMapping(value = "/jdetail", method = RequestMethod.GET)
	public ModelAndView jdetail(HttpServletRequest request, HttpServletResponse response,
			JoVO vo, ModelAndView mv, SearchCriteria cri) {
		
		// ** 수정 성공후 redirect 요청으로 전달된 경우 message 처리
		if ( request.getParameter("message") != null && 
				request.getParameter("message").length() > 0 )
			mv.addObject("message", request.getParameter("message"));
		System.out.println("*** jno 전달 확인 => "+vo.getJno());
		System.out.println("*** jname 전달 확인 => "+vo.getJname());
		
		// 1. 요청분석
		String uri = "/jo/joDetail";

		// 2. Service 처리
		vo = service.selectOne(vo);
		if (vo != null ) {
			// 2.1) 수정요청 인지 확인
			if ( "U".equals(request.getParameter("jCode")))
				uri = "jo/jupdateForm";
			else {
				// 조원 목록 불러오기
				// => 조별로 조회가 가능한 searchList 메서드를 활용함
				//	  1 Page 만 있으면 되므로 기본값을 지정함.
				//	  단, RowsPerPage 는 현재 Paging 을 하지 않기때문에 큰 값 지정.
				cri.setRowsPerPage(30); // 현재 Paging 은 하지 않기때문에 큰 값을 지정함.
				cri.setCurrPage(1);
				cri.setSnoEno();
				cri.setKeyword(Integer.toString(vo.getJno()));
				cri.setSearchType("j");
				mv.addObject("banana", mservice.searchList(cri));
			} 

			// 2-2) 결과 전달
			mv.addObject("apple", vo);
		} else
			mv.addObject("message", "** 조 번호에 해당하는 자료가 없습니다 "); 
		mv.setViewName(uri);
		return mv;
	}

	// ** Join : 그룹생성
	@RequestMapping(value = "/jinsertf")
	public ModelAndView joinf(HttpServletRequest request, HttpServletResponse response, ModelAndView mv) {
		mv.setViewName("/jo/joinsertForm");
		return mv;
	}

	@RequestMapping(value="/jinsert", method=RequestMethod.POST)
	// => 매핑네임과 method 가 일치하는 요청만 처리함
	public ModelAndView jinsert(HttpServletRequest request, 
			HttpServletResponse response, ModelAndView mv, JoVO vo, RedirectAttributes rttr) {
		// 1. 요청분석
		// => insert 성공 : jlist (redirect 요청 해야함, message 도 전달)
		// => insert 실패 : jinsertForm.jsp
		String uri = "redirect:jlist";

		// 2. Service 처리
		if ( service.jinsert(vo) > 0 ) {
			rttr.addFlashAttribute("message", "새 그룹 생성 성공.");
		} else {
			mv.addObject("message", "새 그룹 생성 실패. 다시 시도하세요.");
			uri = "/jo/joinsertForm";
		}

		// 3. 결과(View -> forward) 처리
		mv.setViewName(uri);
		return mv;
	} //join

	// ** Update : 조 정보 수정하기
	@RequestMapping(value="/jupdate", method=RequestMethod.POST)
	public ModelAndView jupdate(HttpServletRequest request, 
			HttpServletResponse response, ModelAndView mv, JoVO vo) {
		// 1. 요청분석
		// => 성공 : 내정보 표시 ( joDetail.jsp )
		// => 실패 : 재수정 유도 ( jupdateForm.jsp )
		String uri = "redirect:jdetail"; // ver02
		
		// ** Spring 의 redirect
		// => mv.addObject 에 보관한 값들을 쿼리스트링의 parameter로 붙여 전달해줌.
		//	  그러므로 전달하려는 값들을 mv.addObject 로 처리하면 편리.
		//	  단, 브라우저 주소창에 보여지는것은 단점.
		
		//String uri = "redirect:jdetail?jno="+vo.getJno(); // ver01
		// 단, 위 처럼 redirect 에서 parameter를 사용하여 전달하면서 RedirectAttribute rttr 사용 시 오류 발생
		// jdetail 메서드의 매개변수에서 vo로 전달된 parameter 를 받는 경우에 오류 발생함.
		// vo로 받지않는 경우에는 쿼리스트링으로 전달하면서 RedirectAttribute rttr 사용 가능함.
		
		// ** RedirectAttributes : Redirect 할 때 파라메터를 쉽게 전달할 수 있도록 지원함.
		// => addAttribute : URL에 파라메터가 붙어 전달되게 된다. 
		//    				 그렇기 때문에 전달된 페이지에서 파라메터가 노출됨.
		// => addFlashAttribute : Redirect 동작이 수행되기 전에 Session에 값이 저장되고 전달 후 소멸된다.
		//    					  Session을 선언해서 집어넣고 사용 후 지워주는 수고를 덜어준다.
		//						( insert 성공 후 redirect:jlist 에서 Test ) 
		
		mv.addObject("apple", vo);
		// => Update 성공/실패 모두 출력시 필요하므로

		// 2. Service 처리
		if ( service.jupdate(vo) > 0 ) {
			//rttr.addFlashAttribute("message", "~~ 조 수정 성공 ~~"); 
			mv.addObject("jno", vo.getJno());
			mv.addObject("jno", vo.getJname());
			mv.addObject("message", "그룹정보 수정 성공.");
		} else {
			mv.addObject("message", "그룹정보 수정 실패. 다시 시도하세요.");
			uri = "/jo/jupdateForm";
		}
		mv.setViewName(uri);
		return mv;
	}

	// ** Delete : 회원탈퇴
	@RequestMapping(value="/jdelete")
	public ModelAndView jdelete(HttpServletRequest request, HttpServletResponse response, 
			ModelAndView mv, JoVO vo, RedirectAttributes rttr) {
		// 1. 요청분석
		// => 성공 : session 무효화, message 표시, home.jsp
		// 	  실패 : message 표시, home.jsp
		// => 삭제대상 확인 : 본인 loginID or 관리자가 삭제 하는경우 (request.getParameter..)

		String uri = "redirect:jlist";

		// 2. Service 처리
		if ( service.jdelete(vo) > 0 ) {
			rttr.addFlashAttribute("message", "그룹 삭제 성공.");
		} else {
			rttr.addFlashAttribute("message", "그룹 탈퇴 실패. 다시 시도하세요.");
			uri = "redirect:jdetail?jno="+vo.getJno();
		} // Service

		// 3. 결과(ModelAndView) 전달
		// => 성공 & 실패 둘다 redirect home 으로 설정이 바람직함. (단, message 처리 주의)
		// => 웹브라우저 주소창의 주소가 home 이 표시 되도록 하기 위해.
		mv.setViewName(uri);
		return mv;
	}

} //class
