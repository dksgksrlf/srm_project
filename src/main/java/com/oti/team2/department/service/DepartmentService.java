package com.oti.team2.department.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.oti.team2.department.dao.IDepartmentDao;
import com.oti.team2.department.dto.Department;

import lombok.extern.log4j.Log4j2;

@Service
@Log4j2
public class DepartmentService implements IDepartmentService {
	@Autowired
	private IDepartmentDao departmentDao;

	/**
	 * 부서목록 조회 메서드
	 * 
	 * @author 최은종
	 */
	@Override
	public List<Department> getDepartmentList() {
		List<Department> department = departmentDao.selectByMemberId();
		return department;
	}

	/**
	 * 신규부서 등록 메서드
	 * 
	 * @author 최은종
	 */
	@Transactional
	public int addDepartment(Department department) {
		int rows = departmentDao.insertDept(department);
		return rows;
	}

	/**
	 * 부서정보 수정 메서드
	 * 
	 * @author 최은종
	 */
	@Transactional
	public int updateDepartment(Department department) {
		int rows = departmentDao.updateDept(department);
		return rows;
	}

	/**
	 * 부서정보 삭제 메서드
	 * 
	 * @author 최은종
	 */
	@Transactional
	public int deleteDepartment(String deptCd) {
		int rows = departmentDao.deleteDept(deptCd);
		return rows;
	}
	
	/*
	 * 부서 이름 목록
	 * @author 안한길
	 * @return 부서 이름 목록
	 * */
	@Override
	public List<Department> getDepartmentNameList() {
		return departmentDao.selectDepartmentNameList();
	}

	/**
	 *  부서cd로 담당자 id 가져오기
	 *  @author 신정은
	 */
	public String getMngrNameByDeptCd(String deptCd) {
		return departmentDao.selectMngrNameByDeptCd(deptCd);
	}

}
