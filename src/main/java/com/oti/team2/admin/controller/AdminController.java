package com.oti.team2.admin.controller;
import java.util.List;

import org.jsoup.Jsoup;
import org.jsoup.safety.Whitelist;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oti.team2.department.dto.Department;
import com.oti.team2.department.service.IDepartmentService;
import com.oti.team2.member.dto.Member;
import com.oti.team2.member.service.IMemberService;
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
	
	/**
	 * 부서목록 조회 메서드
	 *
	 * @author 최은종
	 * @return 부서 목록으로 리턴
	 */
	@GetMapping("/departmentlist")
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
		return "redirect:/admin/departmentlist";
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

		department.setDeptCd(department.getDeptCd());
		department.setFlnm(Jsoup.clean(department.getFlnm(), Whitelist.basic()));
		department.setOfcTelno(Jsoup.clean(department.getOfcTelno(), Whitelist.basic()));

		departmentService.updateDepartment(department);
		return "redirect:/admin/departmentlist";
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
		return "redirect:/admin/departmentlist";
	}
	

	/**
	 관리자의 고객 목록 조회
	 *@author : 신정은
	 *작성일자 : 2023.02.20
	 * @param model
	 * @return
	 */
	@GetMapping("/clientlist")
	public String getMemberList(Model model) {
		int totalRows = memberService.getTotalRows(Auth.CLIENT.toString());
		Pager pager = new Pager(totalRows, 1);
		log.info(pager);
		
		// 목록 가져오기
		List<Member> clientList = memberService.getMemberList(Auth.CLIENT.toString(), pager);
		model.addAttribute("clientList", clientList);
		//log.info(clientList);
		// 상세 가져오기
		Member client = memberService.getMember(clientList.get(0).getMemberId(), Auth.CLIENT.toString());
		log.info(client);
		model.addAttribute("client", client);
		return "management/clientList";
	}
	
	/**
	 * 
	 *@author : 신정은
	 * @param cid : 고객 목록보기에서 전달되는 고객의 id
	 * 작성일자 : 2023.02.20
	 * @return
	 */
	@ResponseBody
	@GetMapping("/client/{cid}")
	public Member getClient(@PathVariable("cid")String cid) {
		Member cl = memberService.getMember(cid, Auth.CLIENT.toString());
		log.info(cl);
		return cl;
	}
}
