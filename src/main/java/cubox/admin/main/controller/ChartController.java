package cubox.admin.main.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cubox.admin.cmmn.util.StringUtil;
import cubox.admin.main.service.ChartService;

@Controller
public class ChartController {

	@Resource(name = "chartService")
	private ChartService chartService;
	
	//String gvIdentificationYn = StringUtil.nvl(System.getenv("FRS_IDENTIFICATION_YN"), "N");  //1:N
	//String gvVerificationYn = StringUtil.nvl(System.getenv("FRS_VERIFICATION_YN"), "N");  //1:1	

	@ResponseBody
	@RequestMapping(value="/main/chart01.do")
	public ModelAndView chart01(HttpServletRequest request) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		/*Map<String, String> param = new HashMap<String, String>();
		param.put("identification_yn", gvIdentificationYn);
		param.put("verification_yn", gvVerificationYn);
		System.out.println("[char01] param : "+param);*/
		List<Map<String, Object>> list = chartService.selectMainChart01(null);
		modelAndView.addObject("list", list);

		return modelAndView;
	}

	@ResponseBody
	@RequestMapping(value="/main/chart02.do")
	public ModelAndView chart02(HttpServletRequest request) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		/*Map<String, String> param = new HashMap<String, String>();
		param.put("identification_yn", gvIdentificationYn);
		param.put("verification_yn", gvVerificationYn);
		System.out.println("[char02] param : "+param);*/
		Map<String, Object> data = chartService.selectMainChart02(null);
		modelAndView.addObject("data", data);

		return modelAndView;
	}

}
