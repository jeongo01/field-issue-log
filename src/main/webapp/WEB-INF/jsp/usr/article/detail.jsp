<%@ page language="java" contentType="text/html; charset=UTF-8"
    pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>

	<c:set var="pageTitle" value="DETAIL"/>
	<c:set var="hidePageTitle" value="true"/>
		
<%@ include file="../common/header.jsp" %>
<%@ include file="../common/toastUiEditorLib.jsp" %>

	<script>
		$(function() {
			getRecommendPoint();
			
			$('#recommendBtn').click(function() {
				let recommendBtn = $('#recommendBtn').hasClass('btn-active');		
						
				$.ajax({
					url : "../recommendPoint/doRecommendPoint",
					method : "get",
					data : {
						"relTypeCode" : "article",
						"relId" : ${article.id },
						"recommendBtn" : recommendBtn
					},
					dataType : "text",
					success : function(data){
						location.reload();
					},
					error : function(xhr, status, error){
						console.error("ERROR : " + status + " - " + error);
					}
				})
			})
		})
		
		const getRecommendPoint = function(){
			$.ajax({
				url : "../recommendPoint/getRecommendPoint",
				method : "get",
				data : {
					"relTypeCode" : "article",
					"relId" : ${article.id }
				},
				dataType : "json",
				success : function(data){
					if (data.success) {
						$('#recommendBtn').addClass('btn-active');
					}
				},
				error : function(xhr, status, error){
					console.error("ERROR : " + status + " - " + error);
				}
			})
		}
	</script>

	<section class="mt-8 text-xl">
		<div class="container mx-auto px-3">
			
			<div class="mt-2">
				<button class="btn btn-outline btn-sm" onclick="history.back();">뒤로가기</button>
			</div>
			
			<div class="mt-3 flex justify-between items-end">
				<h1 class="text-2xl">
					<span class="mr-2 text-gray-400">${article.id }</span>${pageTitle }					
				</h1>				
				<div class="grid grid-cols-[auto_auto] gap-x-3 text-sm text-gray-400">
					<span>작성일</span><span>${article.regDate.substring(0, 16) }</span>
					<span>수정일</span><span>${article.updateDate.substring(0, 16) }</span>
				</div>
			</div>
			
			<div class="mt-2 p-2 rounded-lg flex justify-between items-center gap-4">
				<div class="text-xl font-bold break-all">
					<span class="text-sm opacity-60 mr-2">제목</span>${article.title }
				</div>
				<div class="shrink-0 text-gray-400">
					<span class="text-sm opacity-60 mr-2">작성자</span>${article.writerName }	
				</div>
			</div>
			
			<div class="mt-3 grid grid-cols-2 md:grid-cols-4 gap-3 text-sm">
				<div class="p-3 border border-gray-600 rounded-lg flex justify-center items-center gap-3">
					<div class="opacity-60">장비명:</div>
					<div>${empty article.equipment ? '-' : article.equipment }</div>
				</div>
				
				<div class="p-3 border border-gray-600 rounded-lg flex justify-center items-center gap-3">
					<div class="opacity-60">작업 단계:</div>
					<div>${empty article.workStage ? '-' : article.workStage }</div>
				</div>
				
				<div class="p-3 border border-gray-600 rounded-lg flex justify-center items-center gap-3">
					<div class="opacity-60">원인 구분:</div>
					<div>${article.causeType }</div>
				</div>
				
				<div class="p-3 border border-gray-600 rounded-lg flex justify-center items-center gap-3">
					<div class="opacity-60">상태:</div>
					<div>${article.status }</div>
					<c:if test="${article.status == '해결'}">
						<div class="text-xs opacity-60">(해결자: ${article.resolverName })</div>
					</c:if>
				</div>	
			</div>
			
			<div class="mt-3 p-4 border border-gray-600 rounded-lg min-h-[100px]">
				<div class="toast-ui-viewer">
					<script type="text/x-template">${article.body }</script>
				</div>
			</div>
				
			<div class="mt-3 flex justify-between items-center">
				<div class="flex items-center gap-6 text-sm">
					<span>조회수 ${article.hitCnt }</span>
					<span class="flex items-center gap-2">
						<c:if test="${rq.loginedMemberId == 0}">
							<span>좋아요</span>
						</c:if>
						
						<c:if test="${rq.loginedMemberId != 0}">
							<button id="recommendBtn" class="btn btn-outline btn-xs mr-8">좋아요</button>
						</c:if>
						<span>${article.point }개</span>
					</span>
				</div>
				<div class="flex gap-2">
					<c:if test="${rq.loginedMemberId != 0 }">
						<c:if test="${article.status != '해결'}">
							<a class="btn btn-outline btn-success btn-sm" href="doResolve?id=${article.id }" onclick="if(confirm('해결 처리하시겠습니까 ?') == false) return false;">해결 처리</a>
						</c:if>
						<c:if test="${article.status == '해결'}">
							<a class="btn btn-outline btn-sm" href="doReopen?id=${article.id }" onclick="if(confirm('이슈 사항을 수정 하시겠습니까 ?') == false) return false">다시 열기</a>
						</c:if>
					</c:if>
					
					<c:if test="${rq.loginedMemberId == article.memberId}">
						<div class="flex gap-2">
							<a class="btn btn-outline btn-sm" href="modify?id=${article.id }">게시글 수정</a>
							<a class="btn btn-outline btn-sm" href="doDelete?id=${article.id }" onclick="if(confirm('삭제 하시겠습니까?') == false) return false;" >삭제</a>
						</div>
					</c:if>				
				</div>
			</div>
			
		</div>
	</section>
	
	<script>
		const replyForm_onSubmit = function(form) {
			form.body.value = form.body.value.trim();
			
			if (form.body.value.length < 2) {
				alert('2글자 이상 입력해주세요.');
				form.body.focus();
				return;
			}
			
			form.submit();
		}
		
		let originalForm = null;
		let originalId = null;
		
		const replyModify_getForm = function(replyId) {
			if(originalForm != null) {
				replyModify_cancle(originalId);
			}
			
			$.ajax({
				url : "../reply/getReplyContent",
				method : "get",
				data : {
					"id" : replyId
				},
				dataType : "json",
				success : function(data){ 
					
					let replyContent = $('#' + replyId);
					
					originalId = replyId;
					originalForm = replyContent.html();
					
					let addHtml = ` 
						<form onsubmit="replyModify_submit(this, \${replyId}); return false;">
							<div class="mt-4 border border-gray-500 rounded-lg p-4">
								<div class="mb-2">\${data.data.writerName}</div>
								<textarea class="textarea textarea-bordered textarea-info w-full" name="body" placeholder="댓글을 작성해보세요.">\${data.data.body}</textarea>
								<div class="flex justify-end">
									<button onclick="replyModify_cancle(\${replyId});" class="btn btn-outline btn-sm mr-2" type="button">취소</button>
									<button class="btn btn-outline btn-sm">수정</button>
								</div>
							</div>
						</form>
					`;
					
					replyContent.empty().html(addHtml);
				},
				error : function(xhr, status, error){
					console.error("ERROR : " + status + " - " + error);
				}
			})
		}
		
		const replyModify_cancle = function(replyId) {
			let replyContent = $('#' + replyId);				
			
			replyContent.html(originalForm); 

			originalId = null;			
			originalForm = null;
		}
		
		const replyDelete = function(replyId) {
			if(confirm('정말 삭제하시겠습니까?') == false) {
				return;
			}
			
			$.ajax({
				url : "../reply/doDeleteAjax",
				method : "post",
				data : { "id" : replyId },
				dataType : "json",
				success : function(data) {
					if (data.success == false) {
						alert(data.msg);
						return;
					}
					$('#' + replyId).remove();
				},
				error : function(xhr, status, error) {
					console.error("ERROR : " + status + " - " + error);
				}
			})
		}
		
		const replyModify_submit = function(form, replyId) {
			form.body.value = form.body.value.trim();
			
			if(form.body.value.length < 2) {
				alert('2글자 이상 입력해주세요.');
				form.body.focus();
				return;
			}
			
			$.ajax ({
				url: "../reply/doModifyAjax",
				method: "post",
				data: {
					"id": replyId,
					"body": form.body.value		
				},
				dataType: "json",
				success: function(data) {
					if(data.success == false) {
						alert(data.msg);
						return;
					}
					
					replyModify_cancle(replyId)
					
					let replyContent = $('#' + replyId);
					replyContent.find('.reply-body').html(data.data.forPrintBody);
					replyContent.find('.reply-date').text(data.data.updateDate.substring(0, 16));
				},
				error : function(xhr, status, error) {
					console.error("ERROR: " + status + " - " + error);
				}
			}) 
		}
	</script>
	
	<section class="my-8 text-base">
		<div class="container mx-auto px-3">
			<div class="mb-2 text-lg">댓글</div>
			<div>
				<c:forEach var="reply" items="${replies }">
					<div id="${reply.id }" class="py-3 border-b border-gray-700 last:border-b-0">
						<div class="flex items-start gap-4">
							<div class="w-28 shrink-0 truncate text-yellow-500">${reply.writerName }</div>
							<div class="reply-body flex-grow break-all">${reply.getForPrintBody() }</div>
							<div class="reply-date shrink-0 pt-1 text-xs text-gray-400">${reply.updateDate.substring(0, 16) }</div>
							<div class="w-8 shrink-0">
								<c:if test="${rq.loginedMemberId == reply.memberId }">
									<div class="dropdown dropdown-end">
										<div tabindex="0" role="button" class="btn btn-circle btn-ghost btn-sm">
									    	<svg xmlns="http://www.w3.org/2000/svg" fill="none" viewBox="0 0 24 24" class="inline-block w-5 h-5 stroke-current"><path stroke-linecap="round" stroke-linejoin="round" stroke-width="2" d="M5 12h.01M12 12h.01M19 12h.01M6 12a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0zm7 0a1 1 0 11-2 0 1 1 0 012 0z"></path></svg>
									    </div>
										<ul tabindex="0" class="z-[1] p-2 shadow menu menu-sm dropdown-content bg-base-100 rounded-box w-24">
											<li><a onclick="replyModify_getForm(${reply.id })">수정</a></li>
											<li><a onclick="replyDelete(${reply.id })">삭제</a></li>
										</ul>
									</div>
								</c:if>
							</div>	
						</div>
					</div>
				</c:forEach>
			</div>
			
			<c:if test="${rq.loginedMemberId != 0 }">
				<form action="../reply/doWrite" method="post" onsubmit="replyForm_onSubmit(this); return false;">
					<input type="hidden" name="relTypeCode" value="article" />
					<input type="hidden" name="relId" value="${article.id }"/>
					<div class="mt-4 border border-gray-500 rounded-lg p-4" >
						<div class="mb-2">${rq.loginedMemberNickname }</div>
						<textarea class="textarea textarea-bordered textarea-info w-full" name="body" placeholder="댓글 작성하기"></textarea>
						<div class="flex justify-end"><button class="btn btn-outline btn-sm">작성</button></div>
					</div>
				</form>
			</c:if>
		</div>
	</section>
	
<%@ include file="../common/footer.jsp" %>