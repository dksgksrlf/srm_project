package com.oti.team2.srinformation.service;

import java.util.List;

import com.oti.team2.srdemand.dto.SdApprovalDto;
import com.oti.team2.srinformation.dto.Dept;
import com.oti.team2.srinformation.dto.Manager;
import com.oti.team2.srinformation.dto.SrinformationList;
import com.oti.team2.srinformation.dto.SrplanInformation;

public interface ISrinformationService {
	/**
	 * 
	 * @author 여수한
	 * 작성일자 : 2023-02-22
	 * @return sr진척 목록 조회
	 */
	List<SrinformationList> getList();
	
	/**
	 * @author 여수한
	 * 작성일자 : 2023-03-02
	 * @return 개발부서 조회
	 */
	List<Dept> getDeptList();
	
	/**
	 * @author 여수한
	 * 작성일자 : 2023-02-23
	 * @return sr진척 계획정보 조회
	 */
	SrplanInformation getPlan(String Plan);
	
	/**
	 * 관리자의 sr요청 승인 시 -> srInformation에 insert하기
	 * @author 신정은
	 */
	public void insertInformation(SdApprovalDto sdApprovalDt);
		
	/**
	 * @author 여수한
	 * 작성일자 : 2023-03-02
	 * @return sr계획정보 부서의 담당자 조회
	 */
	Manager getFlnmByDeptCd(String deptCd);
	
	/**
	 * @author 여수한
	 * 작성일자 : 2023-03-02
	 * @return sr계획정보 부서 변경
	 */
	void updateSrInfo(SrplanInformation srplanInfomation);
}
