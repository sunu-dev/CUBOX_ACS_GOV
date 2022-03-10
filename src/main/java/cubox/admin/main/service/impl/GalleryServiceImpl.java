package cubox.admin.main.service.impl;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.springframework.stereotype.Service;

import cubox.admin.main.dao.GalleryDAO;
import cubox.admin.main.service.GalleryService;
import egovframework.rte.fdl.cmmn.EgovAbstractServiceImpl;

@Service("galleryService")
public class GalleryServiceImpl extends EgovAbstractServiceImpl implements GalleryService {

	@Resource(name="galleryDAO")
	private GalleryDAO galleryDAO;

	@Override
	public Map<String, String> selectGalleryInfo(Map<String, Object> param) throws Exception {
		return galleryDAO.selectGalleryInfo(param);
	}
	
	@Override
	public List<Map<String, String>> selectGalleryList(Map<String, Object> param) throws Exception {
		return galleryDAO.selectGalleryList(param);
	}

	@Override
	public int selectGalleryListCount(Map<String, Object> param) throws Exception {
		return galleryDAO.selectGalleryListCount(param);
	}

}
