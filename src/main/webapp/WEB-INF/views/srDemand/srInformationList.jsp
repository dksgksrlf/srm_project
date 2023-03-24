<%@page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%-- 작성자 : 여수한 / 작성 날짜 : 2023-02-17 --%>
<%-- 작성자 : 최은종 / 작성 날짜 : 2023-02-28 --%>

<html>
<head>
<%@include file="/WEB-INF/views/fragments/header.jsp"%>
<%-- 캘린더css --%>
<link
	href='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.css'
	rel='stylesheet' />
</head>
<script
	src="${pageContext.request.contextPath}/resources/js/srResources.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/deliverables.js"></script>
<script
	src="${pageContext.request.contextPath}/resources/js/srInfoListHstry.js"></script>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resources/css/hstryPager.css">

<script>
   
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
<%-- 히스토리id가 있는경우 탭을 열고 해당위치로 이동 --%>
   <c:if test="${hstryId ne null}">
   $(function(){
	   
  		var trId = "tr"+${hstryId};
  		console.log(trId);
  		$("#"+trId).trigger("click");
 	    $("#srInfoDetailTab").trigger("click");
  		$("#srInfhistoryTab").trigger("click"); 
  		
   });

   </c:if>
   <c:if test="${rownum ne null}">
   $(function(){
	   
  		var trId = "tr"+${rownum};
  		
  		$("#"+trId).trigger("click");
  		
   });

   </c:if>
</script>
<style>
.ui-datepicker-trigger {
	width: 29px;
	vertical-align: top;
}

#startDatepicker, #endDatepicker, #addDatepicker {
	width: 90px;
}

#requestDatepicker, #endRequestDatepicker, #firStartDatepicker,
	#firEndDatepicker, #secStartDatepicker, #secEndDatepicker,
	#thrStartDatepicker, #thrEndDatepicker, #fiveStartDatepicker,
	#fiveEndDatepicker, #fourStartDatepicker, #fourEndDatepicker,
	#sixStartDatepicker, #sixEndDatepicker {
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
	padding: 0px 5px;
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

.form-control {
	font-size: inherit;
}

.col-xl-1 {
	padding-top: 0px;
}

li:before {
	content: none;
}

#headerFirst {
	background: #4C1342;
}

.card .card-header {
	background: linear-gradient(135deg, #360940 10%, #782748 100%);
}

#otiTabs .nav-item a {
	color: #4C1342;
	padding: 15px !important;
}

#otiTabs .nav-link {
	color: #4C1342;
	background-color: white !important;
}

.badge {
	padding: 5px 8px;
}

table th {
	font-size: 15px !important;
}

