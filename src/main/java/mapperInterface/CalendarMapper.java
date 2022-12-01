package mapperInterface;

import java.util.List;

import vo.CalendarVO;

public interface CalendarMapper {
	
	List<CalendarVO> selectList(CalendarVO vo);
	CalendarVO selectOne(CalendarVO vo);
	int insert(CalendarVO vo);
	int update(CalendarVO vo);
	int delete(CalendarVO vo);
	int listCount(CalendarVO vo);

} //interface CalendarMapper
