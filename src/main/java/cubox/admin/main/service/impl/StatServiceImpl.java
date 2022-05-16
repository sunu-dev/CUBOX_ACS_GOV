package cubox.admin.main.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cubox.admin.main.dao.StatDAO;
import cubox.admin.main.service.StatService;
import cubox.admin.main.service.vo.ExcelVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("statService")
public class StatServiceImpl extends EgovAbstractServiceImpl implements StatService {

	@Resource(name="statDAO")
	private StatDAO statDAO;
	
	@Override
	public List<Map<String, Object>> selectCrttDay(Map<String, Object> param) throws Exception {
		return statDAO.selectCrttDay(param); 
	}
	
	@Override
	public List<ExcelVO> selectCrttDayXls(Map<String, Object> param) throws Exception {
		return statDAO.selectCrttDayXls(param); 
	}
	
	@Override
	public List<Map<String, Object>> selectCrttGrDay(Map<String, Object> param) throws Exception {
		return statDAO.selectCrttGrDay(param); 
	}
	
	@Override
	public List<ExcelVO> selectCrttGrDayXls(Map<String, Object> param) throws Exception {
		return statDAO.selectCrttGrDayXls(param); 
	}	

	@Override
	public List<Map<String, Object>> selectGlryDay(Map<String, Object> param) throws Exception {
		return statDAO.selectGlryDay(param);
	}

	@Override
	public List<ExcelVO> selectGlryDayXls(Map<String, Object> param) throws Exception {
		return statDAO.selectGlryDayXls(param);
	}	

}