table tbody td {
	font-size: 13px !important;
}
</style>
<body>
	<%@include file="/WEB-INF/views/fragments/top.jsp"%>
	<%@include file="/WEB-INF/views/fragments/sidebar.jsp"%>
	<!-- Page-body start -->
	<div class="page-body text">
		<!-- *********** -->
		<%-- *********************************** [산출물 목록 모달] *********************************** --%>
		<div class="modal" id="deliverableListModal">
			<div class="modal_body" style="height: 300px">
				<div class="m_head" style="height: 60px">
					<div class="modal_title" style="color: white;">산출물 목록</div>
				</div>
				<div class="m_body" style="height: 190px">
					<div>
						<table class="table table-border text-center deliverableTable"
							style="font-size: 12px; padding: 0px;">
							<thead>
								<tr>
									<th style="width: 1px;"></th>
									<th style="width: 1px;"></th>
									<th>산출물구분</th>
									<th>산출물명</th>
									<th>산출물 경로</th>
									<th>등록자</th>
									<th>등록일</th>
								</tr>
							</thead>
							<tbody>
							</tbody>
						</table>
					</div>
				</div>
				<div class="m_footer" style="height: 50px">
					<button class="modal_btn btn-oti cancle" id="delbtn"
						onclick="deleteDeliverable()">선택 삭제</button>
					<div class="modal_btn btn-oti cancle" data-dismiss="modal">닫기</div>
				</div>
			</div>
		</div>
		<%-- *********************************** [ 산출물 추가 모달 ] ***********************************--%>
		<div class="modal" id="addmodal">
			<div class="modal_body" style="height: 300px">
				<div class="m_head" style="height: 60px">
					<div class="modal_title" style="color: white;">산출물 추가</div>
				</div>
				<div class="m_body" style="height: 190px">
					<div class="form-group row">
						<div class="col-sm-6">
							<div class="row">
								<div class="col col-sm-4">산출물 구분</div>
								<div class="col col-sm-6">
									<div class="dropdown dropdown open">
										<select name="prgrsId" id="prgrsIdSelect">
											<option value="1">요구정의</option>
											<option value="2">분석/설계</option>
											<option value="3">구현</option>
											<option value="4">시험</option>
										</select>
									</div>
								</div>
							</div>
						</div>
						<div class="col-sm-6"></div>
					</div>
					<div class="form-group row">
						<div class="col-sm-6">
							<div class="row">
								<div class="col-sm-4">
									<label class="col-form-label">산출물명</label>
								</div>
								<div class="col-sm-6">
									<input type="text" id="delivNm" name="delivNm">
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="row">
								<div class="col-sm-4">
									<label class="col-form-label">산출물 경로</label>
								</div>
								<div class="col-sm-6">
									<input type="text" id="delivUrl" name="delivUrl">
								</div>
							</div>
						</div>
					</div>
				</div>
				<div class="m_footer" style="height: 50px">
					<div onclick="addDeliverable()" class="modal_btn btn-oti center"
						id="closebtn">등록</div>
					<div class="modal_btn btn-oti cancle" id="closebtn">닫기</div>
				</div>
			</div>
		</div>
		<%-- *********************************** [SR 진척 관리 ] ***********************************--%>
		<div class="row">
			<div class="col-xl-12">
				<div class="card">
					<div class="card-header" id="headerFirst">
						<h5 style="font-weight: bold;">SR 진척 관리</h5>
					</div>
					<div class="card-body" style="height: 70px;">
						<form id="srInfoFilterForm"
							action="${pageContext.request.contextPath}/srinformation/list"
							onsubmit="return srSearch()">
							<div class="col col-xl-1 font-weight-bold" style="width: 90px;">시스템
								구분</div>
							<div class="col col-xl-2" style="padding: 0px; width: 200px;">

								<div class="dropdown dropdown open">
									<select name="sysCd" id="sysCdFilter" onclick="getSysCd()"
										onchange="removeTaskSeCd()" style="width: 200px;">
										<option value="">전체</option>
										<c:if test="${srInfoFilter.sysCd ne null}">
											<option value="${srInfoFilter.sysCd}" selected>${sd.sysNm}<c:if
													test="${sd.sysNm eq null}">${srInfoFilter.sysCd}</c:if></option>
										</c:if>
									</select>
								</div>
							</div>
							<div class="col col-xl-1 font-weight-bold" style="width: 80px;">업무
								구분</div>
							<div class="dropdown dropdown open" style="float: left;">
								<select name="taskSeCd" id="taskSeCdFilter"
									onclick="getTaskSeCd()" style="width: 120px;">
									<c:if test="${srInfoFilter.taskSeCd ne null}">
										<option value="${srInfoFilter.taskSeCd}">${sd.taskSeNm}<c:if
												test="${sd.taskSeNm}">${srInfoFilter.taskSeCd}</c:if></option>
									</c:if>
								</select>
							</div>
							<div class="col col-xl-1 font-weight-bold" style="width: 80px;">진행
								상태</div>
							<div class="col col-xl-1" style="">
								<div class="dropdown dropdown open">
									<select name="sttsCd" id="sttsCdFilter">
										<option value="">전체</option>
										<option value="3"
											<c:if test="${srInfoFilter.sttsCd eq 3}"> selected</c:if>>구현</option>
										<option value="4"
											<c:if test="${srInfoFilter.sttsCd eq 4}"> selected</c:if>>테스트</option>
										<option value="5"
											<c:if test="${srInfoFilter.sttsCd eq 5}"> selected</c:if>>운영반영</option>
									</select>
								</div>
							</div>
							<div class="col col-xl-1  font-weight-bold"
								style="width: 80px; padding-left: 20px;">SR 제목</div>
							<div class="col col-xl-2" style="">
								<input type="text" class="form-control" name="ttl"
									value="${srInfoFilter.ttl}"> <br />
							</div>
							<div class="col col-xl-1" style="padding-left: 30px">
								<c:if test="${srInfoFilter.mySrOnly eq true}">
									<input type="checkbox" name="mySrOnly" value="true" checked>
								</c:if>
								<c:if test="${srInfoFilter.mySrOnly ne true}">
									<input type="checkbox" name="mySrOnly" value="true">
								</c:if>
								<span class="font-weight-bold">내 처리건</span>
							</div>

							<div class="col col-xl-2">
								<button type="submit" class="btn btn-oti btn-sm"
									style="float: center;">
									<i class="ti-search"></i>
								</button>
							</div>
						</form>
					</div>
				</div>
			</div>
			<%-- *********************************** [SR 처리 목록 ] ***********************************--%>
			<div class="col-xl-8 col-md-12">
				<div class="card" style="height: 760px;">
					<div class="card-header">
						<h5>SR 처리 목록</h5>
						<button type="submit" class="btn btn-oti btn-sm" form="srInfoFilterForm	"
									onclick="javascript: form.action='${pageContext.request.contextPath}/srinformation/list/download';"
									style="float: right; margin-right: 50px;">엑셀 다운로드</button>
						<div class="card-header-right">
							<ul class="list-unstyled card-option">
								<li><i class="fa fa fa-wrench open-card-option"></i></li>
								<li><i class="fa fa-window-maximize full-card"></i></li>
								<li><i class="fa fa-refresh reload-card"></i></li>
							</ul>
						</div>
					</div>
					<div class="card-block" id="list">
						<div id="sales-analytics">
							<div class="card-block table-border-style">
								<div class="table-responsive">
									<table class="table table-hover text-center">
										<thead>
											<tr>
												<th style="width: 1px;"></th>
												<th style="font-size: 15px;">SR번호 <c:if
														test="${sort eq 'DESC' || sort eq '1'}">
														<a
															href="${pageContext.request.contextPath}/srinformation/list"
															class="sortBtnAsc"><i class="fas fa-caret-down"
															style="color: #782748; font-size: 24px;"></i></a>
													</c:if> <c:if test="${sort eq 'ASC'}">
														<a
															href="${pageContext.request.contextPath}/srinformation/list"
															class="sortBtnDesc"><i class="fas fa-caret-up"
															style="color: #782748; font-size: 24px;"></i></a>
													</c:if>
												</th>
												<th class="text-left" style="font-size: 15px; width: 200px;">SR명</th>
												<th class="text-left" style="font-size: 15px;">시스템구분</th>
												<th class="text-left" style="font-size: 15px;">업무구분</th>
												<th style="font-size: 15px;">완료요청일 <c:if
														test="${by eq 'DESC' || by eq '1'}">
														<a
															href="${pageContext.request.contextPath}/srinformation/list"
															class="sortBtnAscBy"><i class="fas fa-caret-down"
															style="color: #782748; font-size: 24px;"></i> </a>
													</c:if> <c:if test="${by eq 'ASC'}">
														<a
															href="${pageContext.request.contextPath}/srinformation/list"
															class="sortBtnDescBy"><i class="fas fa-caret-up"
															style="color: #782748; font-size: 24px;"></i></a>
													</c:if></th>
												<th style="font-size: 15px;">완료예정일 <c:if
														test="${ey eq 'DESC'|| ey eq '1'}">
														<a
															href="${pageContext.request.contextPath}/srinformation/list"
															class="sortBtnAscEy"><i class="fas fa-caret-down"
															style="color: #782748; font-size: 24px;"></i></a>
													</c:if> <c:if test="${ey eq 'ASC'}">
														<a
															href="${pageContext.request.contextPath}/srinformation/list"
															class="sortBtnDescEy"><i class="fas fa-caret-up"
															style="color: #782748; font-size: 24px;"></i></a>
													</c:if></th>
												<th style="font-size: 15px;">진행상태</th>
											</tr>
										</thead>
										<tbody>
											<c:if test="${srlist ne null}">
												<c:forEach var="srlist" items="${srlist}" varStatus="num">
													<tr id="tr${pager.startRowNo + num.index}"
														onclick="getDetail('${srlist.dmndNo}','${srlist.srNo}');">
														<th scope="row">${pager.startRowNo + num.index}</th>
														<td id=""><strong>${srlist.srNo}</strong></td>
														<c:choose>
															<c:when test="${fn:length(srlist.ttl) > 15}">
																<td class="text-left"><c:out
																		value="${fn:substring(srlist.ttl,0,14)}" />...</td>
															</c:when>
															<c:otherwise>
																<td class="text-left"><c:out value="${srlist.ttl}" /></td>
															</c:otherwise>
														</c:choose>
														<td class="text-left">${srlist.sysNm}</td>
														<td class="text-left">${srlist.taskSeNm}</td>
														<td>${srlist.bgngYmd}</td>
														<td>${srlist.endYmd}</td>
														<td><c:if test="${srlist.prgrsRt  ge 0}">
																<c:if
																	test="${(srlist.prgrsRt  ge 1) && (srlist.prgrsRt lt 10)}">
																	<label class="badge badge-info">요구정의</label>
																</c:if>
																<c:if
																	test="${(srlist.prgrsRt  ge 10) && (srlist.prgrsRt lt 40)}">
																	<label class="badge badge-warning">분석/설계</label>
																</c:if>
																<c:if
																	test="${(srlist.prgrsRt  ge 40) && (srlist.prgrsRt lt 70)}">
																	<label class="badge badge-success">구현</label>
																</c:if>
																<c:if
																	test="${(srlist.prgrsRt  ge 70) && (srlist.prgrsRt lt 80)}">
																	<label class="badge badge-inverse-success">테스트</label>
																</c:if>
																<c:if
																	test="${(srlist.prgrsRt  ge 80) && (srlist.prgrsRt lt 90)}">
																	<label class="badge badge-inverse-primary">반영요청</label>
																</c:if>
																<c:if
																	test="${(srlist.prgrsRt  ge 90) && (srlist.prgrsRt lt 100)}">
																	<label class="badge badge-primary">운영반영</label>
																</c:if>
																<c:if test="${(srlist.prgrsRt eq 100)}">
																	<label class="badge badge-primary">개발완료</label>
																</c:if>
															</c:if> <c:if test="${srlist.prgrsRt eq 0}">
																<c:if test="${(srlist.sttsNm) eq '접수'}">
																	<label class="badge label-inverse-info">접수</label>
																</c:if>
																<c:if test="${srlist.sttsNm eq '개발취소'}">
																	<label class="badge badge-inverse-danger">개발취소</label>
																</c:if>
																<c:if test="${srlist.sttsNm eq '반려'}">
																	<label class="badge badge-danger">반려</label>
																</c:if>
															</c:if></td>
													</tr>
												</c:forEach>
											</c:if>
											<c:if test="${srlist eq null}">
												<tr>
													<td colSpan="9">검색 결과가 없습니다.</td>
												</tr>
											</c:if>
										</tbody>
									</table>
									<%@include file="/WEB-INF/views/fragments/pagination.jsp"%>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>
			<div class="col-xl-4 col-md-12 pl-0">
				<div class="card">
					<div class="card-header"
						style="padding: 0px 10px; background: rgba(0, 0, 0, 0);">
						<%-- *********************************** 상세 탭 *********************************** --%>
						<ul class="nav nav-tabs md-tabs card-header-pills" role="tablist">
							<li class="nav-item"><a class="nav-link active"
								data-toggle="tab" href="#srDemandDetail" role="tab">SR 요청 정보</a>
								<div class="slide"></div></li>
							<li class="nav-item"><a class="nav-link" data-toggle="tab" id="srInfoDetailTab"
								href="#srInfoDetail" role="tab">SR 처리 정보</a>
								<div class="slide"></div></li>
						</ul>
					</div>
					<%-- *********************************** [SR요청 상세정보 ] ***********************************--%>
					<div class="tab-content tabs card-block"
						style="padding: 0px; padding-top: 20px;">
						<div class="tab-pane active" id="srDemandDetail" role="tabpanel">
							<div class="card-block" style="height: 675px;">
								<div class="card_body " style="font-size: 12px;">

									<div class="form-group row">
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 px-0 font-weight-bold">요청 번호</div>
											<div class="col col-sm-6 px-0">
												<input type="hidden" id="SRDSrNo" value="${srlist[0].srNo}">
												<input readonly class="form-control" id="SRDDmndNo"
													value="${sd.dmndNo}" style="width: 125px;">
											</div>
										</div>
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 px-0 font-weight-bold">우선순위</div>
											<div class="col col-sm-6 px-0">
												<input type="text" readonly class="form-control" id="SiRnk"
													value="${sd.rnk}">
											</div>
										</div>
									</div>
									<hr />
									<div class="form-group row">
										<div class="col col-sm-2 px-0 font-weight-bold">SR 제목</div>
										<div class="col col-sm-9 px-0">
											<input readonly class="form-control" id="SRDTitle"
												value="${sd.ttl}">
										</div>
									</div>
									<hr />
									<div class="form-group row">
										<div class="col col-sm-2 px-0 font-weight-bold">관련근거</div>
										<div class="col col-sm-9 px-0">
											<input readonly class="form-control" id="SRDRelgrund"
												value="${sd.relGrund}">
										</div>
									</div>
									<hr />
									<div class="form-group row">
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 px-0 font-weight-bold">시스템구분</div>
											<div class="col col-sm-8 pl-0">
												<input readonly class="form-control" id="SRDSys"
													value="${sd.sysNm}">
											</div>
										</div>
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 px-0 font-weight-bold">업무구분</div>
											<div class="col col-sm-7 pl-0">
												<input readonly class="form-control" id="SRDTask"
													value="${sd.taskSeNm}">
											</div>
										</div>
									</div>
									<hr />
									<div class="form-group row">
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 px-0 font-weight-bold">요청기관</div>
											<div class="col col-sm-8 pl-0">
												<input readonly class="form-control" id="SRDInst"
													value="${sd.instNm}">
											</div>
										</div>
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 px-0 font-weight-bold">요청자</div>
											<div class="col col-sm-7 pl-0">
												<input readonly class="form-control" id="SRDClientNm"
													value="${sd.clientNm}"> <input type="hidden"
													value="${sd.clientId}" id="SRDClientId">
											</div>
										</div>
									</div>
									<hr />
									<div class="form-group row">
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 px-0 font-weight-bold">SR요청일</div>
											<div class="col col-sm-8 pl-0">
												<input readonly class="form-control" id="SRDDmndymd"
													value="${sd.dmndYmd}">
											</div>
										</div>
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 px-0 font-weight-bold">완료요청일</div>
											<div class="col col-sm-7 pl-0">
												<input readonly class="form-control" id="SRDCmptnDmndYmd"
													value="${sd.cmptnDmndYmd}">
											</div>
										</div>
									</div>
									<hr />
									<div class="form-group row">
										<label class="col-sm-2 px-0 col-form-label font-weight-bold"
											style="line-height: 100px; font-size: 12px">SR 내용</label>
										<div class="col-sm-9 px-0">
											<input readonly class="form-control" style="height: 100px;"
												id="SRDCn" value="${sd.cn}">
										</div>
									</div>
									<hr />
									<div class="form-group row">
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 px-0 font-weight-bold">검토자</div>
											<div class="col col-sm-8 pl-0">
												<input readonly class="form-control" id="SRDRvwrNm"
													value="${sd.rvwrNm}">
											</div>
										</div>
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 font-weight-bold">진행상태</div>
											<div class="col col-sm-7 pl-0">
												<input readonly class="form-control" id="SRDSttsNm"
													value="${sd.sttsNm}">
											</div>
										</div>
									</div>
									<div class="form-group row">
										<p class="col-sm-2 font-weight-bold px-0">첨부파일</p>
										<div class="col-sm-10" id="SRDAttachFile">
											<c:forEach var="f" items="${sd.attachFile}">
												<div>
													<a href="<c:url value='/file/download/${f.fileSn}' />">
														<span class="glyphicon glyphicon-save" aria-hidden="true"></span>
														<span style="margin-right: 20px;"> ${f.orgnlFileNm}
													</span> <span style=""> <fmt:formatNumber type="number"
																value="${f.fileSz/(1024 * 1024)}" pattern="0.0" /> MB
													</span>
													</a>
												</div>
											</c:forEach>
										</div>
									</div>

									<div class="form-group row">
										<div class="col-9"></div>
										<div class="col-3"
											<c:if test="${sd.sttsNm eq '개발취소' || sd.sttsNm eq '개발완료'}">
                                    style="padding-left: 3px; display:none"
                                 </c:if>>
											<button class="btn btn-oti btn-sm"
												onclick="addHistory('${srNo}')" data-toggle="modal"
												data-target="#addHistoryModal">SR 변경요청</button>
										</div>
									</div>
								</div>
							</div>
						</div>
						<%-- *********************************** SR처리 정보탭 *********************************** --%>
						<div class="tab-pane" id="srInfoDetail" role="tabpanel">
							<div class="card-block" style="padding: 0px;">
								<ul class="nav nav-tabs md-tabs" id="otiTabs" role="tablist">
									<li class="nav-item font-weight-bold" onclick="getPlan()"><a
										id="srPlanTab" class="nav-link active" data-toggle="tab"
										href="#home1" role="tab">SR 계획정보</a>
										<div class="slide"></div></li>
									<li class="nav-item font-weight-bold"><a
										id="srResourceTab" class="nav-link" data-toggle="tab"
										href="#profile1" role="tab">SR 자원정보</a>
										<div class="slide"></div></li>
									<li class="nav-item font-weight-bold" onclick="getProgress()"><a
										class="nav-link" data-toggle="tab" href="#messages1"
										role="tab">SR 진척률</a>
										<div class="slide"></div></li>
									<li class="nav-item font-weight-bold" onclick="empHstry()"><a
										class="nav-link" data-toggle="tab" href="#srInfhistory" id="srInfhistoryTab"
										role="tab">SR 히스토리</a>
										<div class="slide"></div></li>
								</ul>
								<%-- *********************************** [ 계획정보 ] ***********************************--%>
								<div class="tab-content tabs card-block" style="padding: 0px;">
									<input type="hidden" id="SRPlDmndNo">
									<div class="tab-pane active" id="home1" role="tabpanel"
										style="padding: 10px;">
										<div class="form-group row">
											<div class="col-sm-6 p-0">
												<div class="col col-sm-4 font-weight-bold">처리팀</div>
												<div class="col col-sm-6" id="deptDiv">
													<select id="dept" onchange="changeDept()">
														<c:forEach var="deptList" items="${deptList}">
															<option id="SRDept" value="${deptList.deptCd}">${deptList.deptNm}</option>
														</c:forEach>
													</select> <input type="hidden" id="SRPlDeptNm">
												</div>
											</div>
											<div class="col-sm-6 p-0">
												<div class="col col-sm-4 font-weight-bold">담당자</div>
												<div class="col col-sm-8" id="SRPlFlnmBySelect">
													<input type="hidden" id="SRPlMemberId"> <input
														readonly class="form-control" id="SRPlFlnm"
														value="${sp.flnm}">
												</div>
											</div>
										</div>
										<div class="form-group row">
											<div class="col-sm-6 p-0">
												<div class="col col-sm-4 font-weight-bold">계획시작일</div>
												<div class="col col-sm-8" id="bgngYmdDiv">
													<input type="date" class="form-control" id="SRPlBgngYmd"
														value="${sp.bgngYmd}">
												</div>
											</div>
											<div class="col-sm-6 p-0">
												<div class="col col-sm-4 font-weight-bold">계획종료일</div>
												<div class="col col-sm-8" id="endYmdDiv">
													<input type="date" class="form-control" id="SRPlEndYmd"
														value="${sp.endYmd}">
												</div>
											</div>
										</div>
										<div class="form-group row">
											<div class="col col-sm-2  p-0 font-weight-bold"
												style="line-height: 90px;">검토 내용</div>
											<div class="col col-sm-10" id="rvwCnDiv">
												<textarea rows="5" cols="5" class="form-control"
													id="SRPlRvwCn">${sp.rvwCn}</textarea>
											</div>
										</div>
										<sec:authorize access="hasRole('ROLE_ADMIN')">
											<button class="btn btn-oti btn-sm" onclick="planUpdate()"
												id="planBtn"
												style="float: right; padding-bottom: 10px; margin-bottom: 10px;">수정</button>
										</sec:authorize>
									</div>
									<%-- *********************************** [ 자원정보 ] ***********************************--%>
									<div class="tab-pane" id="profile1" role="tabpanel"
										style="padding-bottom: 20px;">
										<div class="card-block table-border-style"
											style="padding: 0px;">
											<div class="table-responsive">
												<table class="table table-hover text-center"
													style="font-size: 12px; padding: 0px;">
													<thead>
														<tr>
															<th style="width: 1px;"><input type="checkbox"
																name="resource" value="selectResourceAll"
																onclick="selectResourceAll(this)"></th>
															<th style="width: 1px;">순번</th>
															<th>개발자명</th>
															<th>역할</th>
															<th>투입시작일</th>
															<th>투입종료일</th>
														</tr>
													</thead>
													<tbody id="resourceTableRow">
													</tbody>
												</table>
											</div>
										</div>
										<sec:authorize access="hasRole('ROLE_ADMIN')">
											<button onclick="deleteResource()" class="btn btn-oti btn-sm"
												id="deleteSrResourceBtn"
												style="float: right; padding-bottom: 10px; margin-bottom: 10px; margin-right: 10px;"
												<c:if test="${sd.sttsNm eq '개발취소' || sd.sttsNm eq '개발완료'}">
													style="display:none"
										</c:if>>선택
												삭제</button>
											<button class="btn btn-oti btn-sm" id="addSrResourceBtn"
												style="float: right; padding-bottom: 10px; margin-bottom: 10px; margin-right: 10px;"
												data-toggle="modal" data-target="#addSrResourcesModal"
												<c:if test="${sd.sttsNm eq '개발취소' || sd.sttsNm eq '개발완료'}">
											style="display:none"
										</c:if>>추가</button>
										</sec:authorize>
									</div>
									<%-- *********************************** [ 진척률 ] ***********************************--%>
									<!-- 진행상태에 따라서 inpu readonly로 출력 및 버튼 안보여야됨 -->
									<div class="tab-pane" id="messages1" role="tabpanel"
										style="padding-bottom: 20px;">
										<div class="tab-pane" id="profile1" role="tabpanel">
											<div class="card-block table-border-style"
												style="padding: 0px;">
												<div class="table-responsive">
													<table class="table table-hover text-center"
														style="font-size: 12px; padding: 0px; width: 100%; table-layout: fixed">
														<thead>
															<tr>
																<th style="width: 13%;">작업구분</th>
																<th>시작일</th>
																<th>종료일</th>
																<th style="width: 19%;">진척률</th>
																<th style="width: 13%;">산출물</th>
																<th style="width: 8%;"></th>
															</tr>
														</thead>
														<tbody>
															<tr>

																<td>요구정의 <input type="hidden" id="SRPgPrgrsId0">
																	<input type="hidden" id="SRPgSrNo">
																</td>
																<td id="0bgngYmd"><input type="date"
																	id="SRPgBgngYmd0"></td>
																<td id="0endYmd"><input type="date"
																	id="SRPgEndYmd0"></td>
																<td id="0rt"><input type="number"
																	class="form-control" id="SRPgPrgrsRt0" min="1" max="10"
																	placeholder="1~10이하 범위의 진척률을 입력하세요"></td>
																<td><div class="accordion" id="accordionExample">
																		<button class="btn btn-link btn-block text-center "
																			type="button" data-toggle="modal"
																			data-target="#deliverableListModal"
																			onclick="getDeliverablesTableRow(0)">첨부파일</button>
																	</div></td>
																<td style="padding: 0px; margin: 0px;">
																	<button class="btn btn-oti btn-lg"
																		onclick="updateProgress0()" id="btn0"
																		style="width: 90%; height: 90%">저장</button>
																</td>
															</tr>

															<tr>

																<td>분석/설계<input type="hidden" id="SRPgPrgrsId1"></td>
																<td id="1bgngYmd"><input type="date"
																	id="SRPgBgngYmd1"></td>
																<td id="1endYmd"><input type="date"
																	id="SRPgEndYmd1"></td>
																<td id="1rt"><input type="number"
																	class="form-control" id="SRPgPrgrsRt1" min="11"
																	max="40"></td>
																<td><div class="accordion" id="accordionExample">
																		<button class="btn btn-link btn-block text-center "
																			type="button" data-toggle="modal"
																			data-target="#deliverableListModal"
																			onclick="getDeliverablesTableRow(1)">첨부파일</button>
																	</div></td>
																<td style="padding: 0px; margin: 0px;">
																	<button class="btn btn-oti btn-lg"
																		onclick="updateProgress1()" id="btn1"
																		style="width: 90%; height: 90%">저장</button>
																</td>
															</tr>

															<tr>

																<td>구현<input type="hidden" id="SRPgPrgrsId2"></td>
																<td id="2bgngYmd"><input type="date"
																	id="SRPgBgngYmd2"></td>
																<td id="2endYmd"><input type="date"
																	id="SRPgEndYmd2"></td>
																<td id="2rt"><input type="number"
																	class="form-control" id="SRPgPrgrsRt2" min="41"
																	max="70"></td>
																<td><div class="accordion" id="accordionExample">
																		<button class="btn btn-link btn-block text-center "
																			type="button" data-toggle="modal"
																			data-target="#deliverableListModal"
																			onclick="getDeliverablesTableRow(2)">첨부파일</button>
																	</div></td>
																<td style="padding: 0px; margin: 0px;">
																	<button class="btn btn-oti btn-lg"
																		onclick="updateProgress2()" id="btn2"
																		style="width: 90%; height: 90%">저장</button>
																</td>
															</tr>

															<tr>

																<td>테스트<input type="hidden" id="SRPgPrgrsId3"></td>
																<td id="3bgngYmd"><input type="date"
																	id="SRPgBgngYmd3"></td>
																<td id="3endYmd"><input type="date"
																	id="SRPgEndYmd3"></td>
																<td id="3rt"><input type="number"
																	class="form-control" id="SRPgPrgrsRt3" min="71"
																	max="80"></td>
																<td>
																	<div class="accordion" id="accordionExample">
																		<button class="btn btn-link btn-block text-center "
																			type="button" data-toggle="modal"
																			data-target="#deliverableListModal"
																			onclick="getDeliverablesTableRow(3)">첨부파일</button>
																	</div>
																</td>
																<td style="padding: 0px; margin: 0px;">
																	<button class="btn btn-oti btn-lg"
																		onclick="updateProgress3()" id="btn3"
																		style="width: 90%; height: 90%">저장</button>
																</td>
															</tr>

															<tr>

																<td>반영요청<input type="hidden" id="SRPgPrgrsId4"></td>
																<td id="4bgngYmd"><input type="date"
																	id="SRPgBgngYmd4"></td>
																<td id="4endYmd"><input type="date"
																	id="SRPgEndYmd4"></td>
																<td id="4rt"><input type="number"
																	class="form-control" id="SRPgPrgrsRt4" min="81"
																	max="90"></td>
																<td><div class="accordion" id="accordionExample">
																		<button class="btn btn-link btn-block text-center "
																			type="button" data-toggle="modal"
																			data-target="#deliverableListModal"
																			onclick="getDeliverablesTableRow(4)">첨부파일</button>
																	</div></td>
																<td style="padding: 0px; margin: 0px;">
																	<button class="btn btn-oti btn-lg"
																		onclick="updateProgress4()" id="btn4"
																		style="width: 90%; height: 90%">저장</button>
																</td>
															</tr>

															<tr>

																<td>운영반영<input type="hidden" id="SRPgPrgrsId5"></td>
																<td id="5bgngYmd"><input type="date"
																	id="SRPgBgngYmd5"></td>
																<td id="5endYmd"><input type="date"
																	id="SRPgEndYmd5"></td>
																<td id="5rt"><input type="number"
																	class="form-control" id="SRPgPrgrsRt5" min="91"
																	max="100"></td>
																<td><div class="accordion" id="accordionExample">
																		<button class="btn btn-link btn-block text-center "
																			type="button" data-toggle="modal"
																			data-target="#deliverableListModal"
																			onclick="getDeliverablesTableRow(5)">첨부파일</button>
																	</div></td>
																<td style="padding: 0px; margin: 0px;">
																	<button class="btn btn-oti btn-lg"
																		onclick="updateProgress5()" id="btn5"
																		style="width: 90%; height: 90%">저장</button>
																</td>
															</tr>

														</tbody>
													</table>
												</div>
											</div>
										</div>

										<button class="btn btn-oti btn-sm" id="addbtn"
											style="float: right;width:100%;">산출물
											추가</button>
									</div>
									<%-- *********************************** [ SR 히스토리  ] ***********************************--%>
									<div class="tab-pane" id="srInfhistory" role="tabpanel"
										style="padding-bottom: 20px;">
										<div class="card-block table-border-style"
											style="padding: 0px;">
											<div class="table-responsive">
												<table class="table table-hover text-center historyTable"
													style="font-size: 12px; padding: 0px;">
													<thead>
														<tr>
															<th style="width: 1px;">순번</th>
															<th>요청자명</th>
															<th>요청유형</th>
															<th>변경될 완료요청일</th>
															<th>승인여부</th>
														</tr>
													</thead>
													<tbody id="srhistory1">
													</tbody>
												</table>
												<%-- 페이징 --%>
												<div class="hstryPager-container">
													<div class="hstryPager"></div>
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
	<%@include file="/WEB-INF/views/fragments/bottom.jsp"%>

	<%@include file="/WEB-INF/views/history/approvalInfoHistoryModal.jsp"%>
	<%@include file="/WEB-INF/views/history/addHistoryModal.jsp"%>
	<%@include file="/WEB-INF/views/history/modifyHistoryModal.jsp"%>
	<%@include file="/WEB-INF/views/srInfo/addSrResourcesModal.jsp"%>
</body>
</html>
F
