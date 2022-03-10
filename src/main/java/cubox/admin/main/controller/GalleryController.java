package cubox.admin.main.controller;

import java.io.File;
import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.io.FileUtils;
import org.apache.commons.lang.time.DateUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import cubox.admin.cmmn.util.CommonUtils;
import cubox.admin.cmmn.util.S3GetImage;
import cubox.admin.cmmn.util.StringUtil;
import cubox.admin.main.service.CodeService;
import cubox.admin.main.service.GalleryService;
import cubox.admin.main.service.MenuService;
import cubox.admin.main.service.vo.LoginVO;
import cubox.admin.main.service.vo.PaginationVO;

@Controller
public class GalleryController {

	private static final Logger LOGGER = LoggerFactory.getLogger(GalleryController.class);

	@Value("#{property['Globals.paging.recPerPage']}")
	private int gvRecPerPage;  //조회할 페이지 수
	
	@Value("#{property['Globals.paging.curPageUnit']}")
	private int gvCurPageUnit;  //한번에 표시할 페이지 번호 개수

	@Resource(name="commonUtils")
	private CommonUtils commonUtils;

	@Resource(name="codeService")
	private CodeService codeService;
	
	@Resource(name="menuService")
	private MenuService menuService;

	@Resource(name="galleryService")
	private GalleryService galleryService;

	@RequestMapping(value="/gallery/list.do")
	public String list(ModelMap model, HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");

		String menuUrl = request.getServletPath();
		String menuNm = StringUtil.nvl(menuService.selectMenuNm(menuUrl));
		String initYn = StringUtil.nvl(param.get("initYn"), "Y");
		String initVal1 = commonUtils.getStringDate(DateUtils.addDays(new Date(), -7), "yyyy-MM-dd");
		String initVal2 = commonUtils.getToday("yyyy-MM-dd");
		
		LOGGER.debug("###[galleryList] param : {}", param);
		
		if (loginVO != null && loginVO.getUserId() != null && !loginVO.getUserId().equals("")) {
			
			if(initYn.equals("Y")) {
				param.put("srchDtFr", initVal1);
				param.put("srchDtTo", initVal2);
			}
			
			List<Map<String, Object>> cboCntPerPage = codeService.selectCdCombo("00001"); //페이지당건수
			
			int srchCnt = gvRecPerPage;
			String sRecPerPage = StringUtil.nvl(param.get("srchRecPerPage"));
			if(!sRecPerPage.equals("")) {
				srchCnt = Integer.parseInt(sRecPerPage);
			}

			// paging
			int srchPage = Integer.parseInt(StringUtil.nvl(param.get("srchPage"), "1")); //조회할 페이지 번호 기본 1페이지
			param.put("offset", commonUtils.getOffset(srchPage, srchCnt));
			param.put("srchCnt", srchCnt);
			
			// select
			List<Map<String, String>> list = galleryService.selectGalleryList(param);
			int count = galleryService.selectGalleryListCount(param);

			// paging
			PaginationVO pageVO = new PaginationVO();
			pageVO.setCurPage(srchPage);
			pageVO.setRecPerPage(srchCnt);
			pageVO.setTotRecord(count);
			pageVO.setUnitPage(gvCurPageUnit);
			pageVO.calcPageList();
			
			model.addAttribute("menuNm", menuNm); 
			model.addAttribute("menuUrl", menuUrl); 
			model.addAttribute("params", param); 
			model.addAttribute("list", list);
			model.addAttribute("pagination", pageVO);
			model.addAttribute("cboCntPerPage", cboCntPerPage);

			// 검색초기값
			model.addAttribute("initVal1", initVal1);
			model.addAttribute("initVal2", initVal2);

			return "cubox/gallery/GalleryList";
		} else {
			return "redirect:/login.do";
		}
	}
	
	@RequestMapping(value="/gallery/detailPopup.do")
	public String detailPopup(ModelMap model, @RequestParam Map<String, Object> param) throws Exception {
		
        Map<String, String> detail = galleryService.selectGalleryInfo(param);
		
		model.addAttribute("detail", detail);
		
		return "cubox/gallery/GalleryDetailPopup";
	}	

	@RequestMapping(value="/gallery/getImage.do")
	public ResponseEntity<byte[]> getImage(@RequestParam("path") String filePath) throws Exception {
		byte[] byteArray = null;
		
		String gvGalleryImageGb = System.getenv("FRS_GALLERY_IMAGE_GB"); 
		LOGGER.debug("###[getImage] gvGalleryImageGb/filePath : ({}){}", gvGalleryImageGb, filePath);		
		
		if(gvGalleryImageGb.equals("S3")) {
			byteArray = S3GetImage.getImage(filePath);	
		} else if(gvGalleryImageGb.equals("F")) {
			File file = new File(filePath);
			byteArray = FileUtils.readFileToByteArray(file);
		}
		
		final HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.IMAGE_JPEG);
		return new ResponseEntity<byte[]>(byteArray, headers, HttpStatus.OK);
	}	

}
