package cubox.admin.main.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("codeDAO")
public class CodeDAO extends EgovAbstractMapper {

	private static final String sqlNameSpace = "code.";

	public List<Map<String, Object>> selectCdCombo(String str) throws Exception {
		return selectList(sqlNameSpace+"selectCdCombo", str);
	}

	public List<Map<String, Object>> selectUpperCdCombo() throws Exception {
		return selectList(sqlNameSpace+"selectUpperCdCombo");
	}
	
	public Map<String, Object> selectCdInfo(Map<String, Object> param) throws Exception {
		return selectOne(sqlNameSpace+"selectCdInfo", param);
	}
	
	public List<Map<String, Object>> selectCdList(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectCdList", param);
	}
	
	public List<Map<String, Object>> selectCdTree(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectCdTree", param);
	}
	
	public List<Map<String, Object>> selectCdAllList(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectCdAllList", param);
	}	

	public int selectCdAllListCount(Map<String, Object> param) throws Exception {
		return (Integer)selectOne(sqlNameSpace+"selectCdAllListCount", param);
	}
	
	public String selectNewUpperCd() throws Exception {
		return (String)selectOne(sqlNameSpace+"selectNewUpperCd");
	}
	
	public int selectCdInfoDup(Map<String, Object> param) throws Exception {
		return (Integer)selectOne(sqlNameSpace+"selectCdInfoDup", param);
	}
	
	public int insertCdInfo(Map<String, Object> param) throws Exception {
		return insert(sqlNameSpace+"insertCdInfo", param);
	}
	
	public int updateCdInfo(Map<String, Object> param) throws Exception {
		return update(sqlNameSpace+"updateCdInfo", param);
	}
	
	public int updateCdUseYn(Map<String, Object> param) throws Exception {
		return update(sqlNameSpace+"updateCdUseYn", param);
	}
}
