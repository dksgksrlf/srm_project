package com.oti.team2.member.controller;

import java.util.Collection;
import java.util.Iterator;

import org.springframework.security.core.Authentication;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.oti.team2.member.dto.Users;

import lombok.extern.log4j.Log4j2;
@Log4j2
@Controller
public class LoginController {
	
	@GetMapping("/loginForm")
	public String getLogin() {
		return "member/login";
	}

	@ResponseBody
	@GetMapping("/auth")
	public Authentication postLogin(Authentication auth) { //@AuthenticationPrincipal Users user
		//Authentication auth = SecurityContextHolder.getContext().getAuthentication();
		
		//Id 알아오는 법
		//Authentication auth 매개변수로 가져오고 getName();
		String memberId=auth.getName();	
		Collection<? extends GrantedAuthority> authorities = auth.getAuthorities();
		
		Iterator<? extends GrantedAuthority> iterator = authorities.iterator();
		GrantedAuthority authority;
		while(iterator.hasNext()) authority = iterator.next();
		log.info("getName: "+ memberId);

		return auth;
	}
}
