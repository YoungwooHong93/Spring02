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

import criTest.PageMaker;
import criTest.SearchCriteria;
import lombok.extern.log4j.Log4j;
import service.BoardService;
import vo.BoardVO;
import vo.MemberVO;

@Log4j
@Controller
public class BoardController {
	
	@Autowired
	BoardService service;
	//BoardService service =  new BoardServiceImpl() ;
	
	@RequestMapping(value="/log4jTest")
	public String log4jTest() {
		// ** @Log4j Test
		// => lombok , log4j  dependency 필요함 (pom.xml 확인)
		// => 로깅레벨 단계 준수함 ( log4j.xml 의 아래 logger Tag 의 level 확인)
		//   TRACE > DEBUG > INFO > WARN > ERROR > FATAL(치명적인)
		//	<logger name="com.ncs.green">
		//		<level value="info" />
		//	</logger>	
		
		log.debug("** @Log4j Test1) debug **") ;
		log.info("** @Log4j Test2) info **") ;
		log.warn("** @Log4j Test3) warn **") ;
		log.error("** @Log4j Test4) error **") ;
    	return "home";
	} //log4jTest
	
	// ** Board Check List ***************************
	// => ver01) UI의 checkbox 를 이용하여 mapper에 반복문 적용하기
	// => ver02) SearchCriteria,  PageMaker 적용하기 
	@RequestMapping(value="/bchecklist")
	public ModelAndView bchecklist(ModelAndView mv, SearchCriteria cri, PageMaker pageMaker) {
		
		// ** Paging 준비
		cri.setSnoEno();
		
		// ** @Log4j 적용 Test
		log.info("\n ** @Log4j 적용 Test => "+cri);
		
		// 1) Check_Box 처리
		// => check 선택이 없는경우 check 는 null 값으로 
		if ( cri.getCheck() !=null && cri.getCheck().length < 1 ) {
			cri.setCheck(null);
		}
		// 2) Service 실행
		// => 선택하지 않은경우, 선택한 경우 모두 mapper 의 Sql 로 처리
		mv.addObject("banana", service.checkList(cri));
		
		// 3) View 처리 => PageMaker
		pageMaker.setCri(cri);
		pageMaker.setTotalRowsCount(service.checkCount(cri));   
		
    	mv.addObject("pageMaker", pageMaker);
		
		mv.setViewName("board/bCheckList");
    	return mv;
	} //bchecklist
	
	// ** Ajax_jsonView_BoardDetail
	@RequestMapping(value="/jsbdetail")
	public ModelAndView jsbdetail(HttpServletResponse response, ModelAndView mv, BoardVO vo) {

		// ** jsonView 사용시 response 의 한글처리
		response.setContentType("text/html; charset=UTF-8");
		
		vo = service.selectOne(vo);
		mv.addObject("content", vo.getContent());
		mv.setViewName("jsonView");
		return mv;
	} //jsbdetail
	
	// ** Ajax_ID_BoardList
	@RequestMapping(value="/aidblist")
	public ModelAndView aidblist(HttpServletRequest request, ModelAndView mv, SearchCriteria cri) {
		// cri.setKeyword(request.getParameter("id"));
		// => ajax 요청시 id 값을 keyword 로 지정하면 자동으로 set cri 되므로 생략가능
		// => SearchCriteria 사용을 위해서는
		//    searchType, keyword, rowsPerPage, 
		//	  currPage: 1  , sno: 0 (MySql) -> default 값 사용하면 됨
		cri.setSearchType("i");
		cri.setRowsPerPage(50);  // Paging 을 적용하지않으므로 넉넉하게 지정함
		
		List<BoardVO> list = new ArrayList<BoardVO>();
    	list = service.searchList(cri);
    	if ( list!=null && list.size()>0 ) {
    		mv.addObject("banana", list);  
    	}else {
    		mv.addObject("message", "~~ 출력 자료가 없습니다 ~~");
    	}
    	mv.setViewName("axTest/axBoardList");
    	return mv;
	} //aidblist
	
	// ** Ajax Board_Cri_List
	@RequestMapping(value="/axbcri")
	public ModelAndView axbcri(HttpServletRequest request, HttpServletResponse response, 
						ModelAndView mv, SearchCriteria cri, PageMaker pageMaker) {
		// 1) Criteria 처리 
		cri.setSnoEno();
		// 2) 서비스처리
		mv.addObject("banana", service.searchList(cri));  
    	// 3) View 처리 => PageMaker
		pageMaker.setCri(cri);
		pageMaker.setTotalRowsCount(service.searchCount(cri));  
    	mv.addObject("pageMaker", pageMaker);
    	
    	mv.setViewName("/axTest/axbCriList");
    	return mv;
	} //axbcri
	
