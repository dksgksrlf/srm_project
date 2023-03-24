package com.oti.team2.member.service;

import java.util.List;

import com.oti.team2.member.dto.Developer;
import com.oti.team2.member.dto.FilterDto;
import com.oti.team2.member.dto.Member;
import com.oti.team2.member.dto.MemberDto;
import com.oti.team2.member.dto.ProfileImg;
import com.oti.team2.util.pager.Pager;

public interface IMemberService {

	/**
	 * 멤버 타입별 총 행수 조회
	 * 
	 * @author : 신정은
	 * @param memberType
	 * @return
	 */
	public int getTotalRows(String memberType, FilterDto filterDto);

	/**
	 * 멤버 타입 별 목록 조회 (관리자가 수행)
	 * 
	 * @author : 신정은
	 * @param memberType
	 * @param pager
	 * @param filtering
	 * @return
	 */
	public List<Member> getMemberList(String memberType, Pager pager, FilterDto filterDto);

	/**
	 * 멤버 타입 별 내 정보 조회
	 * 
	 * @author : 신정은
	 * @param memberId
	 * @param memberType
	 * @return
	 */
	public Member getMember(String memberId, String memberType);

	/**
	 * 멤버 타입 별 내 정보 수정 고객만 수정, 관리자/개발자 수정 필요
	 * 
	 * @author : 신정은
	 * @param member
	 */
	public void updateMember(Member member);

	/**
	 * 멤버의 프로필 사진 조회 수정 필요
	 * 
	 * @author : 신정은
	 * @param memberId
	 * @return
	 */
	public ProfileImg getProfileImg(String memberId);

	/*
	 * 맴버 삭제
	 * 
	 * @author 안한길
	 * 
	 * @param 맴버아이디
	 * 
	 * @return 반영된 행수
	 */
	public int deleteMember(String memberId);

	/*
	 * 맴버 수정
	 * 
	 * @author 안한길
	 * 
	 * @param 수정된 값
	 * 
	 * @return 반영된 행수
	 */
	public int modifyMember(Member member);

	/*
	 * 개발자 목록 조회
	 * 
	 * @author 안한길
	 * 
	 * @param 부서 id
	 * 
	 * @return 개발자 목록
	 */
	public List<Developer> getEmployeeNameList(String deptCd);

	/**
	 * memberId로 사용자 이름 가져오기
	 * 
	 * @author 신정은
	 */
	public String getFlnm(String memberId);

	/**
	 * 아이디와 전화번호로 가입 유무 판단해서 비밀번호 찾기
	 * 
	 * @author 최은종 
	 * 
	 */
	public String getPswd(MemberDto memberDto);

	/**
	 * 비밀번호 찾기 후 임시 비밀번호로 업데이트
	 * 
	 * @author 최은종 
	 * 
	 */
	public int updateNewPswd(MemberDto memberDto);
	
	public Member isMember(String id);
}
