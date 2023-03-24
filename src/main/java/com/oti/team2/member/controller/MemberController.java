package com.oti.team2.member.controller;

import java.io.IOException;
import java.util.UUID;

import javax.mail.internet.InternetAddress;
import javax.mail.internet.MimeMessage;
import javax.mail.internet.MimeMessage.RecipientType;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;

import com.oti.team2.institution.dto.Institution;
import com.oti.team2.institution.service.IInstitutionService;
import com.oti.team2.member.dto.EmployeeList;
import com.oti.team2.member.dto.File;
import com.oti.team2.member.dto.Member;
import com.oti.team2.member.dto.MemberDto;
import com.oti.team2.member.dto.ProfileImg;
import com.oti.team2.member.service.IJoinService;
import com.oti.team2.member.service.IMemberService;
import com.oti.team2.srresource.service.ISrResourceService;

import lombok.extern.log4j.Log4j2;

@Controller
@Log4j2
@RequestMapping("/member")
public class MemberController {
	@Autowired
	private IMemberService memberService;
	@Autowired
	private IJoinService joinService;
	@Autowired
	private ISrResourceService srResourceService;
	@Autowired
	private IInstitutionService institutionService;
	@Autowired
	private JavaMailSender mailSender;

	/**
	 * 멤버의 내 정보 조회
	 * 
	 * @author : 신정은
	 * @param session
	 * @param model
	 * @return
	 */
	@GetMapping("/myinfo")
	public String getMember(HttpSession session, Model model, Authentication auth) {
		// session 에서 사용자 정보 가져오기
		log.info("-----------------------");
		log.info(auth);
		String role = auth.getAuthorities().stream().findFirst().get().toString();
		log.info(role);
		Member member = memberService.getMember(auth.getName(), role);
		Institution inst = institutionService.getInst(auth.getName());
		log.info(inst);
		log.info(member);
		model.addAttribute("inst", inst);
		model.addAttribute("member", member);
		return "member/myinfo";
	}

	/**
	 * 모든 사용자의 자신의 정보 수정
	 * 
	 * @author : 신정은
	 * @param member
	 * @return
	 */
	@PostMapping("/myinfo")
	public String updateMember(Member member) {
		log.info("변경할 내정보" + member);
		memberService.updateMember(member);
		return "redirect:/member/myinfo";
	}

	/**
	 * 
	 * 멤버의 프로필 사진 조회
	 * 
	 * @author : 신정은
	 * @param memberId
	 * @return
	 */
	@GetMapping("/profile/{memberId}")
	public ResponseEntity<byte[]> getProfile(@PathVariable String memberId) {
		ProfileImg profileImg = memberService.getProfileImg(memberId);
		log.info(memberId);
		HttpHeaders headers = new HttpHeaders();
		String mtypes[] = profileImg.getFileType().split("/");
		headers.setContentType(new MediaType(mtypes[0], mtypes[1]));

		return new ResponseEntity<byte[]>(profileImg.getFileData(), headers, HttpStatus.OK);
	}

	/**
	 * 개발자 목록 조회
	 * 
	 * @author : 안한길
	 * @param deptCd
	 * @return List<developer>
	 */
	@ResponseBody
	@GetMapping("/department")
	public EmployeeList getEmployeeList(@RequestParam() String deptCd) {
		log.info(deptCd);
		EmployeeList employeeList = new EmployeeList();
		employeeList.setDevelopers(memberService.getEmployeeNameList(deptCd));
		employeeList.setSchedule(
				srResourceService.getSrResourceListByEmpId(employeeList.getDevelopers().get(0).getEmpId()));
		log.info(employeeList.getSchedule());
		return employeeList;
	}

	/**
	 * 프로필 사진 등록(수정)
	 * 
	 * @author : 여수한
	 * @param File
	 * @return
	 * @throws IOException
	 */
	@ResponseBody
	@PostMapping("/profile")
	public void addFile(@RequestParam("file") MultipartFile multi, File file, Authentication auth) throws Exception {
		String memberId = auth.getName();
		log.info("컨트롤러 들어옴 : memberId = " + memberId);
		if (multi != null && !multi.isEmpty()) {
			file.setFileContentType(multi.getContentType());
			file.setFileData(multi.getBytes());
			log.info("fileData: " + file.getFileData());
			joinService.addFile(file, memberId);
		}
	}

