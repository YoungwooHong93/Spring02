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

import criTest.Criteria;
import criTest.PageMaker;
import criTest.SearchCriteria;
import service.BoardService;
import vo.BoardVO;

@Controller
public class BoardController {
	// ** 전역변수 활용
	@Autowired
	BoardService service;

	// ** Criteria PageList
	// => ver01 : Criteria cri
	// => ver02 : SearchCriteria cri
	@RequestMapping(value = "/bcrilist")
	public ModelAndView bcrilist(HttpServletRequest request, HttpServletResponse response, 
									ModelAndView mv, SearchCriteria cri, PageMaker pageMaker) {
		// 1) Criteria 처리 
		// => setCurrPage, setRowsPerPage 는 Parameter 로 전달되어,
		//    setCurrPage(..) , setRowsPerPage(..) 는 자동처리됨(스프링에 의해)
		//    -> cri.setCurrPage(Integer.parseInt(request.getParameter("currPage")))
		// => 그러므로 currPage 이용해서 sno, eno 계산만 하면됨
		cri.setSnoEno(); // Criteria Class에 값이 저장되어 있음
		
		// ** ver02
		// => SearchCriteria : searchType, keyword 는 Parameter로 전달되어 자동으로 set 처리 됨.
		
		
		// 2) 서비스 처리
		// => List 처리
		//mv.addObject("banana", service.criList(cri)); // ver01
		mv.addObject("banana", service.searchList(cri)); // ver02
		
		// 3) View 처리 => PageMaker
		pageMaker.setCri(cri);
		//pageMaker.setTotalRowsCount(service.criTotalCount()); // ver01 : 전체 Rows의 갯수
		pageMaker.setTotalRowsCount(service.searchCount(cri)); 	// ver02 : 조건과 일치하는 Rows의 갯수
		mv.addObject("pageMaker", pageMaker);
		
		
		mv.setViewName("/board/bCriList");
		return mv;
	}

	// ** BoardList
	@RequestMapping(value = "/blist")
	public ModelAndView blist(HttpServletRequest request, HttpServletResponse response, ModelAndView mv) {
		// ** BoardList

		List<BoardVO> list = new ArrayList<BoardVO>();
		list = service.selectList();
		if ( list!=null ) {
			mv.addObject("banana", list); //  request.setAttribute(..) 구문과 동일
		}else {
			mv.addObject("message", "~~ 출력 자료가 없습니다 ~~");
		}
		mv.setViewName("/board/boardList");
		return mv;
	}

	// ** BoardDetail
	// => 글 내용 확인, 글 수정화면 요청시 (jCode=U&seq=...)
	// => 조회수 증가
	//  - 증가조건 : 글보는이(loginID)와 글쓴이가 다를때 && jCode!=U
	//  - 증가메서드: DAO, Service 에 countUp 메서드 추가
	//  - 증가시점 : selectOne 성공후	
	@RequestMapping(value = "/bdetail")
	public ModelAndView bdetail(HttpServletRequest request, HttpServletResponse response, BoardVO vo, ModelAndView mv) {
		// 1. 요청 분석
		String uri = "/board/boardDetail";

		// 2. Service 처리
		vo = service.selectOne(vo);
		if( vo != null ) {
			// 2.1) 조회수 증가
			String loginID = (String)request.getSession().getAttribute("loginID");
			if ( !vo.getId().equals(loginID) && !"U".equals(request.getParameter("jCode")) ) {
				// => 조회수 증가
				if ( service.countUp(vo) > 0 ) vo.setCnt(vo.getCnt()+1);
			} // if_증가조건

			// 2.2) 수정요청 확인
			if ( "U".equals(request.getParameter("jCode")))
				uri = "/board/bupdateForm";

			// 2.3) 결과 전달
			mv.addObject("apple", vo);

		} else mv.addObject("message", "해당 번호의 게시물이 존재하지 않습니다.");

		mv.setViewName(uri);
		return mv;
	} //bdetail

	// ** InsertF : 새글등록
	@RequestMapping(value = "/binsertf")
	public ModelAndView binsertf(HttpServletRequest request, HttpServletResponse response, ModelAndView mv) {
		mv.setViewName("/board/bInsertForm");
		return mv;
	}

