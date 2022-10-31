package com.kjh.exam.demo.controller;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;

import com.kjh.exam.demo.service.ReplyService;
import com.kjh.exam.demo.vo.Rq;

@Controller
public class UsrReplyController {

	@Autowired
	private ReplyService replyService;
	@Autowired
	private Rq rq;

	@RequestMapping("/usr/reply/addReply")
	public String addReply(String relTypeCode, int relId,String body) {
		
		replyService.addReply(relTypeCode,relId,body);
		
		

		return rq.jsReplace(relTypeCode, body);
	}
}