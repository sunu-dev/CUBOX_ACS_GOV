package cubox.admin.main.service;

import java.util.List;
import java.util.Map;

public interface ThresholdService {

	public List<Map<String, Object>> selectThresholdCombo() throws Exception;
	public List<Map<String, Object>> selectThresholdList(Map<String, Object> param) throws Exception;
	public int selectThresholdListCount(Map<String, Object> param) throws Exception;
	
	public List<Map<String, Object>> selectThresholdHistory(Map<String, Object> param) throws Exception;
	public int selectThresholdHistoryCount(Map<String, Object> param) throws Exception;

	public Map<String, Object> selectThresholdInfo(Map<String, Object> param) throws Exception;
	public int insertThresholdInfo(Map<String, Object> param) throws Exception;	
	public int updateThresholdInfo(Map<String, Object> param) throws Exception;		
	public int updateThresholdValue(Map<String, Object> param) throws Exception;
	
	public int updateThresholdLog(Map<String, Object> param) throws Exception;		
}
