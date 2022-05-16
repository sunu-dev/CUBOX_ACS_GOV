package cubox.admin.main.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import cubox.admin.main.service.vo.ExcelVO;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("statDAO")
public class StatDAO extends EgovAbstractMapper {

	private static final String sqlNameSpace = "stat.";

	public List<Map<String, Object>> selectCrttDay(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectCrttDay", param);
	}
	
	public List<ExcelVO> selectCrttDayXls(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectCrttDayXls", param);
	}
	
	public List<Map<String, Object>> selectCrttGrDay(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectCrttGrDay", param);
	}
	
	public List<ExcelVO> selectCrttGrDayXls(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectCrttGrDayXls", param);
	}	
	
	public List<Map<String, Object>> selectGlryDay(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectGlryDay", param);
	}
	
	public List<ExcelVO> selectGlryDayXls(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectGlryDayXls", param);
	}

}
