package cubox.admin.main.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cubox.admin.cmmn.util.StringUtil;
import cubox.admin.main.dao.DeviceDAO;
import cubox.admin.main.service.DeviceService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("deviceService")
public class DeviceServiceImpl extends EgovAbstractServiceImpl implements DeviceService {

	@Resource(name="deviceDAO")
	private DeviceDAO deviceDAO;
	
	@Override
	public Map<String, Object> selectDeviceInfo(Map<String, Object> param) throws Exception {
		return deviceDAO.selectDeviceInfo(param);
	}
	
	@Override
	public List<Map<String, Object>> selectDeviceList(Map<String, Object> param) throws Exception {
		return deviceDAO.selectDeviceList(param);
	}

	@Override
	public int selectDeviceListCount(Map<String, Object> param) throws Exception {
		return deviceDAO.selectDeviceListCount(param);
	}
	
	@Override
	public int updateDeviceListForStatus(Map<String, Object> param) throws Exception {
		int[] id_list = (int[])param.get("id_list");
		int cnt = deviceDAO.updateDeviceListForStatus(param);
		
		if(id_list.length != cnt) {
			String work = "승인(활성화)";
			String status = StringUtil.nvl(param.get("status"));
			if(status.equals("I")) work = "무효";
			throw new RuntimeException(work + " 처리 중 상태가 변경된 단말기가 있습니다.\r\n조회 후 다시 실행하십시오.");
		}
		
		return cnt;
	}
	
	@Override
	public int deleteDeviceList(Map<String, Object> param) throws Exception {
		int[] id_list = (int[])param.get("id_list");
		int cnt = deviceDAO.deleteDeviceList(param);
		
		if(id_list.length != cnt) {
			throw new RuntimeException("삭제 처리 중 상태가 변경된 단말기가 있습니다.\r\n조회 후 다시 실행하십시오.");
		}
		
		return cnt;
	}	
	
	@Override
	public List<Map<String, Object>> selectDeviceStatusHistory(Map<String, Object> param) throws Exception {
		return deviceDAO.selectDeviceStatusHistory(param);
	}

	@Override
	public int selectDeviceStatusHistoryCount(Map<String, Object> param) throws Exception {
		return deviceDAO.selectDeviceStatusHistoryCount(param);
	}
	
	@Override
	public List<String> selectDeviceUuidList(Map<String, Object> param) throws Exception {
		return deviceDAO.selectDeviceUuidList(param);
	}
	
	@Override
	public int updateDeviceStatusLog(Map<String, Object> param) throws Exception {
		return deviceDAO.updateDeviceStatusLog(param);
	}
	
}
