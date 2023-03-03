package com.oti.team2.srdemand.dto;

import java.sql.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class SdApprovalDto {
	private String dmndNo;
	private int val;
	private String rnk;
	private String rjctRsn;
	private String rvwrId;
	@JsonFormat(shape=JsonFormat.Shape.STRING,pattern="yyyy-MM-dd",timezone="Asia/Seoul")
	private Date bgngYmd;
	@JsonFormat(shape=JsonFormat.Shape.STRING,pattern="yyyy-MM-dd",timezone="Asia/Seoul")
	private String endYmd;
}
