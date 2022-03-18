package cubox.admin.main.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("chartDAO")
public class ChartDAO extends EgovAbstractMapper {

	private static final String sqlNameSpace = "chart.";
	
	// 일별 얼굴인증현황
	public List<Map<String, Object>> selectMainChart01(Map<String, String> param) throws Exception {
		return selectList(sqlNameSpace+"selectMainChart01", param);
	}	
	
	// 금일 얼굴인증현황
	public Map<String, Object> selectMainChart02(Map<String, String> param) throws Exception {
		return selectOne(sqlNameSpace+"selectMainChart02", param);
	}	

}
