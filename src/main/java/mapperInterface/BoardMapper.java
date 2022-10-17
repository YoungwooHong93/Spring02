package mapperInterface;

import java.util.List;

import criTest.Criteria;
import criTest.SearchCriteria;
import vo.BoardVO;

public interface BoardMapper {
	
	// ** Criteria PageList
	// => ver02
	List<BoardVO> searchList(SearchCriteria cri);
	int searchCount(SearchCriteria cri);
	
	// => ver01
	List<BoardVO> criList(Criteria cri);
	int criTotalCount();
	
	// ** selectList
	List<BoardVO> selectList();
	
	// ** selectOne
	BoardVO selectOne(BoardVO vo);
	
	// ** Insert : 새 게시물 작성
	int insert(BoardVO vo);
	
	// ** Update : 게시물 수정
	int update(BoardVO vo);
	
	// ** Delete : 게시물 삭제
	int delete(BoardVO vo);
	
	// ** CountUp : 조회수 증가
	int countUp(BoardVO vo);
	
	// ** Reply insert : 답글 달기
	int stepUpdate(BoardVO vo);
	int rinsert(BoardVO vo);
	
} //interface
