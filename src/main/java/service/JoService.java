package service;

import java.util.List;

import vo.JoVO;

public interface JoService {
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
	
}
