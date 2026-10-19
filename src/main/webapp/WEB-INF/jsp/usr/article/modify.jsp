<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

	<c:set var="pageTitle" value="modify"/>

<%@ include file="../common/header.jsp" %>
<%@ include file="../common/toastUiEditorLib.jsp" %>

	<section class="mt-8 text-xl">
		<div class="container mx-auto px-3">
			<form action="doModify" method="post" onsubmit="submitForm(this); return false;">
				<input name="id" type="hidden" value="${article.id }">
				<input name="body" type="hidden"/>
				<div>
					<table class="table table-lg">
						<tr>
							<th>번호</th>
							<td>${article.id }</td>
						</tr>
						
						<tr>
							<th>장비명</th>
							<td><input class="input input-bordered input-info w-96" name="equipment" type="text" value="${article.equipment}" placeholder="장비명을 입력해주세요."/></td>
						</tr>
						<tr>
							<th>작업 단계</th>
							<td>
								<select class="select select-bordered select-info" name="workStage">
									<option value="">선택 안 함</option>
									<c:forTokens var="stage" items="조립품 확인,조립,공압,명칭 표기,IO 체크,부속품·센서 부착,세팅,검수,이설,장비 설치,형교환" delims=",">
										<option value="${stage }" ${article.workStage == stage ? 'selected' : ''}>${stage }</option>
									</c:forTokens>
								</select>
							</td>
						</tr>
						<tr>
							<th>원인 구분</th>
							<td>
								<select class="select select-bordered select-info" name="causeType">
									<c:forTokens var="cause" items="원인 불명,기구,전장,제어,설계,세팅,전 공정,품질" delims=",">
										<option value="${cause }" ${article.causeType == cause ? 'selected' : ''}>${cause }</option>
									</c:forTokens>
								</select>
							</td>
						</tr>
						<tr>
							<th>상태</th>
							<td>
								<c:choose>
									<c:when test="${article.status == '해결'}">해결</c:when>
									<c:otherwise>
										<select class="select select-bordered select-info" name="status">
											<c:forTokens var="statusOption" items="진행 중,협의 중,보류" delims=",">
												<option value="${statusOption }" ${article.status == statusOption ? 'selected' : ''}>${statusOption }</option>
											</c:forTokens>
										</select>
									</c:otherwise>
								</c:choose>
							</td>
						</tr>
						<tr>
							<th>작성일</th>
							<td>${article.regDate }</td>
						</tr>
						<tr>
							<th>수정일</th>
							<td>${article.updateDate }</td>
						</tr>
						<tr>
							<th>작성자</th>
							<td>${article.writerName }</td>
						</tr>
						<tr>
							<th>제목</th>
							<td><input class="input input-bordered input-info w-96" name="title" type="text" value="${article.title }" placeholder="제목을 입력해주세요."/></td>
						</tr>
						<tr>
							<th>이슈 사항</th>
							<td>
								<div class="toast-ui-editor">
									<script type="text/x-template">${article.body }</script>
								</div>
							</td>
						</tr>
						<tr>
							<td class="text-center" colspan="2"><button class="btn btn-wide btn-outline btn-sm">수정</button></td>
						</tr>

					</table>
				</div>
			</form>
			<div class="mt-2">
				<button class="btn btn-outline btn-sm" onclick="history.back();">뒤로가기</button>
			</div>
		</div>
	</section>

	<%@ include file="../common/footer.jsp" %>