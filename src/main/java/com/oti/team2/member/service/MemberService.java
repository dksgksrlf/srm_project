package com.oti.team2.member.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.oti.team2.member.dao.IMemberDao;
import com.oti.team2.member.dto.Developer;
import com.oti.team2.member.dto.FilterDto;
import com.oti.team2.member.dto.Member;
import com.oti.team2.member.dto.ProfileImg;
import com.oti.team2.util.pager.Pager;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class MemberService implements IMemberService {
	@Autowired
	private IMemberDao memberDao;
	
	/**
	 * 멤버 타입별 총 행수 조회
	 *@author : 신정은
	 */
	@Override
	public int getTotalRows(String memberType , FilterDto filterDto) {
		return memberDao.countByMemberType(memberType,filterDto);
	}
	
	/**
	 * 멤버 타입 별 목록 조회 (관리자가 수행)
	 *@author : 신정은
	 */
	@Override
	public List<Member> getMemberList(String memberType, Pager pager,FilterDto filterDto) {
		return memberDao.selectByMemberType(memberType, pager,filterDto);		
	}

	/**
	 * 멤버 타입 별 내 정보 조회
	 *@author : 신정은
	 */
	@Override
	public Member getMember(String memberId, String memberType) {
		return memberDao.selectByMemberIdAndMemberType(memberId, memberType);	
	}

	/**
	 * 멤버 타입 별 내 정보 수정
	 * 고객만 수정, 관리자/개발자 수정 필요
	 * @author : 신정은
	 */
	@Override
	public void updateMember(Member member) {		
		int row = memberDao.updateMember(member);
		log.info("row : " + row);
	}

	/**
	 * 멤버의 프로필 사진 조회
	 * 수정 필요
	 *@author : 신정은
	 */
	@Override
	public ProfileImg getProfileImg(String memberId) {
		
		return null;
	}
	
	/*
	 * 맴버 삭제 
	 * @author 안한길
	 * @param  맴버아이디
	 * @return 반영된 행수
	 * */
	@Override
	public int deleteMember(String memberId) {
		return memberDao.deleteMemberByMemberId(memberId);
	}

	/*
	 * 맴버 수정
	 * @author 안한길
	 * @param  수정된 값
	 * @return 반영된 행수
	 * */
	@Override
	public int modifyMember(Member member) {
		return memberDao.updateMemberByMemberId(member);
	}
	/*
	 * 개발자 목록 조회
	 * @author 안한길
	 * @param  부서 id
	 * @return 개발자 목록
	 * */
	@Override
	public List<Developer> getEmployeeNameList(String deptCd) {
		return memberDao.selectByDeptCd(deptCd);
	}

	/**
	 * memberId로 사용자 이름 가져오기
	 * @author 신정은
	 */
	public String getFlnm(String memberId) {
		return memberDao.selectFlnmByMemberId(memberId);
	}
}
