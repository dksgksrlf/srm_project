<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8"%>
<%@taglib prefix="c" uri="http://java.sun.com/jsp/jstl/core"%>

<%--  inclue 시킨다. ㅡmodel.add(("pager",pager") foreach로 페이지 숫자 복사 , 링크 앞부분을 model.add("link") : /sr/list?page=1--%>
<div class="pagination-container">
	<div class="pagination">
		<c:if test="${pager.startPageNo -1 > 0 }">
			<a class="pagination-newer" href="?page=${pager.startPageNo - 1}">PREV</a>
		</c:if>
		<span class="pagination-inner">
			<c:forEach var="num" begin="${pager.startPageNo}" end="${pager.endPageNo}" step="1">
				<c:if test="${pager.pageNo == num }">
					<a class="pagination-active" href="?page=${num}">${num}</a>
				</c:if>
				<c:if test="${pager.pageNo != num }">
					<a href="?page=${num}">${num}</a>
				</c:if>
			</c:forEach>
		</span>
		<c:if test="${pager.endPageNo < pager.totalPageNo }">
			<a class="pagination-older" href="?page=${pager.endPageNo + 1}">NEXT</a>
		</c:if>
	</div>

</div>
