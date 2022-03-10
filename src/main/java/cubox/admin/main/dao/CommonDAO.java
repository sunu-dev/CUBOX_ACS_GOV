package cubox.admin.main.dao;

import java.util.HashMap;
import java.util.List;

import org.springframework.stereotype.Repository;

import cubox.admin.main.service.vo.AuthorVO;
import cubox.admin.main.service.vo.LoginVO;
import cubox.admin.main.service.vo.MenuClVO;
import cubox.admin.main.service.vo.MenuVO;
import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("commonDAO")
public class CommonDAO extends EgovAbstractMapper {

	private static final String sqlNameSpace = "common.";

	public LoginVO actionLogin(LoginVO vo) throws Exception {
		return (LoginVO)selectOne(sqlNameSpace + "actionLogin", vo);
	}

	public int lastConnect(LoginVO vo) throws Exception {
		return update(sqlNameSpace+"lastConnect", vo);
	}
	
	public int failConnect(LoginVO vo) throws Exception {
		return update(sqlNameSpace+"failConnect", vo);
	}
	
	public List<AuthorVO> selectAuthorList(HashMap<String, Object> map) throws Exception {
		return selectList(sqlNameSpace+"selectAuthorList", map);
	}	
	
	public List<MenuClVO> selectMenuClListByAuthor(HashMap<String, Object> map) throws Exception {
		return selectList(sqlNameSpace+"selectMenuClListByAuthor", map);
	}	
	
	public List<MenuVO> selectAuthorMenuList(HashMap<String, Object> map) throws Exception {
		return selectList(sqlNameSpace+"selectAuthorMenuList", map);
	}	
	

}
