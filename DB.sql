#DB 생성
DROP DATABASE IF EXISTS SB_AM;
CREATE DATABASE SB_AM;
USE SB_AM;

# 게시물 테이블 생성
CREATE TABLE article(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    title CHAR(100) NOT NULL,
    `body` TEXT NOT NULL
);

# 게시물 테스트데이터 생성
INSERT INTO article 
SET regDate = NOW(),
updateDate = NOW(),
title = '제목 1',
`body` = '내용 1';

INSERT INTO article 
SET regDate = NOW(),
updateDate = NOW(),
title = '제목 2',
`body` = '내용 2';

INSERT INTO article 
SET regDate = NOW(),
updateDate = NOW(),
title = '제목 3',
`body` = '내용 3';

# 회원 테이블 생성
CREATE TABLE `member`(
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    loginId CHAR(20) NOT NULL,
    loginPw CHAR(60) NOT NULL,
    `authLevel` SMALLINT(2) UNSIGNED DEFAULT 3 COMMENT '권한 레벨 (3=일반,7=관리자)',
    `name` CHAR(20) NOT NULL, 
    nickname CHAR(20) NOT NULL,
    cellphoneNum CHAR(20) NOT NULL,
    email CHAR(50) NOT NULL,
    delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '탈퇴여부 (0=탈퇴 전,1=탈퇴 후)',
    delDate DATETIME COMMENT '탈퇴날짜'
);

# 회원 테스트데이터 생성 (관리자)
INSERT INTO `member` 
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'admin',
loginPw = 'admin',
`authLevel` = 7,
`name` = '관리자', 
nickname = '관리자',
cellphoneNum = '01012341234',
email = 'kginyc5500@gmail.com';

# 회원 테스트데이터 생성 (일반)
INSERT INTO `member` 
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test1',
loginPw = 'test1',
`name` = '사용자1', 
nickname = '사용자1',
cellphoneNum = '01043214321',
email = 'kginyc5501@gmail.com';

INSERT INTO `member` 
SET regDate = NOW(),
updateDate = NOW(),
loginId = 'test2',
loginPw = 'test2',
`name` = '사용자2', 
nickname = '사용자2',
cellphoneNum = '01067896789',
email = 'kginyc5502@gmail.com';

SELECT * FROM `member`;

SELECT * FROM article;

# 게시물 테이블에 회원번호 칼럼 추가
ALTER TABLE article ADD COLUMN memberId INT(10) UNSIGNED NOT NULL AFTER `updateDate`;

UPDATE article
SET memberId = 2
WHERE memberId = 0;

# 게시판 테이블 생성
CREATE TABLE board (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    `code` CHAR(50) NOT NULL UNIQUE COMMENT 'notice(공지사항), free1(자유게시판1), free2(자유게시판2),..',
    `name` CHAR(50) NOT NULL UNIQUE COMMENT '게시판 이름',
    delStatus TINYINT(1) UNSIGNED NOT NULL DEFAULT 0 COMMENT '삭제여부 (0=삭제 전,1=삭제 후)',
    delDate DATETIME COMMENT '삭제날짜'
);

# 기본 게시판 생성
INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'notice',
`name` = '공지사항';

INSERT INTO board
SET regDate = NOW(),
updateDate = NOW(),
`code` = 'free1',
`name` = '자유게시판';

# 게시물 테이블에 boardId 칼럼 추가
ALTER TABLE article ADD COLUMN boardId INT(10) UNSIGNED NOT NULL AFTER `memberId`;

# 1,2 번 게시물을 공지사항 게시물로 수정
UPDATE article
SET boardId = 1
WHERE id IN (1,2);

# 3 번 게시물을 자유게시판 게시물로 수정
UPDATE article
SET boardId = 2
WHERE id IN (3);


 # 게시물 갯수 늘리기
INSERT INTO article
(
	regDate, updateDate, memberId, boardId, title, `body`
)
SELECT NOW(), NOW(), FLOOR(RAND() * 2) + 1, FLOOR(RAND() * 2) + 1, CONCAT('제목_',RAND()), CONCAT('내용_',RAND())
FROM article;

SELECT COUNT(*) FROM article;

SELECT LAST_INSERT_ID();
SELECT * FROM board;

# 추천 테이블 생성
CREATE TABLE reactionPoint (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    memberId INT(10) UNSIGNED NOT NULL,
    relTypeCode CHAR(50) NOT NULL COMMENT '관련 데이터 타입 코드',
	relId INT(10) UNSIGNED NOT NULL COMMENT '관련 데이터  번호',
    `point` SMALLINT(2) NOT NULL
);

# reactionPoint 테스트 데이터
# 1번 회원이 1번 article 에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'article',
relId = 1,
`point` = -1;

