package cubox.admin.main.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cubox.admin.main.dao.CodeDAO;
import cubox.admin.main.service.CodeService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("codeService")
public class CodeServiceImpl extends EgovAbstractServiceImpl implements CodeService {

	@Resource(name="codeDAO")
	private CodeDAO codeDAO;
	
	@Override
	public List<Map<String, Object>> selectCdCombo(String str) throws Exception {
		return codeDAO.selectCdCombo(str);
	}
	
	@Override
	public List<Map<String, Object>> selectUpperCdCombo() throws Exception {
		return codeDAO.selectUpperCdCombo();
	}
	
	@Override
	public Map<String, Object> selectCdInfo(Map<String, Object> param) throws Exception {
		return codeDAO.selectCdInfo(param);
	}
	
	@Override
	public List<Map<String, Object>> selectCdList(Map<String, Object> param) throws Exception {
		return codeDAO.selectCdList(param);
	}

	@Override
	public List<Map<String, Object>> selectCdTree(Map<String, Object> param) throws Exception {
		return codeDAO.selectCdTree(param);
	}
	
	@Override
	public List<Map<String, Object>> selectCdAllList(Map<String, Object> param) throws Exception {
		return codeDAO.selectCdAllList(param);
	}	
	
	@Override
	public int selectCdAllListCount(Map<String, Object> param) throws Exception {
		return codeDAO.selectCdAllListCount(param);
	}
	
	@Override
	public int insertUpperCdInfo(Map<String, Object> param) throws Exception {
		param.put("cd", codeDAO.selectNewUpperCd());
		return codeDAO.insertCdInfo(param);
	}
	
	@Override
	public int insertCdInfo(Map<String, Object> param) throws Exception {
		int cnt = codeDAO.selectCdInfoDup(param);
		if(cnt > 0) {
			throw new RuntimeException("이미 사용중인 코드입니다.");
		}
		
		return codeDAO.insertCdInfo(param);
	}
	
	@Override
	public int updateCdInfo(Map<String, Object> param) throws Exception {
		return codeDAO.updateCdInfo(param);
		
	}
	
	@Override
	public int updateCdUseYn(Map<String, Object> param) throws Exception {
		return codeDAO.updateCdUseYn(param);
		
	}

}
