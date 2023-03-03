package com.oti.team2.srinformation.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.oti.team2.srinformation.dto.Dept;
import com.oti.team2.srinformation.dto.Manager;
import com.oti.team2.srinformation.dto.SrInformationRequestDto;
//github.com/OTI-SRM/srm_project
import com.oti.team2.srinformation.dto.SrinformationList;
import com.oti.team2.srinformation.dto.SrplanInformation;

@Mapper
public interface ISrinformationDao {

	/**
	 * 
	 * @author 여수한 작성일자 : 2023-02-22
	 * @return sr진척 상세 조회
	 */
	public List<SrinformationList> selectInfoAll();

	/**
	 * 
	 * @author 여수한 작성일자 : 2023-02-23
	 * @return sr진척 계획정보 조회
	 */
	public SrplanInformation selectPlanByDmndNo(@Param("dmndNo") String dmndNo);
	
	/**
	 * WOR-2023 으로 시작하는 데이터의 수를 가져온다.
	 *  @author 신정은
	 */
	public int countBySrNo(String srCode);
	
	/**
	 * sr요청 승인 시 srInformation으로 insert한다.
	 *  @author 신정은
	 */
	public int insertSrInformatioin(SrInformationRequestDto srInfoDto);

	/**
	 * 
	 * @author 여수한 작성일자 : 2023-03-02
	 * @return 개발부서 조회
	 */
	public List<Dept> selectDept();

	/**
	 * 
	 * @author 여수한 작성일자 : 2023-03-02
	 * @param deptCd 
	 * @return sr계획정보 부서 변경시 해당 담당자 변경
	 */
	public Manager selectFlnmByDeptCd(@Param("deptCd") String deptCd);
	
	/**
	 * 
	 * @author 여수한
	 * 작성일자 : 2023-03-02
	 * @return sr계획정보 부서 변경
	 */
	public void updateSrInfo(@Param("srplanInfomation") SrplanInformation srplanInfomation);
}
