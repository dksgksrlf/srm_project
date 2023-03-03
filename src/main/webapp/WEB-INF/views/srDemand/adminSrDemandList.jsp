<%@page contentType="text/html; charset=UTF-8"%>

<%-- 작성자 : 여수한 / 작성 날짜 : 2023-02-17 --%>

<html>
<head>
<%@include file="/WEB-INF/views/fragments/header.jsp"%>
</head>
<script>
	
<%-- JSON으로 받아온 HistoryList를 보여주기 위한 ajax --%>
	function getHistoryList() {
		var srNo = $("#srNo").val();
		console.log("srHistoryList 글번호: " + srNo);
		$
				.ajax({
					url : "/history/list?srNo=" + srNo,
					type : "GET",

					success : function(result) {
						console.log(result);
						console.log(result.srInformationHistory[0].hstryTtl);

						for (var i = 0; i < result.srInformationHistory.length; i++) {
							var historyId = result.srInformationHistory[i].hstryId;
							var historyCount = [ i + 1 ];
							var historyTtl = result.srInformationHistory[i].hstryTtl;
							if (result.srInformationHistory[i].chgEndYmd === null) {
								var historyChgEndYmd = "-";
							} else {
								var historyChgEndYmd = result.srInformationHistory[i].chgEndYmd;
							}
							if (result.srInformationHistory[i].hstryStts == 'I') {
								var historyStts = "요청 중";
							} else if (result.srInformationHistory[i].hstryStts == 'N') {
								var historyStts = "반려";
							} else {
								var historyStts = "승인";
							}

							var param = '<tr data-toggle="modal" data-target="#approvalHistoryModal" onclick="getHstryDetail('
									+ historyId + ')">';
							param += '<th scope="row">' + historyCount
									+ '</th>';
							param += '<td>' + historyTtl + '</td>';
							param += '<td>' + historyChgEndYmd + '</td>';
							param += '<td>' + historyStts + '</td>';
							param += '</tr>';

							$("#history").append(param);
						}
					}
				});
	}
<%-- 모달 실행 --%>
	$(document).on('click', '#addbtn', function(e) {
		console.log("click event");
		$('#addmodal').addClass('show');
		document.body.style = `overflow: hidden`;
	});
	$(document).on('click', '#closebtn', function(e) {
		console.log("click event");
		$('#addmodal').removeClass('show');
		document.body.style = `overflow: scroll`;
	});
</script>
<style>
#startDatepicker, #endDatepicker, #addDatepicker {
	width: 90px;
}

#requestDatepicker, #endRequestDatepicker, #firStartDatepicker,
	#firEndDatepicker, #secStartDatepicker, #secEndDatepicker,
	#thrStartDatepicker, #thrEndDatepicker, #fiveStartDatepicker,
	#fiveEndDatepicker, #fourStartDatepicker, #fourEndDatepicker,
	#sixStartDatepicker, #sixEndDatepicker, #startDatepicker,
	#endDatepicker {
	width: 70px;
	padding-right: 0px;
}

div.left {
	width: 65%;
	float: left;
	box-sizing: border-box;
}

div.right {
	width: 35%;
	float: right;
	box-sizing: border-box;
	border-left: 1px solid black;
}

div .right .form-control {
	height: 20px;
}

th {
	text-align: center;
}

.col-sm-4 {
	padding: 0px;
}
/* 
.table td, .table th {
	padding: 0.75rem;
} */
.card .card-block {
	padding: 0px 5px !important;
}

.col-xl-1 {
	padding-top: 8px;
	padding-right: 0px;
	padding-left: 10px;
}

.modal {
	position: fixed;
	top: 0;
	left: 0;
	bottom: 0;
	right: 0;
	background: rgba(0, 0, 0, 0.4);
}

