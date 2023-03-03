package com.oti.team2.admin.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.jsoup.Jsoup;
import org.jsoup.safety.Whitelist;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oti.team2.department.dto.Department;
import com.oti.team2.department.service.IDepartmentService;
import com.oti.team2.jobgrade.service.IJobGradeService;
import com.oti.team2.member.dto.FilterDto;
//github.com/OTI-SRM/srm_project
import com.oti.team2.member.dto.Member;
import com.oti.team2.member.service.IMemberService;
import com.oti.team2.srdemand.dto.SdApprovalDto;
import com.oti.team2.srdemand.dto.SrDemand;
import com.oti.team2.srdemand.dto.SrdemandDetail;
import com.oti.team2.srdemand.service.ISrDemandService;
import com.oti.team2.util.Auth;
import com.oti.team2.util.pager.Pager;

import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
@RequestMapping("/admin")
public class AdminController {

	@Autowired
	private IDepartmentService departmentService;

	@Autowired
	private IMemberService memberService;

	@Autowired
	private IJobGradeService jobGradeService;

	@Autowired
	private ISrDemandService srdemandService;

	/**
	 * 부서목록 조회 메서드
	 *
	 * @author 최은종
	 * @return 부서 목록으로 리턴
	 */
	@GetMapping("/department/list")
	public String getDepartmentList(Model model) {
		log.info("departmentList 조회");

		List<Department> departmentList = departmentService.getDepartmentList();
		model.addAttribute("departmentList", departmentList);

		return "management/departmentsList";
	}

	/**
	 * 신규부서 등록 메서드
	 *
	 * @author 최은종
	 * @param department 객체에 넣어서 DB에 등록
	 * @return 부서 목록으로 리다이렉트
	 */
	@PostMapping("/department/add")
	public String addDepartment(Department department) {
		log.info("department 신규 등록");

		departmentService.addDepartment(department);
		return "redirect:/admin/department/list";
	}

	/**
	 * 부서정보 수정 메서드
	 *
	 * @author 최은종
	 * @param department 객체 값 가져오고 수정하기
	 * @return 부서 목록으로 리다이렉트
	 */
	@PostMapping("/department/modify")
	public String updateDepartment(Department department) {
		log.info("department 수정");

		department.setFlnm(Jsoup.clean(department.getFlnm(), Whitelist.basic()));
		department.setOfcTelno(Jsoup.clean(department.getOfcTelno(), Whitelist.basic()));

		departmentService.updateDepartment(department);
		return "redirect:/admin/department/list";
	}

	/**
	 * 부서정보 삭제 메서드
	 *
	 * @author 최은종
	 * @param deptCd 부서 코드 가져와서 정보 삭제(cascade)
	 * @return 부서 목록으로 리다이렉트
	 */
	@GetMapping("/department/delete")
	public String deleteDepartment(String deptCd) {
		log.info("department 삭제");

		departmentService.deleteDepartment(deptCd);
		return "redirect:/admin/department/list";
	}

