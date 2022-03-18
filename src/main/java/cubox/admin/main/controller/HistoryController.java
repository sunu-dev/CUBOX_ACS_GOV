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
import org.springframework.web.servlet.ModelAndView;

import cubox.admin.cmmn.util.CommonUtils;
import cubox.admin.cmmn.util.S3GetImage;
import cubox.admin.cmmn.util.StringUtil;
import cubox.admin.main.service.CodeService;
import cubox.admin.main.service.HistoryService;
import cubox.admin.main.service.MenuService;
import cubox.admin.main.service.vo.ExcelVO;
import cubox.admin.main.service.vo.LoginVO;
import cubox.admin.main.service.vo.PaginationVO;

@Controller
public class HistoryController {

	private static final Logger LOGGER = LoggerFactory.getLogger(HistoryController.class);

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

	@Resource(name="historyService")
	private HistoryService historyService;
	
	@RequestMapping(value="/history/idenList.do")
	public String idenList(ModelMap model, HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");

		String menuUrl = request.getServletPath();
		String menuNm = StringUtil.nvl(menuService.selectMenuNm(menuUrl));
		String initYn = StringUtil.nvl(param.get("initYn"), "Y");
		String initVal1 = commonUtils.getStringDate(DateUtils.addDays(new Date(), -7), "yyyy-MM-dd");
		String initVal2 = commonUtils.getToday("yyyy-MM-dd");
		
		LOGGER.debug("###[idenList] param : {}", param);
		
		if (loginVO != null && loginVO.getUserId() != null && !loginVO.getUserId().equals("")) {
			
			if(initYn.equals("Y")) {
				param.put("srchDtFr", initVal1);
				param.put("srchDtTo", initVal2);
			}
			
			if(StringUtil.nvl(param.get("chkPass")).equals("Y") && StringUtil.nvl(param.get("chkFail")).equals("Y")) {
				param.put("resultCd", "");
			} else if(StringUtil.nvl(param.get("chkPass")).equals("") && StringUtil.nvl(param.get("chkFail")).equals("")) {
				param.put("resultCd", "");
			} else {
				if(StringUtil.nvl(param.get("chkPass")).equals("Y")) {
					param.put("resultCd", 1);
				} else if(StringUtil.nvl(param.get("chkFail")).equals("Y")) {
					param.put("resultCd", 0);
				} else {
					param.put("resultCd", "");
				}
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
			List<Map<String, String>> list = historyService.selectIdentifyHist(param);
			int count = historyService.selectIdentifyHistCount(param);

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

			return "cubox/history/IdentifyList";
		} else {
			return "redirect:/login.do";
		}
	}
	
	@RequestMapping(value="/history/idenListXls.do")
	public ModelAndView idenListXls(HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");
		ModelAndView modelAndView = new ModelAndView();
		LOGGER.debug("###[identify_listXls] param : {}", param);
		
		if (loginVO != null && loginVO.getUserId() != null && !loginVO.getUserId().equals("")) {
			
			String chkTextArray = StringUtil.nvl(param.get("chkTextArray"));
			String[] chkText = chkTextArray.split(",");
			
			String chkValueArray = StringUtil.nvl(param.get("chkValueArray"));
			String[] chkValue = chkValueArray.split(",");
			String excelColumns = "";
			for(int i = 1 ; i <= chkValue.length ; i++) {
				if(i > 1) excelColumns += ", ";
				excelColumns += chkValue[i-1] + " as CELL" + String.valueOf(i); 
			}
			param.put("excelColumns", excelColumns);
			
			// 검색 param
			if(StringUtil.nvl(param.get("chkPass")).equals("Y") && StringUtil.nvl(param.get("chkFail")).equals("Y")) {
				param.put("resultCd", "");
			} else if(StringUtil.nvl(param.get("chkPass")).equals("") && StringUtil.nvl(param.get("chkFail")).equals("")) {
				param.put("resultCd", "");
			} else {
				if(StringUtil.nvl(param.get("chkPass")).equals("Y")) {
					param.put("resultCd", 1);
				} else if(StringUtil.nvl(param.get("chkFail")).equals("Y")) {
					param.put("resultCd", 0);
				} else {
					param.put("resultCd", "");
				}
			}		
			
			// select
			List<ExcelVO> list = historyService.selectIdentifyHistXls(param);
			
			modelAndView.setViewName("excelDownloadView");
			modelAndView.addObject("resultList", list);
			modelAndView.addObject("excelName", "얼굴인증이력");
			modelAndView.addObject("excelHeader", chkText);
		}
		
		return modelAndView;
	}		
	
	@RequestMapping(value="/history/idenDetailPopup.do")
	public String idenDetailPopup(ModelMap model, @RequestParam Map<String, Object> param) throws Exception {
		
        Map<String, String> detail = historyService.selectIdentifyHistInfo(param);
		
		model.addAttribute("detail", detail);
		model.addAttribute("gb", "I");
		
		return "cubox/history/DetailPopup";
	}
	
	@RequestMapping(value="/history/veriList.do")
	public String veriList(ModelMap model, HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");

		String menuUrl = request.getServletPath();
		String menuNm = StringUtil.nvl(menuService.selectMenuNm(menuUrl));
		String initYn = StringUtil.nvl(param.get("initYn"), "Y");
		String initVal1 = commonUtils.getStringDate(DateUtils.addDays(new Date(), -7), "yyyy-MM-dd");
		String initVal2 = commonUtils.getToday("yyyy-MM-dd");
		
		LOGGER.debug("###[veriList] param : {}", param);
		
		if (loginVO != null && loginVO.getUserId() != null && !loginVO.getUserId().equals("")) {
			
			if(initYn.equals("Y")) {
				param.put("srchDtFr", initVal1);
				param.put("srchDtTo", initVal2);
			}
			
			if(StringUtil.nvl(param.get("chkPass")).equals("Y") && StringUtil.nvl(param.get("chkFail")).equals("Y")) {
				param.put("resultCd", "");
			} else if(StringUtil.nvl(param.get("chkPass")).equals("") && StringUtil.nvl(param.get("chkFail")).equals("")) {
				param.put("resultCd", "");
			} else {
				if(StringUtil.nvl(param.get("chkPass")).equals("Y")) {
					param.put("resultCd", 1);
				} else if(StringUtil.nvl(param.get("chkFail")).equals("Y")) {
					param.put("resultCd", 0);
				} else {
					param.put("resultCd", "");
				}
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
			List<Map<String, String>> list = historyService.selectVerifyHist(param);
			int count = historyService.selectVerifyHistCount(param);

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

			return "cubox/history/VerifyList";
		} else {
			return "redirect:/login.do";
		}
	}	
		
	@RequestMapping(value="/history/veriListXls.do")
	public ModelAndView veriListXls(HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");
		ModelAndView modelAndView = new ModelAndView();
		LOGGER.debug("###[veriListXls] param : {}", param);
		
		if (loginVO != null && loginVO.getUserId() != null && !loginVO.getUserId().equals("")) {
			
			String chkTextArray = StringUtil.nvl(param.get("chkTextArray"));
			String[] chkText = chkTextArray.split(",");
			
			String chkValueArray = StringUtil.nvl(param.get("chkValueArray"));
			String[] chkValue = chkValueArray.split(",");
			String excelColumns = "";
			for(int i = 1 ; i <= chkValue.length ; i++) {
				if(i > 1) excelColumns += ", ";
				excelColumns += chkValue[i-1] + " as CELL" + String.valueOf(i); 
			}
			param.put("excelColumns", excelColumns);
			
			// 검색 param
			if(StringUtil.nvl(param.get("chkPass")).equals("Y") && StringUtil.nvl(param.get("chkFail")).equals("Y")) {
				param.put("resultCd", "");
			} else if(StringUtil.nvl(param.get("chkPass")).equals("") && StringUtil.nvl(param.get("chkFail")).equals("")) {
				param.put("resultCd", "");
			} else {
				if(StringUtil.nvl(param.get("chkPass")).equals("Y")) {
					param.put("resultCd", 1);
				} else if(StringUtil.nvl(param.get("chkFail")).equals("Y")) {
					param.put("resultCd", 0);
				} else {
					param.put("resultCd", "");
				}
			}		
			
			// select
			List<ExcelVO> list = historyService.selectVerifyHistXls(param);
			
			modelAndView.setViewName("excelDownloadView");
			modelAndView.addObject("resultList", list);
			modelAndView.addObject("excelName", "얼굴인증이력");
			modelAndView.addObject("excelHeader", chkText);
		}
		
		return modelAndView;
	}
	
	@RequestMapping(value="/history/veriDetailPopup.do")
	public String veriDetailPopup(ModelMap model, @RequestParam Map<String, Object> param) throws Exception {
		
        Map<String, String> detail = historyService.selectVerifyHistInfo(param);
		
		model.addAttribute("detail", detail);
		model.addAttribute("gb", "V");
		
		return "cubox/history/DetailPopup";
	}
	
	@RequestMapping(value="/history/getImage.do")
	public ResponseEntity<byte[]> getImage(@RequestParam("path") String filePath, @RequestParam("gb") String gb) throws Exception {
		byte[] byteArray = null;
		
		String gvLogGb = "N";
		if(gb.equals("G")) {
			gvLogGb = System.getenv("FRS_GALLERY_IMAGE_GB");
		} else if(gb.equals("I")) {
			gvLogGb = System.getenv("FRS_IDENTIFICATION_LOG_GB");
		} else if(gb.equals("V")) {
			gvLogGb = System.getenv("FRS_VERIFICATION_LOG_GB");
		}
		
		LOGGER.debug("###[getImage] gb/gvLogGb/filePath : ({}/{}){}", gb, gvLogGb, filePath);
		
		if(gvLogGb.equals("S3")) {
			byteArray = S3GetImage.getImage(filePath);	
		} else if(gvLogGb.equals("F")) {
			File file = new File(filePath);
			byteArray = FileUtils.readFileToByteArray(file);
		}
		
		final HttpHeaders headers = new HttpHeaders();
		headers.setContentType(MediaType.IMAGE_JPEG);
		return new ResponseEntity<byte[]>(byteArray, headers, HttpStatus.OK);
	}		
}
