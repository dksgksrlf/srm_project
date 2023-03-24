package com.oti.team2.member.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oti.team2.board.dto.BoardListDto;
import com.oti.team2.board.service.IBoardService;
import com.oti.team2.srdemand.dto.MytodoSrListDto;
import com.oti.team2.srdemand.service.ISrDemandService;
import com.oti.team2.srinformationhistory.dto.MyTodoHistoryListDto;
import com.oti.team2.srinformationhistory.service.ISrInformationHistoryService;
import com.oti.team2.util.Auth;
import com.oti.team2.util.pager.Pager;

import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
public class MainController {

	@Autowired
	private ISrDemandService srdemandService;

	@Autowired
	private IBoardService boardService;

	@Autowired
	private ISrInformationHistoryService srInformationHistoryService;

	/**
	 * 나의 할일 화면 제공
	 *
	 * @author 신정은
	 * 
	 */
	@GetMapping("/myportal")
	public String mypotal(Authentication auth, Model model) {
		String role = auth.getAuthorities().stream().findFirst().get().toString();
		String memberId = auth.getName();
		model.addAttribute("memberId", memberId);

		List<MytodoSrListDto> srList = null;
		List<BoardListDto> qnaList = null;
		List<BoardListDto> noticeList = null;
		Pager qPager = null; // qna 페이저
		Pager nPager = null; // notice 페이저
		Pager pager = null; // sr페이저
		int atotal = 0; // 요청 : 0
		int rejTotal = 0; // 반려 : 1
		int rtotal = 0; // 접수 : 2
		int dtotal = 0; // 개발 : 3
		int ttotal = 0; // 테스트 :4
		int comtotal = 0; // 완료 : 5
		int cantotal = 0; // 취소 : 6
		int histotal = 0; // 히스토리

		// 공지사항
		nPager = new Pager(6, boardService.getTotalRow("notice", null, null), 1);
		noticeList = boardService.getBoardList("notice", null, nPager, null);

		if (role.equals(Auth.ROLE_CLIENT.toString())) {
			pager = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(auth.getName(), null, 2, 1);
			atotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(auth.getName(), null, 0, 1).getTotalRows();
			rejTotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(auth.getName(), null, 1, 1).getTotalRows();
			rtotal = pager.getTotalRows();
			dtotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(auth.getName(), null, 3, 1).getTotalRows();
			ttotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(auth.getName(), null, 4, 1).getTotalRows();
			comtotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(auth.getName(), null, 5, 1).getTotalRows();
			cantotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(auth.getName(), null, 6, 1).getTotalRows();
			// 히스토리 총 수 가져와야 됨
			histotal = srInformationHistoryService.getCountTodoForCust(auth.getName());
			srList = srdemandService.getMytodoSrList(auth.getName(), null, 2, pager);
			// 게시글
			qPager = new Pager(6, boardService.getTotalRow("qna", memberId, null), 1);
			qnaList = boardService.getBoardList("qna", memberId, qPager, null);
			model.addAttribute("sttsCd", 2);

		} else if (role.equals(Auth.ROLE_DEVELOPER.toString())) {
			pager = srdemandService.getcountsByEmpIdAndSttsCd(auth.getName(), 3, 1);
			srList = srdemandService.getMytodoSrListForDeveloper(auth.getName(), 3, pager);

			atotal = srdemandService.getcountsByEmpIdAndSttsCd(auth.getName(), 0, 1).getTotalRows();
			rejTotal = srdemandService.getcountsByEmpIdAndSttsCd(auth.getName(), 1, 1).getTotalRows();
			rtotal = srdemandService.getcountsByEmpIdAndSttsCd(auth.getName(), 2, 1).getTotalRows();
			dtotal = pager.getTotalRows();
			ttotal = srdemandService.getcountsByEmpIdAndSttsCd(auth.getName(), 4, 1).getTotalRows();
			comtotal = srdemandService.getcountsByEmpIdAndSttsCd(auth.getName(), 5, 1).getTotalRows();
			cantotal = srdemandService.getcountsByEmpIdAndSttsCd(auth.getName(), 6, 1).getTotalRows();
			// 히스토리 총 수 가져와야 됨
			histotal = srInformationHistoryService.getCountTodoForDev(auth.getName(), auth.getName());
			// 게시글
			qPager = new Pager(6, boardService.getcountByEmpId(memberId, null), 1);
			qnaList = boardService.getBoardListByEmpId(memberId, qPager, null);
			model.addAttribute("sttsCd", 3);

		} else {
			pager = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(null, auth.getName(), 0, 1);
			srList = srdemandService.getMytodoSrList(null, auth.getName(), 0, pager);

			atotal = pager.getTotalRows();
			rejTotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(null, auth.getName(), 1, 1).getTotalRows();
			rtotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(null, auth.getName(), 2, 1).getTotalRows();
			dtotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(null, auth.getName(), 3, 1).getTotalRows();
			ttotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(null, auth.getName(), 4, 1).getTotalRows();
			comtotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(null, auth.getName(), 5, 1).getTotalRows();
			cantotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(null, auth.getName(), 6, 1).getTotalRows();
			// 히스토리 총 수 가져와야 됨
			histotal = srInformationHistoryService.getCountTodoForAdmin(auth.getName());
			// 게시글
			qPager = new Pager(6, boardService.getTotalRow("qna", null, null), 1);
			qnaList = boardService.getBoardList("qna", null, qPager, null);
			model.addAttribute("sttsCd", 0);

		}
		model.addAttribute("srList", srList);
		model.addAttribute("pager", pager);

		model.addAttribute("atotal", atotal); // [요청]건의 총 수를 보여준다.
		model.addAttribute("rejTotal", rejTotal); // [반려]건의 총 수를 보여준다.
		model.addAttribute("rtotal", rtotal); // [접수]건의 총 수를 보여준다.
		model.addAttribute("dtotal", dtotal); // [개발]건의 총 수를 보여준다.
		model.addAttribute("ttotal", ttotal); // [테스트]건의 총 수를 보여준다.
		model.addAttribute("comtotal", comtotal); // [개발 완료]건의 총 수를 보여준다.
		model.addAttribute("cantotal", cantotal); // [취소]건의 총 수를 보여준다.
		model.addAttribute("histotal", histotal); // [권한별로 히스토리]건의 총 수를 보여준다.

		model.addAttribute("qnaList", qnaList);
		model.addAttribute("qPager", qPager);
		model.addAttribute("noticeList", noticeList);
		model.addAttribute("nPager", nPager);

		log.info(srList);
		log.info(pager);
		return "member/my-todo";
	}

