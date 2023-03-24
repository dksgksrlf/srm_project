<%-- 작성자 : 신정은 작성날짜 : 2023-02-20 --%>
<%-- 작성자 : 최은종 작성날짜 : 2023-03-10 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@taglib prefix="sec"
   uri="http://www.springframework.org/security/tags"%>
<%@taglib prefix="form" uri="http://www.springframework.org/tags/form"%>

<html>
<head>
<%@include file="/WEB-INF/views/fragments/header.jsp"%>
<script
   src="${pageContext.request.contextPath}/resources/js/rememberId.js"></script>
<script>
   
</script>
<style>
.modal-header {
   background-color: linear-gradient(135deg, #92344B 10%, #F05F57 100%);
   color: white;
}
</style>
</head>
<body themebg-pattern="theme1">
   <!-- Pre-loader start -->
   <div class="theme-loader">
      <div class="loader-track">
         <div class="preloader-wrapper">
            <div class="spinner-layer spinner-blue">
               <div class="circle-clipper left">
                  <div class="circle"></div>
               </div>
               <div class="gap-patch">
                  <div class="circle"></div>
               </div>
               <div class="circle-clipper right">
                  <div class="circle"></div>
               </div>
            </div>
            <div class="spinner-layer spinner-red">
               <div class="circle-clipper left">
                  <div class="circle"></div>
               </div>
               <div class="gap-patch">
                  <div class="circle"></div>
               </div>
               <div class="circle-clipper right">
                  <div class="circle"></div>
               </div>
            </div>

            <div class="spinner-layer spinner-yellow">
               <div class="circle-clipper left">
                  <div class="circle"></div>
               </div>
               <div class="gap-patch">
                  <div class="circle"></div>
               </div>
               <div class="circle-clipper right">
                  <div class="circle"></div>
               </div>
            </div>

            <div class="spinner-layer spinner-green">
               <div class="circle-clipper left">
                  <div class="circle"></div>
               </div>
               <div class="gap-patch">
                  <div class="circle"></div>
               </div>
               <div class="circle-clipper right">
                  <div class="circle"></div>
               </div>
            </div>
         </div>
      </div>
   </div>
   <!-- Pre-loader end -->

   <section class="login-block">
      <!-- Container-fluid starts -->
      <div class="container">
         <div class="row">
            <div class="col-sm-12">
               <!-- 로그인 및 아이디 저장 기능 구현 (최은종) -->
               <form:form class="md-float-material form-material" id="loginForm"
                  action="/login" method="post">
                  <div class="text-center"></div>
                  <div class="auth-box card">
                     <div class="card-block">
                        <div class="row m-b-20">
                           <div class="col-md-12">
                              <h3 class="text-center">로그인</h3>
                           </div>
                        </div>
                        <div class="form-group form-primary">
                           <input type="text" id="memberId" name="memberId"
                              class="form-control" required=""> <span
                              class="form-bar"></span> <label class="float-label">아이디</label>
                        </div>
                        <div class="form-group form-primary">
                           <input type="password" name="pswd" class="form-control"
                              required=""> <span class="form-bar"></span> <label
                              class="float-label">비밀번호</label>
                        </div>
                        <div class="row m-t-25 text-left">
                           <div class="col-12">
                              <div class="checkbox-fade fade-in-primary d-">
                                 <label> <input type="checkbox" id="checkId"
                                    value="true"> <span class="cr"><i
                                       class="cr-icon icofont icofont-ui-check txt-primary"></i></span> <span
                                    class="text-inverse">아이디 저장</span>
                                 </label>
                              </div>
               </form:form>

               <!-- 비밀번호 찾기 -->
               <div class="forgot-phone text-right f-right mb-4">
                  <a class="text-right f-w-600" data-toggle="modal"
                     data-target="#findPwModal">비밀번호 찾기</a>
               </div>
            </div>
         </div>
         <div class="row">
            <div class="col-md-12">
               <button type="submit" form="loginForm"
                  class="btn btn-oti btn-md btn-block waves-effect waves-light text-center m-b-20">로그인</button>
            </div>
         </div>
         <div class="row">
            <div class="col-md-6">
               <button type="button" onclick="location.href='/join-client' "
                  class="btn btn-oti btn-md btn-block waves-effect waves-light text-center m-b-20">회원가입
                  (고객용)</button>
            </div>
            <div class="col-md-6">
               <button type="button" onclick="location.href='/join-employee' "
                  class="btn btn-oti btn-md btn-block waves-effect waves-light text-center m-b-20">회원가입
                  (사원용)</button>
            </div>
         </div>
          <div class="row">
            <div class="col-md-6">
               <a href="/google/login">
	                <img width="180px;"
	                  src="${pageContext.request.contextPath}/resources/oti_images/google.png"
	                  alt="small-logo.png">
                  </a>
            </div>
         </div> 
         <hr />
         <div class="row">
            <div class="col-md-10">
               <p class="text-inverse text-left m-b-0"></p>
            </div>
            <div class="col-md-12" align="center">
               <img
                  src="${pageContext.request.contextPath}/resources/assets/images/auth/Logo-small-bottom.png"
                  alt="small-logo.png">
            </div>
         </div>
      </div>
   </section>
   <%@include file="/WEB-INF/views/fragments/bottom.jsp"%>
   <%-- 모달 --%>
   <%@include file="/WEB-INF/views/alertModal/sraddAlert.jsp"%>
   <%@include file="/WEB-INF/views/member/findPwModal.jsp"%>
</body>
</html>