	/**
	 * 비밀번호 찾기 (이메일로 임시 비밀번호 발급)
	 * 
	 * @author 최은종
	 * @param request, model, memberDto, eml, telNo
	 * @return 로그인 폼
	 * 
	 */
	/*
	@ResponseBody
	@PostMapping("/findPswd")
	public int getPswd(HttpServletRequest req, Model model, MemberDto memberDto,
			@RequestParam(required = true, value = "eml") String eml,
			@RequestParam(required = true, value = "telNo") String telNo) {
		log.info("비번찾기 컨트롤러");
		log.info("1:" + eml);
		log.info("2:" + telNo);

		// 매개변수로 사용할 dto에 뷰를 통해 받은 검증을 위한 이메일과 전화번호 담아서 보내기
		memberDto.setEml(eml);
		memberDto.setTelNo(telNo);
		String joinedMember = memberService.getPswd(memberDto);
		memberDto.setMemberId(joinedMember);
		log.info(joinedMember);
		model.addAttribute("joinedMember", joinedMember);

		if (joinedMember == null) {
			// 회원정보가 없다면
			log.info("회원정보 없음");
			return 0;
		} else {
			// 회원정보가 있다면 임시 비밀번호 생성
			log.info("회원정보 있음");
			String randomPswd = UUID.randomUUID().toString().replaceAll("-", "");
			randomPswd = randomPswd.substring(0, 10);
			// 비밀번호 암호화
			String randomPswdforDb = joinService.getEncodedPassword(randomPswd);
			memberDto.setPswd(randomPswdforDb);
			log.info("randomPswd: " + randomPswd);
			// 임시 비밀번호로 DB 업데이트
			memberService.updateNewPswd(memberDto);

			// 발신인 정보
			String fromEmail = "otiteam2@gmail.com"; // 받는 사람 메일에 표시됨
			String fromName = "오티아이"; // 발신인 이름
			String title = "[오티아이] OTI-SRM 임시 비밀번호 입니다.";
			String content = memberDto.getMemberId() + " 님 안녕하세요.";
			content += "<p class='card-text'>요청하신 임시 비밀번호 발급 서비스 입니다.</p>";
			content += "<p class='card-text'>임시 비밀번호: " + randomPswd + "</p>";
			content += "<p class='card-text'>로그인 후 비밀번호를 변경하여 사용하시길 바랍니다.</p>";
			content += "<p class='card-text'>감사합니다.</p>";
			content += "e-mail: otiteam2@gmail.com";

			// 수신인 정보
			String toEmail = memberDto.getEml();

			// 이메일 발송
			MimeMessage msg = mailSender.createMimeMessage();
			try {
				MimeMessageHelper helper = new MimeMessageHelper(msg, true, "utf-8");
				helper.setFrom(fromEmail);
				helper.setTo(toEmail);
				helper.setSubject(title);
				helper.setText(content, true);
				mailSender.send(msg);
			} catch (Exception e) {
				log.info("이메일 발송 실패: " + e);
			}
			// 회원정보가 있다면
			return 1;
		}
	}
	*/
	
