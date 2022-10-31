package com.kjh.exam.demo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kjh.exam.demo.repository.ReplyRepository;
import com.kjh.exam.demo.vo.Reply;

@Service
public class ReplyService {

	@Autowired
	private ReplyRepository replyRepository;
	
	public List<Reply> getRepliesByArticle(int relId) {
		
		return replyRepository.getRepliesByArticle(relId);
	}

}
