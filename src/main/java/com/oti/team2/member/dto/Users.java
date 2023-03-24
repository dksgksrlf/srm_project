package com.oti.team2.member.dto;

import java.util.List;

import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.core.userdetails.User;

public class Users extends User {
	private String flnm;
	private String picture;

	public Users(
		String memberId,
		String pswd,
		boolean enabled,
		List<GrantedAuthority> authority,	
		String flnm, String picture) {
	super(memberId, pswd, enabled, true, true, true, authority);
	this.flnm=flnm;
	this.picture=picture;
		}

	public String getFlnm() {
		return flnm;
	}
	
	public String getPicture() {
		return picture;
	}

}