	// ** Ajax_BoardList
	@RequestMapping(value="/axblist")
	public ModelAndView axblist(ModelAndView mv) {
		
		//mv.addObject("banana", service.selectList()); 
		// => list 가 null 인 경우 message 처리를 UI 에서
		
		List<BoardVO> list = new ArrayList<BoardVO>();
    	list = service.selectList();
    	if ( list!=null ) {
    		mv.addObject("banana", list);  // request.setAttribute(...) 와 동일효과
    	}else {
    		mv.addObject("message", "~~ 출력 자료가 없습니다 ~~");
    	}
    	mv.setViewName("axTest/axBoardList");
    	return mv;
	} //axblist
	
	// ** Criteria PageList
	// => ver01 : Criteria cri
	// => ver02 : SearchCriteria cri
	@RequestMapping(value="/bcrilist")
	public ModelAndView bcrilist(HttpServletRequest request, HttpServletResponse response, 
						ModelAndView mv, SearchCriteria cri, PageMaker pageMaker) {
		// 1) Criteria 처리 
		// => setCurrPage, setRowsPerPage 는 Parameter 로 전달되어,
		//    setCurrPage(..) , setRowsPerPage(..) 는 자동처리됨(스프링에 의해)
		//    -> cri.setCurrPage(Integer.parseInt(request.getParameter("currPage")))
		// => 그러므로 currPage 이용해서 sno, eno 계산만 하면됨
		cri.setSnoEno();
		
		// ** ver02
		// => SearchCriteria: searchType, keyword 는 Parameter로 전달되어 자동 set 됨.
		
		// 2) 서비스처리
		// => List 처리
		//mv.addObject("banana", service.criList(cri)); // ver01
		mv.addObject("banana", service.searchList(cri)); // ver02
		    	
    	// 3) View 처리 => PageMaker
		pageMaker.setCri(cri);
		//pageMaker.setTotalRowsCount(service.criTotalCount()); // ver01: 전체 Rows 갯수 
		pageMaker.setTotalRowsCount(service.searchCount(cri));     // ver02: 조건과 일치하는 Rows 갯수 
    	mv.addObject("pageMaker", pageMaker);
    	
    	//System.out.println("*******"+pageMaker);
    	
    	mv.setViewName("/board/bCriList");
    	return mv;
	} //bcrilist
	
	// ** BoardList
	@RequestMapping(value="/blist")
	public ModelAndView blist(HttpServletRequest request, HttpServletResponse response, ModelAndView mv) {
		
		List<BoardVO> list = new ArrayList<BoardVO>();
    	list = service.selectList();
    	if ( list!=null ) {
    		mv.addObject("banana", list);  // request.setAttribute(...) 와 동일효과
    	}else {
    		mv.addObject("message", "~~ 출력 자료가 없습니다 ~~");
    	}
    	mv.setViewName("/board/boardList");
    	return mv;
	}
	
	// ** BoardDetail
	// => 글내용 확인 , 수정화면 요청시 (jCode=U&seq=...)
	// => 조회수 증가
	// 	- 증가조건 : 글보는이(loginID)와 글쓴이가 다를때 && jCode!=U
	//	- 증가메서드: DAO, Service 에 countUp 메서드 추가
	//	- 증가시점 : selectOne 성공후
	@RequestMapping(value="/bdetail")
	public ModelAndView bdetail(HttpServletRequest request, HttpServletResponse response, ModelAndView mv, BoardVO vo) {
		// 1. 요청분석
		String uri = "/board/boardDetail";
		
		// 2. Service 처리
		vo = service.selectOne(vo);
		if ( vo != null ) {
			// 2.1) 조회수 증가
			String loginID = (String)request.getSession().getAttribute("loginID");
			if ( !vo.getId().equals(loginID) && !"U".equals(request.getParameter("jCode")) ) {
				// => 조회수 증가
				if ( service.countUp(vo) > 0 ) vo.setCnt(vo.getCnt()+1); 
			} //if_증가조건
			
			// 2.2) 수정요청 인지 확인
			if ( "U".equals(request.getParameter("jCode")))
				uri = "/board/bupdateForm";
			
			// 2.3)	결과전달		
			mv.addObject("apple", vo);
		}else mv.addObject("message", "~~ 글번호에 해당하는 자료가 없습니다. ~~");
		
		mv.setViewName(uri);
		return mv;
	} //bdetail
	
