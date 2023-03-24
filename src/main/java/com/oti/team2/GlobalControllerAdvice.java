package com.oti.team2;

import org.springframework.security.core.Authentication;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.ControllerAdvice;
import org.springframework.web.bind.annotation.ExceptionHandler;
import org.springframework.web.bind.annotation.RequestMapping;

import lombok.extern.log4j.Log4j2;

@ControllerAdvice
@Log4j2
public class GlobalControllerAdvice {

	/**
	 * ControllerAdvice를 이용한 예외발생 처리 메서드
	 *
	 * @author 최은종
	 * @param exception 모든 예외의 최상위 클래스
	 * @return 에러 페이지로 리턴
	 */
	@ExceptionHandler(Exception.class)
	public String exceptionAll(Exception exception, Model model, Authentication auth) {
		log.error(exception.toString());
		//exception.printStackTrace();

		model.addAttribute("exception", exception);
		if ((auth.getAuthorities().stream().findFirst().get().toString()).equals("ROLE_CLIENT")) {
			log.info("고객용 에러페이지");
			return "error/runtimeClient";
		} else {
			log.error(exception.getMessage());
			log.info("관리자/개발자용 에러페이지");
			return "error/runtime";
		}
	}

}