package mapperInterface;

import java.util.List;

import vo.JoVO;

public interface JoMapper {
	// ** selectList
	List<JoVO> selectList();
	
	// ** selectOne
	JoVO selectOne(JoVO VO);
	
	// ** Insert
	int jinsert(JoVO vo);
	
	// ** Update
	int jupdate(JoVO vo);
	
	// ** Delete
	int jdelete(JoVO vo);
	
} // interface
