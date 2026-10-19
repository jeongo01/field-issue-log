<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

	<c:set var="pageTitle" value="WRITE"/>
	
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/toastUiEditorLib.jsp" %>
		
	<section class="mt-8 text-xl">
		<div class="container mx-auto px-3">
			<form action="doWrite" method="post" onsubmit="submitForm(this); return false;">
				<input name="body" type="hidden" />
				<input name="boardId" type="hidden" value="${board.id }"/>
				
				<div class="text-sm text-gray-400">${board.name }</div>
				
				<div class="mt-2 flex items-center gap-3">
					<label class="shrink-0 text-sm">제목</label>
					<input class="input input-bordered input-info flex-grow" name="title" type="text" placeholder="제목을 입력해주세요." />
				</div>
				
				<div class="mt-6 grid grid-cols-4 gap-3">
					<div>
						<label class="block text-center text-sm">장비 명칭</label>
						<input class="input input-bordered input-info w-full mt-1" name="equipment" type="text" placeholder="예: 장비 명" />
					</div>
					
					<div>
						<label class="block text-center text-sm">작업 단계</label>
						<select class="select select-bordered select-info w-full mt-1" name="workStage">
							<option>조립품 확인</option>
							<option>조립</option>
							<option>공압</option>
							<option>명칭 표기</option>
							<option>Io check</option>
							<option>부속품·센서 부착</option>
							<option>세팅</option>
							<option>검수</option>
							<option>이설</option>
							<option>장비 설치</option>
							<option>형교환</option>
						</select>
					</div>
					<div>
						<label class="block text-center text-sm">원인 구분</label>
						<select class="select select-bordered select-info w-full mt-1" name="causeType">
							<option>기구</option>
							<option>설계</option>
							<option>제어</option>
							<option>전장</option>
							<option>설계</option>
							<option>세팅</option>
							<option>품질</option>
							<option>전 공정</option>
						</select>
					</div>
					<div>
						<label class="block text-center text-sm">상태</label>
						<c:choose>
							<c:when test="${article.status == '해결'}">
								해결 <span class="text-sm opacity-60">다시 열기</span>
							</c:when>
							<c:otherwise>
								<select class="select select-bordered select-info w-full mt-1" name="status">
									<option>진행 중</option>
									<option>협의 중</option>
									<option>보류</option>	
								</select>
							</c:otherwise>
						</c:choose>
					</div>
				</div>
				
				<div class="mt-4">
					<label class="text-sm">이슈 사항</label>
					<div class="toast-ui-editor mt-1"></div>
				</div>
				
				<div class="mt-4 text-center">
					<button class="btn btn-wide btn-outline btn-sm">작성</button>
				</div>
			</form>
			
			<div>
				<button class="btn btn-outline btn-sm" onclick="history.back();">뒤로가기</button>
			</div>
		</div>
	</section>

<%@ include file="../common/footer.jsp" %>