.m.body {
	height: 50vh;
	overflow-y: auto;
}
</style>
<body>
	<div id="pcoded" class="pcoded">
		<div class="pcoded-overlay-box"></div>
		<div class="pcoded-container navbar-wrapper">
			<%@include file="/WEB-INF/views/fragments/top.jsp"%>
			<div class="pcoded-main-container">
				<div class="pcoded-wrapper">
					<%@include file="/WEB-INF/views/fragments/sidebar.jsp"%>
					<div class="pcoded-content">
						<%@include file="/WEB-INF/views/fragments/pageHeader.jsp"%>
						<div class="pcoded-inner-content pt-4">
							<div class="main-body">
								<div id="pageWrapper" class="page-wrapper">
									<!-- Page-body start -->
									<div class="page-body text">
										<!-- *********** -->
										<div class="row">
											<%-- *********************************** [SR 요청 관리 ] ***********************************--%>
											<div class="col-xl-12">
												<div class="card">
													<div class="card-header">
														<div class="row">
															<div class="col-10">
																<h5>SR 요청 관리</h5>
															</div>
														</div>
														<hr />
														<form id="srSearchForm">
															<div class="row">
																<div class="col col-3 pr-0">
																	<label for="dmndYmdStart" style="margin-right: 10px;">조회
																		기간</label> <input type="date" name="dmndYmdStart"
																		id="dmndYmdStart"> ~ <input type="date"
																		name="dmndYmdEnd" id="dmndYmdEnd">
																</div>
																<div class="col col-2 pr-0">
																	<label for="sttsCd" style="margin-right: 10px;">진행
																		상태</label> <select id="sttsCd" name="sttsCd">
																		<option value="0">요청</option>
																		<option value="1">반려</option>
																	</select>
																</div>
																<div class="col col-3 pr-0">
																	<label for="sysCd" style="margin-right: 10px;">관련
																		시스템</label> <select id="sysCd" name="sysCd">
																		<option value="0">워크넷</option>
																		<option value="1">고용정보원</option>
																	</select> <select id="taskSeCd" name="taskSeCd">
																		<option value="0">내부망</option>
																		<option value="1">외부망</option>
																	</select>
																</div>
																<div class="col col-xl-3">
																	<label for="keyWord" style="margin-right: 10px;">키워드</label>
																	<input type="text" name="keyWord" id="keyWord">
																	<button onclick="srSearch()" type="button"
																		class="btn btn-lg btn-info">
																		<i class="ti-search"></i>
																	</button>
																</div>
																<div class="col col-xl-1" style="padding-left: 0px;">
																	<button class="btn btn-info">엑셀 다운로드</button>
																</div>
															</div>
														</form>
													</div>
												</div>
											</div>

											<%-- *********************************** [SR 요청 목록 ] ***********************************--%>
											<div class="col-xl-8 col-md-12">
												<div class="card">
													<div class="card-header">
														<h5>관리자 !!SR 요청 목록</h5>
														<div class="card-header-right">
															<ul class="list-unstyled card-option">
																<li><i class="fa fa fa-wrench open-card-option"></i></li>
																<li><i class="fa fa-window-maximize full-card"></i></li>
																<li><i class="fa fa-minus minimize-card"></i></li>
																<li><i class="fa fa-refresh reload-card"></i></li>
																<li><i class="fa fa-trash close-card"></i></li>
															</ul>
														</div>
													</div>
													<div class="card-block" id="list">
														<div id="sales-analytics">
															<div class="card-block table-border-style">
																<div class="table-responsive">
																	<table class="table table-hover text-center"
																		style="font-size: 12;">
																		<thead>
																			<tr>
																				<th style="width: 1px;"></th>
																				<th>요청 번호</th>
																				<th>제목</th>
																				<th>관련시스템</th>
																				<th style="width: 200px;">등록자</th>
																				<th>소속</th>
																				<th>검토자</th>
																				<th>진행상태</th>
																				<th>등록일</th>
																				<th>완료예정일</th>
																			</tr>

																		</thead>
																		<tbody>
																			<c:forEach var="srDemand" items="${srDemandList}"
																				varStatus="status">
																				<tr
																					onclick="getSrDemandDetail('${srDemand.dmndNo}')">
																					<th scope="row">${status.count}</th>
																					<td>${srDemand.dmndNo}</td>
																					<td>${srDemand.ttl}</td>
																					<td>${srDemand.sysNm}</td>
																					<td>${srDemand.custNm}</td>
																					<td>${srDemand.instNm}</td>
																					<td>${srDemand.rvwrNm}</td>
																					<td>${srDemand.sttsNm}</td>
																					<td>${srDemand.dmndYmd}</td>
																					<td>${srDemand.endYmd}</td>
																				</tr>
																			</c:forEach>
																		</tbody>
																	</table>
																	<!-- 페이징 처리 -->
																	<div class="d-flex justify-content-center">
																		<%@ include
																			file="/WEB-INF/views/fragments/pagination.jsp"%>
																	</div>

																</div>
															</div>

														</div>
													</div>
												</div>
											</div>

											<%-- *********************************** [SR요청 처리정보 ] ***********************************--%>
											<div class="col-xl-4 col-md-12">
												<div class="card">
													<div class="card-header">
														<h5>SR요청 상세</h5>
														<div class="card-header-right">
															<ul class="list-unstyled card-option">
																<li><i class="fa fa fa-wrench open-card-option"></i></li>
																<li><i class="fa fa-window-maximize full-card"></i></li>
																<li><i class="fa fa-minus minimize-card"></i></li>
																<li><i class="fa fa-refresh reload-card"></i></li>
																<li><i class="fa fa-trash close-card"></i></li>
															</ul>
														</div>
													</div>
													<ul class="nav nav-tabs  md-tabs" role="tablist">
														<li class="nav-item"><a class="nav-link active"
															data-toggle="tab" href="#srDemandDetail" role="tab">SR요청
																상세정보</a>
															<div class="slide"></div></li>
														<li class="nav-item"><a class="nav-link"
															data-toggle="tab" href="#srHistory"
															onclick="getHistoryList()" role="tab">SR 히스토리</a>
															<div class="slide"></div></li>
													</ul>

													<div class="tab-content tabs card-block"
														style="padding: 0px; padding-top: 20px;">
														<div class="tab-pane active" id="srDemandDetail"
															role="tabpanel">
															<div class="card-block">
																<div class="card_body" id="sddetail"
																	style="font-size: 12px; padding-top: 20px;">
																	<div class="form-group row">
																		<div class="col-sm-6">
																			<div class="col col-sm-4 font-weight-bold">SR번호</div>
																			<div class="col col-sm-6">
																				<div type="text" class="form-control dmndNo">${sd.dmndNo}</div>
																			</div>
																		</div>
																	</div>
																	<div class="form-group row">
																		<div class="col col-sm-2 font-weight-bold">SR 제목</div>
																		<div class="col col-sm-9">
																			<div type="text" class="form-control ttl">${sd.ttl}</div>
																		</div>
																	</div>
																	<div class="form-group row">
																		<div class="col col-sm-2 font-weight-bold">관련 근거</div>
																		<div class="col col-sm-9">
																			<div type="text" class="form-control relGrund">${sd.relGrund}</div>
																		</div>
																	</div>
																	<div class="form-group row">
																		<div class="col-sm-6">
																			<div class="col col-sm-4 font-weight-bold">시스템구분</div>
																			<div class="col col-sm-6 sysNm">${sd.sysNm}</div>
																		</div>
																		<div class="col-sm-6">
																			<div class="col col-sm-4 font-weight-bold">업무구분</div>
																			<div class="col col-sm-4 taskSeNm">${sd.taskSeNm}</div>
																		</div>
																	</div>
																	<div class="form-group row">
																		<div class="col-sm-6">
																			<div class="col col-sm-4 font-weight-bold">요청기관</div>
																			<div class="col col-sm-6 instNm">${sd.instNm}</div>

																		</div>
																		<div class="col-sm-6">
																			<div class="col col-sm-4 font-weight-bold">요청자</div>
																			<div class="dropdown dropdown open clientNm">${sd.clientNm}</div>
																		</div>
																	</div>
																	<div class="form-group row">
																		<div class="col-sm-6">
																			<div class="col col-sm-4 font-weight-bold">요청일</div>
																			<div class="col col-sm-8 dmndYmd">${sd.dmndYmd}</div>
																		</div>
																		<div class="col-sm-6">
																			<div class="col col-sm-4 font-weight-bold">완료요청일</div>
																			<div class="col col-sm-8 cmptnDmndYmd">${sd.cmptnDmndYmd}</div>
																		</div>
																	</div>
																	<div class="row mt-3">
																		<div class="col-6">
																			<div class="col col-sm-4 font-weight-bold">개발
																				담당자</div>
																			<div class="col col-sm-6">
																				<div type="text" class="form-control picNm">${sd.picNm}</div>
																			</div>
																		</div>
																		<div class="col-6">
																			<div class="col col-sm-4 font-weight-bold">개발
																				부서</div>
																			<div class="col col-sm-6">
																				<div type="text" class="form-control deptNm">${sd.deptNm}</div>
																			</div>
																		</div>
																	</div>
																	<div class="row mt-3">
																		<div class="col-6">
																			<div class="col col-sm-4 font-weight-bold">진행
																				상태</div>
																			<div class="col col-sm-6">
																				<div type="text" class="form-control sttsNm">${sd.sttsNm}</div>
																			</div>
																		</div>
																		<div class="col-6">
																			<div class="col col-sm-4 font-weight-bold">완료(예정)일</div>
																			<div class="col col-sm-6 endYmd">${sd.endYmd}</div>
																		</div>
																	</div>
																	<div class="row mt-3">
																		<div class="col-6">
																			<div class="col col-sm-4 font-weight-bold">검토자
																				이름</div>
																			<div class="col col-sm-6">
																				<div type="text" class="form-control rvwrNm">${sd.rvwrNm}</div>
																			</div>
																		</div>
																		<div class="col-6">
																			<div class="col col-sm-4 font-weight-bold">우선순위</div>
																			<div class="col col-sm-6">
																				<select id="rnk">
																					<option value="상" selected>상</option>
																					<option value="중">중</option>
																					<option value="하">하</option>
																				</select>
																			</div>
																		</div>
																	</div>

																	<div class="row mt-3 ml-1">
																		<label
																			class="col-sm-3 col-form-label px-0 font-weight-bold"
																			style="line-height: 120px">반려 사유</label>
																		<div class="col-sm-9 pl-0 ">
																			<c:if test="${sd.sttsCd == 0}">
																				<textarea rows="5" cols="5"
																					class="form-control rjctRsn" id="srRjctRsn"></textarea>
																			</c:if>
																			<c:if test="${sd.sttsCd != 0}">
																				<div class="form-control rjctRsn">${sd.rjctRsn}</div>
																			</c:if>
																		</div>
																	</div>
																	<div class="form-group row">
																		<label
																			class="col-sm-2 col-form-label font-weight-bold"
																			style="line-height: 100px; font-size: 12px;">SR
																			내용</label>
																		<div class="col-sm-9">
																			<div class="form-control cn" style="height: 100px;">${sd.cn}</div>
																		</div>
																	</div>
																	<div class="form-group row">
																		<label
																			class="col-sm-3 col-form-label font-weight-bold"
																			style="font-size: 12px;">첨부파일</label>
																		<div class="col-sm-9">
																			<input type="file" class="">
																		</div>
																	</div>
																	<div class="row">
																		<div class="col-6"></div>
																		<c:if test="${sd.sttsCd == 0}">
																			<div class="col-6" style="text-align: right">
																				<div id="srAccept"
																					class="btn btn-primary btn-round save center"
																					onclick="goAccept('${sd.dmndNo}')">승인</div>

																				<div id="srDecline"
																					class="btn btn-primary btn-round danger cancle"
																					onclick="goDecline('${sd.dmndNo}')">반려</div>
																			</div>
																		</c:if>
																	</div>
																</div>
																<%------------- 요청 수정 ----------------------------------- --%>
																<div class="card_body" id="sdupdate"
																	style="font-size: 12px; padding-top: 20px; display: none;">
																	<form action="/srdemand/modify" method="post"
																		id="sdUpdateForm">
																		<input type="hidden" name="dmndNo"
																			value="${sd.dmndNo}">
																		<div class="form-group row">
																			<div class="col-sm-6">
																				<div class="col col-sm-4 font-weight-bold">SR번호ss</div>
																				<div class="col col-sm-6">
																					<div type="text" class="dmndNo">${sd.dmndNo}</div>
																				</div>
																			</div>
																		</div>
																		<div class="form-group row">
																			<div class="col col-sm-2 font-weight-bold">SR
																				제목</div>
																			<div class="col col-sm-9">
																				<input type="text" class="form-control ttl"
																					name="ttl">
																			</div>
																		</div>
																		<div class="form-group row">
																			<div class="col col-sm-2 font-weight-bold">관련
																				근거</div>
																			<div class="col col-sm-9">
																				<input type="text" class="form-control relGrund"
																					name="relGrund">
																			</div>
																		</div>
																		<div class="form-group row">
																			<div class="col-sm-6">
																				<div class="col col-sm-4 font-weight-bold">시스템구분</div>
																				<div class="col col-sm-6 sysNm">${sd.sysNm}</div>
																			</div>
																			<div class="col-sm-6">
																				<div class="col col-sm-4 font-weight-bold">업무구분</div>
																				<div class="col col-sm-4 taskSeNm">${sd.taskSeNm}</div>
																			</div>
																		</div>
																		<div class="form-group row">
																			<div class="col-sm-6">
																				<div class="col col-sm-4 font-weight-bold">요청기관</div>
																				<div class="col col-sm-6 instNm"></div>

																			</div>
																			<div class="col-sm-6">
																				<div class="col col-sm-4 font-weight-bold">요청자</div>
																				<div class="dropdown dropdown open clientNm"></div>
																			</div>
																		</div>
																		<div class="form-group row">
																			<div class="col-sm-6">
																				<div class="col col-sm-4 font-weight-bold">요청일</div>
																				<div class="col col-sm-8 dmndYmd"></div>
																			</div>
																			<div class="col-sm-6">
																				<div class="col col-sm-4 font-weight-bold">완료요청일</div>
																				<div class="col col-sm-8 cmptnDmndYmd"></div>
																			</div>
																		</div>
																		<div class="row mt-3">
																			<div class="col-6">
																				<div class="col col-sm-4 font-weight-bold">진행
																					상태</div>
																				<div class="col col-sm-6">
																					<div class="form-control sttsNm" disabled></div>
																				</div>
																			</div>
																		</div>
																		<div class="form-group row">
																			<label
																				class="col-sm-2 col-form-label font-weight-bold"
																				style="line-height: 100px; font-size: 12px;">SR
																				내용</label>
																			<div class="col-sm-9">
																				<textarea rows="5" cols="5" class="form-control cn"
																					style="height: 100px;" name="cn"></textarea>
																			</div>
																		</div>
																		<div class="form-group row">
																			<label
																				class="col-sm-3 col-form-label font-weight-bold"
																				style="font-size: 12px;">첨부파일</label>
																			<div class="col-sm-9">
																				<input type="file" class="">
																			</div>
																		</div>
																	</form>
																	<div class="row">
																		<div class="col-6"></div>
																		<div class="col-6" style="text-align: right">
																			<button type="submit" class="modal_btn save center"
																				form="sdUpdateForm">저장</button>

																			<button
																				class="btn btn-primary btn-round danger cancle">삭제</button>
																		</div>
																	</div>
																</div>
															</div>
														</div>
														<%-- *********************************** [ SR 히스토리  ] ***********************************--%>
														<div class="tab-pane" id="srHistory" role="tabpanel">
															<div class="card-block table-border-style"
																style="padding: 0px;">
																<div class="table-responsive">
																	<table class="table table-hover text-center"
																		style="font-size: 12px; padding: 0px;">
																		<thead>
																			<tr>
																				<th style="width: 1px;">순번</th>
																				<th>제목</th>
																				<th>변경될 완료일</th>
																				<th>수락여부</th>
																			</tr>
																		</thead>
																		<tbody id="history">
																		</tbody>
																	</table>
																</div>
															</div>
														</div>
													</div>
												</div>
											</div>
										</div>
									</div>
								</div>
							</div>
						</div>
					</div>
					<!-- *********** -->
				</div>
				<!-- Page-body end -->
			</div>
			<div id="styleSelector"></div>
		</div>
	</div>

	<%@include file="/WEB-INF/views/fragments/bottom.jsp"%>

	<!-- 검색 -->
	<script src="/resources/assets/js/srDemandList.js"></script>

	<%-- 상세, 등록, 수정 --%>
	<script src="/resources/js/srDemand.js"></script>
	<!-- 모달 -->
	<jsp:include page="/WEB-INF/views/history/approvalHistoryModal.jsp" />
	<jsp:include page="/WEB-INF/views/srDemand/srDemandDetail.jsp" />
	<jsp:include page="/WEB-INF/views/srDemand/modal.jsp" />
	<%@include file="/WEB-INF/views/history/addHistoryModal.jsp"%>
	<%@include file="/WEB-INF/views/history/addHistoryModalDetail.jsp"%>
</body>
</html>