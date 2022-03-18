package cubox.admin.main.service;

import java.util.List;
import java.util.Map;

import cubox.admin.main.service.vo.ExcelVO;

public interface HistoryService {

	public Map<String, String> selectIdentifyHistInfo(Map<String, Object> param) throws Exception;
	public List<Map<String, String>> selectIdentifyHist(Map<String, Object> param) throws Exception;
	public int selectIdentifyHistCount(Map<String, Object> param) throws Exception;
	public List<ExcelVO> selectIdentifyHistXls(Map<String, Object> param) throws Exception;	

	public Map<String, String> selectVerifyHistInfo(Map<String, Object> param) throws Exception;
	public List<Map<String, String>> selectVerifyHist(Map<String, Object> param) throws Exception;
	public int selectVerifyHistCount(Map<String, Object> param) throws Exception;
	public List<ExcelVO> selectVerifyHistXls(Map<String, Object> param) throws Exception;	
	
	public List<Map<String, String>> selectMainIdentifyHist(Map<String, Object> param) throws Exception;
	public List<Map<String, String>> selectMainVerifyHist(Map<String, Object> param) throws Exception;

}
