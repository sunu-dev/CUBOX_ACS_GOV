package cubox.admin.main.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import cubox.admin.main.service.vo.ExcelVO;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("historyDAO")
public class HistoryDAO extends EgovAbstractMapper {

	private static final String sqlNameSpace = "history.";

	public Map<String, String> selectIdentifyHistInfo(Map<String, Object> param) throws Exception {
		return selectOne(sqlNameSpace+"selectIdentifyHistInfo", param);
	}	
	
	public List<Map<String, String>> selectIdentifyHist(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectIdentifyHist", param);
	}	
	
	public int selectIdentifyHistCount(Map<String, Object> param) throws Exception {
		return selectOne(sqlNameSpace+"selectIdentifyHistCount", param);
	}
	
	public List<ExcelVO> selectIdentifyHistXls(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectIdentifyHistXls", param);
	}
	
	public Map<String, String> selectVerifyHistInfo(Map<String, Object> param) throws Exception {
		return selectOne(sqlNameSpace+"selectVerifyHistInfo", param);
	}	
	
	public List<Map<String, String>> selectVerifyHist(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectVerifyHist", param);
	}	
	
	public int selectVerifyHistCount(Map<String, Object> param) throws Exception {
		return selectOne(sqlNameSpace+"selectVerifyHistCount", param);
	}
	
	public List<ExcelVO> selectVerifyHistXls(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectVerifyHistXls", param);
	}
	
	public List<Map<String, String>> selectMainIdentifyHist(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectMainIdentifyHist", param);
	}

}