	// ** Insert : 새글등록
	@RequestMapping(value="/binsertf")
	public ModelAndView binsertf(HttpServletRequest request, HttpServletResponse response, ModelAndView mv) {
		mv.setViewName("/board/binsertForm");
		return mv;
	}
	@RequestMapping(value="/binsert", method=RequestMethod.POST)
	// => 매핑네임과 method 가 일치하는 요청만 처리함
	// => Get 요청시 : 405–허용되지 않는 메소드 (Request method 'GET' not supported)  
	public ModelAndView binsert(HttpServletRequest request, 
			HttpServletResponse response, ModelAndView mv, BoardVO vo, RedirectAttributes rttr) {
	
		// 1. 요청분석
		// => insert 성공 : blist (redirect 요청, message 전달)
		//    insert 실패 : binsertForm.jsp  
		String uri = "redirect:blist";
		// 2. Service 처리
		if ( service.insert(vo)>0 ) {
			rttr.addFlashAttribute("message", "~~ 새글 등록 성공 ~~");
		}else {
			mv.addObject("message", "~~ 새글 등록 실패, 다시 하세요 ~~");
			uri = "/board/binsertForm";
		}
		// 3. 결과(ModelAndView) 전달 
		mv.setViewName(uri);
		return mv;
	} //binsert
	
	// ** Update : 글수정하기
	@RequestMapping(value="/bupdate", method=RequestMethod.POST)
	public ModelAndView bupdate(HttpServletRequest request, HttpServletResponse response, ModelAndView mv, BoardVO vo) {
		// 1. 요청분석
		// => Update 성공: boardDetail.jsp
		//           실패: 재수정 유도 -> bupdateForm.jsp
		String uri = "/board/boardDetail";
		mv.addObject("apple",vo);
		// => Update 성공/실패 모두 출력시 필요하므로
		
		// 2. Service 처리
		if ( service.update(vo) > 0 ) {
			mv.addObject("message", "~~ 글수정 성공 ~~"); 
		}else {
			mv.addObject("message", "~~ 글수정 실패, 다시 하세요 ~~");
			uri = "/board/bupdateForm";
		}
		
		// 3. 결과(ModelAndView) 전달 
		mv.setViewName(uri);
		return mv;
	}
	
	// ** Delete : 글 삭제
	@RequestMapping(value="/bdelete")
	public ModelAndView bdelete(HttpServletRequest request, HttpServletResponse response, 
									ModelAndView mv, BoardVO vo, RedirectAttributes rttr) {
		// 1. 요청분석
		// => Delete 성공: redirect:blist
		//           실패: message 표시, redirect:bdetail
		String uri = "redirect:blist";
		
		// 2. Service 처리
		if ( service.delete(vo) > 0 ) {
			rttr.addFlashAttribute("message", "~~ 글삭제 성공 ~~"); 
		}else {
			rttr.addFlashAttribute("message", "~~ 글삭제 실패, 다시 하세요 ~~");
			uri = "redirect:bdetail?seq="+vo.getSeq();
		} // Service
		
		// 3. 결과(ModelAndView) 전달 
		mv.setViewName(uri);
		return mv;
	} //bdelete

	// ** Reply_Insert : 답글등록
	@RequestMapping(value="/rinsertf")
	public ModelAndView rinsertf(HttpServletRequest request, 
			HttpServletResponse response, ModelAndView mv, BoardVO vo) {
		// => vo 에는 전달된 부모글의 root, step, indent 가 담겨있음 
		// => 매핑메서드의 인자로 정의된 vo 는 request.setAttribute 와 동일 scope
		//    단, 클래스명의 첫글자를 소문자로 ...  ${boardVO.root}
		mv.setViewName("/board/rinsertForm");
		return mv;
	}
	@RequestMapping(value="/rinsert", method=RequestMethod.POST)
	public ModelAndView rinsert(HttpServletRequest request, HttpServletResponse response,
									ModelAndView mv, BoardVO vo, RedirectAttributes rttr) {
		// 1. 요청분석
		// => 성공: blist
		//    실패: 재입력 유도 (rinsertForm.jsp)
		// => set vo
		//		- root: 부모와 동일
		//		- step: 부모 step + 1
		//		- indent: 부모 indent + 1
		//		- 그러므로 rinsertForm 에 부모값을 보관 (hidden으로) 해서 전달받음 
		//		  이를 위해 boardDetail 에서 요청시 퀴리스트링으로 전달 -> rinsertf 
		String uri = "redirect:blist";
		vo.setStep(vo.getStep()+1);
		vo.setIndent(vo.getIndent()+1);
		
		// 2. Service 처리
		if ( service.rinsert(vo)>0 ) {
			rttr.addFlashAttribute("message", "~~ 답글 등록 성공 ~~");
		}else {
			mv.addObject("message", "~~ 답글 등록 실패, 다시 하세요 ~~");
			uri = "/board/rinsertForm";
		}
		
		// 3. 결과(ModelAndView) 전달 
		mv.setViewName(uri);
		return mv;
	} //rinsert	
	
} //class
