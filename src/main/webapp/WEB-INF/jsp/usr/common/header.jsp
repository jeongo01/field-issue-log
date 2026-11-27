<%@ page language="java" contentType="text/html; charset=UTF-8"
	pageEncoding="UTF-8" %>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/functions" prefix="fn"%>
<!DOCTYPE html>
<html>
<head>
<meta charset="UTF-8">
<title>${fn:escapeXml(pageTitle) }</title>

<link rel="shortcut icon" href="/resource/images/favicon.ico" />

<!-- 데이지UI -->
<link href="https://cdn.jsdelivr.net/npm/daisyui@4.6.0/dist/full.min.css" rel="stylesheet" type="text/css" />
<!-- 테일윈드 치트시트 -->
<script src="https://cdn.tailwindcss.com"></script>
<!-- 제이쿼리 -->
<script src="https://cdnjs.cloudflare.com/ajax/libs/jquery/3.7.1/jquery.min.js"></script>
<!-- 폰트어썸 -->
<link rel="stylesheet" href="https://cdnjs.cloudflare.com/ajax/libs/font-awesome/6.5.1/css/all.min.css" integrity="sha512-DTOQO9RWCH3ppGqcWaEA1BIZOC6xxalwEsw9c2QQeAIftl+Vegovlnee1c9QX4TctnWMn13TZye+giMm8e2LwA==" crossorigin="anonymous" referrerpolicy="no-referrer" />
<link rel="stylesheet" href="/resource/common.css" />
<script src="/resource/common.js" defer></script>
</head>
<body>
	<div class="h-20 container mx-auto text-3xl flex">
		<div><a class="h-full px-3 flex items-center" href="/">E</a></div>
		<div class="flex-grow"></div>
		<ul class="flex">
			<li class="hover:underline"><a class="h-full px-3 flex items-center" href="/">HOME</a></li>
			
			<li class="hover:underline dropdown dropdown-hover">
				<a href class="h-full px-3 flex items-center" tabindex="0">국내</a>
				<ul tabindex="0" class="dropdown-content menu bg-base-200 rounded-box z-[1] w-48 p-2 shdow text-base">
					<li><a href="/usr/article/list?boardId=1">청주 A사 1공장</a></li>
					<li><a href="/usr/article/list?boardId=2">청주 A사 2공장</a></li>
				</ul>
			</li>
			
			<li class="hover:underline dropdown dropdown-hover">
				<a href class="h-full px-3 flex items-center" tabindex="0">해외</a>
				<ul tabindex="0" class="dropdown-content menu bg-base-200 rounded-box z-[1] w-48 p-2 shdow text-base">
					<li><a href="/usr/article/list?boardId=3">중국 B사 1공장</a></li>
					<li><a href="/usr/article/list?boardId=4">일본 B사 2공장</a></li>
				</ul>
			</li>
			
			<li class="hover:underline"><a class="h-full px-3 flex items-center" href="/usr/article/list?boardId=5">기타</a></li>
			<c:if test="${rq.loginedMemberId == 0}">
				<li class="hover:underline"><a class="h-full px-3 flex items-center" href="/usr/member/join">회원가입</a></li>
				<li class="hover:underline"><a class="h-full px-3 flex items-center" href="/usr/member/login">로그인</a></li>
			</c:if>
			<c:if test="${rq.loginedMemberId != 0}">
				<li class="hover:underline"><a class="h-full px-3 flex items-center" href="/usr/member/doLogout">로그아웃</a></li>	
			</c:if>
		</ul>	
	</div>
	
	<c:if test="${empty hidePageTitle }">
		<section class="my-3 text-2xl">
			<div class="container mx-auto px-3">
				<h1>${fn:escapeXml(pageTitle) } PAGE</h1>
			</div>
		</section>
	</c:if>