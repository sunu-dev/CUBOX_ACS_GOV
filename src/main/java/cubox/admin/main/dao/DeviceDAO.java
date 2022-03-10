package cubox.admin.main.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("deviceDAO")
public class DeviceDAO extends EgovAbstractMapper {

	private static final String sqlNameSpace = "device.";

	public Map<String, Object> selectDeviceInfo(Map<String, Object> param) throws Exception {
		return selectOne(sqlNameSpace+"selectDeviceInfo", param);
	}	
	
	public List<Map<String, Object>> selectDeviceList(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectDeviceList", param);
	}	
	
	public int selectDeviceListCount(Map<String, Object> param) throws Exception {
		return selectOne(sqlNameSpace+"selectDeviceListCount", param);
	}
	
	public int updateDeviceListForStatus(Map<String, Object> param) throws Exception {
		int cnt = update(sqlNameSpace+"updateDeviceListForStatus", param);
		insert(sqlNameSpace+"insertDeviceStatusHistoryForStatus", param);
		return cnt;
	}
	
	public int deleteDeviceList(Map<String, Object> param) throws Exception {
		insert(sqlNameSpace+"insertDeviceStatusHistoryForDelete", param);
		return update(sqlNameSpace+"deleteDeviceList", param);
	}
	
	public List<Map<String, Object>> selectDeviceStatusHistory(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectDeviceStatusHistory", param);
	}	

	public int selectDeviceStatusHistoryCount(Map<String, Object> param) throws Exception {
		return selectOne(sqlNameSpace+"selectDeviceStatusHistoryCount", param);
	}

	public List<String> selectDeviceUuidList(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectDeviceUuidList", param);
	}
	
	public int updateDeviceStatusLog(Map<String, Object> param) throws Exception {
		return update(sqlNameSpace+"updateDeviceStatusLog", param);
	}
	

}
