$(document).ready(function(){
	getPlan();
	var currentUrlForSort=window.location.href;
	if(currentUrlForSort.indexOf('dmndNoToHstry')!=-1){
		currentUrlForSort=currentUrlForSort.substring(0,currentUrlForSort.indexOf('dmndNoToHstry')-1);
	}
	if(currentUrlForSort.indexOf('hstryId')!=-1){
		currentUrlForSort=currentUrlForSort.substring(0,currentUrlForSort.indexOf('hstryId')-1);
	}
	// 파라미터 여부
	if(currentUrlForSort.indexOf('?')!=-1 && currentUrlForSort.indexOf('?')!=currentUrlForSort.length-1){
		
		var indexOfFilter = currentUrlForSort.indexOf('&');
		var indexOfPage=currentUrlForSort.indexOf('page');
		var filter=null;
		if(currentUrlForSort.indexOf('sort')!=-1){
			currentUrlForSort=currentUrlForSort.substring(0,currentUrlForSort.indexOf('sort')-1);
		}
		if(currentUrlForSort.indexOf('by')!=-1) {
			currentUrlForSort=currentUrlForSort.substring(0,currentUrlForSort.indexOf('by')-1);
		}
		if(currentUrlForSort.indexOf('ey')!=-1) {
			currentUrlForSort=currentUrlForSort.substring(0,currentUrlForSort.indexOf('ey')-1);
		}
		
		// page파라미터와 다른 파라미터가 있는경우
		if(indexOfFilter!=-1&&indexOfPage!=-1){
			filter=currentUrlForSort.substring(indexOfFilter+1,currentUrlForSort.length);
			
			$(".sortBtnAsc").attr("href",$(".sortBtnAsc").attr("href")+"?"+filter+"&sort=ASC");
			$(".sortBtnDesc").attr("href",$(".sortBtnDesc").attr("href")+"?"+filter+"&sort=DESC");
			
			$(".sortBtnAscBy").attr("href",$(".sortBtnAscBy").attr("href")+"?"+filter+"&by=ASC");
			$(".sortBtnDescBy").attr("href",$(".sortBtnDescBy").attr("href")+"?"+filter+"&by=DESC");
			
			$(".sortBtnAscEy").attr("href",$(".sortBtnAscEy").attr("href")+"?"+filter+"&ey=ASC");
			$(".sortBtnDescEy").attr("href",$(".sortBtnDescEy").attr("href")+"?"+filter+"&ey=DESC");
		}else if(currentUrlForSort.indexOf('page')==-1){// 파라미터가 page가 아닌경우
			indexOfFilter=currentUrlForSort.indexOf('?');
			if(indexOfFilter==-1){
				// 파라미터가 sort밖에 없는경우
				$(".sortBtnAsc").attr("href","?sort=ASC");
				$(".sortBtnDesc").attr("href","?sort=DESC");
				
				$(".sortBtnAscBy").attr("href","?by=ASC");
				$(".sortBtnDescBy").attr("href","?by=DESC");
				
				$(".sortBtnAscEy").attr("href","?ey=ASC");
				$(".sortBtnDescEy").attr("href","?ey=DESC");
			}else{
				filter=currentUrlForSort.substring(indexOfFilter,currentUrlForSort.length);
				$(".sortBtnAsc").attr("href",$(".sortBtnAsc").attr("href")+filter+"&sort=ASC");
				$(".sortBtnDesc").attr("href",$(".sortBtnDesc").attr("href")+filter+"&sort=DESC");
				
				$(".sortBtnAscBy").attr("href",$(".sortBtnAscBy").attr("href")+filter+"&by=ASC");
				$(".sortBtnDescBy").attr("href",$(".sortBtnDescBy").attr("href")+filter+"&by=DESC");
				
				$(".sortBtnAscEy").attr("href",$(".sortBtnAscEy").attr("href")+filter+"&ey=ASC");
				$(".sortBtnDescEy").attr("href",$(".sortBtnDescEy").attr("href")+filter+"&ey=DESC");
			}
		}	
	}else{
		$(".sortBtnAsc").attr("href","?sort=ASC");
		$(".sortBtnDesc").attr("href","?sort=DESC");
		
		$(".sortBtnAscBy").attr("href","?by=ASC");
		$(".sortBtnDescBy").attr("href","?by=DESC");
		
		$(".sortBtnAscEy").attr("href","?ey=ASC");
		$(".sortBtnDescEy").attr("href","?ey=DESC");
	}
});
/* SR요청 상세보기 */
function getDetail(dmndNo, srNo) {
	console.log("상세보기 : " + dmndNo + srNo);

	$.ajax({
		url : '/srinformation/detail/' + dmndNo,
		type : 'GET',
		async: false, //알람을 통해 히스토리 탭으로 바로 넘어가는 경우 동기 방식으로
		data : {
			dmndNo : dmndNo
		},
		success : function(detail) {
			$('#SRPlFlnm').show();
			$('#changeMemberId').remove();
			$('#changeManager').remove();
			console.log("srinfo.js 들어옴");
			console.log(detail);
			console.log(detail.isDnumExists);
			console.log(detail.dd);
			console.log(detail.role);
			console.log(detail.dd.attachFile.length); 
			
			// 첨부파일 유뮤 확인 용도
			var attYn = 0;
			if(detail.dd.attachFile.length > 0) {
				attYn = 1;
			}
			
			var role = detail.role;
			
	         // 관리자 & 개발자 권한과 상황에 따른 요청 버튼 제한 (최은종)
	         if(role=='ROLE_DEVELOPER') {
	            if(detail.isDnumExists>0){
	               $(".col-3").show();
	            } else if((detail.isDnumExists)<=0 || (detail.dd.sttsNm) =='개발완료' || (detail.dd.sttsNm) =='개발취소') {
	               $(".col-3").hide();
	            } 
	         } else if(role=='ROLE_ADMIN'){
	            if((detail.dd.sttsNm) =='개발완료' || (detail.dd.sttsNm) =='개발취소') {
	               $(".col-3").hide();
	            } else {
	               $(".col-3").show();
	            }         
	         }


			/* 개발완료 or 개발취소일 때 계획정보 */
			if((detail.dd.sttsNm) =='개발완료' || (detail.dd.sttsNm) =='개발취소') {
				/* 처리팀 */
				$("#dept").hide();
				$("#SRPlDeptNm").remove();
				$("#deptDiv").append($("<input type='text' readonly class='form-control' id='SRPlDeptNm'>"));
				/* 계획 시작일 */
				$("#SRPlBgngYmd").remove();
				$("#bgngYmdDiv").append($("<input type='text' readonly class='form-control' id='SRPlBgngYmd'>"));
				/* 계획 종료일 */
				$("#SRPlEndYmd").remove();
				$("#endYmdDiv").append($("<input type='text' readonly class='form-control' id='SRPlEndYmd'>"));
				/* 검토내용 */
				$("#SRPlRvwCn").remove();
				$("#rvwCnDiv").append($("<textarea readonly rows='5' cols='5' class='form-control' id='SRPlRvwCn'></textarea>"));
				/* 버튼 */
				$("#planBtn").hide();
				/* 자원정보 버튼 */
				$("#deleteSrResourceBtn").hide();
				$("#addSrResourceBtn").hide();
			} /* 개발중 */
			else {
				/* 처리팀 */
				$("#dept").show();
				$("#SRPlDeptNm").remove();
				/* 계획 시작일 */
				$("#SRPlBgngYmd").remove();
				$("#bgngYmdDiv").append($("<input type='text' class='form-control' id='SRPlBgngYmd'>"));
				/* 계획 종료일 */
				$("#SRPlEndYmd").remove();
				$("#endYmdDiv").append($("<input type='text' class='form-control' id='SRPlEndYmd'>"));
				/* 검토내용 */
				$("#SRPlRvwCn").remove();
				$("#rvwCnDiv").append($("<textarea rows='5' cols='5' class='form-control' id='SRPlRvwCn'></textarea>"));
				/* 버튼 */
				$("#planBtn").show();
				/* 자원정보 버튼 */
				$("#deleteSrResourceBtn").show();
				$("#addSrResourceBtn").show();
			}
			$("#SRDSrNo").val(srNo);
			$("#SRDDmndNo").val(detail.dd.dmndNo);
			// 우선순위 데이터
/* $("#SiRnk").empty(); */
			$("#SiRnk").val(detail.dd.rnk);
			$("#SRDRvwrNm").val(detail.dd.rvwrNm);
			$("#SRDClientNm").val(detail.dd.clientNm);
			$("#SRDClientId").val(detail.dd.clientId);/* 알림 요청용 요청자 id */
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
			$("#SRDSttsNm").val(detail.dd.sttsNm);
			// 파일
			$("#SRDAttachFile").empty();
			detail.dd.attachFile.forEach((value)=>{
				console.log(value.fileSz/(1024 * 1024));
				var fz = (value.fileSz/(1024 * 1024)).toFixed(1);
				console.log(fz);
				$("#SRDAttachFile").append(
						"<a href='/file/download/'"+value.fileSn+">" +
						"	<span class='glyphicon glyphicon-save' aria-hidden='true'></span>" +
						"	<span style='margin-right: 20px;'>"+value.orgnlFileNm+"</span><span>"+ fz + " MB </span>" +
						"</a>"
				);
			});
			
			$("#SRPlDeptNm").val(detail.dd.deptNm);
			$("#SRPlDmndNo").val(detail.pi.dmndNo);
			$("#SRPlMemberId").val(detail.pi.memberId);
			$("#SRPlFlnm").val(detail.pi.flnm);
			$("#SRPlBgngYmd").val(detail.pi.bgngYmd);
			$("#SRPlEndYmd").val(detail.pi.endYmd);
			$("#SRPlRvwCn").val(detail.pi.rvwCn);
			/* 자원 정보 모달 */
			$("#srPlanTab").tab("show");
			$("#srNo").val(srNo);
			$("#ttl").val(detail.dd.ttl);
			$("#addSrResourceModalDept option[value='"+detail.pi.deptCd+"']").prop("selected",true);
			$("#resourceInst").val(detail.dd.instNm);
			$("#resourceTableRow").empty();
			$(".deliverableTable tbody").empty();
			
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
			/* 개발완료 or 개발취소 */
			if(plan.sttsCd>=5) {
				/* 처리팀 */
				$("#dept").hide();
				$("#SRPlDeptNm").remove();
				$("#deptDiv").append($("<input type='text' readonly class='form-control' id='SRPlDeptNm'>"));
				/* 계획 시작일 */
				$("#SRPlBgngYmd").remove();
				$("#bgngYmdDiv").append($("<input type='text' readonly class='form-control' id='SRPlBgngYmd'>"));
				/* 계획 종료일 */
				$("#SRPlEndYmd").remove();
				$("#endYmdDiv").append($("<input type='text' readonly class='form-control' id='SRPlEndYmd'>"));
				/* 검토내용 */
				$("#SRPlRvwCn").remove();
				$("#rvwCnDiv").append($("<textarea readonly rows='5' cols='5' class='form-control' id='SRPlRvwCn'></textarea>"));
				/* 버튼 */
				$("#planBtn").hide();
			} /* 개발중 */
			else {
				/* 처리팀 */
				$("#dept").show();
				$("#SRPlDeptNm").remove();
				/* 계획 시작일 */
				$("#SRPlBgngYmd").remove();
				$("#bgngYmdDiv").append($("<input type='text' class='form-control' id='SRPlBgngYmd'>"));
				/* 계획 종료일 */
				$("#SRPlEndYmd").remove();
				$("#endYmdDiv").append($("<input type='text' class='form-control' id='SRPlEndYmd'>"));
				/* 검토내용 */
				$("#SRPlRvwCn").remove();
				$("#rvwCnDiv").append($("<textarea rows='5' cols='5' class='form-control' id='SRPlRvwCn'></textarea>"));
				/* 버튼 */
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
			console.log("오늘 : " + today);
			if(Progress[0].endYmd==null || Progress[0].endYmd>=today) {
				console.log("개발완료");
			}
			for (var i = 0; i < Progress.length; i++) {
				if(Progress[5].endYmd!=null && Progress[5].prgrsRt==100) {
					console.log("나는 개발완료");
					$("#delbtn").hide();
					$("#addbtn").hide();
					for(var j=0; j<6; j++) {
						console.log("나는 진짜 개발완료");
						$("#btn"+j).hide();
						$("#SRPgBgngYmd"+j).remove();
						$("#SRPgEndYmd"+j).remove();
						$("#SRPgPrgrsRt"+j).remove();
						$("#"+j+"bgngYmd").append($("<input type='text' readonly class='form-control' style='width:100px;margin:0 auto;' id='SRPgBgngYmd"+j+"'>"));
						$("#"+j+"endYmd").append($("<input type='text' readonly class='form-control' style='width:100px; margin:0 auto;'id='SRPgEndYmd"+j+"'>"));
						$("#"+j+"rt").append($("<input type='text' readonly class='form-control' id='SRPgPrgrsRt"+j+"'>"));
						$("#SRPgBgngYmd" + j).val(Progress[j].bgngYmd);
						$("#SRPgEndYmd" + j).val(Progress[j].endYmd);
						$("#SRPgPrgrsRt" + j).val(Progress[j].prgrsRt);
					}
					i=i+5;
					break;
				}
				$("#delbtn").show();
				$("#addbtn").show();
				if(Progress[i].endYmd==null || Progress[i].endYmd>=today) {
					if((Progress[i].prgrsRt!=10) || (Progress[i].prgrsRt!=40) || (Progress[i].prgrsRt!=70) || (Progress[i].prgrsRt!=80)||(Progress[i].prgrsRt!=90)||(Progress[i].prgrsRt!=100)) {
						$("#btn"+i).show();
						$("#SRPgBgngYmd"+i).remove();
						$("#SRPgEndYmd"+i).remove();
						$("#SRPgPrgrsRt"+i).remove();
						$("#"+i+"bgngYmd").append($("<input type='date' id='SRPgBgngYmd"+i+"'>"));
						$("#"+i+"endYmd").append($("<input type='date' id='SRPgEndYmd"+i+"'>"));
						if(i==0) {
							$("#"+i+"rt").append($("<input type='number' class='form-control' id='SRPgPrgrsRt"+i+"'min='0' max='10'>"));
						} else if(i==1) {
							$("#"+i+"rt").append($("<input type='number' class='form-control' id='SRPgPrgrsRt"+i+"'min='11' max='40'>"));
						} else if(i==2) {
							$("#"+i+"rt").append($("<input type='number' class='form-control' id='SRPgPrgrsRt"+i+"'min='41' max='70'>"));
						} else if(i==3) {
							$("#"+i+"rt").append($("<input type='number' class='form-control' id='SRPgPrgrsRt"+i+"'min='71' max='80'>"));
						} else if(i==4) {
							$("#"+i+"rt").append($("<input type='number' class='form-control' id='SRPgPrgrsRt"+i+"'min='81' max='90'>"));
						} else if(i==5) {
							$("#"+i+"rt").append($("<input type='number' class='form-control' id='SRPgPrgrsRt"+i+"'min='91' max='100'>"));
						}
						$("#SRPgSrNo").val(Progress[i].srNo);
						$("#SRPgPrgrsId" + i).val(Progress[i].prgrsId);
						$("#SRPgBgngYmd" + i).val(Progress[i].bgngYmd);
						$("#SRPgEndYmd" + i).val(Progress[i].endYmd);
						$("#SRPgPrgrsRt" + i).val(Progress[i].prgrsRt);
						document.getElementById('SRPgEndYmd' + i).setAttribute("min", $("#SRPgBgngYmd" + i).val());
						if(i>0) {
							var min=i-1;
							document.getElementById('SRPgBgngYmd' + i).setAttribute("min", $("#SRPgEndYmd" + min).val());
						}
						
					} else if((Progress[i].prgrsRt==10) || (Progress[i].prgrsRt==40) || (Progress[i].prgrsRt==70) || (Progress[i].prgrsRt==80)||(Progress[i].prgrsRt==90)||(Progress[i].prgrsRt==100)){
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
				if(Progress[i].bgngYmd<today) {
					$("#SRPgBgngYmd"+i).remove();
					$("#"+i+"bgngYmd").append($("<input type='text' readonly class='form-control' style='width:100px;margin:0 auto;' id='SRPgBgngYmd"+i+"'>"));
					$("#SRPgBgngYmd" + i).val(Progress[i].bgngYmd);
				}
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
	var prgrsSeNm = "요구정의";
	if(bgngYmd>endYmd) {
		bgngYmd = null;
		endYmd = null;
	}
	$.ajax({
		url : '/srinformation/progress/update',
		type : 'POST',
		data : {
			prgrsSeNm : prgrsSeNm,
			prgrsRt : prgrsRt,
			bgngYmd : bgngYmd,
			endYmd : endYmd,
			prgrsId : prgrsId,
			srNo : $("#SRPgSrNo").val()
		},
		success : function(prgrs) {
			location.href = "/srinformation/list?dmndNoToHstry="+$("#SRDDmndNo").val();
		}
	});
}
function updateProgress1() {
	var bgngYmd = $("#SRPgBgngYmd1").val();
	var prgrsId = $("#SRPgPrgrsId1").val();
	var endYmd = $("#SRPgEndYmd1").val();
	var prgrsRt = $("#SRPgPrgrsRt1").val();
	var prgrsSeNm = "분석/설계";
	if(bgngYmd>endYmd) {
		bgngYmd = null;
		endYmd = null;
	}
	$.ajax({
		url : '/srinformation/progress/update',
		type : 'POST',
		data : {
			prgrsSeNm : prgrsSeNm,
			prgrsRt : prgrsRt,
			bgngYmd : bgngYmd,
			endYmd : endYmd,
			prgrsId : prgrsId,
			srNo : $("#SRPgSrNo").val()
		},
		success : function(prgrs) {
			location.href = "/srinformation/list?dmndNoToHstry="+$("#SRDDmndNo").val();
		}
	});
}
function updateProgress2() {
	var bgngYmd = $("#SRPgBgngYmd2").val();
	var prgrsId = $("#SRPgPrgrsId2").val();
	var endYmd = $("#SRPgEndYmd2").val();
	var prgrsRt = $("#SRPgPrgrsRt2").val();
	var prgrsSeNm = "구현";
	if(bgngYmd>endYmd) {
		bgngYmd = null;
		endYmd = null;
	}
	$.ajax({
		url : '/srinformation/progress/update',
		type : 'POST',
		data : {
			prgrsSeNm : prgrsSeNm,
			prgrsRt : prgrsRt,
			bgngYmd : bgngYmd,
			endYmd : endYmd,
			prgrsId : prgrsId,
			srNo : $("#SRPgSrNo").val()
		},
		success : function(prgrs) {
			location.href = "/srinformation/list?dmndNoToHstry="+$("#SRDDmndNo").val();
		}
	});
}
function updateProgress3() {
	var bgngYmd = $("#SRPgBgngYmd3").val();
	var prgrsId = $("#SRPgPrgrsId3").val();
	var endYmd = $("#SRPgEndYmd3").val();
	var prgrsRt = $("#SRPgPrgrsRt3").val();
	var prgrsSeNm = "테스트";
	if(bgngYmd>endYmd) {
		bgngYmd = null;
		endYmd = null;
	}
	$.ajax({
		url : '/srinformation/progress/update',
		type : 'POST',
		data : {
			prgrsSeNm : prgrsSeNm,
			prgrsRt : prgrsRt,
			bgngYmd : bgngYmd,
			endYmd : endYmd,
			prgrsId : prgrsId,
			srNo : $("#SRPgSrNo").val()
		},
		success : function(prgrs) {
			location.href = "/srinformation/list?dmndNoToHstry="+$("#SRDDmndNo").val();
		}
	});
}
function updateProgress4() {
	var bgngYmd = $("#SRPgBgngYmd4").val();
	var prgrsId = $("#SRPgPrgrsId4").val();
	var endYmd = $("#SRPgEndYmd4").val();
	var prgrsRt = $("#SRPgPrgrsRt4").val();
	var prgrsSeNm = "반영요청";
	if(bgngYmd>endYmd) {
		bgngYmd = null;
		endYmd = null;
	}
	$.ajax({
		url : '/srinformation/progress/update',
		type : 'POST',
		data : {
			prgrsSeNm : prgrsSeNm,
			prgrsRt : prgrsRt,
			bgngYmd : bgngYmd,
			endYmd : endYmd,
			prgrsId : prgrsId,
			srNo : $("#SRPgSrNo").val(),
			rcvrId:$("#SRDClientId").val(), /* 반영 요청할 요청자 아이디 */
			dmndNo:$("#SRDDmndNo").val()
		},
		success : function(prgrs) {
			location.href = "/srinformation/list?dmndNoToHstry="+$("#SRDDmndNo").val();
		}
	});
}
function updateProgress5() {
	var bgngYmd = $("#SRPgBgngYmd5").val();
	var prgrsId = $("#SRPgPrgrsId5").val();
	var endYmd = $("#SRPgEndYmd5").val();
	var prgrsRt = $("#SRPgPrgrsRt5").val();
	var prgrsSeNm = "운영반영";
	if(bgngYmd>endYmd) {
		bgngYmd = null;
		endYmd = null;
	}
	$.ajax({
		url : '/srinformation/progress/update',
		type : 'POST',
		data : {
			prgrsSeNm : prgrsSeNm,
			prgrsRt : prgrsRt,
			bgngYmd : bgngYmd,
			endYmd : endYmd,
			prgrsId : prgrsId,
			srNo : $("#SRPgSrNo").val()
		},
		success : function(prgrs) {
			location.href = "/srinformation/list?dmndNoToHstry="+$("#SRDDmndNo").val();
		}
	});
}
/* 계획정보 변경 */
function planUpdate() {
	var selectedElement = document.getElementById("dept");
	var deptCd = selectedElement.options[selectedElement.selectedIndex].value;
	console.log("계획정보 변경");
	console.log("바뀔 부서" + deptCd);
	
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
			deptCd : deptCd,
			bgngYmd : $("#SRPlBgngYmd").val(),
			endYmd : $("#SRPlEndYmd").val(),
			rvwCn : $("#SRPlRvwCn").val()
		},
		success : function(res) {
			location.href = "/srinformation/list?dmndNoToHstry="+$("#SRDDmndNo").val();
		}
	});
}

/* 시스템 목록 */
function getSysCd(){
	if($("#sysCdFilter option").length <= 2){
		$("#sysCdFilter option").remove();
	}
	if($("#sysCdFilter option").length == 0){
		$.ajax({
			url : '/srsystem/list',
			type : 'GET',
			success : function(result){
				$("#sysCdFilter").append("<option value=''>전체</option>");
				result.forEach((value)=>{
					$("#sysCdFilter").append(
							"<option value='"+value.sysCd+"'>"+value.sysNm+"</option>"
					);
				});
			}
		});
	}
}
function removeTaskSeCd(){
	$("#taskSeCdFilter option").remove();
} 
/* 업무 목록 */
function getTaskSeCd(){
	if($("#taskSeCdFilter option").length == 1){
		$("#taskSeCdFilter option").remove();
	}
	if($("#sysCdFilter option:selected").length != 0 && $("#taskSeCdFilter option").length == 0 ){
		$.ajax({
			url : '/task/list/'+$("#sysCdFilter option:selected").val(),
			type : 'GET',
			data : {'sysCd' : $("sysCdFilter option:selected").val()},
			success : function(result){
				$("#taskSeCdFilter").append("<option value=''>전체</option>");
				result.forEach((value)=>{
					$("#taskSeCdFilter").append(
							"<option value='"+value.taskSeCd+"'>"+value.taskSeNm+"</option>"
					);
				});
			}
		});
	}
}
/* 빈 검색 조건 비활성화 */
function srSearch(){
	$("#srInfoFilterForm input").each((index,value)=>{
		if(!$(value).val()){
			$(value).prop("disabled",true);
		}
	});
	$("#srInfoFilterForm select").each((index,value)=>{
		if(!$(value).children("option:selected").val()||$(value).children(" option").length==0){
			$(value).prop("disabled",true);
		}
	});
	return true;
}
