<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<style>
#calendar thead, tbody {
	background-color:white;
} 
</style>
<div class="modal" id="addSrResourcesModal">

	<div class="modal-body modal-dialog modal-lg" style="height: 800px">
		<div class="m_head ">
			<div class="modal_title font-weight-bold" style="color: white">자원정보</div>
			<!-- <button type="button" class="close" data-dismiss="modal">&times;</button> -->
		</div>
		<div class="m_body bg-light">
			<div class="row">
				<div class="col-6">
					<div id="calendar" style="width: 100%"></div>
					
				</div>
				<div class="col-6 border-left-1">
					<form id="addResourceForm">
						<div class="row my-3">
							<div class="col-6 font-weight-bold">SR제목 :</div>
							<div class="col-6">
								<input type="hidden" id="srNo" name="srNo"
									value="${srlist[0].srNo}"> <input type="text" id="ttl"
									value="${sd.ttl}" disabled>
							</div>
						</div>
						<div class="row my-3">
							<div class="col-6 font-weight-bold">요청기관 :</div>
							<div class="col-6">
								<input id="resourceInst" type="text" value="${sd.instNm}"
									disabled>
							</div>
						</div>
						<div class="row my-3">
							<div class="col-6 font-weight-bold">부서 :</div>
							<div class="col-6">
								<select id="addSrResourceModalDept">
									<c:forEach var="deptList" items="${deptList}">
										<option id="SRDept" value="${deptList.deptCd}">${deptList.deptNm}</option>
									</c:forEach>
								</select>
							</div>
						</div>
						<div class="row my-3">
							<div class="col-6 font-weight-bold">투입 인력 :</div>
							<div class="col-6">
								<select id="empId" name="empId" onchange="showSchedule()">

								</select>
							</div>
						</div>
						<div class="row my-3">
							<div class="col-6 font-weight-bold">역할 :</div>
							<div class="col-6">
								<select id="ptcptnRoleCd" name="ptcptnRoleCd"
									onclick="getPtcptnRoleCd()">
								</select>
							</div>
						</div>
						<div class="row my-3">
							<div class="col-6">
								<label for="schdlBgngYmd" class="font-weight-bold">투입
									시작일 : </label>
							</div>
							<div class="col-6">
								<input type="date" id="schdlBgngYmd" name="schdlBgngYmd">
							</div>
						</div>
						<div class="row my-3">
							<div class="col-6">
								<label for="schdlEndYmd" class="font-weight-bold">투입 종료일
									: </label>
							</div>
							<div class="col-6">
								<input type="date" id="schdlEndYmd" name="schdlEndYmd">
							</div>
						</div>
					</form>
				</div>
			</div>
			<div class= "row">
				<div id="scheduleTable" style="margin:10px 5px 5px 5px;width:100%; "></div>

			</div>
		</div>
		<div class="m_footer bg-light">

			<button id="addResourceBtn" onclick="addResource()"
				style="margin-right: 15px"
				class="btn btn-oti save center font-weight-bold"
				data-dismiss="modal">확인</button>
			<button id="modifyResourceBtn"
				style="display: none; margin-right: 15px" onclick="modifyResource()"
				class="btn btn-oti save center font-weight-bold"
				data-dismiss="modal">수정</button>

			<button class="btn btn-oti danger cancle font-weight-bold"
				data-dismiss="modal">닫기</button>

		</div>
	</div>

</div>
<!-- fullcalendar CDN -->
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/main.min.js'></script>
<!-- fullcalendar 언어 CDN -->
<script
	src='https://cdn.jsdelivr.net/npm/fullcalendar@5.8.0/locales-all.min.js'></script>

<script src="/resources/js/addSrResourcesModal.js"></script>