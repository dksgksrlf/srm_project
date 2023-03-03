<%@ page contentType="text/html; charset=UTF-8"%>
<%@ taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>
<%@taglib prefix="sec"
	uri="http://www.springframework.org/security/tags"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<nav class="pcoded-navbar">
	<div class="sidebar_toggle">
		<a href="#"><i class="icon-close icons"></i></a>
	</div>
	<div class="pcoded-inner-navbar main-menu">
		<div class="">
			<div class="main-menu-header">
				<img class="img-80 img-radius"
					src="${pageContext.request.contextPath}/resources/assets/images/avatar-4.jpg"
					alt="User-Profile-Image">
				<div class="user-details" style="color: white">
					<sec:authorize access="isAuthenticated()">
						<b><sec:authentication property="principal.flnm" /> 님</b>
					</sec:authorize>
				</div>
			</div>
		</div>


		<div class="pcoded-navigation-label mt-3"
			data-i18n="nav.category.navigation">MY PORTAL</div>
		<ul class="pcoded-item pcoded-left-item">
			<li class=""><a
				href="${pageContext.request.contextPath}/myportal"
				class="waves-effect waves-dark"> <span class="pcoded-micon"><i
						class="ti-home pt-1"></i><b>D</b></span> <span class="pcoded-mtext"
					data-i18n="nav.dash.main">나의 할 일</span> <span class="pcoded-mcaret"></span>
			</a></li>
		</ul>

		<div class="pcoded-navigation-label" style="font-weight: bold;"
			data-i18n="nav.category.forms">회원정보 관리</div>
		<ul class="pcoded-item pcoded-left-item">
			<li><a href="${pageContext.request.contextPath}/member/myinfo"
				class="waves-effect waves-dark"> <span class="pcoded-micon"><i
						class="ti-user pt-1"></i><b>FC</b></span> <span class="pcoded-mtext"
					data-i18n="nav.form-components.main">내 정보 관리</span> <span
					class="pcoded-mcaret"></span>
			</a></li>
			<sec:authorize access="hasRole('ROLE_CLIENT')">
				<li><a
					href="${pageContext.request.contextPath}/institution/detail"
					class="waves-effect waves-dark"> <span class="pcoded-micon"><i
							class="far fa-building pt-1"></i><b>FC</b></span> <span
						class="pcoded-mtext" data-i18n="nav.form-components.main">내
							기관 관리</span> <span class="pcoded-mcaret"></span>
				</a></li>
			</sec:authorize>
		</ul>

		<div class="pcoded-navigation-label" style="font-weight: bold;"
			data-i18n="nav.category.navigation">SR 관리</div>
		<ul class="pcoded-item pcoded-left-item">
			<sec:authorize access="hasRole('ROLE_CLIENT')">
				<li class="">" <a
					href="${pageContext.request.contextPath}/srdemand/list"
					class="waves-effect waves-dark"> <span class="pcoded-micon"><i
							class="far fa-file-alt pt-1"></i><b>D</b></span> <span
						class="pcoded-mtext" data-i18n="nav.dash.main">SR 요청 관리</span> <span
						class="pcoded-mcaret"></span>
				</a>
				</li>
			</sec:authorize>
			<sec:authorize access="hasRole('ROLE_ADMIN')">
				<li class=""><a
					href="${pageContext.request.contextPath}/admin/srdemand/list"
					class="waves-effect waves-dark"> <span class="pcoded-micon"><i
							class="far fa-file-alt pt-1"></i><b>D</b></span> <span
						class="pcoded-mtext" data-i18n="nav.dash.main">SR 요청 관리</span> <span
						class="pcoded-mcaret"></span>
				</a></li>
			</sec:authorize>
			<sec:authorize access="hasRole('ROLE_ADMIN') || hasRole('ROLE_DEVELOPER')">
				<li><a
					href="${pageContext.request.contextPath}/srinformation/list"
					class="waves-effect waves-dark"> <span class="pcoded-micon"><i
							class="fas fa-file-alt pt-1"></i><b>FC</b></span> <span
						class="pcoded-mtext" data-i18n="nav.form-components.main">SR 진척 관리</span> <span class="pcoded-mcaret"></span>
				</a></li>
			</sec:authorize>
		</ul>

		<div class="pcoded-navigation-label" style="font-weight: bold;"
			data-i18n="nav.category.forms">게시판</div>
		<ul class="pcoded-item pcoded-left-item">
			<li><a href="${pageContext.request.contextPath}/board/list"
				class="waves-effect waves-dark"> <span class="pcoded-micon"><i
						class="fas fa-bullhorn pt-1"></i><b>FC</b></span> <span
					class="pcoded-mtext" data-i18n="nav.form-components.main">공지사항</span>
					<span class="pcoded-mcaret"></span>
			</a></li>
			<li><a href="${pageContext.request.contextPath}/board/list"
				class="waves-effect waves-dark"> <span class="pcoded-micon"><i
						class="far fa-comments pt-1"></i><b>FC</b></span> <span
					class="pcoded-mtext" data-i18n="nav.form-components.main">QnA</span>
					<span class="pcoded-mcaret"></span>
			</a></li>
		</ul>

		<sec:authorize access="hasRole('ROLE_ADMIN')">
			<div class="pcoded-navigation-label" style="font-weight: bold;"
				data-i18n="nav.category.navigation">회원 관리</div>
			<ul class="pcoded-item pcoded-left-item">
				<li class=""><a
					href="${pageContext.request.contextPath}/admin/client/list"
					class="waves-effect waves-dark"> <span class="pcoded-micon"><i
							class="far fa-id-card pt-1"></i><b>D</b></span> <span
						class="pcoded-mtext" data-i18n="nav.dash.main">고객 관리</span> <span
						class="pcoded-mcaret"></span>
				</a></li>
				<li class=""><a
					href="${pageContext.request.contextPath}/admin/employee/list"
					class="waves-effect waves-dark"> <span class="pcoded-micon"><i
							class="fas fa-id-card pt-1"></i><b>D</b></span> <span
						class="pcoded-mtext" data-i18n="nav.dash.main">사원 관리</span> <span
						class="pcoded-mcaret"></span>
				</a></li>
				<li class=""><a
					href="${pageContext.request.contextPath}/admin/department/list"
					class="waves-effect waves-dark"> <span class="pcoded-micon"><i
							class="fas fa-sitemap pt-1"></i><b>FC</b></span> <span
						class="pcoded-mtext" data-i18n="nav.dash.main">부서 관리</span> <span
						class="pcoded-mcaret"></span>
				</a></li>
			</ul>
		</sec:authorize>
	</div>
</nav>