	@ResponseBody
	@PostMapping("/findPswd")
	public int getPswd(HttpServletRequest req, Model model, MemberDto memberDto,
			@RequestParam(required = true, value = "eml") String eml,
			@RequestParam(required = true, value = "telNo") String telNo) {
		log.info("비번찾기 컨트롤러");
		log.info("1:" + eml);
		log.info("2:" + telNo);

		// 매개변수로 사용할 dto에 뷰를 통해 받은 검증을 위한 이메일과 전화번호 담아서 보내기
		memberDto.setEml(eml);
		memberDto.setTelNo(telNo);
		String joinedMember = memberService.getPswd(memberDto);
		memberDto.setMemberId(joinedMember);
		log.info(joinedMember);
		model.addAttribute("joinedMember", joinedMember);

		if (joinedMember == null) {
			// 회원정보가 없다면
			log.info("회원정보 없음");
			return 0;
		} else {
			// 회원정보가 있다면 임시 비밀번호 생성
			log.info("회원정보 있음");
			String randomPswd = UUID.randomUUID().toString().replaceAll("-", "");
			randomPswd = randomPswd.substring(0, 10);
			// 비밀번호 암호화
			String randomPswdforDb = joinService.getEncodedPassword(randomPswd);
			memberDto.setPswd(randomPswdforDb);
			log.info("randomPswd: " + randomPswd);
			// 임시 비밀번호로 DB 업데이트
			memberService.updateNewPswd(memberDto);

			// 발신인 정보
			String fromEmail = "otiteam2@gmail.com"; // 받는 사람 메일에 표시됨
			String fromName = "오티아이"; // 발신인 이름
			String title = "[오티아이] OTI-SRM 임시 비밀번호 입니다.";
			
			String content = "";
			content += "<!DOCTYPE html>";
			content += "<html lang=\"en\">";
			content += "<head>" + 
					"<title>CSS Template</title>" + 
					"<meta charset=\"utf-8\">" + 
					"<meta name=\"viewport\" content=\"width=device-width, initial-scale=1\">";
			content += "<style>" + 
					"* {box-sizing: border-box;}" + 
					"body { font-family: Arial, Helvetica, sans-serif;}";
			content += "header {" + 
					"  background:  linear-gradient( 135deg, #360940 10%, #F05F57 100%);" + 
					"  padding: 5px;" + 
					"  text-align: center;" + 
					"  font-size: 20px;" + 
					"  color: white;" + 
					"}";
			content += "article {" + 
					"  -webkit-flex: 3;" + 
					"  -ms-flex: 3;" + 
					"  flex: 3;" + 
					"  background-color: #F2F2F2;" + 
					"  padding: 40px;" + 
					"}" + 
					"footer {" + 
					"  background-color: #4C1342;" + 
					"  padding: 3px;" + 
					"  text-align: center;" + 
					"  color: white;" + 
					"}" + 
					"a{color:#FFFFFF;}" + 
					"h3{text-align: center;}"+
					"a:hover{color:#F05F57;}" + 
					"</style>" + 
					"</head>";
			content += "<body>" + 
					"<header>" + 
					"  <h2>임시 비밀번호 발급</h2>" + 
					"</header>";
			content += "<section>" + 
					"  <article>" + 
					"    <h1>안녕하세요 "+ memberDto.getMemberId() +" 님</h1>" + 
					"     <p>오티아이 SRM 입니다.</p>" + 
					"    <p>아래의 임시 비밀번호로 로그인 하신 뒤 비밀번호 변경을 진행해주세요.</p>";
			content += "<div align='center' style='border:2px solid black; font-family:verdana';>" + 
					"      <div style='font-size:200%; color:#D45254;'>" + 
					"      	<strong >"+ randomPswd +"<strong >" + 
					"      </div>" + 
					"	</div>" + 
					"  <br/>";
			content += "<p>고객의 행복을 함께 만들어 갑니다.</p>" + 
					"   <p>감사합니다.</p>" + 
					"   <br/>" + 
					"   <p>Contact Us : otiteam2@gmail.com</p>" + 
					"<h3 style='color:white;'><a href=\"http://localhost:8080/loginForm\">로그인 하러 가기</a></h3>" +
					"  </article>" + 
					"</section>";
			content += "<footer>" + 
					"<strong ><p style='line-height: 20px'>Team2</p><strong >" +
					"</footer>" + 
					"</body>" + 
					"</html>";

			// 수신인 정보
			String toEmail = memberDto.getEml();

			// 이메일 발송
			try {
				MimeMessage msg = mailSender.createMimeMessage();			
				msg.setFrom(new InternetAddress(fromEmail, "오티아이"));
				msg.addRecipient(RecipientType.TO, new InternetAddress(toEmail, memberDto.getMemberId(), "UTF-8"));
				msg.setSubject(title);
				msg.setText(content, "UTF-8", "html"); //html태그 넣기 위함
				mailSender.send(msg);
			} catch (Exception e) {
				log.info("이메일 발송 실패: " + e);
			}
			// 회원정보가 있다면
			return 1;
		}
	}

	/**
	 * 
	 * 사진 조회
	 * 
	 * @author : 신정은
	 * @param memberId
	 * @return
	 */
	@GetMapping("/img/{memberId}")
	public ResponseEntity<byte[]> getimg(@PathVariable String memberId) {
		ProfileImg profileImg = memberService.getProfileImg(memberId);
		log.info(" 영기 ~~~ ");
		log.info(memberId);
		HttpHeaders headers = new HttpHeaders();
		String mtypes[] = profileImg.getFileType().split("/");
		headers.setContentType(new MediaType(mtypes[0], mtypes[1]));

		return new ResponseEntity<byte[]>(profileImg.getFileData(), headers, HttpStatus.OK);
	}

}
