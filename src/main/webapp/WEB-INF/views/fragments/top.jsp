<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@ taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<script src="${pageContext.request.contextPath}/resources/js/alert.js"></script>
<sec:authorize access="isAuthenticated()">
	<script>
		$(function() {
			//세션스토리지에 값 검사 후 뷰에 제공
			console.log("타이머 시작");
			if (localStorage.getItem('logintime')) {
				var stime = localStorage.getItem('logintime');
				var myLoginTime = parseInt(stime, 10);
				var timer = setInterval(
						function() {
							if (parseInt(localStorage.getItem('logintime'), 10) > 0) {
								$("#loginTime").text(
										timeFormate(parseInt(localStorage
												.getItem('logintime'), 10)));
								localStorage
										.setItem('logintime', ""
												+ (parseInt(localStorage
														.getItem('logintime'),
														10) - 1));
							}
							 else {
								showOtiAlert();
								localStorage.removeItem('logintime');
							}

						}, 1000);

			} else {
				localStorage.removeItem('logintime');
				localStorage.setItem('logintime',
						"${pageContext.session.maxInactiveInterval}");
			}
		});

		//로그인 연장
		function resetLoginTime() {
			if (localStorage.getItem('logintime')) {
				console.log("로그인 연장 함");
				localStorage.setItem('logintime',
						"${pageContext.session.maxInactiveInterval}");
			} else
				localStorage.setItem('logintime',
						"${pageContext.session.maxInactiveInterval}");
		}

		//날짜 포맷
		function timeFormate(myNum) {
			var hours = Math.floor(myNum / 3600);
			var minutes = Math.floor((myNum - (hours * 3600)) / 60);
			var seconds = myNum - (hours * 3600) - (minutes * 60);

			if (hours < 10) {
				hours = "0" + hours;
			}
			if (minutes < 10) {
				minutes = "0" + minutes;
			}
			if (seconds < 10) {
				seconds = "0" + seconds;
			}
			return hours + ':' + minutes + ':' + seconds;
		}
	</script>
</sec:authorize>

<sec:authorize access="isAnonymous()">
	<script>
		localStorage.removeItem('logintime');
		$("#loginTime").html("<p>없음2</p>");
	</script>
</sec:authorize>
<script>
	//로그아웃
	function logOut() {
		console.log("로그아웃 실행");
		$.ajax({
			url : "${pageContext.request.contextPath}/logout",
			type : "POST",
			success : function(res) {
				localStorage.removeItem('logintime');
				localStorage.setItem('logintime',
						"${pageContext.session.maxInactiveInterval}");
				localStorage.removeItem('logintime');
				location.reload();
			}
		});
	}
</script>

<style>
#otiTabs .nav-item a {
	color: #4C1342;
	padding: 15px !important;
}

#otiTabs .nav-link {
	color: #4C1342;
	background-color: white !important;
}

#mes {
	background: linear-gradient(135deg, #F05F57 10%, #92344B 100%);
}
</style>

<jsp:include page="/WEB-INF/views/member/checkPw.jsp" />
<jsp:include page="/WEB-INF/views/fragments/otiAlert.jsp" />
<jsp:include page="/WEB-INF/views/alertModal/sraddAlert.jsp" />

