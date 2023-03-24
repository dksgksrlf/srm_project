<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@ taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>
<style>
.pcoded-mtext, i {
	color: white;
}

.profile_wrapper {
	float: left;
	width: 100px;
	/*height: 100px;*/
	margin: 0 15px 0 75px;
	position: relative;
}

.gradation_animate {
	position: absolute;
	top: -5px;
	left: 0px;
	width: 100px;
	height: 100px;
	border-radius: 50%;
	background:
		url(https://k.kakaocdn.net/dn/BQFZF/btqzu7xZvy9/p3qATq2IbK4edXbUm76pTK/img.png)
		no-repeat;
	animation: spin 1s linear infinite;
}

.image_wrapper {
	/* position: relative; */
	overflow: hidden;
	width: 94px;
	height: 94px;
	border-radius: 50%;
	/* top: 3px;
	left: 3px; */
	margin: auto;
}
</style>

<div class="pcoded-main-container" style="margin-top: 0px">
	<div class="pcoded-wrapper">
		<nav class="pcoded-navbar" navbar-theme="themelight1"
			active-item-theme="theme1" sub-item-theme="theme2"
			active-item-style="style0" pcoded-navbar-position="fixed">
			<div class="sidebar_toggle">
				<a href="#"><i class="icon-close icons"></i></a>
			</div>
			<div
				class="pcoded-inner-navbar main-menu mCustomScrollbar _mCS_1 mCS_no_scrollbar"
				style="height: calc(100% - 56px); background-color: #4C1342">
				<div id="mCSB_1"
					class="mCustomScrollBox mCS-light mCSB_vertical_horizontal mCSB_inside"
					style="max-height: none;" tabindex="0">
					<div class="main-menu-header row mr-0" style="padding-bottom:0px;">
						<div class="profile_wrapper row mr-0 pr-0">
							<div class="gradation_animate"></div>
							<div class="image_wrapper">
								<sec:authentication property="principal.picture" var="picture" />
								<c:if test="${picture eq null}">
									<img class="img-80 img-radius" style="width: 90px"
									src="${pageContext.request.contextPath}/member/profile/<sec:authentication property='principal.username'/>">
								</c:if>
								<c:if test="${picture ne null}">
									<img class="img-80 img-radius" style="width: 90px"
										src="<sec:authentication property='principal.picture'/>">
								</c:if> 
							</div>
						</div>
						<div class="user-details col-12 row"
							style="color: #F2EBE5;">
							<div align="center" class="text-center">
								<sec:authorize access="hasRole('ROLE_ADMIN')">
									<label class="badge badge-oti font-weight-bold"style="position: static;font-size:15px;">관리자</label>
								</sec:authorize>
								<sec:authorize access="hasRole('ROLE_DEVELOPER')">
									<label class="badge badge-oti" style="position: static;">개발자</label>
								</sec:authorize>
								<sec:authorize access="hasRole('ROLE_CLIENT')">
									<label class="badge badge-oti" style="position: static;">고객</label>
								</sec:authorize>

								<sec:authorize access="isAuthenticated()">
									<b class="font-weight-bold" style="font-size:20px;"><sec:authentication property="principal.flnm" /> 님</b>
								</sec:authorize>
							</div>
						</div>
					</div>
					<div class="pcoded-navigation-label " style="font-size:20px;font-weight: bold;"
						data-i18n="nav.category.navigation" menu-title-theme="theme1">MY
						PORTAL</div>
					<ul class="pcoded-item pcoded-left-item" item-border="true"
						item-border-style="none" subitem-border="true">
						<li class=""><a
							href="${pageContext.request.contextPath}/myportal"
							class="waves-effect waves-dark"> <span class="pcoded-micon"><i
									class="ti-home pt-1"></i><b>D</b></span> <span class="pcoded-mtext font-weight-bold" style="font-size:15px;"
								data-i18n="nav.dash.main">나의 할 일</span> <span
								class="pcoded-mcaret"></span>
						</a></li>
					</ul>
					<div class="pcoded-navigation-label " style="font-size:20px;font-weight: bold;"
						data-i18n="nav.category.forms" menu-title-theme="theme1">회원정보
						관리</div>
					<ul class="pcoded-item pcoded-left-item" item-border="true"
						item-border-style="none" subitem-border="true">
						<li class=""><a
							href="${pageContext.request.contextPath}/member/myinfo"
							class="waves-effect waves-dark"> <span class="pcoded-micon"><i
									class="ti-user pt-1"></i><b>FC</b></span> <span class="pcoded-mtext font-weight-bold" style="font-size:15px;"
								data-i18n="nav.form-components.main">내 정보 관리</span> <span
								class="pcoded-mcaret"></span>
						</a></li>
					</ul>
					<div class="pcoded-navigation-label " style="font-size:20px;font-weight: bold;"
						data-i18n="nav.category.navigation" menu-title-theme="theme1">SR
						관리</div>
					<ul class="pcoded-item pcoded-left-item" item-border="true"
						item-border-style="none" subitem-border="true">
						<sec:authorize access="hasRole('ROLE_CLIENT')">
							<li class=""><a
								href="${pageContext.request.contextPath}/srdemand/list"
								class="waves-effect waves-dark"> <span class="pcoded-micon"><i
										class="far fa-file-alt pt-1"></i><b>D</b></span> <span
									class="pcoded-mtext font-weight-bold" style="font-size:15px;" data-i18n="nav.dash.main">SR 요청 관리</span>
									<span class="pcoded-mcaret"></span>
							</a></li>
						</sec:authorize>
						<sec:authorize access="hasRole('ROLE_ADMIN')">
							<li class=""><a
								href="${pageContext.request.contextPath}/admin/srdemand/list"
								class="waves-effect waves-dark"> <span class="pcoded-micon"><i
										class="far fa-file-alt pt-1"></i><b>D</b></span> <span
									class="pcoded-mtext font-weight-bold" style="font-size:15px;"data-i18n="nav.dash.main">SR 요청 관리</span>
									<span class="pcoded-mcaret"></span>
							</a></li>
						</sec:authorize>
						<sec:authorize
							access="hasRole('ROLE_ADMIN') || hasRole('ROLE_DEVELOPER')">
							<li class=""><a
								href="${pageContext.request.contextPath}/srinformation/list"
								class="waves-effect waves-dark"> <span class="pcoded-micon"><i
										class="fas fa-file-alt pt-1"></i><b>FC</b></span> <span
									class="pcoded-mtext font-weight-bold" style="font-size:15px;" data-i18n="nav.form-components.main">SR
										진척 관리</span> <span class="pcoded-mcaret"></span>
							</a></li>
						</sec:authorize>
					</ul>
					<div class="pcoded-navigation-label " style="font-size:20px;font-weight: bold;" style="font-weight: bold;"
						data-i18n="nav.category.forms" menu-title-theme="theme1">게시판</div>
					<ul class="pcoded-item pcoded-left-item" item-border="true"
						item-border-style="none" subitem-border="true">
						<li class=""><a
							href="${pageContext.request.contextPath}/board/list?type=notice"
							class="waves-effect waves-dark"> <span class="pcoded-micon"><i
									class="fas fa-bullhorn pt-1"></i><b>FC</b></span> <span
								class="pcoded-mtext font-weight-bold" style="font-size:15px;" data-i18n="nav.form-components.main">공지사항</span>
								<span class="pcoded-mcaret"></span>
						</a></li>
						<li class=""><a
							href="${pageContext.request.contextPath}/board/list?type=qna"
							class="waves-effect waves-dark"> <span class="pcoded-micon"><i
									class="far fa-comments pt-1"></i><b>FC</b></span> <span
								class="pcoded-mtext font-weight-bold" style="font-size:15px;" data-i18n="nav.form-components.main">문의사항</span>
								<span class="pcoded-mcaret"></span>
						</a></li>
					</ul>
					<sec:authorize access="hasRole('ROLE_ADMIN')">
						<div class="pcoded-navigation-label" style="font-size:20px;font-weight: bold;"
							data-i18n="nav.category.navigation" menu-title-theme="theme1">회원
							관리</div>
						<ul class="pcoded-item pcoded-left-item" item-border="true"
							item-border-style="none" subitem-border="true">
							<li class=""><a
								href="${pageContext.request.contextPath}/admin/client/list"
								class="waves-effect waves-dark"> <span class="pcoded-micon"><i
										class="far fa-id-card pt-1"></i><b>D</b></span> <span
									class="pcoded-mtext font-weight-bold" style="font-size:15px;" data-i18n="nav.dash.main">고객 관리</span> <span
									class="pcoded-mcaret"></span>
							</a></li>
							<li class=""><a
								href="${pageContext.request.contextPath}/admin/employee/list"
								class="waves-effect waves-dark"> <span class="pcoded-micon"><i
										class="fas fa-id-card pt-1"></i><b>D</b></span> <span
									class="pcoded-mtext font-weight-bold" style="font-size:15px;" data-i18n="nav.dash.main">사원 관리</span> <span
									class="pcoded-mcaret"></span>
							</a></li>
							<li class=""><a
								href="${pageContext.request.contextPath}/admin/department/list"
								class="waves-effect waves-dark"> <span class="pcoded-micon"><i
										class="fas fa-sitemap pt-1"></i><b>FC</b></span> <span
									class="pcoded-mtext font-weight-bold" style="font-size:15px;" data-i18n="nav.dash.main">부서 관리</span> <span
									class="pcoded-mcaret"></span>
							</a></li>
						</ul>
					</sec:authorize>
				</div>
			</div>
		</nav>
		<div class="pcoded-content">

			<div class="pcoded-inner-content">
				<!-- Main-body start -->
				<div class="main-body">
					<div class="page-wrapper">