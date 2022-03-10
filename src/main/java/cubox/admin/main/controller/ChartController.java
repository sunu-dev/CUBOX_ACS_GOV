package cubox.admin.main.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.ModelAndView;

import cubox.admin.main.service.ChartService;

@Controller
public class ChartController {

	@Resource(name = "chartService")
	private ChartService chartService;

	@ResponseBody
	@RequestMapping(value="/main/chart01.do")
	public ModelAndView chart01(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		List<Map<String, Object>> list = chartService.selectMainChart01();
		modelAndView.addObject("list", list);

		return modelAndView;
	}

	@ResponseBody
	@RequestMapping(value="/main/chart02.do")
	public ModelAndView chart02(@RequestParam Map<String, Object> param, HttpServletRequest request) throws Exception {
		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		Map<String, Object> data = chartService.selectMainChart02();
		modelAndView.addObject("data", data);

		return modelAndView;
	}

}
