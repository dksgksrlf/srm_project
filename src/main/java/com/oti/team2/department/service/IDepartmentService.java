package com.oti.team2.department.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.oti.team2.department.dto.Department;

import com.oti.team2.util.pager.Pager;

public interface IDepartmentService {

	/**
	 * 부서목록 조회 메서드
	 * 
	 * @author 최은종
	 */
	public List<Department> getDepartmentList();

	/**
	 * 신규부서 등록 메서드
	 * 
	 * @author 최은종
	 */
	public int addDepartment(Department department);

	/**
	 * 부서정보 수정 메서드
	 * 
	 * @author 최은종
	 */
	public int updateDepartment(Department department);

	/**
	 * 부서정보 삭제 메서드
	 * 
	 * @author 최은종
	 */
	public int deleteDepartment(String deptCd);
	
	/*
	 * 부서 이름 목록
	 * @author 안한길
	 * @return 부서 이름 목록
	 * */
	public List<Department> getDepartmentNameList();
	
	/**
	 *  부서cd로 담당자 아이디 가져오기
	 *  @author 신정은
	 */
	public String getMngrNameByDeptCd(@Param("deptCd") String deptCd);
}
