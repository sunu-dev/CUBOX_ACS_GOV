package cubox.admin.schedule.dao;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository
public class ScheduleDAO extends EgovAbstractMapper {
	
	public int insertStatCrttDay(String sBaseDe) throws Exception {
		return insert("schedule.insertStatCrttDay", sBaseDe);
	}
	
	public int insertStatGlryDay(String sBaseDe) throws Exception {
		return insert("schedule.insertStatGlryDay", sBaseDe);
	}	
}
