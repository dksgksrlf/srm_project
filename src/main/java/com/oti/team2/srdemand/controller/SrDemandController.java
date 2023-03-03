package com.oti.team2.srdemand.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oti.team2.institution.service.IInstitutionService;
import com.oti.team2.member.service.IMemberService;
import com.oti.team2.srdemand.dto.SrDemand;
import com.oti.team2.srdemand.dto.SrRequestDto;
import com.oti.team2.srdemand.dto.SrdemandDetail;
import com.oti.team2.srdemand.dto.WriteSdBaseDto;
import com.oti.team2.srdemand.dto.WriterDto;
import com.oti.team2.srdemand.service.ISrDemandService;
import com.oti.team2.system.dto.SrSystem;
import com.oti.team2.system.service.ISystemService;
import com.oti.team2.task.dto.SystemTask;
import com.oti.team2.task.service.ITaskService;
import com.oti.team2.util.Auth;
import com.oti.team2.util.pager.Pager;

import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
@RequestMapping("/srdemand")
public class SrDemandController {

	@Autowired
	private IInstitutionService institutionService;

	@Autowired
	private ISrDemandService srdemandService;

	@Autowired
	private IMemberService memberService;
	
	@Autowired
	private ISystemService systemService;
	
	@Autowired
	private ITaskService taskService;

	/**
	 * sr요청 작성 시 , 작성자의 아이디, 이름, 소속기관 이름을 세팅하기 위함
	 * 
	 * @author 신정은
	 * 
	 */
	@ResponseBody
	@GetMapping("/add")
	public WriteSdBaseDto addSrDemand(Authentication auth) {
		log.info("기본정보 세팅" + auth.getName());
		// 세션에서 사용자의 이름을 가져와야 됨.
		String memberId = auth.getName();
		String flnm = memberService.getFlnm(memberId);
		
		// 시스템 목록의 첫 시스템과, 해당 시스템의 업무구분 데이터를 기본적으로 세팅한다.
		SrSystem system = systemService.getFirstSystem();
		log.info("system" + system);
		List<SystemTask> taskList = taskService.getTaskList(system.getSysCd());
		log.info("taskList" + taskList);
		
		String instName = institutionService.getInst(memberId).getInstNm();
		WriterDto writerDto = new WriterDto(memberId, flnm, instName);
		WriteSdBaseDto wbDto = new WriteSdBaseDto(writerDto, system, taskList);
		log.info(wbDto);
		return wbDto;
	}

	/**
	 * sr요청 등록
	 * 
	 * @author 신정은
	 */
	@PostMapping("/add")
	public String postSrDemand(SrRequestDto srRequest) {
		log.info(srRequest);
		srdemandService.addSrDemand(srRequest);
		return "redirect:/srdemand/list";
	}

	/**
	 * 고객요청 목록 조회 기능 **
	 * 
	 * @author 신정은
	 */
	@GetMapping("/list")
	public String getSrDemandList(Authentication auth, Model model,
			@RequestParam(required = false, name = "dmndno") String dmndno,
			@RequestParam(required = true, name = "page", defaultValue = "1") String page) {

		String memberId = auth.getName();

		// 목록
		int totalRows = srdemandService.getCountClientSr(memberId);
		Pager pager = new Pager(totalRows, Integer.parseInt(page));
		log.info(pager);
		List<SrDemand> list = null;
		list = srdemandService.getSrDemandList(memberId, pager);
		model.addAttribute("mySrDemandList", list);

		// 기본 첫번째 상세 or 선택된 상세
		SrdemandDetail sd = null;
		if (dmndno != null) {
			sd = srdemandService.getSrDemandDetail(dmndno);
		} else {
			sd = srdemandService.getSrDemandDetail(list.get(0).getDmndNo());
		}

		model.addAttribute("sd", sd);
		model.addAttribute("pager", pager);
		
		return "srDemand/userSrDemandList";
	}

	/**
	 * SR요청 상세보기
	 * 
	 * @author 신정은
	 */
	@ResponseBody
	@GetMapping("/detail/{dmNo}")
	public SrdemandDetail getSrDemandDetail(@PathVariable String dmNo) {
		SrdemandDetail sd = srdemandService.getSrDemandDetail(dmNo);
		log.info(sd);
		return sd;
	}

	/**
	 * SR요청 수정하기
	 * 
	 * @author 신정은
	 */
	@PostMapping("/modify")
	public String updateSrDemand(SrRequestDto srRequestDto) {
		// 수정 진행
		log.info(srRequestDto);
		srdemandService.updateSrDemand(srRequestDto);
		return "redirect:/srdemand/list?dmndno=" + srRequestDto.getDmndNo();
	}
	
	/**
	 * SR요청 삭제하기
	 * 
	 * @author 신정은
	 */
	@GetMapping("/delete/{dmndNo}") 
	public String deleteSrDemand(@PathVariable("dmndNo")String dmndNo) {
		log.info(dmndNo);
		srdemandService.deleteSrdemand(dmndNo);
		return "";
	}

}