<%-- 작성자 : 신정은
   작성날짜 : 2023-02-20 --%>
<%@ page language="java" contentType="text/html; charset=UTF-8"
   pageEncoding="UTF-8"%>
<%@ taglib prefix="fn" uri="http://java.sun.com/jsp/jstl/functions"%>
<%@ taglib prefix="sec"
   uri="http://www.springframework.org/security/tags"%>
<html>
<head>
<%@include file="/WEB-INF/views/fragments/header.jsp"%>
<link rel="stylesheet" type="text/css"
   href="${pageContext.request.contextPath}/resources/css/srButton.css">
<link rel="stylesheet" type="text/css"
   href="${pageContext.request.contextPath}/resources/css/pagination.css">
<script src="${pageContext.request.contextPath}/resources/js/mytodo.js"></script>
<script
   src="${pageContext.request.contextPath}/resources/js/mytodoHstry.js"></script>
<sec:authorize access="hasRole('ROLE_ADMIN')">
   <script src="${pageContext.request.contextPath}/resources/js/graph.js"></script>
</sec:authorize>
<sec:authorize access="hasRole('ROLE_DEVELOPER')">
   <script src="${pageContext.request.contextPath}/resources/js/devCal.js"></script>
</sec:authorize>

<script
   src="https://cdnjs.cloudflare.com/ajax/libs/Chart.js/2.9.3/Chart.min.js"></script>

<script
   src="https://cdn.jsdelivr.net/npm/chart.js@2.9.4/dist/Chart.min.js"></script>
<script
   src="https://cdn.jsdelivr.net/gh/emn178/chartjs-plugin-labels/src/chartjs-plugin-labels.js"></script>
<script>
   document.addEventListener("DOMContentLoaded", function() {
      var ctx = $('#myChart');
      $.ajax({
         url : "/client/chart",
         type : "GET",
         success : function(res) {
            console.log(res[0]);
            var myChart = new Chart(ctx, {
               type : 'pie',
               data : {
                  labels : [ '요청', '반려', '접수', '개발중', '테스트', '개발완료',
                        '개발취소' ],
                  datasets : [ {
                     label : '# of Votes',
                     data : [ res[0], res[1], res[2], res[3], res[4],
                           res[5], res[6] ],
                     backgroundColor : [ 'rgba(255, 99, 132, 0.2)',
                           'rgba(54, 162, 235, 0.2)',
                           'rgba(255, 206, 86, 0.2)',
                           'rgba(75, 192, 192, 0.2)',
                           'rgba(153, 102, 255, 0.2)',
                           'rgba(255, 159, 64, 0.2)' ],
                     borderColor : [ 'rgba(255, 99, 132, 1)',
                           'rgba(54, 162, 235, 1)',
                           'rgba(255, 206, 86, 1)',
                           'rgba(75, 192, 192, 1)',
                           'rgba(153, 102, 255, 1)',
                           'rgba(255, 159, 64, 1)' ],
                     borderWidth : 1
                  } ]
               },
               options : {
                  scales : {
                     yAxes : [ {
                        ticks : {
                           beginAtZero : true
                        }
                     } ]
                  }
               }
            });
         }
      });
   });
</script>



<script
   src="${pageContext.request.contextPath}/resources/calendar/packages/daygrid/main.js'/>"></script>
<script
   src="${pageContext.request.contextPath}/resources/calendar/js/main.js'/>"></script>
<script
   src='https://cdn.jsdelivr.net/npm/fullcalendar@6.1.4/index.global.min.js'></script>

<!-- 모달 -->
<link rel="stylesheet" type="text/css"
   href="${pageContext.request.contextPath}/resources/css/srModal.css">
<style type="text/css">
.btn {
   padding: 3px;
}

.badge {
   padding: 5px 8px;
   font-size:15px;
}

