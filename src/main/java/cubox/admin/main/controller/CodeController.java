package cubox.admin.main.controller;

import java.util.List;
import java.util.Map;

import javax.annotation.Resource;
import javax.servlet.http.HttpServletRequest;

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
import cubox.admin.cmmn.util.StringUtil;
import cubox.admin.main.service.CodeService;
import cubox.admin.main.service.MenuService;
import cubox.admin.main.service.StatService;
import cubox.admin.main.service.vo.LoginVO;
import cubox.admin.main.service.vo.PaginationVO;

@Controller
public class CodeController {

	private static final Logger LOGGER = LoggerFactory.getLogger(CodeController.class);

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

	@Resource(name="statService")
	private StatService statService;
	
	@RequestMapping(value="/admin/codeManage.do")
	public String codeManage(ModelMap model, HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");

		String menuUrl = request.getServletPath();
		String menuNm = StringUtil.nvl(menuService.selectMenuNm(menuUrl));
		
		LOGGER.debug("###[codeManage] param : {}", param);
		
		if (loginVO != null && loginVO.getUserId() != null && !loginVO.getUserId().equals("")) {
		
			List<Map<String, Object>> cboCntPerPage = codeService.selectCdCombo("00001"); //페이지당건수
			List<Map<String, Object>> cboUpperCd = codeService.selectUpperCdCombo(); //메뉴분류
			
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
			List<Map<String, Object>> list = codeService.selectCdAllList(param);
			int count = codeService.selectCdAllListCount(param);

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
			model.addAttribute("cboUpperCd", cboUpperCd);

			return "cubox/admin/CodeManage";
		} else {
			return "redirect:/login.do";
		}
	}	
	
	@ResponseBody
	@RequestMapping(value="/admin/getCdInfo.do")
	public ModelAndView getCdInfo(HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		try { 
			Map<String, Object> detail = codeService.selectCdInfo(param);
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
	@RequestMapping(value="/admin/getUpperCdList.do")
	public ModelAndView getUpperCdList(HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		try {
			param.put("upper_cd", "00000");
			List<Map<String, Object>> list = codeService.selectCdList(param);
			
			modelAndView.addObject("list", list);
			
		} catch(Exception e) {
			e.printStackTrace();
			modelAndView.addObject("message", e.getMessage());
		}

		return modelAndView;
	}		
	
	@ResponseBody
	@RequestMapping(value="/admin/saveUpperCdInfo.do")
	public ModelAndView saveUpperCdInfo(HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");
		param.put("regist_id", loginVO.getEsntlId());
		param.put("updt_id", loginVO.getEsntlId());
		
		param.put("cd", StringUtil.nvl(param.get("hidUpperCd")));
		param.put("cd_nm", StringUtil.nvl(param.get("txtUpperCdNm")));
		param.put("cd_desc", StringUtil.nvl(param.get("txtUpperDesc")));
		param.put("sort_ordr", StringUtil.nvl(param.get("txtUpperSortOrdr"), "1"));
		param.put("cd_dp", 1);
		param.put("upper_cd", "00000");
		
		int cnt = 0;
		try {
			if(StringUtil.nvl(param.get("hidUpperCd")).equals("")) {
				cnt = codeService.insertUpperCdInfo(param);	
			} else {
				cnt = codeService.updateCdInfo(param);
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
	@RequestMapping(value="/admin/saveCdInfo.do")
	public ModelAndView saveCdInfo(HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");
		param.put("regist_id", loginVO.getEsntlId());
		param.put("updt_id", loginVO.getEsntlId());
		
		param.put("cd", StringUtil.nvl(param.get("txtCd")));
		param.put("cd_nm", StringUtil.nvl(param.get("txtCdNm")));
		param.put("cd_desc", StringUtil.nvl(param.get("txtDesc")));
		param.put("sort_ordr", StringUtil.nvl(param.get("txtSortOrdr"), "1"));
		param.put("cd_dp", 2);
		
		LOGGER.debug("###[saveCdInfo] param : {}", param);
		
		int cnt = 0;
		try {
			if(StringUtil.nvl(param.get("hidCd")).equals("")) {
				param.put("upper_cd", StringUtil.nvl(param.get("selUpperCd")));
				cnt = codeService.insertCdInfo(param);	
			} else {
				param.put("upper_cd", StringUtil.nvl(param.get("hidUpperOfCd")));
				cnt = codeService.updateCdInfo(param);
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
	@RequestMapping(value="/admin/modCdUseYn.do")
	public ModelAndView modCdUseYn(HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");
		param.put("updt_id", loginVO.getEsntlId());
		
		try {
			int cnt = codeService.updateCdUseYn(param);	
			
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

	@RequestMapping(value="/admin/codeTree.do")
	public String codeTree(ModelMap model, HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {
		LoginVO loginVO = (LoginVO)request.getSession().getAttribute("loginVO");

		String menuUrl = request.getServletPath();
		String menuNm = StringUtil.nvl(menuService.selectMenuNm(menuUrl));
		
		LOGGER.debug("###[codeTree] param : {}", param);
		
		if (loginVO != null && loginVO.getUserId() != null && !loginVO.getUserId().equals("")) {
		
			List<Map<String, Object>> cboCntPerPage = codeService.selectCdCombo("00001"); //페이지당건수
			List<Map<String, Object>> cboMenuCl = menuService.selectMenuClCombo(); //메뉴분류
			
			int srchCnt = gvRecPerPage;
			String sRecPerPage = StringUtil.nvl(param.get("srchRecPerPage"));
			if(!sRecPerPage.equals("")) {
				srchCnt = Integer.parseInt(sRecPerPage);
			}

			// paging
			int srchPage = Integer.parseInt(StringUtil.nvl(param.get("srchPage"), "1")); //조회할 페이지 번호 기본 1페이지
			param.put("offset", commonUtils.getOffset(srchPage, srchCnt));
			//param.put("srchCnt", srchCnt);
			
			// select
			List<Map<String, Object>> list = codeService.selectCdAllList(param);
			int count = codeService.selectCdAllListCount(param);

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
			model.addAttribute("cboMenuCl", cboMenuCl);

			return "cubox/admin/CodeTree";
		} else {
			return "redirect:/login.do";
		}
	}

	@ResponseBody
	@RequestMapping(value="/admin/getCdTree.do")
	public ModelAndView getCdTree(HttpServletRequest request, @RequestParam Map<String, Object> param) throws Exception {

		ModelAndView modelAndView = new ModelAndView();
		modelAndView.setViewName("jsonView");
		
		try {
			List<Map<String, Object>> list = codeService.selectCdTree(param);
			System.out.println(list);
			
			modelAndView.addObject("tree", list);
			
		} catch(Exception e) {
			e.printStackTrace();
			modelAndView.addObject("message", e.getMessage());
		}

		return modelAndView;
	}	

}
