package com.oti.team2.system.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.oti.team2.system.dao.ISystemDao;
import com.oti.team2.system.dto.SrSystem;

@Service
public class SystemService implements ISystemService{

	@Autowired
	private ISystemDao systemDao;
	
	/**
	 * SR요청 등록시, 모든 시스템 조회
	 * @author 신정은
	 */
	public List<SrSystem> getSystemList() {
		List<SrSystem> systems = systemDao.selectAll();
		return systems;
	}
	
	/**
	 * sysCd로 deptCd 가져오기
	 * @author 신정은
	 */
	public String getDeptCdBySysCd(String sysCd) {
		return systemDao.getDeptCdBySysCd(sysCd);
	}

	/**
	 * 요청 등록 시, 초기 데이터 세팅을위해 하나의 시스템과 해당 업무구분 데이터를 제공을 위함
	 * @author 신정은
	 */
	public SrSystem getFirstSystem() {
		return systemDao.selectFirstSystem();
	}
}
