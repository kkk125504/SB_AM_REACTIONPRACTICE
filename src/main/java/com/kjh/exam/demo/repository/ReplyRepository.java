package com.kjh.exam.demo.repository;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Select;

import com.kjh.exam.demo.vo.Reply;

@Mapper
public interface ReplyRepository {
	
	@Select("""
			<script>
			SELECT RE.*, M.nickname AS extra__replyWriter 
			FROM reply AS RE
			LEFT JOIN `member` AS M
			ON RE.memberId = M.id
			WHERE RE.relTypeCode ='reply'
			AND	RE.relId = #{relId}
			</script>
			""")
	List<Reply> getRepliesByArticle(int relId);

}