	/**
	 * 관리자의 고객 목록 조회
	 * 
	 * @author : 신정은 작성일자 : 2023.02.20
	 * @param model
	 * @return
	 */
	@GetMapping("/client/list")
	public String getMemberList(@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "flnm", required = false) String flnm,
			@RequestParam(value = "instNm", required = false) String instNm, Model model) {
		FilterDto filterDto = new FilterDto();
		if (instNm != null) {
			filterDto.setDeptNm(instNm);
			model.addAttribute("instNm", instNm);
		}
		if (flnm != null) {
			filterDto.setFlnm(flnm);
			model.addAttribute("flnm", flnm);
		}
		int totalRows = memberService.getTotalRows(Auth.ROLE_CLIENT.toString(), filterDto);
		Pager pager = new Pager(totalRows, 1);
		// log.info(pager);

		// 목록 가져오기
		List<Member> clientList = memberService.getMemberList(Auth.ROLE_CLIENT.toString(), pager, filterDto);
		model.addAttribute("clientList", clientList);
		// log.info(clientList);
		// 상세 가져오기
		Member client = memberService.getMember(clientList.get(0).getMemberId(), Auth.ROLE_CLIENT.toString());
		log.info(client);
		model.addAttribute("client", client);
		model.addAttribute("pager", pager);

		return "management/clientList";
	}

	/**
	 * 
	 * @author : 신정은
	 * @param cid : 고객 목록보기에서 전달되는 고객의 id 작성일자 : 2023.02.20
	 * @return
	 */
	@ResponseBody
	@GetMapping("/client/{cid}")
	public Member getClient(@PathVariable("cid") String cid) {
		Member cl = memberService.getMember(cid, Auth.ROLE_CLIENT.toString());
		log.info(cl);
		return cl;
	}

	/*
	 * 사원 목록 페이지
	 * 
	 * @author 안한길
	 * 
	 * @param page : 페이지 flnm:이름 deptNm:부서명 jbgdNm:부서명
	 * 
	 * @return 사원 목록 페이지 url
	 */
	@RequestMapping(value = "/employee/list", method = RequestMethod.GET)
	public String getEmployeeList(@RequestParam(value = "page", defaultValue = "1") int page,
			@RequestParam(value = "flnm", required = false) String flnm,
			@RequestParam(value = "deptNm", required = false) String deptNm,
			@RequestParam(value = "jbgdNm", required = false) String jbgdNm, Model model) {
		log.info("getEmployeeList" + page + flnm);
		FilterDto filterDto = new FilterDto();
		if (deptNm != null) {
			filterDto.setDeptNm(deptNm);
			model.addAttribute("deptNm", deptNm);
		}
		if (flnm != null) {
			filterDto.setFlnm(flnm);
			model.addAttribute("flnm", flnm);
		}
		if (jbgdNm != null) {
			filterDto.setJbgdNm(jbgdNm);
			model.addAttribute("jbgdNm", jbgdNm);
		}
		int totalRows = memberService.getTotalRows(Auth.ROLE_DEVELOPER.toString(), filterDto);
		Pager pager = new Pager(totalRows, page);

		List<Member> employeesList = memberService.getMemberList(Auth.ROLE_DEVELOPER.toString(), pager, filterDto);

		// 사원 목록 첫번째 사원 정보 사원정보 카드에 추가
		employeesList.set(0,
				memberService.getMember(employeesList.get(0).getMemberId(), Auth.ROLE_DEVELOPER.toString()));
		// 사원 정보 카드 에서 직급, 부서 선택 목록
		model.addAttribute("jobGradeList", jobGradeService.getJobGradeList());
		model.addAttribute("departmentList", departmentService.getDepartmentNameList());

		model.addAttribute("employeesList", employeesList);
		model.addAttribute("pager", pager);
		return "management/employeesList";
	}

	/*
	 * 사원 상세 정보
	 * 
	 * @author 안한길
	 * 
	 * @param 사원 아이디
	 * 
	 * @return 사원 정보
	 */
	@ResponseBody
	@RequestMapping(value = "/employee", method = RequestMethod.GET)
	public Member getEmployeeDetail(@RequestParam() String employeeId) {
		log.info(employeeId);
		return memberService.getMember(employeeId, Auth.ROLE_DEVELOPER.toString());
	}

	/*
	 * 사원 삭제
	 * 
	 * @author 안한길
	 * 
	 * @param 사원 아이디
	 * 
	 * @return 반영 행수
	 */
	@ResponseBody
	@RequestMapping(value = "/employee/delete", method = RequestMethod.GET)
	public int deleteEmployee(@RequestParam() String employeeId) {
		log.info(employeeId);
		return memberService.deleteMember(employeeId);
	}

	/*
	 * 사원 정보 수정
	 * 
	 * @author 안한길
	 * 
	 * @param 수정된 사원 정보
	 * 
	 * @return 반영 행수
	 */
	@ResponseBody
	@RequestMapping(value = "/employee/modify", method = RequestMethod.POST)
	public int modifyEmployee(Member member) {
		log.info(member);
		return memberService.modifyMember(member);
	}

	/**
	 * 관리자의 모든 요청 목록 조회 기능 **
	 * 
	 * @author 신정은
	 */
	@GetMapping("/srdemand/list")
	public String getSrDemandList(Model model, @RequestParam(required = false, name = "dmndno") String dmndno,
			@RequestParam(required = true, name = "page", defaultValue = "1") String page) {

		// 목록
		int totalRows = srdemandService.getCountAllSr();
		Pager pager = new Pager(totalRows, Integer.parseInt(page));
		log.info(pager);

		List<SrDemand> list = srdemandService.getSrDemandListBy(pager);
		model.addAttribute("srDemandList", list);

		// 기본 첫번째 상세 or 선택된 상세
		SrdemandDetail sd = null;
		if (dmndno != null) {
			sd = srdemandService.getSrDemandDetail(dmndno);
		} else {
			sd = srdemandService.getSrDemandDetail(list.get(0).getDmndNo());
		}

		model.addAttribute("sd", sd);
		model.addAttribute("pager", pager);

		return "srDemand/adminSrDemandList";
	}

	/**
	 * 관리자의 sr요청 결재 기능 **
	 * 
	 * @author 신정은
	 */
	@ResponseBody
	@PostMapping("/srdemand/approval")
	public Map<String, String> getSrDemandApproval(Authentication auth, @RequestBody SdApprovalDto sdApprovalDto) {
		sdApprovalDto.setRvwrId(auth.getName());
		log.info(sdApprovalDto);
		srdemandService.getSrDemandApproval(sdApprovalDto);

		Map<String, String> map = new HashMap<>();
		String result = "";
		if (sdApprovalDto.getVal() == 1) {
			result = sdApprovalDto.getDmndNo() + "번 요청이 승인처리 되었습니다.";
		} else
			result = sdApprovalDto.getDmndNo() + "번 요청이 반려처리 되었습니다.";
		map.put("result", result);
		return map;
	}

}
