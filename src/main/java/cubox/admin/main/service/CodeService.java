package cubox.admin.main.service;

import java.util.Map;
import java.util.List;

public interface CodeService {

	public List<Map<String, Object>> selectCdCombo(String str) throws Exception;
	public List<Map<String, Object>> selectUpperCdCombo() throws Exception;
	
	public Map<String, Object> selectCdInfo(Map<String, Object> param) throws Exception;
	public List<Map<String, Object>> selectCdList(Map<String, Object> param) throws Exception;
	public List<Map<String, Object>> selectCdTree(Map<String, Object> param) throws Exception;
	
	public List<Map<String, Object>> selectCdAllList(Map<String, Object> param) throws Exception;
	public int selectCdAllListCount(Map<String, Object> param) throws Exception;
	
	public int insertUpperCdInfo(Map<String, Object> param) throws Exception;	
	public int insertCdInfo(Map<String, Object> param) throws Exception;	
	public int updateCdInfo(Map<String, Object> param) throws Exception;	
	public int updateCdUseYn(Map<String, Object> param) throws Exception;	

}
