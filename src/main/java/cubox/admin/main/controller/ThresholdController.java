package cubox.admin.main.controller;

import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.time.DateUtils;
import org.json.simple.JSONObject;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cubox.admin.cmmn.util.CommonUtils;
import cubox.admin.cmmn.util.FrmsApiUtil;
import cubox.admin.cmmn.util.StringUtil;
import cubox.admin.main.service.CodeService;
import cubox.admin.main.service.MenuService;
import cubox.admin.main.service.ThresholdService;
import cubox.admin.main.service.vo.LoginVO;
import cubox.admin.main.service.vo.PaginationVO;

@Controller
public class ThresholdController {

	private static final Logger LOGGER = LoggerFactory.getLogger(ThresholdController.class);

	@Value("#{property['Globals.paging.recPerPage']}")
	private int gvRecPerPage;  //조회할 페이지 수
	
	@Value("#{property['Globals.paging.curPageUnit']}")
	private int gvCurPageUnit;  //한번에 표시할 페이지 번호 개수
	
	@Value("#{property['Globals.api.threshold']}")
	private String GLOBAL_API_THRESHOLD;

	@Resource(name="commonUtils")
	private CommonUtils commonUtils;

	@Resource(name="codeService")
	private CodeService codeService;
	
	@Resource(name="menuService")
	private MenuService menuService;

	@Resource(name="thresholdService")
	private ThresholdService thresholdService;

	@RequestMapping(value="/threshold/list.do")
	public String list(ModelMap model, HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");

		String menuUrl = request.getServletPath();
		String menuNm = StringUtil.nvl(menuService.selectMenuNm(menuUrl));
		String initYn = StringUtil.nvl(param.get("initYn"), "Y");
		String initVal1 = commonUtils.getStringDate(DateUtils.addDays(new Date(), -7), "yyyy-MM-dd");
		String initVal2 = commonUtils.getToday("yyyy-MM-dd");
		
		LOGGER.debug("###[list] param : {}", param);
		
		if (loginVO != null && loginVO.getUserId() != null && !loginVO.getUserId().equals("")) {
			
			if(initYn.equals("Y")) {
				param.put("srchDtFr", initVal1);
				param.put("srchDtTo", initVal2);
			}
			
			List<Map<String, Object>> cboCntPerPage = codeService.selectCdCombo("00001"); //페이지당건수
			List<Map<String, Object>> cboType = codeService.selectCdCombo("00002"); //장비구분
			List<Map<String, Object>> cboType2 = codeService.selectCdCombo("00003"); //얼굴인식방식
			
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
			List<Map<String, Object>> list = thresholdService.selectThresholdList(param);
			int count = thresholdService.selectThresholdListCount(param);

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
			model.addAttribute("cboType", cboType);
			model.addAttribute("cboType2", cboType2);

			// 검색초기값
			model.addAttribute("initVal1", initVal1);
			model.addAttribute("initVal2", initVal2);

			return "cubox/threshold/ThresholdList";
		} else {
			return "redirect:/login.do";
		}
	}
	
	@RequestMapping(value="/threshold/history.do")
	public String history(ModelMap model, HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");

		String menuUrl = request.getServletPath();
		String menuNm = StringUtil.nvl(menuService.selectMenuNm(menuUrl));
		String initYn = StringUtil.nvl(param.get("initYn"), "Y");
		String initVal1 = commonUtils.getStringDate(DateUtils.addDays(new Date(), -7), "yyyy-MM-dd");
		String initVal2 = commonUtils.getToday("yyyy-MM-dd");
		
		LOGGER.debug("###[history] param : {}", param);
		
		if (loginVO != null && loginVO.getUserId() != null && !loginVO.getUserId().equals("")) {
			
			if(initYn.equals("Y")) {
				param.put("srchDtFr", initVal1);
				param.put("srchDtTo", initVal2);
			}
			
			List<Map<String, Object>> cboThreshold = thresholdService.selectThresholdCombo(); //임계치
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
			List<Map<String, Object>> list = thresholdService.selectThresholdHistory(param);
			int count = thresholdService.selectThresholdHistoryCount(param);

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
			model.addAttribute("cboThreshold", cboThreshold);

			// 검색초기값
			model.addAttribute("initVal1", initVal1);
			model.addAttribute("initVal2", initVal2);

			return "cubox/threshold/ThresholdHistory";
		} else {
			return "redirect:/login.do";
		}
	}
	
