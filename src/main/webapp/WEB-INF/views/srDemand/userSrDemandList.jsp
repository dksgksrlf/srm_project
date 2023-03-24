<%@page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="fmt" uri="http://java.sun.com/jsp/jstl/fmt"%>
<%-- 작성자 : 여수한 / 작성 날짜 : 2023-02-17 --%>
<%-- 작성자: 최은종 / 작성 날짜: 2023-02-23 --%>

<html>
<head>
<%@include file="/WEB-INF/views/fragments/header.jsp"%>
<link rel="stylesheet" type="text/css"
	href="${pageContext.request.contextPath}/resources/css/hstryPager.css">
<script
	src="${pageContext.request.contextPath}/resources/js/srDemandListHstry.js"></script>

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
<%-- rownu이 주어질경우 히스토리 탭 열기 --%>
   <c:if test="${rownum ne null}">
   $(function(){
         
         var trId = "tr"+${rownum};
         console.log(trId);
         $("#"+trId).trigger("click");
         <c:if test="${noHstry ne true}">
            $("#srHistoryTab").trigger("click"); 
         </c:if>
   });
   
   </c:if>
</script>

<style>
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

.card .card-block {
	padding: 0px;
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

.m.body { : 50vh;
	overflow-y: auto;
}

#srDemandDetail {
	font-size: 12px;
	padding-left: 0px;
}

#card_body, .form-control {
	font-size: 12px;
}

.badge {
	padding: 5px 8px;
}

#headerFirst {
	background: #6b2146;
}

.card .card-header {
	background: linear-gradient(135deg, #6b2146 10%, #93344b 100%);
}

#otiTabs .nav-item a {
	color: #4C1342;
	padding: 15px !important;
}

#otiTabs .nav-link {
	color: #4C1342;
	background-color: white !important;
}

table th {
	font-size: 15px !important;
}

table thead tr {
	width: 100%;
}

table tbody td {
	font-size: 15px !important;
}

.fontWrapper {
	/* display: block; */ /* 블록태그로 만들어준다 */
	text-overflow: ellipsis; /* 말줄임 css */
	white-space: nowrap; /*글자를 한줄로 모아준다*/
	overflow: hidden;
	background: pink; /*실제 글자 영역 상태 확인하기 위함*/
	margin-right: 0;
}
</style>
</head>

