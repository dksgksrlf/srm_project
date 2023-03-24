package com.oti.team2.member.service;

import java.util.ArrayList;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;

import com.oti.team2.member.dao.IMemberDao;
import com.oti.team2.member.dto.Member;
import com.oti.team2.member.dto.Users;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class UserService implements UserDetailsService {

	@Autowired
	private IMemberDao memberDao;

	/**
	 * 스프링 시큐리티 적용한 로그인 메소드
	 * 
	 * @author 최은종, 신정은
	 */
	@Override
	public UserDetails loadUserByUsername(String memberId) throws UsernameNotFoundException {
		log.info("서비스 들어옴~~~~~~~~~~~~~~");
		Member member = memberDao.selectByMemberId(memberId);
		if (member == null) {
			throw new UsernameNotFoundException("없는 사용자입니다.");
		}
		log.info(member);

		List<GrantedAuthority> authority = new ArrayList<>();
		authority.add(new SimpleGrantedAuthority(member.getAuthority()));

		Users user = new Users(member.getMemberId(), member.getPswd(), member.isEnabled(), authority, member.getFlnm(), null);
		return user;
	}
}