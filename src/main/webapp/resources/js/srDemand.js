/** ****************SR 상세 조회*************************** */
/* 작성자 : 신정은 SR 요청을 가져오기 */
function getSrDemandDetail(dmNo) {
   console.log("sfsffd");
   $("#userButtonDiv").empty();
   $("#adminButtonDiv").empty();
   $("#srDmndDetailTab").tab("show");
   
         $.ajax({
            url : "/srdemand/detail/" + dmNo,
            type : "GET",
            async:false, //알림으로 히스토리 확인시 srno가 없어 목록을 불러오지 못함
            success : function(res) {
               $("#sddetail").html(res);
            }
         });
}


/* 요청 등록 */
function addSr() {
		console.log("들어옴 ~~~ ");
		console.log($("select[name=sysCdd]"));
		var custId = $("input[name=custIdd]").val();
		var sysCd =  $("select[name=sysCdd]").val();
		var taskSeCd =  $("select[name=taskSeCdd]").val();
		var ttl =  $("input[name=ttld]").val();
		var relGrund =  $("#tarea2").val();
		var cn =  $("#tarea1").val();
		var cmptnDmndYmd =  $("input[name=cmptnDmndYmdd]").val();
		
		console.log(custId);
		console.log(sysCd);
		console.log(taskSeCd);
		console.log(ttl);
		console.log(relGrund);
		console.log(cn);
		console.log(cmptnDmndYmd);

		var flag = true;
		
		if(!sysCd || !taskSeCd || !ttl || !relGrund || !cn || !cmptnDmndYmd){
			console.log("내용 다 써라");
			showSraddAlert("모든 내용을 작성해주십시요.");
			flag = false;
		} 
		
		var formData = new FormData();
		var flist = $('input[name=attachFile]')[0].files;
		
		formData.append("custId", custId);
		formData.append("sysCd", sysCd);
		formData.append("taskSeCd", taskSeCd);
		formData.append("ttl", ttl);
		formData.append("relGrund", relGrund);
		formData.append("cn", cn);
		formData.append("cmptnDmndYmd", cmptnDmndYmd);
					 		
		
		// fileInput 개수를 구한다.
		for (var i = 0; i < flist.length; i++) {
			var maxSize = 1024 * 3;
			var fsize = Math.floor(flist[i].size / 1024);
			console.log(fsize);
			var fileName = flist[i].name;
			let dot = fileName.lastIndexOf('.');
			let type = fileName.substring(dot+1, fileName.length).toLowerCase();
			
			if(type == "exe") {
				flag = false;
				//alert(".exe 파일은 업로드할 수 없습니다.")
				showSraddAlert(".exe 파일은 업로드할 수 없습니다.");
				break;
			}
			
			if(fsize >= maxSize) {
				flag = false;
				showSraddAlert("3MB이상의 파일은 업로드할 수 없습니다.");
				break;
			}
			console.log(type);
			formData.append('attachFile', flist[i]);
		}
		
		if(flag) {
			$.ajax({
				url : '/srdemand/add',
				type : 'POST',
				data : formData ,
				enctype: "multipart/form-data",
				processData: false, //프로세스 데이터 설정 : false 값을 해야 form data로 인식함
		        contentType: false,
				success : function(res) {
					showSuccessSraddAlert("요청을 성공적으로 등록했습니다.");
					$("#sradd button").on("click",function(){
						location.href="/srdemand/list";
					});
					$("#addmodal").removeClass("show");
				}			
			});			
		}
		//$("#addmodal").removeClass("show");
		
	
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
            var option = $("<option value=" + res.taskList[idx].taskSeCd
                  + ">" + res.taskList[idx].taskSeNm + "</option>")
            $('.sysTask').append(option);
         }

      }
   });
}
/*
 * 작성자 : 신정은 내용 : sr 요청 작성시, 모든 시스템 데이터 드롭다운에 표시하기 위함
 */