.card .card-header {
   background: linear-gradient(135deg, #93344b 10%, #6b2146 100%);
}

.card .card-body table td, .card-block table td, table td {
   font-size: 13px;
}

.card .card-body table th, .card-block table th, table th {
   font-size: 14px;
}
</style>
</head>

<body>
   <%@include file="/WEB-INF/views/fragments/top.jsp"%>
   <%@include file="/WEB-INF/views/fragments/sidebar.jsp"%>
   <!-- Page-body start -->
   <div class="page-body">
      <div class="row">
         <!-- Color Open Accordion start -->
         <div class="col-lg-12">
            <div class="card" id="mytodo">
               <div class="col-12">
                  <!-- Nav tabs -->
                  <ul class="nav card-header-pills nav-tabs md-tabs" role="tablist">
                     <sec:authorize access="hasRole('ROLE_ADMIN')">
                        <li class="nav-item btn"><div
                              class="nav-link sttsCd0 active font-weight-bold" style="font-size:20px;" onclick="moveTab(0)">
                              요청<span class="badge badge-otidanger"style="font-size:15px;">${atotal}</span>
                           </div>
                           <div class="slide"></div></li>
                        <li class="nav-item btn"><div class="nav-link sttsCd1 font-weight-bold" style="font-size:20px;"
                              onclick="moveTab(1)">
                              반려 <span class="badge badge-otitodo"style="font-size:15px;">${rejTotal}</span>
                           </div>
                           <div class="slide"></div></li>
                        <li class="nav-item btn"><div class="nav-link sttsCd2 font-weight-bold" style="font-size:20px;"
                              onclick="moveTab(2)">
                              접수 <span class="badge badge-otitodo"style="font-size:15px;">${rtotal}</span>
                           </div>
                           <div class="slide"></div></li>
                        <li class="nav-item btn ">
                           <div class="nav-link sttsCd3 font-weight-bold" style="font-size:20px;" onclick="moveTab(3)">
                              개발 중 <span class="badge badge-otitodo"style="font-size:15px;">${dtotal}</span>
                           </div>
                           <div class="slide"></div>
                        </li>
                     </sec:authorize>
                     <sec:authorize access="hasRole('ROLE_DEVELOPER')">
                        <li class="nav-item btn active">
                           <div class="nav-link sttsCd3 active font-weight-bold" style="font-size:20px;" onclick="moveTab(3)">
                              개발 중 <span class="badge badge-danger"style="font-size:15px;">${dtotal}</span>
                           </div>
                           <div class="slide"></div>
                        </li>
                     </sec:authorize>

                     <sec:authorize access="hasRole('ROLE_CLIENT')">
                        <li class="nav-item btn"><div class="nav-link sttsCd0 font-weight-bold" style="font-size:20px;"
                              onclick="moveTab(0)">
                              요청<span class="badge badge-otitodo" style="font-size:15px;">${atotal}</span>
                           </div>
                           <div class="slide"></div></li>
                        <li class="nav-item btn"><div class="nav-link sttsCd1 font-weight-bold" style="font-size:20px;"
                              onclick="moveTab(1)">
                              반려 <span class="badge badge-otitodo"style="font-size:15px;">${rejTotal}</span>
                           </div>
                           <div class="slide"></div></li>
                        <li class="nav-item btn"><div
                              class="nav-link sttsCd2 active font-weight-bold" style="font-size:20px;" onclick="moveTab(2)">
                              접수 <span class="badge badge-otidanger"style="font-size:15px;">${rtotal}</span>
                           </div>
                           <div class="slide"></div></li>
                        <li class="nav-item btn">
                           <div class="nav-link sttsCd3 font-weight-bold" style="font-size:20px;" onclick="moveTab(3)">
                              개발 중 <span class="badge badge-otitodo"style="font-size:15px;">${dtotal}</span>
                           </div>
                           <div class="slide"></div>
                        </li>
                     </sec:authorize>
                     <li class="nav-item btn"><div class="nav-link sttsCd4 font-weight-bold" style="font-size:20px;"
                           onclick="moveTab(4)">
                           테스트 <span class="badge badge-otitodo"style="font-size:15px;">${ttotal}</span>
                        </div>
                        <div class="slide"></div></li>
                     <li class="nav-item btn"><div class="nav-link sttsCd5 font-weight-bold" style="font-size:20px;"
                           onclick="moveTab(5)">
                           개발완료 <span class="badge badge-otitodo"style="font-size:15px;">${comtotal}</span>
                        </div>
                        <div class="slide"></div></li>
                     <li class="nav-item btn"><div class="nav-link sttsCd6 font-weight-bold" style="font-size:20px;"
                           onclick="moveTab(6)">
                           개발취소 <span class="badge badge-otitodo"style="font-size:15px;">${cantotal}</span>
                        </div>
                        <div class="slide"></div></li>
                     <li class="nav-item btn"><div class="nav-link hstry font-weight-bold" style="font-size:20px;"
                           onclick="moveHstryTab()">
                           히스토리<span class="badge badge-otitodo"style="font-size:15px;">${histotal}</span>
                        </div>
                        <div class="slide"></div></li>
                  </ul>
                  <!-- Tab panes -->
                  <div class="tab-content card-block" style="padding: 0px 20px 20px 20px;">
                     <!------나의 할일 : 요청-------->
                     <div class="tab-pane active" id="requesttable" role="tabpanel">
                        <%@ include file="/WEB-INF/views/mytodo/srTable.jsp"%>
                     </div>
                  </div>
               </div>
            </div>
         </div>
      </div>
      <div class="row">
         <!-- 공지사항 게시판 -->
         <div class="col-lg-4" id="noticeList">
            <jsp:include page="/WEB-INF/views/mytodo/notice.jsp" />
         </div>
         <!-- 시각자료 넣을 곳 -->
         <div class="col-lg-4" style="padding-left:0px;" id="qnaList">
            <jsp:include page="/WEB-INF/views/mytodo/qna.jsp" />
         </div>
         <sec:authorize access="hasRole('ROLE_ADMIN')">
            <div class="col-lg-4" style="padding-left:0px;">
               <jsp:include page="/WEB-INF/views/mytodo/progressGraph.jsp" />
            </div>
         </sec:authorize>
         <sec:authorize access="hasRole('ROLE_DEVELOPER')">
            <div class="card col-lg-4" style="padding:0px;">
               <div class="card-header">
                  <h5 class="card-header-text">나의 일정</h5>
               </div>
               <div class="card-body">
                  <div id="calendar" style="background-color: white"></div>
               </div>
            </div>
         </sec:authorize>
         <sec:authorize access="hasRole('ROLE_CLIENT')">
            <div class="card col-lg-4" style="padding:0px;">
               <div class="card-header">
                  <h5 class="card-header-text" style="font-size:20px;font-weight:bold">나의 요청 현황</h5>
               </div>
               <div class="card-body">
                  <canvas id="myChart" height="230"></canvas>
               </div>
            </div>
         </sec:authorize>

      </div>
   </div>
   <!-- Page-body end -->
   <%@include file="/WEB-INF/views/fragments/bottom.jsp"%>
   <!-- 모달 -->
   <jsp:include page="/WEB-INF/views/srDemand/modal.jsp" />
</body>
</html>