# 1번 회원이 2번 article 에 좋아요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 1,
relTypeCode = 'article',
relId = 2,
`point` = 1;

# 2번 회원이 1번 article 에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 1,
`point` = -1;

# 2번 회원이 2번 article 에 싫어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 2,
relTypeCode = 'article',
relId = 2,
`point` = 1;

# 3번 회원이 1번 article 에 좋어요
INSERT INTO reactionPoint
SET regDate = NOW(),
updateDate = NOW(),
memberId = 3,
relTypeCode = 'article',
relId = 1,
`point` = 1;

SELECT * FROM reactionPoint;

# 게시물 테이블에 goodReactionPoint 칼럼 추가
ALTER TABLE article ADD COLUMN goodReactionPoint INT(10) UNSIGNED NOT NULL DEFAULT 0;

# 게시물 테이블에 badReactionPoint 칼럼 추가
ALTER TABLE article ADD COLUMN badReactionPoint INT(10) UNSIGNED NOT NULL DEFAULT 0;

# 기존 게시물의 goodReactionPoint,badReactionPoint 필드의 값 채워주기
UPDATE article AS A
INNER JOIN (
	SELECT RP.relTypeCode, RP.relId,
	SUM(IF(RP.point > 0, RP.point, 0)) AS goodReactionPoint,
	SUM(IF(RP.point < 0, RP.point * -1, 0)) AS badReactionPoint
	FROM reactionPoint AS RP
	GROUP BY RP.relTypeCode, RP.relId
) AS RP_SUM
ON A.id = RP_SUM.relId
SET A.goodReactionPoint = RP_SUM.goodReactionPoint,
A.badReactionPoint = RP_SUM.badReactionPoint;

# reply 테이블
CREATE TABLE reply (
    id INT(10) UNSIGNED NOT NULL PRIMARY KEY AUTO_INCREMENT,
    regDate DATETIME NOT NULL,
    updateDate DATETIME NOT NULL,
    memberId INT(10) UNSIGNED NOT NULL,
    relTypeCode CHAR(50) NOT NULL COMMENT '관련 데이터 타입 코드',
	relId INT(10) UNSIGNED NOT NULL COMMENT '관련 데이터  번호',
	`comment` VARCHAR(100) NOT NULL
	class TINYINT NOT NULL COMMENT '댓글 대댓글 계층 번호'
);
#######################################################

/*
# 게시물 갯수 늘리기
insert into article
(
	regDate, updateDate, memberId, boardId, title, `body`
)
select now(), now(), FLOOR(RAND() * 2) + 1, FLOOR(RAND() * 2) + 1, concat('제목_',rand()), CONCAT('내용_',RAND())
from article;
*/

/*
--> getArticles
select A.*, 
IFNULL(SUM(RP.point),0) AS extra__sumReactionPoint,
IFNULL(SUM(if(RP.point > 0, RP.point, 0)),0) AS extra__goodReactionPoint,
IFNULL(SUM(IF(RP.point < 0, RP.point, 0)),0) AS extra__badReactionPoint
from (
	SELECT A.*, M.nickname AS extra__writerName
	FROM article AS A
	LEFT JOIN `member` AS M
	ON A.memberId= M.id 
			) As A
left JOIN reactionPoint AS RP
ON RP.relTypeCode = 'article'
and A.id = RP.relId
group by A.id

*/
/*
--> getArticle
SELECT A.*, M.nickname AS extra__writerName,
IFNULL(SUM(RP.point),0) AS extra__sumReactionPoint,
IFNULL(SUM(if(RP.point > 0, RP.point, 0)),0) AS extra__goodReactionPoint,
IFNULL(SUM(IF(RP.point < 0, RP.point, 0)),0) AS extra__badReactionPoint
FROM article AS A
LEFT JOIN `member` AS M
ON A.memberId = M.id
LEFT JOIN reactionPoint AS RP
on RP.relTypeCode = 'article'
and A.id = RP.relId
WHERE A.id =1
GROUP BY A.id
*/

/*
select ifnull(sum(RP.point),0) as s
from reactionPoint AS RP
where RP.relTypeCode = 'article'
AND RP.relId = 2
and RP.memberId = 2
*/

/*
--> 각 게시물 별, 좋아요, 싫어요 총합
select RP.relTypeCode, RP.relId,
sum(if(RP.point > 0, RP.point, 0)) as goodReactionPoint,
sum(IF(RP.point < 0, RP.point * -1, 0)) AS badReactionPoint
from reactionPoint as RP
group by RP.relTypeCode, RP.relId
*/

/*
SELECT *
FROM reactionPoint AS RP
GROUP BY RP.relTypeCode, RP.relId
*/

SELECT * FROM article;

SELECT * FROM reactionPoint;

DESC article;
SELECT LAST_INSERT_ID();