<div id="pcoded" class="pcoded iscollapsed" theme-layout="vertical"
	vertical-placement="left" vertical-layout="wide"
	pcoded-device-type="phone" vertical-nav-type="offcanvas"
	vertical-effect="overlay" vnavigation-view="view1" nav-type="st2"
	fream-type="theme1" sidebar-img="false" sidebar-img-type="img1"
	layout-type="light">

	<div class="pcoded-container navbar-wrapper">

		<nav class="navbar header-navbar pcoded-header iscollapsed"
			header-theme="theme1" pcoded-header-position="fixed">
			<div class="navbar-wrapper">
				<div class="navbar-logo">
					<a href="/"> <img class="img-fluid"
						src="${pageContext.request.contextPath}/resources/assets/images/otilogo.png"
						alt="Theme-Logo" style="margin-left: 7px;" />
					</a> <a class="mobile-options waves-effect waves-light"> <i
						class="ti-more"></i>
					</a>
				</div>

				<div class="navbar-container container-fluid">
					<ul class="nav-left">
						<li>
							<div class="sidebar_toggle">
								<a href="javascript:void(0)"><i class="ti-menu"></i></a>
							</div>
						</li>

						<li class="header-mobile-menu" style="margin-top: 20px"><a
							class="mobile-menu waves-effect waves-light" id="mobile-collapse"
							href="#!"> <i class="ti-menu"></i></a></li>

						<li class="header-fullscreen" style="margin-top: 20px"><a
							href="#!" onclick="javascript:toggleFullScreen()"
							class="waves-effect waves-light"> <i class="ti-fullscreen"></i>
						</a></li>
						<li style="color: white;">
							<div id="serverTime"></div>
							<div id="sessionExpiry"></div>
						</li>
					</ul>
					<ul class="nav-left" style="margin-left: 350px;">
						<li
							style="color: white; margin: auto; justify-content: center; font-weight: bold; font-size: 20px;">
							세션 만료시간 <span id="loginTime" style="margin-left: 3px;"></span>
						</li>
					</ul>
					<ul class="nav-left">
						<li><button class="btn btn-sm btn-oti"
								style="font-size: 20px; background-color: #92344B; margin-top: 20px; padding: 5px; border-color: white; border-width: 2;"
								onclick="resetLoginTime()">로그인 시간 연장</button></li>
					</ul>
					<ul class="nav-right">
						<%-- 알림 --%>
						<li class="header-notification" style="margin-top: 20px"><span
							id="alertBadge" class="badge bg-c-yellow" style="width: 15px; height: 15px;"></span> <a
							href="#!" id="alertBtn" class="waves-effect waves-light"
							onclick="getAlertList();event.preventDefault();"
							style="display: block; padding-right: 4px"> <i
								class="far fa-bell" style="font-size: 30px;"></i>
						</a>

							<div class="show-notification" onclick='event.stopPropagation()'
								style="display: none; width: 600px;">
								<ul>
									<li style="color: white;" id="mes">
										<h6>알림 메시지</h6>
									</li>
								</ul>
								<!-- Nav tabs -->
								<ul class="nav nav-tabs md-tabs" id="otiTabs" role="tablist"
									style="width: 100%; margin: 0px">
									<sec:authorize access="hasRole('ROLE_CLIENT')">
										<li class="nav-item" style="padding: 0px"><a
											class="nav-link active" style="font-size: 15px; font-weight: bold;"
											data-toggle="tab" href="#rfltTab" role="tab">반영요청</a>
											<div class="slide"></div></li>
										<li class="nav-item" style="padding: 0px"><a
											class="nav-link" style="font-size: 13px; font-weight: bold;" data-toggle="tab"
											href="#chgDmndTab" role="tab">완료요청일 변경</a>
											<div class="slide"></div></li>
										<li class="nav-item" style="padding: 0px"><a
											class="nav-link" style="font-size: 15px;" data-toggle="tab"
											href="#cancleTab" role="tab">개발취소</a>
											<div class="slide"></div></li>
									</sec:authorize>
									<sec:authorize access="hasRole('ROLE_DEVELOPER')">
										<li class="nav-item" style="padding: 0px"><a
											class="nav-link active" style="font-size: 15px; font-weight: bold;"
											data-toggle="tab" href="#rfltTab" role="tab">반영요청</a>
											<div class="slide"></div></li>
										<li class="nav-item" style="padding: 0px"><a
											class="nav-link" style="font-size: 15px; font-weight: bold;" data-toggle="tab"
											href="#developerTab" role="tab">완료요청일 변경</a>
											<div class="slide"></div></li>
									</sec:authorize>
									<sec:authorize access="hasRole('ROLE_ADMIN')">
										<li class="nav-item" style="padding: 0px"><a
											class="nav-link active" style="font-size: 15px; font-weight: bold;"
											data-toggle="tab" href="#rfltTab" role="tab">반영요청</a>
											<div class="slide"></div></li>
										<li class="nav-item" style="padding: 0px"><a
											class="nav-link" style="font-size: 15px; font-weight: bold;" data-toggle="tab"
											href="#chgDmndTab" role="tab">완료요청일 변경</a>
											<div class="slide"></div></li>
										<li class="nav-item" style="padding: 0px"><a
											class="nav-link" style="font-size: 15px; font-weight: bold;" data-toggle="tab"
											href="#developerTab" role="tab">완료요청일 변경(from Dev)</a>
											<div class="slide"></div></li>
										<li class="nav-item" style="padding: 0px"><a
											class="nav-link" style="font-size: 15px; font-weight: bold;" data-toggle="tab"
											href="#cancleTab" role="tab">개발취소</a>
											<div class="slide"></div></li>
									</sec:authorize>
								</ul>
								<div id="alertTab" class="tab-content card-block ">
									<!-- 반영 요청 알림 -->
									<div class="tab-pane active" id="rfltTab" role="tabpanel">
										<ul>
										</ul>
									</div>
									<%-- 요청일 변경 알림 --%>
									<div class="tab-pane" id="chgDmndTab" role="tabpanel">
										<ul>

										</ul>
									</div>
									<%-- 요청일 변경 알림 --%>
									<div class="tab-pane" id="developerTab" role="tabpanel">
										<ul>

										</ul>
									</div>
									<%-- 개발취소알림 --%>
									<div class="tab-pane" id="cancleTab" role="tabpanel">
										<ul>

										</ul>
									</div>
								</div>
							</div></li>

						<%-- 로그아웃 --%>
						<li class="user-profile header-notification"><sec:authorize
								access="isAuthenticated()">
								<li class="waves-effect waves-light">
									<button class="btn btn-sm btn-oti" onclick="logOut()"
										style="margin-top: 14px; margin-left: 5px; font-size:15px; border-width: 2; background-color: #4C1342;"
										type="button">로그아웃</button>
								</li>
							</sec:authorize></li>
					</ul>
				</div>
			</div>
		</nav>