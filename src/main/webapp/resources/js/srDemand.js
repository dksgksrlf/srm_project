/** ****************SR 상세 조회*************************** */
/* 작성자 : 신정은 SR 요청을 가져오기 */
function getSrDemandDetail(dmNo) {
	$.ajax({
		url : "/srdemand/detail/" + dmNo,
		type : "GET",
		success : function(res) {
			$(".dmndNo").text(res.dmndNo);
			$(".dmndNo").val(res.dmndNo);
			$(".ttl").text(res.ttl);
			$(".ttl").val(res.ttl);
			$(".relGrund").text(res.relGrund);
			$(".relGrund").val(res.relGrund);
			$(".dmndYmd").text(res.dmndYmd);
			$(".cmptnDmndYmd").text(res.cmptnDmndYmd);
			$(".rjctRsn").text(res.rjctRsn);

			$(".cn").text(res.cn);
			$(".cn").val(res.cn);
			$(".endYmd").text(res.endYmd);
			$(".picNm").text(res.picNm);
			$(".deptNm").text(res.deptNm);
			$(".sttsNm").text(res.sttsNm);
			$(".sysNm").text(res.sysNm);

			/*
			 * var sysCd = res.sysCd; console.log("~~~~~~~~~ sys cd ~~~~~~~~ " +
			 * sysCd); $(".srSystems").val(sysCd).prop("selected", true);
			 */

			$(".taskSeNm").text(res.taskSeNm);
			$(".instNm").text(res.instNm);
			$(".clientNm").text(res.clientNm);
			$(".rvwrNm").text(res.rvwrNm);
		}
	});
}

/** *************SR 등록 , 수정********************************** */
/*
 * 작성자 : 신정은 내용 : sr 요청 작성시, 작성자의 기본 정보 세팅
 */
function writerBase() {
	$.ajax({
		url : '/srdemand/add',
		type : 'GET',
		success : function(res) {
			console.log(res.taskList);
			$("#writerName").text(res.writerDto.memberName);
			$("#instName").text(res.writerDto.instName);
			$("#custId").val(res.writerDto.memberId);
			$(".srSystems").val(res.system.sysCd).prop("selected", true);
			
			for (var idx = 0; idx < res.taskList.length; idx++) {
				var option = $("<option value=" + res.taskList[idx].taskSeCd + ">"
						+ res.taskList[idx].taskSeNm + "</option>")
				$('.sysTask').append(option);
			}
			 
			
		}
	});
}
/*
 * 작성자 : 신정은 내용 : sr 요청 작성시, 모든 시스템 데이터 드롭다운에 표시하기 위함
 */
function setSystems() {
	$.ajax({
		url : '/srsystem/list',
		type : 'GET',
		success : function(res) {
			console.log(res);
			for (var idx = 0; idx < res.length; idx++) {
				var option = $("<option value=" + res[idx].sysCd +" id=" + res[idx].sysCd+ ">"
						+ res[idx].sysNm + "</option>")
				$('.srSystems').append(option);
			}
		}
	});
}
/*
 * 작성자 : 신정은 내용 : sr 요청 작성시 시스템 선택시 해당되는 업무구분 데이터 목록 가져오기 위함
 */
function changeSystem(sysCd) {
	console.log("changeSystem ----------")
	$('.sysTask').empty();

	$.ajax({
		url : '/task/list/' + sysCd,
		type : 'GET',
		success : function(res) {
			console.log(res);
			for (var idx = 0; idx < res.length; idx++) {
				var option = $("<option value=" + res[idx].taskSeCd + ">"
						+ res[idx].taskSeNm + "</option>")
				$('.sysTask').append(option);
			}
		}
	});
}

/* 요청 수정 */
$(document).on('click', '#modbtn', function(e) {
	console.log("요청 수정");
	setSystems();
	$("#sddetail").css("display", "none");
	$("#sdupdate").css("display", "block");

});

/* 사용자의 srDemand 삭제 */
function deleteSr() {
	var dmndNo = $(".dmndNo").val();
	console.log(dmndNo);
	$.ajax({
		url : '/srdemand/delete/' + dmndNo,
		type : 'GET',
		success : function(res) {
			console.log(res);
		}
	
	});
}


/******************************    관리자의 요청 승인    ********************************************/

/* sr요청 승인*/
function goAccept(dmndNo) {
	var rnk = $('#rnk').val();	
	var bgngYmd = $('.dmndYmd').text();
	var endYmd = $('.cmptnDmndYmd').text();
	var jsonData = { 
			"dmndNo" : dmndNo,
			"val" : 1,
			"rnk" : rnk,
			"bgngYmd" : bgngYmd,
			"endYmd" : endYmd
		}; 
	console.log(jsonData);
	
	$.ajax({
		url : '/admin/srdemand/approval',
		type : 'POST',
		data : JSON.stringify(jsonData) ,
		contentType: 'application/json; charset=UTF-8',
		dataType : "json",
		success : function(res) {
			alert(res.result);
		},
		error : function(error) {
			 console.log(error);
	    }
	});
}

/* sr요청 반려*/
function goDecline(dmndNo) {
	// 반려사유 작성하지 않을 경우 g화면 다시 이동시키기
	var rjctRsn = $('#srRjctRsn').val();
	
	if (!rjctRsn) {
      alert('반려사유를 입력하여주세요.');
      $('#srRjctRsn').focus();
	} else {
		var jsonData = { 
				"dmndNo" : dmndNo,
				"val" : 0 ,
				"rjctRsn" : rjctRsn
			}; 
		
		$.ajax({
			url : '/admin/srdemand/approval',
			type : 'POST',
			data : JSON.stringify(jsonData) ,
			contentType: "application/json; charset=UTF-8",
			success : function(res) {
				alert(res.result);
			},
			error : function(error) {
		       console.log(error);
		    }
		
		});
	}
	
	
}



