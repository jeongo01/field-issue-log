package com.koreaIT.demo.controller;

import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreaIT.demo.service.ArticleService;
import com.koreaIT.demo.service.BoardService;
import com.koreaIT.demo.service.ReplyService;
import com.koreaIT.demo.util.Util;
import com.koreaIT.demo.vo.Article;
import com.koreaIT.demo.vo.Board;
import com.koreaIT.demo.vo.Reply;
import com.koreaIT.demo.vo.Rq;

import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;

@Controller
public class UsrArticleController {
	
	private ArticleService articleService;
	private BoardService boardService;
	private ReplyService replyService;
	private Rq rq;
	
	public UsrArticleController(ArticleService articleService, BoardService boardService, ReplyService replyService, Rq rq) {
		this.articleService = articleService;
		this.boardService = boardService;
		this.replyService = replyService;
		this.rq = rq;
	}
	
	@RequestMapping("/usr/article/write")
	public String write(Model model, @RequestParam(defaultValue="0") int boardId) {
		
		Board board = boardService.getBoardById(boardId);
		
		if(board == null) {
			return rq.jsReturnOnView("게시판을 선택한 뒤 글을 작성해주세요.");
		}
		
		model.addAttribute("board", board);
		
		return "usr/article/write";
	}

	@RequestMapping("/usr/article/doWrite")
	@ResponseBody
	public String doWrite(String title, String body, int boardId, String equipment, String workStage, String causeType, String status, Integer resolverId) {
		
		if(Util.empty(title)) {
			return Util.jsHistoryBack("제목을 입력해 주세요.");
		}
		
		if(Util.empty(body)) {
			return Util.jsHistoryBack("내용을 입력해 주세요.");
		}
		
		articleService.writeArticle(rq.getLoginedMemberId(), title, body, boardId, equipment, workStage, causeType, status, resolverId);
		
		int id = articleService.getLastInsertId();
		
		return Util.jsReplace(Util.f("%d번 게시물이 작성 되었습니다.", id), Util.f("detail?id=%d", id));
	}
	
	@RequestMapping("/usr/article/list")
	public String showList(Model model, int boardId,
			@RequestParam(defaultValue = "1") int page,
			@RequestParam(defaultValue = "title") String searchKeywordType,
			@RequestParam(defaultValue = "") String searchKeyword,
			@RequestParam(defaultValue = "") String searchStatus,
			@RequestParam(defaultValue = "") String searchCauseType) {
		
		if(page <= 0) {
			return rq.jsReturnOnView("페이지 번호가 올바르지 않습니다.");
		}
		
		Board board = boardService.getBoardById(boardId);
		
		if(board == null) {
			return rq.jsReturnOnView("존재하지 않는 게시판입니다.");
		}
		
		int articlesCnt = articleService.getArticlesCnt(boardId, searchKeywordType, searchKeyword, searchStatus, searchCauseType);
		
		int itemsInAPage = 10;
		
		int limitStart = (page - 1) * itemsInAPage;
		
		int pagesCnt = (int) Math.ceil((double) articlesCnt / itemsInAPage);
		
		List<Article> articles = articleService.getArticles(boardId, searchKeywordType, searchKeyword, searchStatus, searchCauseType, limitStart, itemsInAPage);
		
		int from = ((page - 1) / itemsInAPage ) * itemsInAPage + 1;
		int end = (((page - 1) / itemsInAPage) + 1) * itemsInAPage;
		
		if (end > pagesCnt) {
			end = pagesCnt;
		}
		
		model.addAttribute("articles", articles);
		model.addAttribute("board", board);
		model.addAttribute("articlesCnt", articlesCnt);
		
		model.addAttribute("page", page);
		model.addAttribute("pagesCnt", pagesCnt);
		model.addAttribute("from", from);
		model.addAttribute("end", end);
		
		model.addAttribute("searchKeywordType", searchKeywordType);
		model.addAttribute("searchKeyword", searchKeyword);
		
		model.addAttribute("searchStatus", searchStatus);
		model.addAttribute("searchCauseType", searchCauseType);
		
		return "usr/article/list";
	}
	