	@ResponseBody
	@RequestMapping(value="/threshold/get.do")
	public ModelAndView get(HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		try { 
			Map<String, Object> detail = thresholdService.selectThresholdInfo(param);
			if(detail != null) {
				modelAndView.addObject("detail", detail);	
			} else {
				modelAndView.addObject("message", "해당 자료가 없습니다.");
			}
		} catch(Exception e) {
			e.printStackTrace();
			modelAndView.addObject("message", e.getMessage());
		}

		return modelAndView;
	}	
	
	@ResponseBody
	@RequestMapping(value="/threshold/save.do")
	public ModelAndView save(HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");
		param.put("regist_id", loginVO.getEsntlId());
		param.put("updt_id", loginVO.getEsntlId());
		
		param.put("sn", param.get("hidCd"));
		param.put("nm", StringUtil.nvl(param.get("txtNm")));
		param.put("val", param.get("txtVal"));
		param.put("type", StringUtil.nvl(param.get("selType")));
		param.put("type_2", StringUtil.nvl(param.get("selType2")));
		
		int cnt = 0;
		try {
			if(StringUtil.nvl(param.get("hidCd")).equals("")) {
				cnt = thresholdService.insertThresholdInfo(param);	
			} else {
				cnt = thresholdService.updateThresholdInfo(param);
			}
			
			if(cnt > 0) {
				modelAndView.addObject("result", "success");
			} else {
				modelAndView.addObject("result", "fail");
			}
		} catch(Exception e) {
			e.printStackTrace();
			modelAndView.addObject("result", "fail");
			modelAndView.addObject("message", e.getMessage());
		}

		return modelAndView;
	}
	
	@ResponseBody
	@RequestMapping(value="/threshold/modVal.do")
	public ModelAndView modVal(HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");
		param.put("updt_id", loginVO.getEsntlId());
		
		LOGGER.debug("###[modVal] param : {}", param);
		
		int cnt = 0;
		try {
			if(StringUtil.nvl(param.get("hidType")).equals("S") && GLOBAL_API_THRESHOLD.equals("Y")) { //서버임계치 API호출

				String action = "/v1/admin/threshold";
				String method = "POST";
				
				JSONObject json = new JSONObject();
				json.put("adminId", loginVO.getEsntlId());
				json.put("threshold", param.get("txtVal"));
				json.put("type", param.get("hidType"));
				json.put("type2", param.get("hidType2"));
		
				String reqBody = json.toJSONString();
				LOGGER.debug("###[서버임계치API] reqBody : {}", reqBody);

				HashMap<String, Object> result = new HashMap<String, Object>();
				result = FrmsApiUtil.getFrmsApiReq(reqBody, action, method); //{data=null, errorResponse=null, timestamp=1634635516192}  
				LOGGER.debug("###[서버임계치API] result : {}", result);				
				
				if(StringUtil.nvl(result.get("responseCode")).equals("200")) {
					HashMap<String, Object> data = (HashMap<String, Object>)result.get("data");
					data.put("regist_id", loginVO.getEsntlId());
					LOGGER.debug("###[서버임계치API] update Log : {}", data);
					cnt = thresholdService.updateThresholdLog(data);				
					LOGGER.debug("###[서버임계치API] update cnt : {}", cnt);
				} else {
					cnt = 0;
					LOGGER.error("###[서버임계치API] result : {}", result);
				}		
				
				/*if(result != null && !result.isEmpty()) {
					cnt = 1;
				} else {
					cnt = 0;
				}*/
			
			} else {
				param.put("sn", param.get("hidCd"));
				param.put("val", param.get("txtVal"));
				
				cnt = thresholdService.updateThresholdValue(param);
			}
			
			if(cnt > 0) {
				modelAndView.addObject("result", "success");
			} else {
				modelAndView.addObject("result", "fail");
			}
		} catch(Exception e) {
			e.printStackTrace();
			modelAndView.addObject("result", "fail");
			modelAndView.addObject("message", e.getMessage());
		}

		return modelAndView;
	}		
}
