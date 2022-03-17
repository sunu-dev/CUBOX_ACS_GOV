package cubox.admin.main.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("thresholdDAO")
public class ThresholdDAO extends EgovAbstractMapper {

	private static final String sqlNameSpace = "threshold.";

	public List<Map<String, Object>> selectThresholdCombo() throws Exception {
		return selectList(sqlNameSpace+"selectThresholdCombo");
	}	
	
	public List<Map<String, Object>> selectThresholdList(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectThresholdList", param);
	}	
	
	public int selectThresholdListCount(Map<String, Object> param) throws Exception {
		return selectOne(sqlNameSpace+"selectThresholdListCount", param);
	}	
	
	public List<Map<String, Object>> selectThresholdHistory(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectThresholdHistory", param);
	}	
	
	public int selectThresholdHistoryCount(Map<String, Object> param) throws Exception {
		return selectOne(sqlNameSpace+"selectThresholdHistoryCount", param);
	}
	
	public Map<String, Object> selectThresholdInfo(Map<String, Object> param) throws Exception {
		return selectOne(sqlNameSpace+"selectThresholdInfo", param);
	}
	
	public String selectNewCd() throws Exception {
		return (String)selectOne(sqlNameSpace+"selectNewCd");
	}
	
	public int insertThresholdInfo(Map<String, Object> param) throws Exception {
		int cnt = insert(sqlNameSpace+"insertThresholdInfo", param);
		insert(sqlNameSpace+"insertThresholdHistory", param);
		return cnt;
	}
	
	public int updateThresholdInfo(Map<String, Object> param) throws Exception {
		int cnt = update(sqlNameSpace+"updateThresholdInfo", param);
		insert(sqlNameSpace+"insertThresholdHistory", param);
		return cnt;
	}
	
	public int updateThresholdValue(Map<String, Object> param) throws Exception {
		int cnt = update(sqlNameSpace+"updateThresholdValue", param);
		insert(sqlNameSpace+"insertThresholdHistory", param);
		return cnt;
	}
	
	public int updateThresholdLog(Map<String, Object> param) throws Exception {
		return update(sqlNameSpace+"updateThresholdLog", param);
	}
}
