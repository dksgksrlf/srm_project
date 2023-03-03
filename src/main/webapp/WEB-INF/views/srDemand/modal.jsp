<%@page contentType="text/html; charset=UTF-8"%>

<%-- 작성자 : 여수한 / 작성 날짜 : 2023-02-17 --%>
<%-- 상세, 등록, 수정 --%>
<script src="/resources/js/srDemand.js"></script>
<script>
	$(document).on('click', '#addbtn', function(e) {
		console.log("userSrDemandList  요청 등록")
<%--  작성자의 기본 정보 세팅 --%>
	writerBase();
<%-- sr 요청 작성시, 모든 시스템 데이터 드롭다운에 표시하기 위함--%>
	setSystems();
		$('#addmodal').addClass('show');
		document.body.style = `overflow: hidden`;
	});

	/* 요청 모달 닫기 */
	$(document).on('click', '#closebtn', function(e) {
		console.log("click event");
		$('#addmodal').removeClass('show');
		document.body.style = `overflow: scroll`;
	});

	$(document).on('click', '#closebtn', function(e) {
		console.log("click event");
		$('#modmodal').removeClass('show');
		document.body.style = `overflow: scroll`;
	});
	/* 개발 등록 */
	$(document).on('click', '#devbtn', function(e) {
		console.log("click event");
		$('#devmodal').addClass('show');
		document.body.style = `overflow: hidden`;

	});
	$(document).on('click', '#closebtn', function(e) {
		console.log("click event");
		$('#devmodal').removeClass('show');
		document.body.style = `overflow: scroll`;
	});
</script>
<style>
.ui-datepicker-trigger {
	width: 29px;
	vertical-align: top;
}

#addDatepicker, #addEndRequestDatepicker, #modDatepicker,
	#modEndRequestDatepicker, #devDatepicker {
	width: 90px;
}

.col-sm-4 {
	padding: 0px;
}

