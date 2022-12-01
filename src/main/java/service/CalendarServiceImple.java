package service;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import mapperInterface.CalendarMapper;
import vo.CalendarVO;

@Service("calendar")
public class CalendarServiceImple implements CalendarService{
	@Autowired
	private CalendarMapper dao;

	@Override
	public List<CalendarVO>selectList(CalendarVO vo){
		return dao.selectList(vo);
	}
	
	@Override
	public int listCount(CalendarVO vo) {
		return dao.listCount(vo);
	}

	@Override
	public CalendarVO selectOne(CalendarVO vo) {
		return dao.selectOne(vo);
	}

	@Override
	public int insert(CalendarVO vo) {
		return dao.insert(vo);
	}

	@Override
	public int update(CalendarVO vo) {
		return dao.update(vo);
	}

	@Override
	public int delete(CalendarVO vo) {
		return dao.delete(vo);
	}
} // class