	/**
	 * 나의 할 일의 요청상태별 처리
	 *
	 * @author 신정은
	 * 
	 */
	@GetMapping("/myportal/mytodo")
	public String mytodo(Authentication auth, Model model,
			@RequestParam(required = true, name = "sttsCd", defaultValue = "0") int stts,
			@RequestParam(required = true, name = "page", defaultValue = "1") int pageNo) {

		String role = auth.getAuthorities().stream().findFirst().get().toString();
		List<MytodoSrListDto> srList = null;
		Pager pager = null;
		log.info("stts   : " + stts);

		if (role.equals(Auth.ROLE_CLIENT.toString())) {
			pager = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(auth.getName(), null, stts, pageNo);
			srList = srdemandService.getMytodoSrList(auth.getName(), null, stts, pager);
		} else if (role.equals(Auth.ROLE_DEVELOPER.toString())) {
			pager = srdemandService.getcountsByEmpIdAndSttsCd(auth.getName(), stts, pageNo);
			srList = srdemandService.getMytodoSrListForDeveloper(auth.getName(), stts, pager);
		} else {
			pager = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(null, auth.getName(), stts, pageNo);
			srList = srdemandService.getMytodoSrList(null, auth.getName(), stts, pager);
		}

		model.addAttribute("srList", srList);
		model.addAttribute("pager", pager);
		model.addAttribute("sttsCd", stts);
		log.info(srList);
		log.info(pager);
		return "mytodo/srTable";
	}

