package cubox.admin.schedule.service.impl;

import java.util.Map;

import javax.annotation.Resource;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Service;

import cubox.admin.schedule.dao.ScheduleDAO;
import cubox.admin.schedule.service.ScheduleService;

@Service("ScheduleService")
public class ScheduleServiceImpl implements ScheduleService {

	@Resource(name = "scheduleDAO")
	private ScheduleDAO scheduleDAO;
	
	private static final Logger LOGGER = LoggerFactory.getLogger(ScheduleServiceImpl.class);
	
	@Override
	public int insertStatCrttDay(Map<String, String> param) throws Exception {
		return scheduleDAO.insertStatCrttDay(param);
	}
	
	@Override
	public int insertStatCrttGrDay(Map<String, String> param) throws Exception {
		return scheduleDAO.insertStatCrttGrDay(param);
	}
	
	@Override
	public int insertStatGlryDay(String sBaseDe) throws Exception {
		return scheduleDAO.insertStatGlryDay(sBaseDe);
	}
	
}
