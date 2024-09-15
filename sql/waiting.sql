-- 재귀 깊이를 늘려서 더 많은 데이터를 생성할 수 있도록 설정 (MySQL 8.0 이상)
SET SESSION cte_max_recursion_depth = 1000000;

-- Waiting 테이블에 100만 건의 더미 데이터 삽입
INSERT INTO waiting (people_count, canceled_time, created_date, customer_id, id, store_id, visited_time, waiting_number, waiting_order, customer_phone, waiting_status)
WITH RECURSIVE cte AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 1000000
)
SELECT
    FLOOR(RAND() * 10) + 1 AS people_count, -- 인원 수 (랜덤하게 1~10명)
    NULL AS canceled_time, -- 취소된 날짜 (NULL 값으로 설정)
    CURRENT_TIMESTAMP - INTERVAL FLOOR(RAND() * 10) DAY AS created_date, -- 생성된 날짜 (랜덤하게 0~9일 전)
    FLOOR(RAND() * 100000) + 1 AS customer_id, -- 고객 ID (랜덤하게 1~100001 범위)
    n AS id, -- 기본 키 ID (1부터 1000000까지 순차적으로 생성)
    FLOOR(RAND() * 1000) + 1 AS store_id, -- 매장 ID (랜덤하게 1~1000 범위)
    CURRENT_TIMESTAMP - INTERVAL FLOOR(RAND() * 10) DAY AS visited_time, -- 방문 시간 (랜덤하게 0~9일 전)
    FLOOR(RAND() * 100000) + 1 AS waiting_number, -- 대기 번호 (랜덤하게 1~100000 범위)
    FLOOR(RAND() * 100000) + 1 AS waiting_order, -- 대기 순서 (랜덤하게 1~100000 범위)
    CONCAT('010-', LPAD(FLOOR(RAND() * 10000), 4, '0'), '-', LPAD(FLOOR(RAND() * 10000), 4, '0')) AS customer_phone, -- 고객 전화번호 (랜덤하게 생성)
    ELT(FLOOR(RAND() * 5) + 1, 'CUSTOMER_CANCELED', 'NO_SHOW', 'SHOP_CANCELED', 'VISITED', 'WAITING') AS waiting_status -- 대기 상태 (랜덤하게 선택)
FROM cte;

select id, waiting_order
from waiting
where store_id ='1' and waiting_status='WAITING'
order by waiting_order;

ALTER TABLE waiting MODIFY id BIGINT NOT NULL;
ALTER TABLE waiting MODIFY id BIGINT NOT NULL AUTO_INCREMENT;
ALTER TABLE waiting AUTO_INCREMENT = 1000001;
SHOW TABLE STATUS LIKE 'waiting';
SHOW CREATE TABLE waiting;

ALTER TABLE waiting DROP PRIMARY KEY;


select id,waiting_number
from waiting
where waiting_status='WAITING' and customer_id=3
order by created_date desc ;


