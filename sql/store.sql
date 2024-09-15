
SET SESSION cte_max_recursion_depth = 1000;

-- store 테이블에 1000개의 더미 데이터 삽입
INSERT INTO store (
    close_time, end_break_time, estimated_waiting_time, last_order,
    max_reservation_in_day, max_reservation_in_time, open_time,
    reservation_close_time, reservation_open_time, star_rating,
    start_break_time, waiting_close_time, waiting_open_time,
    waiting_people_count, description, notice, phone,
    regular_day_off, store_address, store_name, thumbnail,
    reservation_status, store_type, waiting_status
)
WITH RECURSIVE cte AS (
    SELECT 1 AS n
    UNION ALL
    SELECT n + 1 FROM cte WHERE n < 1000
)
SELECT
    SEC_TO_TIME(FLOOR(RAND() * 86400)) AS close_time, -- 닫는 시간 (랜덤하게 00:00:00 ~ 23:59:59)
    SEC_TO_TIME(FLOOR(RAND() * 86400)) AS end_break_time, -- 종료 시간 (랜덤하게 00:00:00 ~ 23:59:59)
    SEC_TO_TIME(FLOOR(RAND() * 86400)) AS estimated_waiting_time, -- 예상 대기 시간 (랜덤하게 00:00:00 ~ 23:59:59)
    SEC_TO_TIME(FLOOR(RAND() * 86400)) AS last_order, -- 마지막 주문 시간 (랜덤하게 00:00:00 ~ 23:59:59)
    FLOOR(RAND() * 100) + 1 AS max_reservation_in_day, -- 하루 최대 예약 수 (1~100)
    FLOOR(RAND() * 10) + 1 AS max_reservation_in_time, -- 시간당 최대 예약 수 (1~10)
    SEC_TO_TIME(FLOOR(RAND() * 86400)) AS open_time, -- 열리는 시간 (랜덤하게 00:00:00 ~ 23:59:59)
    SEC_TO_TIME(FLOOR(RAND() * 86400)) AS reservation_close_time, -- 예약 종료 시간 (랜덤하게 00:00:00 ~ 23:59:59)
    SEC_TO_TIME(FLOOR(RAND() * 86400)) AS reservation_open_time, -- 예약 시작 시간 (랜덤하게 00:00:00 ~ 23:59:59)
    ROUND(RAND() * 5, 1) AS star_rating, -- 별점 (랜덤하게 0.0 ~ 5.0)
    SEC_TO_TIME(FLOOR(RAND() * 86400)) AS start_break_time, -- 휴식 시작 시간 (랜덤하게 00:00:00 ~ 23:59:59)
    SEC_TO_TIME(FLOOR(RAND() * 86400)) AS waiting_close_time, -- 대기 종료 시간 (랜덤하게 00:00:00 ~ 23:59:59)
    SEC_TO_TIME(FLOOR(RAND() * 86400)) AS waiting_open_time, -- 대기 시작 시간 (랜덤하게 00:00:00 ~ 23:59:59)
    FLOOR(RAND() * 50) + 1 AS waiting_people_count, -- 대기 인원 수 (랜덤하게 1~50)
    CONCAT('Description for store ', n) AS description, -- 매장 설명 (예시)
    CONCAT('Notice for store ', n) AS notice, -- 공지사항 (예시)
    CONCAT('010-', LPAD(FLOOR(RAND() * 10000), 4, '0'), '-', LPAD(FLOOR(RAND() * 10000), 4, '0')) AS phone, -- 전화번호 (랜덤하게 생성)
    ELT(FLOOR(RAND() * 7) + 1, 'Monday', 'Tuesday', 'Wednesday', 'Thursday', 'Friday', 'Saturday', 'Sunday') AS regular_day_off, -- 정기 휴무일 (랜덤하게 선택)
    CONCAT('Address for store ', n) AS store_address, -- 매장 주소 (예시)
    CONCAT('Store Name ', n) AS store_name, -- 매장 이름 (예시)
    CONCAT('thumbnail_', n, '.jpg') AS thumbnail, -- 썸네일 (예시)
    ELT(FLOOR(RAND() * 2) + 1, 'OFF', 'ON') AS reservation_status, -- 예약 상태 (랜덤하게 선택)
    ELT(FLOOR(RAND() * 3) + 1, 'CUSTOM', 'GENERAL_RESERVATION', 'GENERAL_WAITING') AS store_type, -- 매장 유형 (랜덤하게 선택)
    ELT(FLOOR(RAND() * 3) + 1, 'CLOSE', 'OPEN', 'UNAVAILABLE') AS waiting_status -- 대기 상태 (랜덤하게 선택)
FROM cte;