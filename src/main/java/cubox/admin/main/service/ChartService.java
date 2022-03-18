package cubox.admin.main.service;

import java.util.Map;
import java.util.List;

public interface ChartService {

	public List<Map<String, Object>> selectMainChart01(Map<String, String> param) throws Exception;
	public Map<String, Object> selectMainChart02(Map<String, String> param) throws Exception;
	

}
