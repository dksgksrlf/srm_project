/* SR요청 상세보기 */
function getDetail(dmndNo, srNo) {
	console.log("상세보기 : " + dmndNo + srNo);
	$.ajax({
		url : '/srinformation/detail/' + dmndNo,
		type : 'GET',
		data : {
			dmndNo : dmndNo
		},
		success : function(detail) {
			$('#SRPlFlnm').show();
			$('#changeMemberId').remove();
			$('#changeManager').remove();
			
			if((detail.dd.sttsNm) =='개발완료' || (detail.dd.sttsNm) =='개발취소') {
				$(".col-3").hide();
			} else {
				$(".col-3").show();
			}
			/*개발완료 or 개발취소*/
			if((detail.dd.sttsNm) =='개발완료' || (detail.dd.sttsNm) =='개발취소') {
				/*처리팀*/
				$("#dept").hide();
				$("#SRPlDeptNm").remove();
				$("#deptDiv").append($("<input type='text' readonly class='form-control' id='SRPlDeptNm'>"));
				/*계획 시작일*/
				$("#SRPlBgngYmd").remove();
				$("#bgngYmdDiv").append($("<input type='text' readonly class='form-control' id='SRPlBgngYmd'>"));
				/*계획 종료일*/
				$("#SRPlEndYmd").remove();
				$("#endYmdDiv").append($("<input type='text' readonly class='form-control' id='SRPlEndYmd'>"));
				/*검토내용*/
				$("#SRPlRvwCn").remove();
				$("#rvwCnDiv").append($("<textarea readonly rows='5' cols='5' class='form-control' id='SRPlRvwCn'></textarea>"));
				/*버튼*/
				$("#planBtn").hide();
			} /*개발중*/
			else {
				/*처리팀*/
				$("#dept").show();
				$("#SRPlDeptNm").remove();
				/*계획 시작일*/
				$("#SRPlBgngYmd").remove();
				$("#bgngYmdDiv").append($("<input type='text' class='form-control' id='SRPlBgngYmd'>"));
				/*계획 종료일*/
				$("#SRPlEndYmd").remove();
				$("#endYmdDiv").append($("<input type='text' class='form-control' id='SRPlEndYmd'>"));
				/*검토내용*/
				$("#SRPlRvwCn").remove();
				$("#rvwCnDiv").append($("<textarea rows='5' cols='5' class='form-control' id='SRPlRvwCn'></textarea>"));
				/*버튼*/
				$("#planBtn").show();
			}
			$("#SRDSrNo").val(srNo);
			$("#SRDDmndNo").val(detail.dd.dmndNo);
			$("#SRDTitle").val(detail.dd.ttl);
			$("#SRDRelgrund").val(detail.dd.relGrund);
			$("#SRDSys").val(detail.dd.sysNm);
			$("#SRDTask").val(detail.dd.taskSeNm);
			$("#SRDInst").val(detail.dd.instNm);
			$("#SRDFlnm").val(detail.dd.flnm);
			$("#SRDDmndymd").val(detail.dd.dmndYmd);
			$("#SRDCmptnDmndYmd").val(detail.dd.cmptnDmndYmd);
			$("#SRDCn").val(detail.dd.cn);
			$("#SRDFile").val(detail.dd.fileNm);
			$("#dept").val(detail.pi.deptCd).prop("selected", true);
			
			$("#SRPlDeptNm").val(detail.dd.deptNm);
			$("#SRPlDmndNo").val(detail.pi.dmndNo);
			$("#SRPlMemberId").val(detail.pi.memberId);
			$("#SRPlFlnm").val(detail.pi.flnm);
			$("#SRPlBgngYmd").val(detail.pi.bgngYmd);
			$("#SRPlEndYmd").val(detail.pi.endYmd);
			$("#SRPlRvwCn").text(detail.pi.rvwCn);
			/* 자원 정보 모달 */
			$("#srPlanTab").tab("show");
			$("#srNo").val(srNo);
			$("#ttl").val(detail.dd.ttl);
			$("#deptCd").val(detail.pi.deptCd);
			$("#deptNm").val(detail.pi.deptNm);
			$("#resourceInst").val(detail.dd.instNm);
			$("#resourceTableRow").empty();
			$(".deliverableTable tbody").empty();
			$("#addModal select").empty();
		}
	});
}
/* SR요청 계획정보 */
function getPlan() {
	$("#SRDDmndNo").val();
	console.log("계획정보 : " + $("#SRDDmndNo").val());
	$.ajax({
		url : '/srinformation/plan/' + $("#SRDDmndNo").val(),
		type : 'GET',
		success : function(plan) {
			/*개발완료 or 개발취소*/
			if(plan.sttsCd>=5) {
				/*처리팀*/
				$("#dept").remove();
				$("#SRPlDeptNm").remove();
				$("#deptDiv").append($("<input type='text' readonly class='form-control' id='SRPlDeptNm'>"));
				/*계획 시작일*/
				$("#SRPlBgngYmd").remove();
				$("#bgngYmdDiv").append($("<input type='text' readonly class='form-control' id='SRPlBgngYmd'>"));
				/*계획 종료일*/
				$("#SRPlEndYmd").remove();
				$("#endYmdDiv").append($("<input type='text' readonly class='form-control' id='SRPlEndYmd'>"));
				/*검토내용*/
				$("#SRPlRvwCn").remove();
				$("#rvwCnDiv").append($("<textarea readonly rows='5' cols='5' class='form-control' id='SRPlRvwCn'></textarea>"));
				/*버튼*/
				$("#planBtn").hide();
			} /*개발중*/
			else {
				/*처리팀*/
				$("#dept").remove();
				$("#SRPlDeptNm").remove();
				/*계획 시작일*/
				$("#SRPlBgngYmd").remove();
				$("#bgngYmdDiv").append($("<input type='text' class='form-control' id='SRPlBgngYmd'>"));
				/*계획 종료일*/
				$("#SRPlEndYmd").remove();
				$("#endYmdDiv").append($("<input type='text' class='form-control' id='SRPlEndYmd'>"));
				/*검토내용*/
				$("#SRPlRvwCn").remove();
				$("#rvwCnDiv").append($("<textarea rows='5' cols='5' class='form-control' id='SRPlRvwCn'></textarea>"));
				/*버튼*/
				$("#planBtn").show();
			}
			$('#SRPlFlnm').show();
			$('#changeMemberId').remove();
			$('#changeManager').remove();
			$("#dept").val(plan.deptCd).prop("selected", true);
			$("#SRPlDmndNo").val(plan.dmndNo);
			$("#SRPlDeptNm").val(plan.deptNm);
			$("#SRPlMemberId").val(plan.memberId);
			$("#SRPlFlnm").val(plan.flnm);
			$("#SRPlBgngYmd").val(plan.bgngYmd);
			$("#SRPlEndYmd").val(plan.endYmd);
			$("#SRPlRvwCn").val(plan.rvwCn);
		}
	});
}
/* sr계획정보 - 처리팀 변경시 해당 담당자 변경 */
function changeDept() {
	var selectedElement = document.getElementById("dept");

	// 선택한 option의 value, 텍스트
	var deptCd = selectedElement.options[selectedElement.selectedIndex].value;
	var deptNm = selectedElement.options[selectedElement.selectedIndex].text;
	console.log("선택된 시스템 :" + deptCd)

	$.ajax({
		url : '/srinformation/mngr/' + deptCd,
		type : 'GET',
		success : function(res) {
			$('#changeMemberId').remove();
			$('#changeManager').remove();
			var input1 = $("<input type='hidden' id='changeMemberId' value=" + res.memberId	+ "></input>")
			var input2 = $("<input readonly class='form-control' id='changeManager' value=" + res.flnm + "></input>")
			$('#SRPlFlnmBySelect').append(input1);
			$('#SRPlFlnmBySelect').append(input2);
			$('#SRPlFlnm').hide();
		}
	});
}
/* SR요청 진척률 조회 */
function getProgress() {
	$("#SRDSrNo").val();
	console.log("진척률: " + $("#SRDSrNo").val());
	$.ajax({
		url : '/srinformation/progress/list/' + $("#SRDSrNo").val(),
		type : 'GET',
		data : {
			Progress : $("#SRDSrNo").val()
		},
		success : function(Progress) {
			let today = new Date();   
			let year = today.getFullYear(); // 년도
			let month = today.getMonth() + 1;  // 월
			if(month<10) {
				month = '0'+month;
			}
			let date = today.getDate();  // 날짜
			if(date<10) {
				date = '0'+date;
			}
			let day = today.getDay();  // 요일
			today = (year + '-' + month + '-' + date);
			console.log(today);
			if(Progress[0].endYmd==null || Progress[0].endYmd>=today) {
				console.log("개발완료");
			}
			for (var i = 0; i < Progress.length; i++) {
				if(Progress[i].endYmd==null || Progress[i].endYmd>=today) {
					$("#btn"+i).show();
					$("#SRPgSrNo").val(Progress[i].srNo);
					$("#SRPgPrgrsId" + i).val(Progress[i].prgrsId);
					$("#SRPgBgngYmd" + i).val(Progress[i].bgngYmd);
					$("#SRPgEndYmd" + i).val(Progress[i].endYmd);
					$("#SRPgPrgrsRt" + i).val(Progress[i].prgrsRt);
					document.getElementById('SRPgEndYmd' + i).setAttribute("min", $("#SRPgBgngYmd" + i).val());
				} else if(Progress[i].endYmd<today) {
					$("#btn"+i).hide();
					$("#SRPgBgngYmd"+i).remove();
					$("#SRPgEndYmd"+i).remove();
					$("#SRPgPrgrsRt"+i).remove();
					$("#"+i+"bgngYmd").append($("<input type='text' readonly class='form-control' style='width:100px;margin:0 auto;' id='SRPgBgngYmd"+i+"'>"));
					$("#"+i+"endYmd").append($("<input type='text' readonly class='form-control' style='width:100px; margin:0 auto;'id='SRPgEndYmd"+i+"'>"));
					$("#"+i+"rt").append($("<input type='text' readonly class='form-control' id='SRPgPrgrsRt"+i+"'>"));
					$("#SRPgBgngYmd" + i).val(Progress[i].bgngYmd);
					$("#SRPgEndYmd" + i).val(Progress[i].endYmd);
					$("#SRPgPrgrsRt" + i).val(Progress[i].prgrsRt);
				}	
			}
			if(Progress[5].endYmd<today) {
				$("#delbtn").hide();
				$("#addbtn").hide();
			} else {
				$("#delbtn").show();
				$("#addbtn").show();
			}
		}
	});
}
/* SR요청 진척률 수정 */
function updateProgress0() {
	var bgngYmd = $("#SRPgBgngYmd0").val();
	var prgrsId = $("#SRPgPrgrsId0").val();
	var endYmd = $("#SRPgEndYmd0").val();
	var prgrsRt = $("#SRPgPrgrsRt0").val();
	$.ajax({
		url : '/srinformation/progress/update',
		type : 'POST',
		data : {
			prgrsRt : prgrsRt,
			bgngYmd : bgngYmd,
			endYmd : endYmd,
			prgrsId : prgrsId,
			srNo : $("#SRPgSrNo").val()
		},
		success : function(prgrs) {
		}
	});
}
function updateProgress1() {
	var bgngYmd = $("#SRPgBgngYmd1").val();
	var prgrsId = $("#SRPgPrgrsId1").val();
	var endYmd = $("#SRPgEndYmd1").val();
	var prgrsRt = $("#SRPgPrgrsRt1").val();
	$.ajax({
		url : '/srinformation/progress/update',
		type : 'POST',
		data : {
			prgrsRt : prgrsRt,
			bgngYmd : bgngYmd,
			endYmd : endYmd,
			prgrsId : prgrsId,
			srNo : $("#SRPgSrNo").val()
		},
		success : function(prgrs) {
		}
	});
}
function updateProgress2() {
	var bgngYmd = $("#SRPgBgngYmd2").val();
	var prgrsId = $("#SRPgPrgrsId2").val();
	var endYmd = $("#SRPgEndYmd2").val();
	var prgrsRt = $("#SRPgPrgrsRt2").val();
	$.ajax({
		url : '/srinformation/progress/update',
		type : 'POST',
		data : {
			prgrsRt : prgrsRt,
			bgngYmd : bgngYmd,
			endYmd : endYmd,
			prgrsId : prgrsId,
			srNo : $("#SRPgSrNo").val()
		},
		success : function(prgrs) {
		}
	});
}
function updateProgress3() {
	var bgngYmd = $("#SRPgBgngYmd3").val();
	var prgrsId = $("#SRPgPrgrsId3").val();
	var endYmd = $("#SRPgEndYmd3").val();
	var prgrsRt = $("#SRPgPrgrsRt3").val();
	$.ajax({
		url : '/srinformation/progress/update',
		type : 'POST',
		data : {
			prgrsRt : prgrsRt,
			bgngYmd : bgngYmd,
			endYmd : endYmd,
			prgrsId : prgrsId,
			srNo : $("#SRPgSrNo").val()
		},
		success : function(prgrs) {
		}
	});
}
function updateProgress4() {
	var bgngYmd = $("#SRPgBgngYmd4").val();
	var prgrsId = $("#SRPgPrgrsId4").val();
	var endYmd = $("#SRPgEndYmd4").val();
	var prgrsRt = $("#SRPgPrgrsRt4").val();
	$.ajax({
		url : '/srinformation/progress/update',
		type : 'POST',
		data : {
			prgrsRt : prgrsRt,
			bgngYmd : bgngYmd,
			endYmd : endYmd,
			prgrsId : prgrsId,
			srNo : $("#SRPgSrNo").val()
		},
		success : function(prgrs) {
		}
	});
}
function updateProgress5() {
	var bgngYmd = $("#SRPgBgngYmd5").val();
	var prgrsId = $("#SRPgPrgrsId5").val();
	var endYmd = $("#SRPgEndYmd5").val();
	var prgrsRt = $("#SRPgPrgrsRt5").val();
	$.ajax({
		url : '/srinformation/progress/update',
		type : 'POST',
		data : {
			prgrsRt : prgrsRt,
			bgngYmd : bgngYmd,
			endYmd : endYmd,
			prgrsId : prgrsId,
			srNo : $("#SRPgSrNo").val()
		},
		success : function(prgrs) {
		}
	});
}
/* 계획정보 변경 */
function planUpdate() {
	console.log("$('#SRPlMemberId').val() : " + $("#SRPlMemberId").val())
	console.log("$('#changeMemberId').val() : " + $("#changeMemberId").val())

	if($("#changeMemberId").val()==null) {
		var memberId = $("#SRPlMemberId").val();
	} else {
		var memberId = $("#changeMemberId").val();
	}
	console.log("담당자: " + memberId);
	$.ajax({
		url : '/srinformation/plan/update',
		type : 'POST',
		data : {
			dmndNo : $("#SRPlDmndNo").val(),
			memberId : memberId,
			deptCd : $("#SRDept").val(),
			bgngYmd : $("#SRPlBgngYmd").val(),
			endYmd : $("#SRPlEndYmd").val(),
			rvwCn : $("#SRPlRvwCn").val()
		},
		success : function(res) {
		}
	});
}