<body>
	<%@include file="/WEB-INF/views/fragments/top.jsp"%>
	<%@include file="/WEB-INF/views/fragments/sidebar.jsp"%>
	<!-- Page-body start -->
	<div class="page-body">
		<div class="row">
			<!-- *********** -->
			<%-- *********************************** [SR 요청 관리 ] ***********************************--%>
			<div class="col-xl-12">
				<div class="card">
					<div class="card-header" id="headerFirst">
						<div class="row justify-content-between">
							<div class="col-10">
								<h5 style="font-weight: bold; font-size: 20px">SR 요청 관리</h5>
							</div>
							<div class="col-1 mr-5">
								<button class="btn btn-info btn-sm" id="addbtn"
									style="font-size: 20px; font-weight: bold;border-radius:20px;">요청 등록</button>
							</div>
						</div>
					</div>
					<div class="card-body" style="height: 70px;">
						<form id="srSearchForm"
							action="${pageContext.request.contextPath}/srdemand/list">
							<div class="row">
								<div class="col col-3 pr-0">
									<label for="dmndYmdStart" style="margin-right: 10px;">조회
										기간</label> <input type="date" name="dmndYmdStart" id="dmndYmdStart"
										value="${srFilterDto.dmndYmdStart}"> ~ <input
										type="date" name="dmndYmdEnd" id="dmndYmdEnd"
										value="${srFilterDto.dmndYmdEnd}">
								</div>
								<div class="col col-2 p-0">
									<label for="sttsCd" style="margin-right: 10px;">진행 상태</label> <select
										id="sttsCd" name="sttsCd">
										<option value="">전체</option>
										<option value="0"
											<c:if test="${srFilterDto.sttsCd eq 0 }">selected</c:if>>요청</option>
										<option value="1"
											<c:if test="${srFilterDto.sttsCd eq 1 }">selected</c:if>>반려</option>
										<option value="2"
											<c:if test="${srFilterDto.sttsCd eq 2 }">selected</c:if>>접수</option>
										<option value="3"
											<c:if test="${srFilterDto.sttsCd eq 3 }">selected</c:if>>개발중</option>
										<option value="4"
											<c:if test="${srFilterDto.sttsCd eq 4 }">selected</c:if>>테스트</option>
										<option value="5"
											<c:if test="${srFilterDto.sttsCd eq 5 }">selected</c:if>>개발
											완료</option>
									</select>
								</div>

								<div class="col col-3 p-0" style="margin-left: -60px;">
									<label for="sysCd">시스템 구분</label> <select id="sysCd"
										name="sysCd" onchange="systemFilter()">

										<option value="">전체</option>
										<c:forEach var="system" items="${systemList}">
											<c:if test="${srFilterDto.sysCd eq system.sysCd}">
												<option value="${system.sysCd}" selected>${system.sysNm}</option>
											</c:if>
											<c:if test="${srFilterDto.sysCd ne system.sysCd}">
												<option value="${system.sysCd}">${system.sysNm}</option>
											</c:if>
										</c:forEach>
									</select>
								</div>
								<div class="col col-2 p-0" style="margin-left: -85px;">
									<label for="taskSeCd">업무구분</label> <select id="taskSeCd"
										name="taskSeCd" style="width: 150px">
										<option value="">전체</option>
										<c:if test="${taskList ne null}">
											<c:forEach var="task" items="${taskList}">
												<c:if test="${srFilterDto.taskSeCd eq task.taskSeCd}">
													<option value="${task.taskSeCd}" selected>${task.taskSeNm}</option>
												</c:if>
												<c:if test="${srFilterDto.taskSeCd ne task.taskSeCd }">
													<option value="${task.taskSeCd}">${task.taskSeNm}</option>
												</c:if>
											</c:forEach>
										</c:if>
									</select>
								</div>
								<div class="col col-3 p-0" style="margin-left: -20px;">
									<label for="keyWord" style="margin-right: 10px;">키워드</label> <input
										type="text" name="keyWord" id="keyWord"
										value="${srFilterDto.keyWord}" style="width: 140px;">
									<button type="submit" class="btn btn-sm btn-oti">
										<i class="ti-search"></i>
									</button>
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
						<h5 style="font-weight: bold; font-size: 20px">SR 요청 목록</h5>
						<button type="submit" class="btn-sm btn" form="srSearchForm"
							onclick="javascript: form.action='${pageContext.request.contextPath}/admin/srdemand/list/download';"
							style="float: right; margin-right: 50px; background-color: transparent; padding: 0px;">
							<img
								src="${pageContext.request.contextPath}/resources/oti_images/엑셀.png"
								width="30px;">
						</button>
						<div class="card-header-right">
							<ul class="list-unstyled card-option">
								<li><i class="fa fa fa-wrench open-card-option"style="color:white;"></i></li>
								<li><i class="fa fa-window-maximize full-card"style="color:white;"></i></li>
								<li><i class="fa fa-refresh reload-card"style="color:white;"></i></li>
							</ul>
						</div>
					</div>
					<div class="card-block" id="list">
						<div id="sales-analytics">
							<div class="card-block table-border-style" style="height: 770px;">
								<div class="table-responsive">
									<table class="table table-hover text-center"
										style="font-size: 12; width: 100%">
										<thead>
											<tr>
												<th style="width: 1px;"></th>
												<th style="font-size: 15px;">요청 번호 <c:if
														test="${sort eq 'DESC'}">
														<a href="${pageContext.request.contextPath}/srdemand/list"
															class="sortBtnAsc"><i class="fas fa-caret-down"
															style="color: #93344b; font-size: 24px;"></i></a>
													</c:if> <c:if test="${sort eq 'ASC'}">
														<a href="${pageContext.request.contextPath}/srdemand/list"
															class="sortBtnDesc"><i class="fas fa-caret-up"
															style="color: #93344b; font-size: 24px;"></i></a>
													</c:if>
												</th>
												<th class="text-left" style="font-size: 15px;">제목</th>
												<th class="text-left" style="font-size: 15px;">관련시스템</th>
												<th class="text-left" style="font-size: 15px;">소속</th>
												<th style="font-size: 15px;">등록일</th>
												<th style="font-size: 15px;">완료요청일</th>
												<th style="font-size: 15px;">진행상태</th>
											</tr>
										</thead>
										<tbody id="dmndTbody">
											<c:if test="${mySrDemandList ne null}">
												<c:forEach var="srDemand" items="${mySrDemandList}"
													varStatus="status">
													<tr onclick="getSrDemandDetail('${srDemand.dmndNo}')"
														id="tr${pager.startRowNo + status.index}">
														<th scope="row">${pager.startRowNo + status.index}</th>
														<td><strong>${srDemand.dmndNo}</strong></td>
														<c:choose>
															<c:when test="${fn:length(srDemand.ttl) > 17}">
																<td id="ttl" class="text-left" style="font-size: 14px;"><c:out
																		value="${fn:substring(srDemand.ttl,0,16)}" />...</td>
															</c:when>
															<c:otherwise>
																<td id="ttl" class="text-left" style="font-size: 14px;"><c:out
																		value="${srDemand.ttl}" /></td>
															</c:otherwise>
														</c:choose>
														<td class="text-left" style="font-size: 14px;">${srDemand.sysNm}</td>
														<td style="font-size: 14px;" class="text-left">${srDemand.instNm}</td>
														<td style="font-size: 13px;">${srDemand.dmndYmd}</td>
														<td style="font-size: 13px;"><c:if
																test="${(srDemand.sttsNm) eq '개발취소'}">
															-</c:if> <c:if test="${(srDemand.sttsNm) ne '개발취소'}">
																${srDemand.cmptnDmndYmd}
															</c:if></td>
															<td style="font-size: 14px;"><c:if
																test="${(srDemand.sttsNm) eq '요청'}">
																<label class="badge badge-warning"
																	style="font-size: 15px;">${srDemand.sttsNm}</label>
															</c:if> <c:if test="${(srDemand.sttsNm) eq '반려'}">
																<label class="badge badge-danger"
																	style="font-size: 15px;">${srDemand.sttsNm}</label>
															</c:if> <c:if test="${(srDemand.sttsNm) eq '접수'}">
																<label class="badge badge-inverse-success"
																	style="font-size: 15px;">${srDemand.sttsNm}</label>
															</c:if> <c:if test="${(srDemand.sttsNm) eq '개발중'}">
																<label class="badge badge-success"
																	style="font-size: 15px;">${srDemand.sttsNm}</label>
															</c:if> <c:if test="${(srDemand.sttsNm) eq '개발완료'}">
																<label class="badge badge-primary"
																	style="font-size: 15px;">${srDemand.sttsNm}</label>
															</c:if> <c:if test="${(srDemand.sttsNm) eq '개발취소'}">
																<label class="badge badge-danger"
																	style="font-size: 15px;">${srDemand.sttsNm}</label>
															</c:if> <c:if test="${(srDemand.sttsNm) eq '테스트'}">
																<label class="badge badge-inverse-primary"
																	style="font-size: 15px;">${srDemand.sttsNm}</label>
															</c:if></td>
													</tr>
												</c:forEach>
											</c:if>
											<c:if test="${mySrDemandList eq null}">
												<tr>
													<td colSpan="9">검색 결과가 없습니다.</td>
												</tr>
											</c:if>
										</tbody>
									</table>
									<!-- 페이징 처리 -->
									<div class="d-flex justify-content-center">
										<%@ include file="/WEB-INF/views/fragments/pagination.jsp"%>
									</div>
								</div>
							</div>
						</div>
					</div>
				</div>
			</div>

			<%-- *********************************** [SR요청 처리정보 ] ***********************************--%>
			<div class="col-xl-4 col-md-12 p-0">
				<div class="card">
					<div class="card-header">
						<h5 style="font-weight: bold; font-size: 20px">SR 요청 상세정보</h5>
					</div>
					<ul class="nav nav-tabs md-tabs" id="otiTabs" role="tablist">
						<li class="nav-item"><a class="nav-link active"
							data-toggle="tab" href="#srDemandDetail" role="tab"
							id="srDmndDetailTab" style="font-weight: bold; font-size: 20px">SR요청
								상세정보</a>
							<div class="slide"></div></li>
						<li class="nav-item" onclick="userHstry()"><a
							id="srHistoryTab" class="nav-link" data-toggle="tab"
							href="#srHistory" role="tab"
							style="font-weight: bold; font-size: 20px">SR 히스토리</a>
							<div class="slide"></div></li>
					</ul>

					<div class="tab-content tabs card-block" style="padding: 0px;">
						<div class="tab-pane active" id="srDemandDetail" role="tabpanel">
							<div class="card-block" id="sddetail">
								<div class="card_body"
									style="font-size: 14px; padding-top: 20px;">
									<div class="form-group row">
										<div class="col col-sm-2 font-weight-bold  px-0">SR번호</div>
										<div class="col col-sm-10">
											<div id="dmndNo" style="width: 100%;">${sd.dmndNo}</div>
										</div>
									</div>
									<hr />
									<div class="form-group row">
										<div class="col col-sm-2 font-weight-bold px-0">SR 제목</div>
										<div class="col col-sm-10">
											<div class="ttl" style="width: 100%;">${sd.ttl}</div>
										</div>
									</div>
									<hr />
									<div class="form-group row">
										<div class="col-sm-2 font-weight-bold px-0">관련 근거</div>
										<div class="col-sm-10">
											<div class="relGrund" style="width: 100%;">${sd.relGrund}</div>
										</div>
									</div>
									<hr />
									<div class="form-group row">
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 font-weight-bold">시스템구분</div>
											<div class="col col-sm-8 sysNm">${sd.sysNm}</div>
										</div>
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 font-weight-bold">업무구분</div>
											<div class="col col-sm-8 taskSeNm">${sd.taskSeNm}</div>
										</div>
									</div>
									<hr />
									<div class="form-group row">
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 font-weight-bold">요청기관</div>
											<div class="col col-sm-8 instNm">${sd.instNm}</div>
										</div>
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 font-weight-bold">요청자</div>
											<div class="col col-sm-6 dropdown dropdown open clientNm">${sd.clientNm}</div>
										</div>
									</div>
									<hr />
									<div class="form-group row">
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 font-weight-bold">등록일</div>
											<div class="col col-sm-8 dmndYmd">${sd.dmndYmd}</div>
										</div>
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 font-weight-bold">완료요청일</div>
											<div class="col col-sm-8 cmptnDmndYmd">${sd.cmptnDmndYmd}</div>
										</div>
									</div>
									<hr />
									<div class="form-group row">
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 font-weight-bold">개발 담당자</div>
											<div class="col col-sm-6">
												<div class=" picNm">${sd.picNm}</div>
											</div>
										</div>
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 font-weight-bold px-0">개발 부서</div>
											<div class="col col-sm-8">
												<div class=" deptNm" style="width: 100%;">${sd.deptNm}</div>
											</div>
										</div>
									</div>
									<hr />
									<div class="form-group row">
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 font-weight-bold">진행 상태</div>
											<div class="col col-sm-6">
												<div class=" sttsNm">${sd.sttsNm}</div>
											</div>
										</div>
										<%-- <c:if test="${sd.sttsCd gt 1}">
                                 <div class="col-sm-6 px-0">
                                    <div class="col col-sm-4 font-weight-bold">완료(예정)일</div>
                                    <div class="col col-sm-6 endYmd">${sd.endYmd}</div>
                                 </div>
                              </c:if> --%>
										<div class="col-sm-6 px-0">
											<div class="col col-sm-4 font-weight-bold">검토자 이름</div>
											<div class="col col-sm-6">
												<div class=" rvwrNm">${sd.rvwrNm}</div>
											</div>
										</div>
									</div>
									<hr />
									<c:if test="${sd.sttsCd == 1}">
										<div class="form-group row">
											<label id="companion"
												class="col-sm-2 col-form-label px-0 font-weight-bold"
												style="line-height: 100px; font-size: 12px;">반려사유</label>
											<div class="col-sm-9">
												<input class="form-control rjctRsn"
													style="height: 100px; width: 325px;" value="${sd.rjctRsn}"></input>
											</div>
										</div>
										<hr />
									</c:if>
									<div class="form-group row">
										<label class="col-sm-2 col-form-label px-0 font-weight-bold"
											style="line-height: 100px; font-size: 12px;">SR 내용</label>
										<div class="col-sm-10">
											<input class="form-control cn"
												style="height: 100px; width: 100%;" value="${sd.cn}"
												readonly></input>
										</div>
									</div>
									<hr />
									<div class="form-group row">
										<p class="col-sm-2 p-0 font-weight-bold">첨부파일</p>
										<div class="col-sm-10">
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
									<hr />
									<div class="row" id="userButtonDiv">
										<c:if test="${sd.sttsCd == 0}">
											<div class="col" style="text-align: right">
												<div class="btn btn-sm btn-danger"
													style="float: right; margin-right: 5px; font-weight: bold; font-size: 20px"
													onclick="deleteSr('${sd.dmndNo}')">삭제</div>
												<button id="modbtn"
													style="float: right; margin-right: 5px; font-weight: bold; font-size: 20px"
													class="btn btn-sm btn-info center"
													onclick="updateSr('${sd.dmndNo}')">수정</button>
											</div>
										</c:if>
										<c:if
											test="${sd.sttsCd > 1 && sd.sttsCd < 5 && prgrsRt eq '90'}">
											<div class="col">
												<div class="btn btn-sm btn-oti cancle" onclick="endSr()"
													style="width: 100%;">반영요청</div>
											</div>
										</c:if>
									</div>
								</div>
							</div>
						</div>

						<%-- *********************************** [ SR 히스토리  ] ***********************************--%>
						<div class="tab-pane" id="srHistory" role="tabpanel">
							<div class="card-block table-border-style" style="padding: 0px;">
								<div class="table-responsive">
									<table class="table table-hover text-center historyTable"
										style="font-size: 12px; padding: 0px;">
										<thead>
											<tr>
												<th style="width: 1px;">순번</th>
												<th>요청유형</th>
												<th>변경될 완료일</th>
												<th>승인여부</th>
											</tr>
										</thead>
										<tbody id="history">
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
		<!-- *********** -->
	</div>
	<!-- Page body end -->
	<%@include file="/WEB-INF/views/fragments/bottom.jsp"%>

	<!-- 모달 -->
	<%@include file="/WEB-INF/views/history/approvalHistoryModal.jsp"%>
	<jsp:include page="/WEB-INF/views/srDemand/modal.jsp" />

</body>
</html>