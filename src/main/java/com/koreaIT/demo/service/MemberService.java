package com.koreaIT.demo.service;

import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;

import com.koreaIT.demo.dao.MemberDao;
import com.koreaIT.demo.vo.Member;

@Service
public class MemberService {
	
	private MemberDao memberDao;
	private PasswordEncoder passwordEncoder;

	public MemberService(MemberDao memberDao, PasswordEncoder passwordEncoder) {
		this.memberDao = memberDao;
		this.passwordEncoder = passwordEncoder;
	}
	
	public void joinMember(String loginId, String loginPw, String name, String nickname, String cellphoneNum, String email) {
		String encodedPw = passwordEncoder.encode(loginPw);                              // 해시로 변 
		memberDao.joinMember(loginId, encodedPw, name, nickname, cellphoneNum, email);
	}
	
	public boolean isPwMatched(String inputPw, String encodedPw) {
		return passwordEncoder.matches(inputPw, encodedPw);                             // 입력값, DB값 순서
	}
	
	public Member getMemberById(int id) {
		return memberDao.getMemberById(id);
	}

	public Member getMemberByLoginId(String loginId) {
		return memberDao.getMemberByLoginId(loginId);
	}
	
}