	@RequestMapping(value="/binsert", method=RequestMethod.POST)
	// => 매핑네임과 method 가 일치하는 요청만 처리함
	public ModelAndView binsert(HttpServletRequest request, 
			HttpServletResponse response, ModelAndView mv, BoardVO vo, RedirectAttributes rttr) {
		// 1. 요청분석
		// => insert 성공 : blist (redirect 요청 해야함, message 도 전달)
		// => insert 실패 : bInsertForm.jsp
		String uri = "redirect:blist";

		// 2. Service 처리
		if ( service.insert(vo) > 0 ) {
			rttr.addFlashAttribute("message", "새 게시물 등록 성공.");
		} else {
			mv.addObject("message", "새 게시물 등록 실패. 다시 시도하세요.");
			uri = "/board/bInsertForm";
		}

		// 3. 결과(View -> forward) 처리
		mv.setViewName(uri);
		return mv;
	} //binsert

	// ** Update : 게시물 수정하기
	@RequestMapping(value="/bupdate", method=RequestMethod.POST)
	public ModelAndView bupdate(HttpServletRequest request, 
			HttpServletResponse response, ModelAndView mv, BoardVO vo) {
		// 1. 요청분석
		// => 성공 : boardDetail.jsp
		// => 실패 : 재수정 유도 ( bupdateForm.jsp )
		String uri = "/board/boardDetail";
		mv.addObject("apple", vo);
		// => Update 성공/실패 모두 출력시 필요하므로

		// 2. Service 처리
		if ( service.update(vo) > 0 ) {
			mv.addObject("message", "게시물 수정 성공.");
		} else {
			mv.addObject("message", "게시물 수정 실패. 다시 시도하세요.");
			uri = "/board/bupdateForm";
		}
		mv.setViewName(uri);
		return mv;
	}

	// ** Delete : 게시글 삭제
	@RequestMapping(value="/bdelete")
	public ModelAndView bdelete(HttpServletRequest request, HttpServletResponse response, 
			ModelAndView mv, BoardVO vo, RedirectAttributes rttr) {
		// 1. 요청분석
		// => 성공 : redirect:blist
		// 	  실패 : message 표시, redirect:bdetail
		String uri = "redirect:blist";

		// 2. Service 처리
		if ( service.delete(vo) > 0 ) {
			rttr.addFlashAttribute("message", "게시물 삭제 성공.");
		} else {
			rttr.addFlashAttribute("message", "게시물 삭제 실패. 다시 시도하세요.");
			uri = "redirect:bdetail?seq="+vo.getSeq();
		} // Service

		// 3. 결과(ModelAndView) 전달
		mv.setViewName(uri);
		return mv;
	} //bdelete

	// ** Reply_Insert : 답글등록
	@RequestMapping(value = "/rinsertf")
	public ModelAndView rinsertf(HttpServletRequest request, 
			HttpServletResponse response, ModelAndView mv, BoardVO vo) {
		// => vo 에는 전달된 부모글의 root, step, indent 가 담겨있음 
		// => 매핑메서드의 인자로 정의된 vo 는 request.setAttribute 와 동일 scope
		//    단, 클래스명의 첫글자를 소문자로 ...  ${boardVO.root}
		mv.setViewName("/board/rinsertForm");
		return mv;
	}

	@RequestMapping(value="/rinsert", method=RequestMethod.POST)
	public ModelAndView rinsert(HttpServletRequest request, 
			HttpServletResponse response, ModelAndView mv, BoardVO vo, RedirectAttributes rttr) {
		// 1. 요청분석
		// => 성공 : blist
		// 	  실패 : 재입력 유도 (rinsertFrom.jsp)
		// => set vo
		//		- root: 부모와 동일
		//		- step: 부모 step + 1
		//		- indent: 부모 indent + 1
		//		- 그러므로 rinsertFrom 에 부모값을 보관 (hidden으로) 해서 전달받음
		//		  이를 위해 boardDetail 에서 요청시 쿼리스트링으로 전달 -> rinsertf

		String uri = "redirect:blist";
		vo.setStep(vo.getStep()+1);
		vo.setIndent(vo.getIndent()+1);

		// 2. Service 처리
		if ( service.rinsert(vo) > 0 ) {
			rttr.addFlashAttribute("message", "답글 작성 성공.");
		} else {
			mv.addObject("message", "답글 작성 실패. 다시 시도하세요.");
			uri = "/board/rinsertForm";
		}

		// 3. 결과(ModelAndView) 전달
		mv.setViewName(uri);
		return mv;
	} //rinsert



} //class
