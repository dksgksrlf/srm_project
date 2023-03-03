package com.oti.team2.system.dao;

import java.util.List;

import com.oti.team2.system.dto.SrSystem;

public interface ISystemDao {
	
	/**
	 * 모든 시스템 조회
	 * @author 신정은
	 */
	public List<SrSystem> selectAll();
	
	/**
	 * sysCd로 deptCd 가져오기
	 * @author 신정은
	 */
	public String getDeptCdBySysCd(String sysCd);
	
	/**
	 * 요청 등록 시, 초기 데이터 세팅을위해 하나의 시스템과 해당 업무구분 데이터를 제공을 위함
	 * @author 신정은
	 */
	public SrSystem selectFirstSystem();

}
