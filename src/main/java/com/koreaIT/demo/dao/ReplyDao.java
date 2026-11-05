package com.koreaIT.demo.dao;

import java.util.List;

import org.apache.ibatis.annotations.Delete;
import org.apache.ibatis.annotations.Insert;
import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;
import org.apache.ibatis.annotations.Update;

import com.koreaIT.demo.vo.Reply;

@Mapper
public interface ReplyDao {
	
	@Insert("""
			INSERT INTO reply
				SET regDate = NOW()
					, updateDate = NOW()
					, memberId = #{loginedMemberId}
					, relTypeCode = #{relTypeCode}
					, relId = #{relId}
					, `body` = #{body}
			""")
	public void writeArticle(int loginedMemberId, String relTypeCode, int relId, String body);

	@Select("""
			SELECT LAST_INSERT_ID()
			""")
	public int getLastInsertId();

	@Select("""
			SELECT R.*, M.nickname AS writerName
				FROM reply AS R
				INNER JOIN `member` AS M
				ON R.memberId = M.id
				WHERE R.relTypeCode = #{relTypeCode}
				AND R.relId = #{relId}
			""")
	public List<Reply> getReplies(String relTypeCode, int relId);

	
	@Delete("""
			DELETE FROM reply
				WHERE id = #{id}
			""")
	public void deleteReply(int id);
	
	@Delete("""
			DELETE FROM reply
				WHERE relTypeCode = #{relTypeCode}
				AND relId = #{relId}
			""")
	public void deleteReplies(String relTypeCode, int relId);

	@Select("""
			SELECT * 
				FROM reply
				WHERE id = #{id} 
			""")
	public Reply getReplyById(int id);

	@Select("""
			SELECT R.*
					, M.nickName AS writerName
				FROM reply AS R
				INNER JOIN `member` AS M
				ON R.memberId = M.id
				WHERE R.id = #{id}
			""")
	public Reply forPrintReply(int id);

	@Update("""
			UPDATE reply
				SET updateDate = NOW()
					, `body` = #{body}
				WHERE id = #{id}
			""")
	public void modifyReply(int id, String body);

	

}