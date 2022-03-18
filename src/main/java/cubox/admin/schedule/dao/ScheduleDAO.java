package cubox.admin.schedule.dao;

import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository
public class ScheduleDAO extends EgovAbstractMapper {
	
	public int insertStatCrttDay(Map<String, String> param) throws Exception {
		return insert("schedule.insertStatCrttDay", param);
	}
	
	public int insertStatGlryDay(String sBaseDe) throws Exception {
		return insert("schedule.insertStatGlryDay", sBaseDe);
	}	
}
