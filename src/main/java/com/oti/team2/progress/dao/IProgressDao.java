package com.oti.team2.progress.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.oti.team2.progress.dto.Progress;
@Mapper
public interface IProgressDao {
	/**
	 * 
	 * @author 여수한
	 * 작성일자 : 2023-02-23
	 * @return sr요청 진척률 조회
	 */
	public List<Progress> selectProgressByDmndNo(@Param("srNo") String srNo);
	/**
	 * 
	 * @author 여수한
	 * 작성일자 : 2023-02-28
	 * @return sr요청 진척률 수정
	 */
	public void updateProgressByPrgrsId(@Param("prgrsId") int prgrsId, @Param("bgngYmd") String bgngYmd, @Param("endYmd") String endYmd, @Param("prgrsRt") int prgrsRt);
	
	
}
