package com.oti.team2.srdemand.dto;

import java.sql.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class SrdemandDetail {
	
	//srDemand 테이블
	private String dmndNo;
	private String ttl;
	private String relGrund;
	@JsonFormat(shape=JsonFormat.Shape.STRING,pattern="yyyy-MM-dd",timezone="Asia/Seoul")
	private Date dmndYmd;
	@JsonFormat(shape=JsonFormat.Shape.STRING,pattern="yyyy-MM-dd",timezone="Asia/Seoul")
	private Date cmptnDmndYmd;
	private String rjctRsn;
	private String cn;
	private String rnk;
	
	//SR진척
	private Date endYmd;
	
	// 부서
	private String picNm; // 개발 담당자 이름
	private String deptNm; // 개발 부서 이름
	
	//진행상태
	private String sttsNm;
	private int sttsCd;
	
	//시스템 테이블
	private String sysNm;
	private String sysCd;
	
	//업무구분 테이블
	private String taskSeNm;
	private String taskCd;
	
	//기관 테이블
	private String instNm; // 요청 기관
	
	//member 테이블
	private String clientNm; // 요청자(고객)
	private String rvwrNm; //검토자 이름
	
}