	@RequestMapping("/usr/article/detail")
	public String showDetail(HttpServletRequest req, HttpServletResponse resp, Model model, int id) {
		
		if(articleService.getArticleById(id) == null) {
			return rq.jsReturnOnView(Util.f("%d번 게시물은 존재하지 않습니다.", id));
		}
		
		Cookie oldCookie = null;
		Cookie[] cookies = req.getCookies();
		
		if(cookies != null) {
			for(Cookie cookie : cookies) {
				if(cookie.getName().equals("hitCnt")) {
					oldCookie = cookie;
				}
			}
		}
		
		if(oldCookie != null) {
			if(oldCookie.getValue().contains("[" + id + "]") == false) {
				articleService.increaseHitCnt(id);
				oldCookie.setValue(oldCookie.getValue() + "_[" + id + "]");
				oldCookie.setPath("/");
				oldCookie.setMaxAge(10);
				resp.addCookie(oldCookie);
			}
			
		} else {
			articleService.increaseHitCnt(id);
			Cookie newCookie = new Cookie("hitCnt", "[" + id + "]");
			newCookie.setPath("/");
			newCookie.setMaxAge(20);
			resp.addCookie(newCookie);
		}
		
		
		Article article = articleService.forPrintArticle(id);
		
		List<Reply> replies = replyService.getReplies("article", id);
		
		model.addAttribute("article", article);
		model.addAttribute("replies", replies);
		
		return "usr/article/detail";
	}
	
	@RequestMapping("/usr/article/modify")
	public String modify(Model model, int id) {
		
		Article article = articleService.forPrintArticle(id);
		
		if(article == null) {
			return rq.jsReturnOnView(Util.f("%d번 게시물은 존재하지 않습니다.", id));
		}
		
		if(rq.getLoginedMemberId() != article.getMemberId()) {
			return rq.jsReturnOnView("해당 게시물에 대한 권한이 없습니다.");
		}
		
		model.addAttribute("article", article);
		
		return "/usr/article/modify";
	}
	
	@RequestMapping("/usr/article/doModify")
	@ResponseBody
	public String doModify(int id, String title, String body, String equipment, String workStage, String causeType, String status) {
		
		Article article = articleService.getArticleById(id);
		
		if(article == null) {
			return Util.jsHistoryBack(Util.f("%d번 게시물은 존재하지 않습니다.", id));
		}
		
		if(article.getMemberId() != rq.getLoginedMemberId()) {
			return Util.jsHistoryBack("해당 게시물에 대한 권한이 없습니다.");
		}
		
		articleService.modifyArticle(id, title, body, equipment, workStage, causeType, status);
		
		return Util.jsReplace(Util.f("%d번 게시물을 수정했습니다.", id), Util.f("detail?id=%d", id));
	}
	
	@RequestMapping("/usr/article/doDelete")
	@ResponseBody
	public String doDelete(int id) {
		
		if(rq.getLoginedMemberId() == 0) {
			return Util.jsHistoryBack("로그인 후에 이용해주세요.");
		}
		
		Article article = articleService.getArticleById(id);
		
		
		if(article == null) {
			return Util.jsHistoryBack(Util.f("%d번 게시물은 존재하지 않습니다.", id));
		}
		
		if(article.getMemberId() != (int) rq.getLoginedMemberId()) {
			return Util.jsHistoryBack("해당 게시물에 대한 권한이 없습니다.");
		}
		
		articleService.deleteArticle(id);
		
		return Util.jsReplace(Util.f("%d번 게시물을 삭제했습니다.", id), Util.f("list?boardId=%d", article.getBoardId()));
	}
	
	@RequestMapping("/usr/article/doResolve")
	@ResponseBody
	public String doResolve(int id) {
		
		Article article = articleService.getArticleById(id);
		
		if(article == null) {
			return Util.jsHistoryBack(Util.f("%d번 게시물은 존재하지 않습니다.", id));
		}
		
		if("해결".equals(article.getStatus())) {
			return Util.jsHistoryBack("이미 해결된 이슈입니다.");
		}
		
		articleService.resolveArticle(id, rq.getLoginedMemberId());
		
		return Util.jsReplace("", Util.f("detail?id=%d", id));
	}
	
	@RequestMapping("/usr/article/doReopen")
	@ResponseBody
	public String doReopen(int id) {
		Article article = articleService.getArticleById(id);
		
		if(article == null ) {
			return Util.jsHistoryBack(Util.f("%d번 게시물은 존재하지 않습니다.", id));
		}
		
		if(!"해결".equals(article.getStatus())) {
			return Util.jsHistoryBack("해결된 이슈만 다시 열 수 있습니다.");
		}
		
		articleService.reopenArticle(id);
		
		return Util.jsReplace("", Util.f("detail?id=%d", id));  // msg 내용이 있으니 이중 문구가 나와서. 빈 문자열로 변경
		
	}
}