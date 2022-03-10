package cubox.admin.main.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cubox.admin.main.dao.HistoryDAO;
import cubox.admin.main.service.HistoryService;
import cubox.admin.main.service.vo.ExcelVO;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("historyService")
public class HistoryServiceImpl extends EgovAbstractServiceImpl implements HistoryService {

	@Resource(name="historyDAO")
	private HistoryDAO historyDAO;
	
	@Override
	public Map<String, String> selectIdentifyHistInfo(Map<String, Object> param) throws Exception {
		return historyDAO.selectIdentifyHistInfo(param);
	}
	
	@Override
	public List<Map<String, String>> selectIdentifyHist(Map<String, Object> param) throws Exception {
		return historyDAO.selectIdentifyHist(param);
	}

	@Override
	public int selectIdentifyHistCount(Map<String, Object> param) throws Exception {
		return historyDAO.selectIdentifyHistCount(param);
	}
	
	@Override
	public List<ExcelVO> selectIdentifyHistXls(Map<String, Object> param) throws Exception {
		return historyDAO.selectIdentifyHistXls(param);
	}		
	
	@Override
	public Map<String, String> selectVerifyHistInfo(Map<String, Object> param) throws Exception {
		return historyDAO.selectVerifyHistInfo(param);
	}
	
	@Override
	public List<Map<String, String>> selectVerifyHist(Map<String, Object> param) throws Exception {
		return historyDAO.selectVerifyHist(param);
	}

	@Override
	public int selectVerifyHistCount(Map<String, Object> param) throws Exception {
		return historyDAO.selectVerifyHistCount(param);
	}
	
	@Override
	public List<ExcelVO> selectVerifyHistXls(Map<String, Object> param) throws Exception {
		return historyDAO.selectVerifyHistXls(param);
	}

	@Override
	public List<Map<String, String>> selectMainIdentifyHist(Map<String, Object> param) throws Exception {
		return historyDAO.selectMainIdentifyHist(param);
	}

}
