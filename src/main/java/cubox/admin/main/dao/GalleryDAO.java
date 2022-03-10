package cubox.admin.main.dao;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Repository;

import egovframework.rte.psl.dataaccess.EgovAbstractMapper;

@Repository("galleryDAO")
public class GalleryDAO extends EgovAbstractMapper {

	private static final String sqlNameSpace = "gallery.";

	public Map<String, String> selectGalleryInfo(Map<String, Object> param) throws Exception {
		return selectOne(sqlNameSpace+"selectGalleryInfo", param);
	}	
	
	public List<Map<String, String>> selectGalleryList(Map<String, Object> param) throws Exception {
		return selectList(sqlNameSpace+"selectGalleryList", param);
	}	
	
	public int selectGalleryListCount(Map<String, Object> param) throws Exception {
		return selectOne(sqlNameSpace+"selectGalleryListCount", param);
	}	
}
