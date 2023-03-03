package com.oti.team2.srinformation.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oti.team2.srdemand.dto.SrdemandDetail;
import com.oti.team2.srdemand.service.ISrDemandService;
import com.oti.team2.srinformation.dto.Dept;
import com.oti.team2.srinformation.dto.Manager;
import com.oti.team2.srinformation.dto.SrTotal;
import com.oti.team2.srinformation.dto.SrinformationList;
import com.oti.team2.srinformation.dto.SrplanInformation;
import com.oti.team2.srinformation.service.ISrinformationService;

import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
public class SrinformationController {
	
	@Autowired
	ISrinformationService srinformationService;
	
	@Autowired
	ISrDemandService srDemandService;
	
	/**
	 * 
	 * @author 여수한
	 * 작성일자 : 2023-02-22
	 * @return sr진척 목록 조회 - 완료
	 */
	@RequestMapping(value="/srinformation/list", method=RequestMethod.GET)
	public String getList(Model model) {
		List<SrinformationList> srlist = srinformationService.getList();
		SrdemandDetail sd = srDemandService.getSrDemandDetail(srlist.get(0).getDmndNo());
		List<Dept> deptList = srinformationService.getDeptList();
		log.info("sd 상세 : " + sd);
		log.info("진척목록: " + srlist);
		log.info("개발부서 목록: " + deptList);
		model.addAttribute("sd", sd);
		model.addAttribute("srlist", srlist);
		model.addAttribute("deptList", deptList);
		return "srInfo/srInformationList";
	}
	
	/**
	 * 
	 * @author 여수한
	 * 작성일자 : 2023-02-22
	 * @return sr요청 상세 조회 - 완료  => 계획정보도 같이 가져와야될듯
	 */
	@ResponseBody
	@RequestMapping(value="/srinformation/detail/{dmndNo}", method=RequestMethod.GET)
	public SrTotal getDetail(@PathVariable("dmndNo")String dmndNo) {
		SrdemandDetail dd = srDemandService.getSrDemandDetail(dmndNo);
		SrplanInformation pi = srinformationService.getPlan(dmndNo);
		SrTotal total = new SrTotal(dd,pi);
		return total;
	}
	
	/**
	 * 
	 * @author 여수한
	 * 작성일자 : 2023-02-23
	 * @return sr요청 계획정보 조회 - 탭 누를 때
	 */
	@ResponseBody
	@RequestMapping(value="/srinformation/plan/{dmndNo}", method=RequestMethod.GET)
	public SrplanInformation getPlanInfo(@PathVariable("dmndNo")String dmndNo) {
		SrplanInformation pi = srinformationService.getPlan(dmndNo);
		log.info("pi : " + pi);
		return pi;
	}

	/**
	 * 
	 * @author 여수한
	 * 작성일자 : 2023-03-02
	 */
	@ResponseBody
	@RequestMapping(value="/srinformation/plan/update", method=RequestMethod.POST)
	public void updateSrInfo(SrplanInformation srplanInfomation) {
		log.info("업데이트될 계획 정보 : " + srplanInfomation);
		srinformationService.updateSrInfo(srplanInfomation);
	}
	
	/**
	 * 
	 * @author 여수한
	 * 작성일자 : 2023-03-02
	 * @return sr계획정보 부서 변경
	 */
	@ResponseBody
	@RequestMapping(value="/srinformation/mngr/{deptCd}", method=RequestMethod.GET)
	public Manager getFlnmByDeptCd(@PathVariable("deptCd")String deptCd) {
		Manager flnm = srinformationService.getFlnmByDeptCd(deptCd);
		log.info("바뀐 담당자: " + flnm);
		return flnm;
	}
}
