package cubox.admin.main.service;

import java.util.List;
import java.util.Map;

public interface DeviceService {

	public Map<String, Object> selectDeviceInfo(Map<String, Object> param) throws Exception;
	public List<Map<String, Object>> selectDeviceList(Map<String, Object> param) throws Exception;
	public int selectDeviceListCount(Map<String, Object> param) throws Exception;
	
	public int updateDeviceListForStatus(Map<String, Object> param) throws Exception;
	public int deleteDeviceList(Map<String, Object> param) throws Exception;
	
	public List<Map<String, Object>> selectDeviceStatusHistory(Map<String, Object> param) throws Exception;
	public int selectDeviceStatusHistoryCount(Map<String, Object> param) throws Exception;
	
	public List<String> selectDeviceUuidList(Map<String, Object> param) throws Exception;
	
	public int updateDeviceStatusLog(Map<String, Object> param) throws Exception;
	
}
