package cubox.admin.main.service;

import java.util.Map;
import java.util.List;

public interface ChartService {

	public List<Map<String, Object>> selectMainChart01() throws Exception;
	public Map<String, Object> selectMainChart02() throws Exception;

}
