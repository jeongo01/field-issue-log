package com.koreaIT.demo.service;

import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.koreaIT.demo.dao.ReplyDao;
import com.koreaIT.demo.vo.Reply;

@Service
public class ReplyService {
	
	private ReplyDao replyDao;
	
	public ReplyService(ReplyDao replyDao) {
		this.replyDao = replyDao;
	}

	// LAST_INSERT_ID()는 커넥션 단위 값이므로 INSERT와 같은 커넥션(트랜잭션)에서 조회해야 한다.
	@Transactional
	public int writeReply(int loginedMemberId, String relTypeCode, int relId, String body) {
		replyDao.writeArticle(loginedMemberId, relTypeCode, relId, body);
		return replyDao.getLastInsertId();
	}

	public List<Reply> getReplies(String relTypeCode, int relId) {
		return replyDao.getReplies(relTypeCode, relId);
	}

	public void deleteReply(int id) {
		replyDao.deleteReply(id);
	}

	public Reply getReplyById(int id) {
		return replyDao.getReplyById(id);
	}

	public Reply forPrintReply(int id) {
		return replyDao.forPrintReply(id);
	}

	public void modifyReply(int id, String body) {
		replyDao.modifyReply(id, body);
	}

}
