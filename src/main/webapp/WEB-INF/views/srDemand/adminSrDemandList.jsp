<%@page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%-- 작성자 : 여수한 / 작성 날짜 : 2023-02-17 --%>

<html>
<head>
<%@include file="/WEB-INF/views/fragments/header.jsp"%>
<script
	src="${pageContext.request.contextPath}/resources/assets/js/srDemandList.js"></script>

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

#srDemandDetail {
	font-size: 12px;
	padding-left: 0px;
}

#card_body, .form-control {
	font-size: 12px;
}

#headerFirst {
	background: #6b2146;
}

.card .card-header {
	background: linear-gradient(135deg, #6b2146 10%, #93344b 100%);
}

.badge {
	padding: 5px 8px;
}

.card .card-block {
	padding: 0px;
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
	width: 100%;
	display: block; /* 블록태그로 만들어준다 */
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
	<div class="page-body text">
		<div class="row">
			<%-- *********************************** [SR 요청 관리 ] ***********************************--%>
			<div class="col-xl-12">
				<div class="card">
					<div class="card-header" id="headerFirst">
						<div class="row">
							<div class="col-10">
								<h5 style="font-weight: bold; font-size: 20px">SR 요청 관리</h5>
							</div>
						</div>
					</div>
					<div class="card-body" style="height: 70px;">
						<form name="srSearchForm" id="srSearchForm"
							action="${pageContext.request.contextPath}/admin/srdemand/list">
							<div class="row">
								<div class="col col-3 pr-0 font-weight-bold">
									<label for="dmndYmdStart" style="margin-right: 10px;">조회
										기간</label> <input type="date" name="dmndYmdStart" id="dmndYmdStart"
										value="${srFilterDto.dmndYmdStart}"> ~ <input
										type="date" name="dmndYmdEnd" id="dmndYmdEnd"
										value="${srFilterDto.dmndYmdEnd}">
								</div>
								<div class="col col-2 pr-0 font-weight-bold">
									<label for="sttsCd">진행 상태</label> <select id="sttsCd"
										name="sttsCd">
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
								<div class="col-4 pr-0 mr-0 pl-0 ml-0 font-weight-bold">
									<label for="sysCd" style="margin-right: 5px;">시스템 구분</label> <select
										id="sysCd" name="sysCd" onchange="systemFilter()">
										<option value="">전체</option>
										<c:forEach var="system" items="${systemList}">
											<c:if test="${srFilterDto.sysCd eq system.sysCd}">
												<option value="${system.sysCd}" selected>${system.sysNm}</option>
											</c:if>
											<c:if test="${srFilterDto.sysCd ne system.sysCd}">
												<option value="${system.sysCd}">${system.sysNm}</option>
											</c:if>
										</c:forEach>
									</select> <select id="taskSeCd" name="taskSeCd">
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
								<div class="col-3 font-weight-bold">
									<label for="keyWord" style="margin-right: 5px;">키워드</label> <input
										type="text" name="keyWord" id="keyWord"
										value="${srFilterDto.keyWord}">
									<button type="submit" class="btn btn-sm btn-oti"
										style="margin-right: 10px; height: 30px;">
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
						<button type="submit" class="btn btn-sm" form="srSearchForm"
							onclick="javascript: form.action='${pageContext.request.contextPath}/admin/srdemand/list/download';"
							style="float: right; margin-right: 50px; background-color: transparent; padding: 0px;">
							<img
								src="${pageContext.request.contextPath}/resources/oti_images/엑셀.png"
								width="30px;">
						</button>
						<div class="card-header-right">
							<ul class="list-unstyled card-option" style="color:white;">
								<li><i class="fa fa fa-wrench open-card-option" style="color:white;"></i></li>
								<li><i class="fa fa-window-maximize full-card"style="color:white;"></i></li>
								<li><i class="fa fa-refresh reload-card"style="color:white;"></i></li>
							</ul>
						</div>
					</div>
					<div class="card-block p-0" id="list">
						<div id="sales-analytics">
							<div class="card-block table-border-style" style="height: 820px;">
								<div class="table-responsive">
									<table class="table table-hover text-center">
										<thead>
											<tr style="padding: 0px;">
												<th style="width: 1px;"></th>
												<th style="font-size: 15px;">요청 번호 <c:if
														test="${sort eq 'DESC'}">
														<a
															href="${pageContext.request.contextPath}/admin/srdemand/list"
															class="sortBtnAsc"><i class="fas fa-caret-down"
															style="color: #93344b; font-size: 24px;"></i></a>
													</c:if> <c:if test="${sort eq 'ASC'}">
														<a
															href="${pageContext.request.contextPath}/admin/srdemand/list"
															class="sortBtnDesc"><i class="fas fa-caret-up"
															style="color: #93344b; font-size: 24px;"></i></a>
													</c:if>

												</th>
												<th class="text-left" style="font-size: 15px; width: 100%;">제목</th>
												<th class="text-left" style="font-size: 15px;">시스템구분</th>
												<th class="text-left" style="font-size: 15px;">소속</th>
												<th style="font-size: 15px;">등록일</th>
												<th style="font-size: 15px;">완료요청일</th>
												<th style="font-size: 15px;">진행상태</th>
											</tr>

										</thead>
										<tbody id="dmndTbody">
											<c:if test="${srDemandList ne null}">
												<c:forEach var="srDemand" items="${srDemandList}"
													varStatus="status">
													<tr onclick="getSrDemandDetail('${srDemand.dmndNo}')"
														id="tr${pager.startRowNo + status.index}">
														<th scope="row">${pager.startRowNo + status.index}</th>
														<td><strong>${srDemand.dmndNo}</strong></td>
														<c:choose>
															<c:when test="${fn:length(srDemand.ttl) > 17}">
																<td id="ttl" class="text-left"><c:out
																		value="${fn:substring(srDemand.ttl,0,16)}" />...</td>
															</c:when>
															<c:otherwise>
																<td id="ttl" class="text-left"><c:out
																		value="${srDemand.ttl}" /></td>
															</c:otherwise>
														</c:choose>
														<%-- <td nowrap id="ttl" class="text-left fontWrapper" ><span class="fontWrapper">${srDemand.ttl}</span></td> --%>
														<td class="text-left">${srDemand.sysNm}</td>
														<td class="text-left">${srDemand.instNm}</td>
														<td>${srDemand.dmndYmd}</td>
														<td>${srDemand.cmptnDmndYmd}</td>
														<td style="font-size: 15px;"><c:if
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
											<c:if test="${srDemandList eq null}">
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
					<div class="card-header">s
						<h5 style="font-weight: bold; font-size: 20px">SR 요청 상세정보</h5>
					</div>
					<div class="tab-content tabs card-block"
						style="padding: 0px; padding-top: 20px;">
						<div class="tab-pane active" id="srDemandDetail" role="tabpanel">
							<div class="card-block">
								<jsp:include page="/WEB-INF/views/srDemand/admin/adSrDetail.jsp" />
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
	<!-- 모달 -->
	<jsp:include page="/WEB-INF/views/srDemand/modal.jsp" />
</body>
</html>