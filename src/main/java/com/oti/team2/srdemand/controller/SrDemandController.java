package com.oti.team2.srdemand.controller;

import java.util.List;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oti.team2.institution.service.IInstitutionService;
import com.oti.team2.srdemand.dto.SrDemand;
import com.oti.team2.srdemand.dto.SrRequestDto;
import com.oti.team2.srdemand.dto.SrdemandDetail;
import com.oti.team2.srdemand.dto.WriterDto;
import com.oti.team2.srdemand.service.ISrDemandService;
import com.oti.team2.util.Auth;

import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
@RequestMapping("/srdemand")
public class SrDemandController {

	@Autowired
	private IInstitutionService institutionService;

	@Autowired
	private ISrDemandService srdemandService;

	/**
	 * sr요청 작성 시 , 작성자의 아이디, 이름, 소속기관 이름을 세팅하기 위함
	 * 
	 * @author 신정은
	 * 
	 */
	@ResponseBody
	@GetMapping("/add")
	public WriterDto addSrDemand(HttpSession session) {
		log.info("기본정보 세팅");
		// 세션에서 사용자의 이름을 가져와야 됨.
		String userId = "client1";
		String user = "고객1";

		String instName = institutionService.getInst(userId).getInstNm();
		WriterDto writerDto = new WriterDto(userId, user, instName);
		log.info(writerDto);
		return writerDto;
	}

	/**
	 * sr요청 등록
	 * 
	 * @author 신정은
	 */
	@PostMapping("/add")
	public String postSrDemand(SrRequestDto srRequest) {
		srRequest.setDmndNo("SR-TEST-3");
		log.info(srRequest);
		srdemandService.addSrDemand(srRequest);
		return "redirect:/srdemand/list";
	}

	/**
	 * 고객/관리자별 요청 목록 조회 기능 ********************************수정필요
	 * 
	 * @author 신정은
	 */
	@GetMapping("/list")
	public String getSrDemandList(HttpSession session, Model model,
			@RequestParam(required = false, name = "dmndno") String dmndno) {
		// 고객인 경우
		String auth = Auth.ROLE_CLIENT.toString();
//      String auth = Auth.ADMIN.toString();
		System.out.println("Sdfkjnldfjsdfjlfjlksdjklsj");
		// 목록
		List<SrDemand> list = null;
		if (auth.equals(Auth.ROLE_CLIENT.toString())) {
			String custId = "client1";
			list = srdemandService.getSrDemandList(custId);
			model.addAttribute("mySrDemandList", list);
		}

		// 관리자인 경우

		// 기본 첫번째 상세 or 선택된 상세
		log.info("--------------재");
		SrdemandDetail sd = null;
		if (dmndno != null) {
			sd = srdemandService.getSrDemandDetail(dmndno);
			log.info("sd 존재" + sd);
		} else {
			sd = srdemandService.getSrDemandDetail(list.get(0).getDmndNo());
		}
		log.info(sd);
		model.addAttribute("sd", sd);

		if (auth.equals(Auth.ROLE_CLIENT.toString())) {
			return "srDemand/userSrDemandList";
		}
		return "srDemand/adminSrDemandList";
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

	@PostMapping("/modify")
	public String updateSrDemand(SrRequestDto srRequestDto) {
		// 수정 진행
		log.info(srRequestDto);
		srdemandService.updateSrDemand(srRequestDto);
		return "redirect:/srdemand/list?dmndno=" + srRequestDto.getDmndNo();
	}

}