.modal {
	position: block;
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
	<!-- *********************************** [ modal start ] ***********************************-->
	<!-- *********************************** [ SR 요청 등록 ] ***********************************-->
	<div class="modal" id="addmodal">
		<div class="modal_body">
			<div class="m_head">
				<div class="modal_title" style="color: white;">SR 요청 등록</div>
			</div>
			<div class="m_body">
				<form action="/srdemand/add" method="post" id="srRequest">
					<div class="form-group row">
						<div class="col-sm-6">
							<div class="col col-sm-4">등록자</div>
							<div class="col col-sm-6" id="writerName"></div>
							<input type="hidden" name="custId" id="custId">
						</div>
						<div class="col-sm-6">
							<div class="col col-sm-4">소속</div>
							<div class="col col-sm-6" id="instName"></div>
						</div>
					</div>
					<div class="form-group row">
						<div class="col-sm-6">
							<div class="col col-sm-4">시스템구분</div>
							<div class="col col-sm-6">
								<div class="dropdown dropdown open">
									<select name="sysCd" class="srSystems"
										onchange="changeSystem(this.value)">
									</select>
								</div>
							</div>
						</div>
						<div class="col-sm-6">
							<div class="col col-sm-4">업무구분</div>
							<div class="col col-sm-6">
								<div class="dropdown dropdown open">
									<select name="taskSeCd" class="sysTask">
									</select>
								</div>
							</div>
						</div>
					</div>
					<hr />
					<div class="form-group row">
						<div class="col col-sm-2">SR 제목</div>
						<div class="col col-sm-9">
							<input type="text" class="form-control" name="ttl">
						</div>
					</div>
					<div class="form-group row">
						<div class="col col-sm-2">관련 근거</div>
						<div class="col col-sm-9">
							<input type="text" class="form-control" name="relGrund">
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-2 col-form-label" style="line-height: 120px">SR
							내용</label>
						<div class="col-sm-9">
							<textarea rows="5" cols="5" class="form-control" name="cn"></textarea>
						</div>
					</div>
					<div class="form-group row">
						<label class="col-sm-2 col-form-label">첨부파일</label>
						<div class="col-sm-9">
							<input type="file" class="">
						</div>
					</div>
					<div class="form-group row">
						<div class="col-sm-6">
							<div class="col col-sm-4">완료 요청일</div>
							<div class="col col-sm-6">
								<input type="date" id="addEndRequestDatepicker"
									name="cmptnDmndYmd">
							</div>
						</div>
					</div>
				</form>
			</div>
			<div class="m_footer">
				<button type="submit" class="modal_btn save center" form="srRequest">등록</button>
				<div class="modal_btn danger cancle" id="closebtn">닫기</div>
			</div>
		</div>

	</div>
	<!-- *********************************** [ SR 개발 등록 ] *********************************** -->
	<div class="modal" id="devmodal">
		<div class="modal_devbody" style="overflow: auto;">
			<div class="m_devhead">
				<div class="modal_title" style="color: white;">SR 개발 등록</div>
			</div>
			<div class="m_devbody">
				<div class="form-group row">
					<div class="col-sm-6">
						<div class="col col-sm-4">등록자</div>
						<div class="col col-sm-6">
							<input type="text" class="form-control">
						</div>
					</div>
					<div class="col-sm-6">
						<div class="col col-sm-4">소속</div>
						<div class="col col-sm-6">
							<input type="text" class="form-control">
						</div>
					</div>
				</div>
				<div class="form-group row">
					<div class="col-sm-6">
						<div class="col col-sm-4">등록일</div>
						<div class="col col-sm-6">
							<input type="date" class="form-control">
						</div>
					</div>
					<div class="col-sm-6">
						<div class="col col-sm-4">관련 시스템</div>
						<div class="col col-sm-6">
							<div class="dropdown dropdown open">
								<form action="#">
									<select name="languages" id="lang">
										<option value="워크넷">시스템1</option>
										<option value="굴국밥">시스템2</option>
										<option value="고소미">시스템3</option>
									</select>
								</form>
							</div>
						</div>
					</div>
				</div>
				<hr />
				<div class="form-group row">
					<div class="col-sm-6">
						<div class="col col-sm-4">개발 담당자</div>
						<div class="col col-sm-6">
							<input type="text" class="form-control">
						</div>
					</div>
					<div class="col-sm-6">
						<div class="col col-sm-4">개발 부서</div>
						<div class="col col-sm-6">
							<input type="text" class="form-control">
						</div>
					</div>
				</div>
				<div class="form-group row">
					<div class="col-sm-6">
						<div class="col col-sm-4">진행 상태</div>
						<div class="col col-sm-6">
							<div class="dropdown dropdown open">
								<form action="#">
									<select name="languages" id="lang">
										<option value="요청">요청</option>
										<option value="반려">반려</option>
										<option value="접수">접수</option>
										<option value="개발중">개발중</option>
										<option value="테스트">테스트</option>
										<option value="개발완료">개발완료</option>
									</select>
								</form>
							</div>
						</div>
					</div>
					<div class="col-sm-6">
						<div class="col col-sm-4">완료(예정)일</div>
						<div class="col col-sm-6">
							<input type="date" id="devDatepicker">
						</div>
					</div>
				</div>

				<div class="form-group row">
					<div class="col-sm-6">
						<div class="col col-sm-4">관련 부서</div>
						<div class="col col-sm-6">
							<input type="text" class="form-control">
						</div>
					</div>
					<div class="col-sm-6">
						<div class="col col-sm-4">우선 순위</div>
						<div class="col col-sm-6">
							<div class="dropdown dropdown open">
								<form action="#">
									<select name="languages" id="lang">
										<option value="상">상</option>
										<option value="중">중</option>
										<option value="하">하</option>
									</select>
								</form>
							</div>
						</div>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label" style="line-height: 120px">검토
						내용</label>
					<div class="col-sm-9">
						<textarea rows="5" cols="5" class="form-control"></textarea>
					</div>
				</div>
				<hr />
				<div class="form-group row">
					<div class="col col-sm-2">SR 제목</div>
					<div class="col col-sm-9">
						<input type="text" class="form-control">
					</div>
				</div>
				<div class="form-group row">
					<div class="col col-sm-2">관련 근거</div>
					<div class="col col-sm-9">
						<input type="text" class="form-control">
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label" style="line-height: 120px">SR
						내용</label>
					<div class="col-sm-9">
						<textarea rows="5" cols="5" class="form-control"></textarea>
					</div>
				</div>
				<div class="form-group row">
					<label class="col-sm-2 col-form-label">첨부파일</label>
					<div class="col-sm-9">
						<input type="file" class="">
					</div>
				</div>
				<div class="form-group row">
					<div class="col-sm-6">
						<div class="col col-sm-4">완료 요청일</div>
						<div class="col col-sm-6">
							<input type="date" class="form-control">
						</div>
					</div>
				</div>
			</div>
			<div class="m_footer">
				<div class="modal_btn save center" id="savebtn">저장</div>
				<div class="modal_btn danger cancle" id="closebtn">닫기</div>
			</div>
		</div>
	</div>