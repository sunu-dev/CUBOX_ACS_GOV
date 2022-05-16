package cubox.admin.schedule.service;

import java.util.Map;

public interface ScheduleService {
	
	public int insertStatCrttDay(Map<String, String> param) throws Exception;
	public int insertStatCrttGrDay(Map<String, String> param) throws Exception;
	public int insertStatGlryDay(String sBaseDe) throws Exception;

}
