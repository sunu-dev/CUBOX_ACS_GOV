package cubox.admin.main.controller;

import java.util.Date;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.apache.commons.lang.time.DateUtils;
import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.stereotype.Controller;
import org.springframework.ui.ModelMap;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.ModelAndView;

import cubox.admin.cmmn.util.CommonUtils;
import cubox.admin.cmmn.util.StringUtil;
import cubox.admin.main.service.CodeService;
import cubox.admin.main.service.MenuService;
import cubox.admin.main.service.StatService;
import cubox.admin.main.service.vo.ExcelVO;
import cubox.admin.main.service.vo.LoginVO;

@Controller
public class StatController {

	private static final Logger LOGGER = LoggerFactory.getLogger(StatController.class);

	@Resource(name="commonUtils")
	private CommonUtils commonUtils;

	@Resource(name="codeService")
	private CodeService codeService;
	
	@Resource(name="menuService")
	private MenuService menuService;

	@Resource(name="statService")
	private StatService statService;

	@RequestMapping(value="/stat/crttDay.do")
	public String crttDay(ModelMap model, HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");

		String menuUrl = request.getServletPath();
		String menuNm = StringUtil.nvl(menuService.selectMenuNm(menuUrl));
		String initYn = StringUtil.nvl(param.get("initYn"), "Y");
		String initVal1 = commonUtils.getStringDate(DateUtils.addDays(new Date(), -7), "yyyy-MM-dd");
		String initVal2 = commonUtils.getStringDate(DateUtils.addDays(new Date(), -1), "yyyy-MM-dd");
		
		LOGGER.debug("###[crttDay] param : {}", param);
		
		if (loginVO != null && loginVO.getUserId() != null && !loginVO.getUserId().equals("")) {
			
			if(initYn.equals("Y")) {
				param.put("srchDtFr", initVal1);
				param.put("srchDtTo", initVal2); 
			}
			
			// select
			List<Map<String, Object>> list = statService.selectCrttDay(param);
			
			model.addAttribute("menuNm", menuNm); 
			model.addAttribute("menuUrl", menuUrl); 
			model.addAttribute("params", param); 
			model.addAttribute("list", list);

			// 검색초기값
			model.addAttribute("initVal1", initVal1);
			model.addAttribute("initVal2", initVal2);

			return "cubox/stat/CrttDay";
		} else {
			return "redirect:/login.do";
		}
	}

	@RequestMapping(value="/stat/crttDayXls.do")
	public ModelAndView crttDayXls(HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");
		ModelAndView modelAndView = new ModelAndView();
		LOGGER.debug("###[crttDayXls] param : {}", param);
		
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
			
			// select
			List<ExcelVO> list = statService.selectCrttDayXls(param);
			
			modelAndView.setViewName("excelDownloadView");
			modelAndView.addObject("resultList", list);
			modelAndView.addObject("excelName", "일별인증통계");
			modelAndView.addObject("excelHeader", chkText);
		}
		
		return modelAndView;
	}	
	
	@RequestMapping(value="/stat/glryDay.do")
	public String glryDay(ModelMap model, HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");

		String menuUrl = request.getServletPath();
		String menuNm = StringUtil.nvl(menuService.selectMenuNm(menuUrl));
		String initYn = StringUtil.nvl(param.get("initYn"), "Y");
		String initVal1 = commonUtils.getStringDate(DateUtils.addDays(new Date(), -7), "yyyy-MM-dd");
		String initVal2 = commonUtils.getStringDate(DateUtils.addDays(new Date(), -1), "yyyy-MM-dd");
		
		LOGGER.debug("###[glryDay] param : {}", param);
		
		if (loginVO != null && loginVO.getUserId() != null && !loginVO.getUserId().equals("")) {
			
			if(initYn.equals("Y")) {
				param.put("srchDtFr", initVal1);
				param.put("srchDtTo", initVal2); 
			}
			
			// select
			List<Map<String, Object>> list = statService.selectGlryDay(param);
			
			model.addAttribute("menuNm", menuNm); 
			model.addAttribute("menuUrl", menuUrl); 
			model.addAttribute("params", param); 
			model.addAttribute("list", list);

			// 검색초기값
			model.addAttribute("initVal1", initVal1);
			model.addAttribute("initVal2", initVal2);

			return "cubox/stat/GlryDay";
		} else {
			return "redirect:/login.do";
		}
	}	
	
	@RequestMapping(value="/stat/glryDayXls.do")
	public ModelAndView glryDayXls(HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");
		ModelAndView modelAndView = new ModelAndView();
		LOGGER.debug("###[glryDayXls] param : {}", param);
		
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
			
			// select
			List<ExcelVO> list = statService.selectGlryDayXls(param);
			
			modelAndView.setViewName("excelDownloadView");
			modelAndView.addObject("resultList", list);
			modelAndView.addObject("excelName", "일별등록통계");
			modelAndView.addObject("excelHeader", chkText);
		}
		
		return modelAndView;
	}	
		
	

}
