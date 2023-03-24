<%-- 작성자: 최은종 / 2023-03-12 --%>

<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<script
	src="${pageContext.request.contextPath}/resources/js/mytodoHstry.js"></script>
<style>
#todoHT th, td {
	text-align: center;
}

#todoHT th{
font-size: 15px !important;
	}
	
#todoHT tbody td{
font-size: 15px !important;
   padding: 2	;
	}
label {
	width:70px;
}
</style>
<table id="todoHT" class="table table-hover"
	style="table-layout: fixed;">
	<c:if test="${fn:length(todoHstryList) == 0 }">
		<div class="text-center d-flex justify-content-center"
			style="height: 100px;">
			<div style="margin: auto;">히스토리 내역이 없습니다.</div>
		</div>
	</c:if>
	<c:if test="${fn:length(todoHstryList) gt 0}">
		<thead>
			<tr>
				<sec:authorize access="hasAnyRole('ROLE_DEVELOPER', 'ROLE_ADMIN')">
					<th class="text-left">SR번호</th>
					<th class="text-left">시스템구분</th>
					<th>요청자명</th>
					<th>요청유형</th>
					<th>변경될 완료예정일</th>
					<th>승인여부</th>
					<th>요청등록일</th>
				</sec:authorize>
				<sec:authorize access="hasAnyRole('ROLE_CLIENT')">
					<th class="text-left">SR번호</th>
					<th class="text-left">시스템구분</th>
					<th>요청부서</th>
					<th>요청유형</th>
					<th>기존 완료요청일</th>
					<th>변경될 완료예정일</th>
					<th>승인여부</th>
					<th>요청등록일</th>
				</sec:authorize>
			</tr>
		</thead>
		<tbody>
			<c:forEach var="todoHstry" items="${todoHstryList}">
				<tr>
					<sec:authorize access="hasAnyRole('ROLE_ADMIN', 'ROLE_DEVELOPER')">

						<td id="srNo1" class="font-weight-bold text-left">${todoHstry.srNo}</td>

						<td id="sysNm1" class="text-left">${todoHstry.sysNm}</td>

						<c:if test='${authRole eq "ROLE_ADMIN"}'>
							<td id="picId">${todoHstry.flnm}</td>
						</c:if>
						<c:if test='${authRole eq "ROLE_DEVELOPER"}'>
							<td id="empId">${todoHstry.flnm}</td>
						</c:if>

						<c:if
							test="${(todoHstry.hstryType eq 'A')||(todoHstry.hstryType eq 'B')}">
							<td id="hstryType1">완료일 변경</td>
						</c:if>
						<c:if test="${todoHstry.hstryType eq 'C'}">
							<td id="hstryType2">개발취소</td>
						</c:if>

						<c:if test="${not empty todoHstry.chgEndYmd}">
							<td id="chgEndYmd1">${todoHstry.chgEndYmd}</td>
						</c:if>

						<c:if test="${empty todoHstry.chgEndYmd}">
							<td id="chgEndYmd2">-</td>
						</c:if>

						<td><c:if test="${todoHstry.hstryStts eq 'I'}">
								<label class="badge badge-warning text-center">미승인</label>
							</c:if> <c:if test="${todoHstry.hstryStts eq 'Y'}">
								<label class="badge badge-success text-center text-white">승인</label>
							</c:if> <c:if test="${todoHstry.hstryStts eq 'N'}">
								<label class="badge badge-inverse-danger text-center">반려</label>
							</c:if></td>

						<td id="wrtYmd1">${todoHstry.wrtYmd}</td>
					</sec:authorize>

					<sec:authorize access="hasAnyRole('ROLE_CLIENT')">
						<td id="dmndNo" class="text-left font-weight-bold">${todoHstry.dmndNo}</td>

						<td id="sysNm2" class="text-left">${todoHstry.sysNm}</td>

						<td id="deptNm">${todoHstry.deptNm}</td>

						<c:if test="${todoHstry.hstryType eq 'B'}">
							<td id="hstryType3">완료일 변경</td>
						</c:if>
						<c:if test="${todoHstry.hstryType eq 'C'}">
							<td id="hstryType4">개발취소</td>
						</c:if>

						<td id="cmptnDmndYmd">${todoHstry.cmptnDmndYmd}</td>

						<c:if test="${not empty todoHstry.chgEndYmd}">
							<td id="chgEndYmd3">${todoHstry.chgEndYmd}</td>
						</c:if>
						<c:if test="${empty todoHstry.chgEndYmd}">
							<td id="chgEndYmd4">-</td>
						</c:if>

						<td><c:if test="${todoHstry.hstryStts eq 'I'}">
								<label class="badge badge-warning text-center">미승인</label>
							</c:if> <c:if test="${todoHstry.hstryStts eq 'Y'}">
								<label class="badge badge-success text-center text-white">승인</label>
							</c:if> <c:if test="${todoHstry.hstryStts eq 'N'}">
								<label class="badge badge-inverse-danger text-center">반려</label>
							</c:if></td>

						<td id="wrtYmd2">${todoHstry.wrtYmd}</td>

					</sec:authorize>
				</tr>
			</c:forEach>
	</c:if>
	</tbody>
</table>
<div class="d-flex justify-content-center">
	<%@ include file="/WEB-INF/views/fragments/mytodoHstryPager.jsp"%>
</div>