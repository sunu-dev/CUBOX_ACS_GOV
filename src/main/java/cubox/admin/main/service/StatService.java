package cubox.admin.main.service;

import java.util.Map;

import cubox.admin.main.service.vo.ExcelVO;

import java.util.List;

public interface StatService {

	public List<Map<String, Object>> selectCrttDay(Map<String, Object> param) throws Exception;
	public List<ExcelVO> selectCrttDayXls(Map<String, Object> param) throws Exception;
	
	public List<Map<String, Object>> selectGlryDay(Map<String, Object> param) throws Exception;
	public List<ExcelVO> selectGlryDayXls(Map<String, Object> param) throws Exception;
}
