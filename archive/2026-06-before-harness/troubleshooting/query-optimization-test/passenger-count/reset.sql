-- ============================================================
-- Query Optimization Test: 테스트 데이터 전체 삭제
-- QTEST_ 접두어로 식별 → load-test 데이터에 영향 없음
-- ============================================================

BEGIN;

-- ① participants 먼저 삭제 (rent 참조)
DELETE FROM rent_participants
WHERE rent_id IN (
    SELECT id FROM rent WHERE title LIKE 'QTEST_RENT_%'
);

-- ② boarding slots 삭제
DELETE FROM rent_boarding_slots
WHERE rent_id IN (
    SELECT id FROM rent WHERE title LIKE 'QTEST_RENT_%'
);

-- ③ rent 삭제
DELETE FROM rent WHERE title LIKE 'QTEST_RENT_%';

COMMIT;


-- ============================================================
-- 삭제 결과 확인
-- ============================================================
-- SELECT COUNT(*) FROM rent WHERE title LIKE 'QTEST_RENT_%';  -- 0
