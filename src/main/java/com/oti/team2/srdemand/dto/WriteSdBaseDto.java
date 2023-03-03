package com.oti.team2.srdemand.dto;

import java.util.List;

import com.oti.team2.system.dto.SrSystem;
import com.oti.team2.task.dto.SystemTask;

import lombok.AllArgsConstructor;
import lombok.Data;

@Data
@AllArgsConstructor
public class WriteSdBaseDto {
	private WriterDto writerDto;
	private SrSystem system;
	private List<SystemTask> taskList;
}
