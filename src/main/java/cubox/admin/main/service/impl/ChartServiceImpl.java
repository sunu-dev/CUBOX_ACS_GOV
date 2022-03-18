package cubox.admin.main.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cubox.admin.main.dao.ChartDAO;
import cubox.admin.main.service.ChartService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("chartService")
public class ChartServiceImpl extends EgovAbstractServiceImpl implements ChartService {

	@Resource(name="chartDAO")
	private ChartDAO chartDAO;
	
	@Override
	public List<Map<String, Object>> selectMainChart01(Map<String, String> param) throws Exception {
		return chartDAO.selectMainChart01(param);
	}
	
	@Override
	public Map<String, Object> selectMainChart02(Map<String, String> param) throws Exception {
		return chartDAO.selectMainChart02(param);
	}


}
