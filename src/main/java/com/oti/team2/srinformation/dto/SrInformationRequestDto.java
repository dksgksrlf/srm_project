package com.oti.team2.srinformation.dto;

import java.sql.Date;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.AllArgsConstructor;
import lombok.Data;

/**
 * srDemand 승인 시 srInformation으로 저장하기 위해 전달되는 dto
 * @author 신정은
 *
 */
@Data
@AllArgsConstructor
public class SrInformationRequestDto {

	private String srNo;
	private String dmndNo;
	private String deptCd;
	private String picId;
	private String rnk; 
	@JsonFormat(shape=JsonFormat.Shape.STRING,pattern="yyyy-MM-dd",timezone="Asia/Seoul")
	private Date bgngYmd;
	@JsonFormat(shape=JsonFormat.Shape.STRING,pattern="yyyy-MM-dd",timezone="Asia/Seoul")
	private String endYmd;
}
