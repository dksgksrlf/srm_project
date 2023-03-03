package com.oti.team2.department.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.oti.team2.department.dto.Department;

@Mapper
public interface IDepartmentDao {
	/**
	 * 부서목록 조회 메서드
	 * 
	 * @author 최은종
	 */
	public List<Department> selectByMemberId();

	/**
	 * 신규부서 등록 메서드
	 * 
	 * @author 최은종
	 */
	public int insertDept(@Param("department") Department department);

	/**
	 * 부서정보 수정 메서드
	 * 
	 * @author 최은종
	 */
	public int updateDept(@Param("department") Department department);

	/**
	 * 부서정보 삭제 메서드
	 * 
	 * @author 최은종
	 */
	public int deleteDept(String deptCd);
	
	/*
	 * 부서 이름 목록
	 * @author 안한길
	 * @return 부서 이름 목록
	 * */
	public List<Department> selectDepartmentNameList();
	
	/**
	 *  부서cd로 담당자 아이디 가져오기
	 *  @author 신정은
	 */
	public String selectMngrNameByDeptCd(@Param("deptCd") String deptCd);
}
