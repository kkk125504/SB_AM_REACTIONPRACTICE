<%@ page language="java" contentType="text/html; charset=UTF-8" pageEncoding="UTF-8"%>
<%@ taglib uri="http://java.sun.com/jsp/jstl/core" prefix="c"%>
<c:set var="pageTitle" value="ARTICLE" />
<%@ include file="../common/head.jspf" %>
	<script>
		const params = {};
		params.id = parseInt('${param.id}');
	</script>
	
	<script>
		function ArticleDetail__increaseHitCount() {
			const localStorageKey = 'article__' + params.id + '__alreadyView';
			
			if(localStorage.getItem(localStorageKey)){
				return;
			}
			
			localStorage.setItem(localStorageKey,true);
			
			$.get('../article/doIncreaseHitCountRd', {
				id : params.id,
				ajaxMode : 'Y'
			}, function(data) {
				$('.article-detail__hit-count').empty().html(data.data1);
			}, 'json');			
		}
		
		function goodReactionPoint() {
			if(${rq.isLogined()==false}){
				alert('로그인 후 이용 가능합니다.');
				return;
			}						
			$.get('../reactionPoint/doGoodReaction', {
				relId : params.id,
				relTypeCode : 'article',
				ajaxMode : 'Y'
			}, function(data) {
				if(data.fail){
					alert(data.msg);
					return;					
				}
				if(data.resultCode=='S-2'){
					$('.good').addClass('btn-outline');
				}
				
				if(data.resultCode=='S-1'){
					$('.good').removeClass('btn-outline');
				}
				
				$('.good').empty().html('좋아요 👍 : '+data.data1);	
				
			}, 'json');		
		}
		function badReactionPoint() {
			if(${rq.isLogined()==false}){
				alert('로그인 후 이용 가능합니다.');
				return;
			}						
			$.get('../reactionPoint/doBadReaction', {
				relId : params.id,
				relTypeCode : 'article',
				ajaxMode : 'Y'
			}, function(data) {
				if(data.fail){
					alert(data.msg);
					return;					
				}
				if(data.resultCode=='S-2'){
					$('.bad').addClass('btn-outline');
				}
				
				if(data.resultCode=='S-1'){
					$('.bad').removeClass('btn-outline');
				}
				
				$('.bad').empty().html('싫어요 👎 : '+data.data1);	
				
			}, 'json');		
		}
		
		
		function selectedReactionPoint() {
			if(${isSelectedGoodReactionPoint}){ 
				$('.good').removeClass('btn-outline');
			}
			if(${isSelectedBadReactionPoint}){ 
				$('.bad').removeClass('btn-outline');
			}
		}
		$(function() {
			// 실전코드
			//ArticleDetail__increaseHitCount();
			// 연습코드
			selectedReactionPoint();
			setTimeout(ArticleDetail__increaseHitCount, 2000);
		})
	</script>
	<section class="mt-8 text-xl">
		<div class="container mx-auto px-3">
			<div class="table-box-type-1">
				<table>
					<colgroup>
						<col width="200" />
					</colgroup>	
					<tbody>		
						<tr>
							<td class="bg-gray-200">번호</td><td><span class="badge">${article.id }</span></td>						
						</tr>
						<tr>
							<td class="bg-gray-200">작성날짜</td><td>${article.regDate }</td>						
						</tr>
						<tr>
							<td class="bg-gray-200">수정날짜</td><td>${article.updateDate }</td>						
						</tr>
						<tr>
							<td class="bg-gray-200">제목</td><td>${article.title }</td>						
						</tr>
						<tr>
							<td class="bg-gray-200">내용</td><td>${article.body }</td>						
						</tr>
						<tr>
							<td class="bg-gray-200">작성자</td><td>${article.extra__writer }</td>						
						</tr>
						<tr>
							<td class="bg-gray-200">조회수</td>
							<td>
							<span class="badge article-detail__hit-count">${article.hitCount }</span>
							   
							</td>						
						</tr>
						<tr>
							<td class="bg-gray-200">추천 수</td>
							<td>						
								<span>&nbsp;</span>
									<button onclick="goodReactionPoint()" class="btn btn-outline btn-xs good">좋아요 👍 : ${article.goodReactionPoint}</button>
								<span>&nbsp;</span>
									<button onclick="badReactionPoint()" class="btn btn-outline btn-xs bad">싫어요 👎 : ${article.badReactionPoint}</button>				
							</td>						
						</tr>
					</tbody>								
				</table>
			</div>
				
			<div class= "btns flex justify-end">					
				<c:if test= "${article.extra__actorCanDelete}" >					
					<a class ="mx-4 btn-text-link btn btn-active btn-ghost" href="modify?id=${article.id }">수정</a>				
				</c:if>	
				
				<c:if test= "${article.extra__actorCanDelete}" >
					<a class ="btn-text-link btn btn-active btn-ghost" onclick="if(confirm('삭제하시겠습니까?') == false) return false;" href="doDelete?id=${article.id }">삭제</a>								
				</c:if>
<!-- 				뒤로가기버튼			
					<button class ="btn-text-link btn btn-active btn-ghost mx-4" type="button" onclick="history.back()">뒤로가기</button> -->				
			</div>
			<div class="replies-box w-full flex">
				<span>댓글!</span>
				<div class="replies ">
					
				</div>
			</div>
			<div class="addReply">
				<c:if test="${rq.isLogined()}">
					<textarea name="reply" id="" cols="50" rows="5" class="textarea textarea-bordered" placeholder="댓글을 남겨보세요."></textarea>
				</c:if>
			</div>		
		</div>
	</section>
<%@ include file="../common/foot.jspf" %>