package cubox.admin.main.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cubox.admin.main.dao.ThresholdDAO;
import cubox.admin.main.service.ThresholdService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("thresholdService")
public class ThresholdServiceImpl extends EgovAbstractServiceImpl implements ThresholdService {

	@Resource(name="thresholdDAO")
	private ThresholdDAO thresholdDAO;
	
	@Override
	public List<Map<String, Object>> selectThresholdCombo() throws Exception {
		return thresholdDAO.selectThresholdCombo();
	}
	
	@Override
	public List<Map<String, Object>> selectThresholdList(Map<String, Object> param) throws Exception {
		return thresholdDAO.selectThresholdList(param);
	}

	@Override
	public int selectThresholdListCount(Map<String, Object> param) throws Exception {
		return thresholdDAO.selectThresholdListCount(param);
	}
	
	@Override
	public List<Map<String, Object>> selectThresholdHistory(Map<String, Object> param) throws Exception {
		return thresholdDAO.selectThresholdHistory(param);
	}

	@Override
	public int selectThresholdHistoryCount(Map<String, Object> param) throws Exception {
		return thresholdDAO.selectThresholdHistoryCount(param);
	}

	@Override
	public Map<String, Object> selectThresholdInfo(Map<String, Object> param) throws Exception {
		return thresholdDAO.selectThresholdInfo(param);
	}
	
	@Override
	public int insertThresholdInfo(Map<String, Object> param) throws Exception {
		param.put("cd", thresholdDAO.selectNewCd());
		return thresholdDAO.insertThresholdInfo(param);
	}

	@Override
	public int updateThresholdInfo(Map<String, Object> param) throws Exception {
		return thresholdDAO.updateThresholdInfo(param);
	}
	
	@Override
	public int updateThresholdValue(Map<String, Object> param) throws Exception {
		return thresholdDAO.updateThresholdValue(param);
	}	
}
