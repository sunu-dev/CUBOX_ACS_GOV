package cubox.admin.main.controller;

import java.util.ArrayList;
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
import cubox.admin.main.service.DeviceService;
import cubox.admin.main.service.MenuService;
import cubox.admin.main.service.vo.LoginVO;
import cubox.admin.main.service.vo.PaginationVO;

@Controller
public class DeviceController {

	private static final Logger LOGGER = LoggerFactory.getLogger(DeviceController.class);

	@Value("#{property['Globals.paging.recPerPage']}")
	private int gvRecPerPage;  //조회할 페이지 수
	
	@Value("#{property['Globals.paging.curPageUnit']}")
	private int gvCurPageUnit;  //한번에 표시할 페이지 번호 개수
	
	@Value("#{property['Globals.api.device']}")
	private String GLOBAL_API_DEVICE;

	@Resource(name="commonUtils")
	private CommonUtils commonUtils;

	@Resource(name="codeService")
	private CodeService codeService;
	
	@Resource(name="menuService")
	private MenuService menuService;

	@Resource(name="deviceService")
	private DeviceService deviceService;

	@RequestMapping(value="/device/waitList.do")
	public String waitList(ModelMap model, HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");

		String menuUrl = request.getServletPath();
		String menuNm = StringUtil.nvl(menuService.selectMenuNm(menuUrl));
		String initYn = StringUtil.nvl(param.get("initYn"), "Y");
		String initVal1 = commonUtils.getStringDate(DateUtils.addDays(new Date(), -7), "yyyy-MM-dd");
		String initVal2 = commonUtils.getToday("yyyy-MM-dd");
		
		LOGGER.debug("###[waitList] param : {}", param);
		
		if (loginVO != null && loginVO.getUserId() != null && !loginVO.getUserId().equals("")) {

			param.put("srchStatus", "W"); //승인대기
			if(initYn.equals("Y")) {
				param.put("srchDtFr", initVal1);
				param.put("srchDtTo", initVal2);
			}
			
			List<Map<String, Object>> cboCntPerPage = codeService.selectCdCombo("00001"); //페이지당건수
			List<Map<String, Object>> cboType = codeService.selectCdCombo("00004"); //단말기구분
			List<Map<String, Object>> cboManu = codeService.selectCdCombo("00005"); //제조사
			
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
			List<Map<String, Object>> list = deviceService.selectDeviceList(param);
			int count = deviceService.selectDeviceListCount(param);

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
			model.addAttribute("cboManu", cboManu);

			// 검색초기값
			model.addAttribute("initVal1", initVal1);
			model.addAttribute("initVal2", initVal2);

			return "cubox/device/DeviceWaitList";
		} else {
			return "redirect:/login.do";
		}
	}
	
	@RequestMapping(value="/device/list.do")
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
			List<Map<String, Object>> cboType = codeService.selectCdCombo("00004"); //단말기구분
			List<Map<String, Object>> cboManu = codeService.selectCdCombo("00005"); //제조사
			
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
			List<Map<String, Object>> list = deviceService.selectDeviceList(param);
			int count = deviceService.selectDeviceListCount(param);

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
			model.addAttribute("cboManu", cboManu);

			// 검색초기값
			model.addAttribute("initVal1", initVal1);
			model.addAttribute("initVal2", initVal2);

			return "cubox/device/DeviceList";
		} else {
			return "redirect:/login.do";
		}
	}	
	
	@SuppressWarnings("unchecked")
	@ResponseBody
	@RequestMapping(value="/device/save.do")
	public ModelAndView save(HttpServletRequest request, @RequestParam Map<String, Object> param, int[] id_list) throws Exception {

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");
		param.put("regist_id", loginVO.getEsntlId());
		param.put("updt_id", loginVO.getEsntlId());
		
		param.put("id_list", id_list);
		
		String status = StringUtil.nvl(param.get("status"));
		
		int cnt = 0;
		try {
			if(GLOBAL_API_DEVICE.equals("Y")) {  //API호출
				String action = "";
				String method = "";
			
				for(int deviceSn : id_list) {
					if(status.equals("A") || status.equals("I")) { //승인(활성화),무효
						method = "PUT";
						action = "/v1/admin/devices/" + String.valueOf(deviceSn) + "/status";
					} else if(status.equals("D")) { //삭제
						method = "DELETE";
						action = "/v1/admin/devices/" + String.valueOf(deviceSn);
					}
					
					JSONObject json = new JSONObject();
					json.put("status", status);					
			
					String reqBody = json.toJSONString();
					LOGGER.debug("###[단말기상태변경API][{}] reqBody : {}", status, reqBody);

					HashMap<String, Object> result = new HashMap<String, Object>();
					result = FrmsApiUtil.getFrmsApiReq(reqBody, action, method);  
					LOGGER.debug("###[단말기상태변경API][{}] result : {}", status, result);
					
					if(StringUtil.nvl(result.get("responseCode")).equals("200")) {
						HashMap<String, Object> data = (HashMap<String, Object>)result.get("data");
						data.put("regist_id", loginVO.getEsntlId());
						if(status.equals("D")) {
							data.put("description", param.get("description"));
						}
						LOGGER.debug("###[단말기상태변경API][{}] update Log : {}", status, data);
						int cnt2 = deviceService.updateDeviceStatusLog(data);				
						LOGGER.debug("###[단말기상태변경API][{}] update cnt : {}", status, cnt2);
					} else {
						LOGGER.error("###[단말기상태변경API][{}] result : {}", status, result);
					}
				}
				
			} else {
				if(status.equals("A") || status.equals("I")) { //승인(활성화),무효
					cnt = deviceService.updateDeviceListForStatus(param);	
				} else if(status.equals("D")) { //삭제
					cnt = deviceService.deleteDeviceList(param);
				}
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
	@RequestMapping(value="/device/get.do")
	public ModelAndView get(HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		try { 
			Map<String, Object> detail = deviceService.selectDeviceInfo(param);
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
	
	@RequestMapping(value="/device/statusHist.do")
	public String statusHist(ModelMap model, HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");

		String menuUrl = request.getServletPath();
		String menuNm = StringUtil.nvl(menuService.selectMenuNm(menuUrl));
		String initYn = StringUtil.nvl(param.get("initYn"), "Y");
		String initVal1 = commonUtils.getStringDate(DateUtils.addDays(new Date(), -7), "yyyy-MM-dd");
		String initVal2 = commonUtils.getToday("yyyy-MM-dd");
		
		LOGGER.debug("###[statusHist] param : {}", param);
		
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
			List<Map<String, Object>> list = deviceService.selectDeviceStatusHistory(param);
			int count = deviceService.selectDeviceStatusHistoryCount(param);

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

			return "cubox/device/DeviceStatusHist";
		} else {
			return "redirect:/login.do";
		}
	}	
	
	
	
}