function setSystems() {
	 $('.sysTask').empty();
   $.ajax({
      url : '/srsystem/list',
      type : 'GET',
      success : function(res) {
         console.log(res);
         for (var idx = 0; idx < res.length; idx++) {
            var option = $("<option value=" + res[idx].sysCd + " id="
                  + res[idx].sysCd + ">" + res[idx].sysNm + "</option>")
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
function updateSr(dmndNo) {
   $("#srDmndDetailTab").tab("show");
   $.ajax({
      url : '/srdemand/modify/' + dmndNo,
      type : 'GET',
      success : function(res) {
         $("#sddetail").html(res);
      }
   });
}

/* 사용자의 srDemand 삭제 */
function deleteSr(dmndNo) {
   console.log(dmndNo);
   $.ajax({
      url : '/srdemand/delete/' + dmndNo,
      type : 'GET',
      success : function(res) {
         location.reload();
      }

   });
}

/**
 * **************************** 관리자의 요청 승인
 * *******************************************
 */

/* sr요청 승인 */
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
      data : JSON.stringify(jsonData),
      contentType : 'application/json; charset=UTF-8',
      dataType : "json",
      success : function(res) {
    	 location.href="/admin/srdemand/list";
      },
      error : function(error) {
         console.log(error);
      }
   });
}

/* sr요청 반려 */
function goDecline(dmndNo) {
   // 반려사유 작성하지 않을 경우 g화면 다시 이동시키기
   var rjctRsn = $('#srRjctRsnn').val();
   if (!rjctRsn) {
     // alert('반려사유를 입력하여주세요.');
	   adminAlert("반려사유를 입력하여주세요.")
      $('#srRjctRsnn').focus();
   } else {
      var jsonData = {
         "dmndNo" : dmndNo,
         "val" : 0,
         "rjctRsn" : rjctRsn
      };

      $.ajax({
         url : '/admin/srdemand/approval',
         type : 'POST',
         data : JSON.stringify(jsonData),
         contentType : "application/json; charset=UTF-8",
         success : function(res) {
            //alert(res.result);
        	location.href="/admin/srdemand/list";
         },
         error : function(error) {
            console.log(error);
         }

      });
   }

}

function endSr() {
	var dmndNo = $('#dmndNo').text()

	console.log("dmndNo : " + dmndNo);
   $.ajax({
      url : '/srdemand/end',
      type : 'POST',
      data : {
         dmndNo : dmndNo
      },
      success : function(res) {
         location.href = "/srdemand/list";
      }
   });
}

/* 빈 검색 조건 비활성화 */
$(function() {   
   /* 빈 검색 조건 비활성화 */
   $("#srSearchForm").on("submit",function(){
      
      $("#srSearchForm input").each((index,value)=>{
         if(!$(value).val()){
            $(value).prop("disabled",true);
         }
      });
      $("#srSearchForm select").each((index,value)=>{
         if(!$(value).children("option:selected").val()||$(value).children(" option").length==0){
            $(value).prop("disabled",true);
         }
      });
      return true;
   });
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
      // page파라미터와 다른 파라미터가 있는경우
      if(indexOfFilter!=-1&&indexOfPage!=-1){
         filter=currentUrlForSort.substring(indexOfFilter+1,currentUrlForSort.length);
         
         $(".sortBtnAsc").attr("href",$(".sortBtnAsc").attr("href")+"?"+filter+"&sort=ASC");
         $(".sortBtnDesc").attr("href",$(".sortBtnDesc").attr("href")+"?"+filter+"&sort=DESC");
      }else if(currentUrlForSort.indexOf('page')==-1){// 파라미터가 page가 아닌경우
         indexOfFilter=currentUrlForSort.indexOf('?');
         if(indexOfFilter==-1){
            // 파라미터가 sort밖에 없는경우
            $(".sortBtnAsc").attr("href","?sort=ASC");
            $(".sortBtnDesc").attr("href","?sort=DESC");
         }else{
        	console.log("두번 실행 됩니까?");
            filter=currentUrlForSort.substring(indexOfFilter,currentUrlForSort.length);
            $(".sortBtnAsc").attr("href",$(".sortBtnAsc").attr("href")+filter+"&sort=ASC");
            $(".sortBtnDesc").attr("href",$(".sortBtnDesc").attr("href")+filter+"&sort=DESC");
         }
      }   
      
   }else{
      $(".sortBtnAsc").attr("href","?sort=ASC");
      $(".sortBtnDesc").attr("href","?sort=DESC");
   }
   console.log("정확한 기준을 모르겠어요");
});

/* 요청 필터 바의 업무구분 가져오기 */
function systemFilter() {
   console.log("systemFilter ----------")
   var sysCd = $("#sysCd option:selected").val();
   $('#taskSeCd').empty();

   $.ajax({
      url : '/task/list/' + sysCd,
      type : 'GET',
      success : function(res) {
         var option = "<option value=''>" + "전체" + "</option>";
         $('#taskSeCd').append(option);
         for (var idx = 0; idx < res.length; idx++) {
            option = $("<option value=" + res[idx].taskSeCd + ">"
                  + res[idx].taskSeNm + "</option>")
            $('#taskSeCd').append(option);
         }
      }
   });
}