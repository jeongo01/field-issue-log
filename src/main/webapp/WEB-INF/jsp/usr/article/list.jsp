<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>

	<c:set var="pageTitle" value="${board.name }"/>

<%@ include file="../common/header.jsp" %>

<section class="mt-8 text-xl">
	<div class="container mx-auto px-3">
		
		<div class="mb-2 text-base flex justify-between">
			<div ><span>총: ${articlesCnt } 개</span></div>
			<div>
				<form>
					<input name="boardId" type="hidden" value="${board.id }"/>
					<select class="select select-info select-sm" data-value="${fn:escapeXml(searchKeywordType) }" name="searchKeywordType">
						<option value="title">제목</option>
						<option value="body">내용</option>
						<option value="title, body">제목 + 내용</option>
					</select>
					<select class="ml-2 select select-info select-sm" name="searchStatus">
						<option value="">상태 전체</option>
						<c:forTokens var="statusOption" items="해결,진행 중,협의 중,보류" delims=",">
							<option value="${statusOption}" ${searchStatus == statusOption ? 'selected' : ''}>${statusOption }</option>
						</c:forTokens>
					</select>
					<select class="ml-2 select select-info select-sm" name="searchCauseType">
						<option value="">원인 전체</option>
						<c:forTokens var="causeOption" items="원인 불명,기구,전장,제어,설계,세팅,전 공정,품질" delims=",">
							<option value="${causeOption}" ${searchCauseType == causeOption ? 'selected' : ''}>${causeOption }</option>
						</c:forTokens>
					</select>
					
					<input class="ml-2 input input-bordered input-info w-60 input-sm" name="searchKeyword" type="text" value="${fn:escapeXml(searchKeyword)}" placeholder="검색어를 입력해주세요." maxlength="20"/>
					
					<button class="ml-2 btn btn-outline btn-sm">검색</button>
				</form>
			</div>
		</div>
		
		<div>
			<table class="table table-lg">
				<thead class="text-lg">
					<tr>
						<th>번호</th>
						<th>제목</th>
						<th>장비명</th>
						<th>상태</th>
						<th>작성자</th>
						<th>작성일</th>
						<th>조회수</th>
						<th>추천수</th>
					</tr>
				</thead>
				<tbody>
					<c:forEach var="article" items="${articles }">
						<tr class="hover">
							<td>${article.id }</td>
							<td class="hover:underline"><a href="detail?id=${article.id }">${fn:escapeXml(article.title) }</a></td>
							<td>${empty article.equipment ? '-' : fn:escapeXml(article.equipment) }</td>
							<td>
								<span class="badge badge-sm
									${article.status == '해결' ? 'badge-success' : '' }
									${article.status == '진행 중' ? 'badge-warning' : '' }
									${article.status == '협의 중' ? 'badge-info' : ''}">
									${fn:escapeXml(article.status) }
								</span>
							</td>
							<td>${fn:escapeXml(article.writerName) }</td>
							<td>${article.regDate.substring(2, 16) }</td>
							<td>${article.hitCnt }</td>
							<td>${article.point }</td>
						</tr>
					</c:forEach>
				</tbody>
			</table>
		</div>
		
		<c:if test="${rq.loginedMemberId != 0}">
			<div class="mt-2 flex justify-end">
				<a class="btn btn-outline btn-sm" href="write?boardId=${board.id }">글쓰기</a>
			</div>
		</c:if>
		
		<div class="mt-2 flex justify-center">
			<div class="join">
				<c:if test="${from != 1}">
					<a class="join-item btn btn-square btn-sm" href="${baseUri}&page=1">&lt;&lt;</a>
					<a class="join-item btn btn-square btn-sm" href="${baseUri}&page=${from - 1}">&lt;</a>
				</c:if>
				
				<c:forEach begin="${from}" end="${end}" var="i">
					<a class="join-item btn btn-square btn-sm ${page == i ? 'btn-active' : '' }" href="${baseUri}&page=${i}">${i}</a>
				</c:forEach>
				
				<c:if test="${end != pagesCnt}">
					<a class="join-item btn btn-square btn-sm" href="${baseUri}&page=${end + 1}">&gt;</a>
					<a class="join-item btn btn-square btn-sm" href="${baseUri}&page=${pagesCnt}">&gt;&gt;</a>
				</c:if>
			</div>
		</div>
		
	</div>
</section>

<%@ include file="../common/footer.jsp" %>