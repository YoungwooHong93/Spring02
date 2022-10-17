package service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import mapperInterface.JoMapper;
import vo.JoVO;

@Service
public class JoServiceImpl implements JoService{
	
	@Autowired
	JoMapper mapper;
	
	@Override
	public List<JoVO> selectList() {
		return mapper.selectList();
	}
	
	@Override
	public JoVO selectOne(JoVO vo) {
		return mapper.selectOne(vo);
	}
	
	@Override
	public int jinsert(JoVO vo) {
		return mapper.jinsert(vo);
	}
	
	@Override
	public int jupdate(JoVO vo) {
		return mapper.jupdate(vo);
	}
	
	@Override
	public int jdelete(JoVO vo) {
		return mapper.jdelete(vo);
	}
	
}
