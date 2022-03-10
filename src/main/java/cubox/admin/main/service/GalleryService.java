package cubox.admin.main.service;

import java.util.List;
import java.util.Map;

public interface GalleryService {

	public Map<String, String> selectGalleryInfo(Map<String, Object> param) throws Exception;
	public List<Map<String, String>> selectGalleryList(Map<String, Object> param) throws Exception;
	public int selectGalleryListCount(Map<String, Object> param) throws Exception;

}
