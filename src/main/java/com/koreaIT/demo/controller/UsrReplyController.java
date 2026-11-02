package com.koreaIT.demo.controller;

import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.koreaIT.demo.service.ReplyService;
import com.koreaIT.demo.util.Util;
import com.koreaIT.demo.vo.Reply;
import com.koreaIT.demo.vo.ResultData;
import com.koreaIT.demo.vo.Rq;

@Controller
public class UsrReplyController {

	private ReplyService replyService;
	private Rq rq;
	
	public UsrReplyController(ReplyService replyService, Rq rq) {
		this.replyService = replyService;
		this.rq = rq;
	}
	
	
	@RequestMapping("/usr/reply/doWrite")
	@ResponseBody
	public String doWrite(String relTypeCode, int relId, String body) {
		
		if(Util.empty(body)) {
			return Util.jsHistoryBack("내용을 입력해주세요.");
		}
		
		replyService.writeReply(rq.getLoginedMemberId(), relTypeCode, relId, body);
		
		return Util.f("<script>location.replace('../article/detail?id=%d')</script>", relId);
	}
	
	@GetMapping("/usr/replies/{id}")
	@ResponseBody
	public ResultData<Reply> getReplyContent(@PathVariable int id) {
		
		Reply reply = replyService.forPrintReply(id);
				
		if(reply == null) {
			return ResultData.from("F-1", Util.f("%d번 댓글은 존재하지 않습니다.", id));
		}
		
		return ResultData.from("S-1", "댓글 정보 조회 성공", reply);
		
	}
	
	@RequestMapping("/usr/reply/doModify")
	@ResponseBody
	public String doModify(int id, String body) {
		
		if(Util.empty(body)) {
			return Util.jsHistoryBack("내용을 입력해주세요.");
		}
		
		Reply reply = replyService.getReplyById(id);
				
		if(reply == null) {
			return Util.jsHistoryBack(Util.f("%d번 댓글은 존재하지 않습니다.", id));
		}
				
		if(rq.getLoginedMemberId() != reply.getMemberId()) {
			return Util.jsHistoryBack("해당 댓글에 대한 권한이 없습니다.");
		}
		
		replyService.modifyReply(id, body);
		
		return Util.jsReplace(Util.f("%d번 댓글을 수정했습니다.", id), Util.f("../article/detail?id=%d", reply.getRelId()));
		
	}
	
	@PutMapping("/usr/replies/{id}")
	@ResponseBody
	public ResultData<Reply> doModifyAjax(@PathVariable int id, String body) {
		
		if(Util.empty(body)) {
			return ResultData.from("F-1", "내용을 입력해주세요.");
		}
		
		Reply reply = replyService.getReplyById(id);
		
		if(reply == null) {
			return ResultData.from("F-2", "게시글에 댓글이 존재하지 않습니다.");
		}
		
		if(rq.getLoginedMemberId() != reply.getMemberId()) {
			return ResultData.from("F-3", "해당 댓글에 대한 권한이 없습니다.");
		}
		
		replyService.modifyReply(id, body);
		
		return ResultData.from("S-1", "댓글을 수정 하셨습니다.", replyService.forPrintReply(id));
	}
	
	@RequestMapping("/usr/reply/doDelete")
	@ResponseBody
	public String doDelete(int id) {	
		
		Reply reply = replyService.getReplyById(id);
		
		if(reply == null) {
			return Util.jsHistoryBack(Util.f("%d번 게시물에 대한 댓글은 존재하지 않습니다.", id));
		}
		
		if(rq.getLoginedMemberId() != reply.getMemberId()) {
			return Util.jsHistoryBack(Util.f("%d번 게시글 댓글에 접근 권한이 없습니다.", id));
		}
		
		replyService.deleteReply(id);
		
		return Util.jsReplace(Util.f("%d번 게시물에 대한 댓글을 삭제했습니다.", id), Util.f("../article/detail?id=%d", reply.getRelId()));
		
	}
	
	@DeleteMapping("/usr/replies/{id}")
	@ResponseBody
	public ResultData<Reply> doDeleteAjax(@PathVariable int id) {
		
		Reply reply = replyService.getReplyById(id);
		
		if(reply == null) {
			return ResultData.from("F-1", "존재하지 않는 게시물 입니다.");
		}
		
		if(rq.getLoginedMemberId() != reply.getMemberId()) {
			return ResultData.from("F-2", "해당 댓글에 대한 권한이 없습니다.");
		}
		
		replyService.deleteReply(id);
		
		return ResultData.from("S-1", "댓글을 삭제했습니다.");
		
	}
}