	/**
	 * 나의 할 일에서 히스토리 내역 보여주기
	 *
	 * @author 최은종
	 * @param pageNo, model, auth
	 * @return 히스토리 탭 경로 리턴
	 * 
	 */
	@GetMapping("/myportal/mytodo/history")
	public String mytodo(Authentication auth, Model model,
			@RequestParam(required = true, name = "page", defaultValue = "1") int pageNo) {
		log.info("컨트롤러");

		String authRole = auth.getAuthorities().stream().findFirst().get().toString();

		int totalRows = 0;
		Pager pager = null;
		log.info("pageNo 조회" + pageNo);

		List<MyTodoHistoryListDto> todoHstryList = null;

		if (authRole.equals("ROLE_ADMIN")) {
			log.info("나는 관리자");
			totalRows = srInformationHistoryService.getCountTodoForAdmin(auth.getName());
			pager = new Pager(5, totalRows, pageNo);
			todoHstryList = srInformationHistoryService.getHstryTodoByPicId(pager, auth.getName());
		} else if (authRole.equals("ROLE_DEVELOPER")) {
			log.info("나는 개발자");
			totalRows = srInformationHistoryService.getCountTodoForDev(auth.getName(), auth.getName());
			pager = new Pager(5, totalRows, pageNo);
			todoHstryList = srInformationHistoryService.getHstryTodoByEmpId(pager, auth.getName(), auth.getName());
		} else {
			log.info("나는 고객");
			totalRows = srInformationHistoryService.getCountTodoForCust(auth.getName());
			pager = new Pager(5, totalRows, pageNo);
			todoHstryList = srInformationHistoryService.getHstryTodoByCustId(pager, auth.getName());
		}

		model.addAttribute("todoHstryList", todoHstryList);
		model.addAttribute("authRole", authRole);
		model.addAttribute("pager", pager);

		log.info(todoHstryList);
		return "mytodo/srHstryTable";
	}

	/**
	 * 고객의 차트 구성
	 * 
	 * @author 신정은
	 */
	@ResponseBody
	@GetMapping("/client/chart")
	public Map<Integer, Integer> getClientChart(Authentication auth) {
		String memberId = auth.getName();

		int atotal = 0; // 요청 : 0
		int rejTotal = 0; // 반려 : 1
		int rtotal = 0; // 접수 : 2
		int dtotal = 0; // 개발 : 3
		int ttotal = 0; // 테스트 :4
		int comtotal = 0; // 완료 : 5
		int cantotal = 0; // 취소 : 6

		atotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(auth.getName(), null, 0, 1).getTotalRows();
		rejTotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(auth.getName(), null, 1, 1).getTotalRows();
		rtotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(auth.getName(), null, 2, 1).getTotalRows();
		dtotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(auth.getName(), null, 3, 1).getTotalRows();
		ttotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(auth.getName(), null, 4, 1).getTotalRows();
		comtotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(auth.getName(), null, 5, 1).getTotalRows();
		cantotal = srdemandService.getcountsByCustIdOrPicIdAndSttsCd(auth.getName(), null, 6, 1).getTotalRows();

		Map<Integer, Integer> map = new HashMap<>();
		map.put(0, atotal);
		map.put(1, rejTotal);
		map.put(2, rtotal);
		map.put(3, dtotal);
		map.put(4, ttotal);
		map.put(5, comtotal);
		map.put(6, cantotal);

		log.info(map);
		return map;
	}

	/**
	 * 403 접근 권한이 없다는 에러화면 제공
	 * 
	 * @author 신정은
	 */
	@GetMapping("/error/forbidden")
	public String forbiddenErrorPage() {
		return "error/forbidden";
	}
}
