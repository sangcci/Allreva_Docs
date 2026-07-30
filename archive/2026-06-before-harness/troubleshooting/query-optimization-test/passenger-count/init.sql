-- ============================================================
-- Query Optimization Test: 대용량 테스트 데이터 삽입
-- 목적: Aggregation Query vs 역정규화(passenger_count) 성능 비교
--
-- 사전 조건: load-test/init.sql 실행 필요 (loadtest1~100 member 생성)
--
-- 데이터 규모:
--   rent               :  10,000건
--   rent_boarding_slots:  30,000건 (rent당 3개 날짜)
--   rent_participants  : 1,020,000건 (slot당 34건)
--
-- 실행 후 k6 스크립트에 입력할 ID 확인:
--   SELECT min(id) FROM rent WHERE title LIKE 'QTEST_RENT_%';
--   SELECT min(id) FROM member WHERE email LIKE 'loadtest%';
-- ============================================================

BEGIN;

-- ① rent 10,000건
INSERT INTO rent (
    member_id, concert_id,
    title, image, artist_name, region,
    deposit_account, boarding_area, up_time, down_time,
    bus_size, bus_type, max_passenger,
    round_price, up_time_price, down_time_price,
    eddate, chat_url, refund_type, information, is_closed,
    created_at, updated_at
)
SELECT
    ((i - 1) % 100) + 1,              -- member_id: loadtest 멤버 1~100 순환
    1,                                 -- concert_id (dummy)
    'QTEST_RENT_' || i,
    'https://image.example.com/' || i,
    'QTEST_ARTIST',
    '서울',
    '국민은행,12345678',
    '서울역',
    '09:00',
    '23:00',
    'LARGE',
    'STANDARD',
    40,
    15000,
    10000,
    10000,
    '2026-12-31',
    'https://chat.example.com/' || i,
    'REFUND',
    'Query Optimization Test Data',
    false,
    NOW(),
    NOW()
FROM generate_series(1, 10000) AS i;


-- ② rent_boarding_slots 30,000건 (rent당 3개 날짜: 09-01, 09-11, 09-21)
--    passenger_count = 34 로 미리 역정규화 값 세팅 (participants 34건과 일치)
INSERT INTO rent_boarding_slots (rent_id, date, recruitment_count, passenger_count, created_at, updated_at)
SELECT
    r.id,
    DATE '2025-09-01' + (d * INTERVAL '10 days'),
    40,
    34,
    NOW(),
    NOW()
FROM (SELECT id FROM rent WHERE title LIKE 'QTEST_RENT_%' ORDER BY id) r
CROSS JOIN generate_series(0, 2) AS d;


-- ③ rent_participants 1,020,000건 (slot당 34건, member_id 1~34 순환)
--    주의: 완료까지 수 분 소요될 수 있음
INSERT INTO rent_participants (
    rent_id, member_id, boarding_date, passenger_num,
    boarding_type, depositor_name, depositor_time,
    phone, refund_account, refund_type,
    created_at, updated_at
)
SELECT
    s.rent_id,
    ((p - 1) % 34) + 1,               -- member_id: 1~34 순환 (loadtest 멤버 기준)
    s.date,
    1,
    'ROUND',
    'QTEST_USER_' || p,
    '10:00',
    '010-1234-5678',
    '국민은행,12345678',
    'REFUND',
    NOW(),
    NOW()
FROM (
    SELECT rbs.rent_id, rbs.date
    FROM rent_boarding_slots rbs
    JOIN rent r ON rbs.rent_id = r.id
    WHERE r.title LIKE 'QTEST_RENT_%'
) s
CROSS JOIN generate_series(1, 34) AS p;

COMMIT;


-- ============================================================
-- 삽입 결과 확인
-- ============================================================
-- SELECT COUNT(*) FROM rent WHERE title LIKE 'QTEST_RENT_%';
-- SELECT COUNT(*) FROM rent_boarding_slots rbs JOIN rent r ON rbs.rent_id = r.id WHERE r.title LIKE 'QTEST_RENT_%';
-- SELECT COUNT(*) FROM rent_participants rp JOIN rent r ON rp.rent_id = r.id WHERE r.title LIKE 'QTEST_RENT_%';
