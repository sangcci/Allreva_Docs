-- before query split
SELECT r.id, rbs.date, rbs.recruitment_count, rbs.passenger_count, rp.id, rp.passenger_num
FROM rent AS r
LEFT JOIN rent_boarding_slots AS rbs ON r.id = rbs.rent_id
LEFT JOIN rent_participants AS rp ON r.id = rp.rent_id AND rbs.date = rp.boarding_date
WHERE rp.member_id = 1;

-- after query split
SELECT r.id, rbs.date, rbs.recruitment_count, rbs.passenger_count
FROM rent AS r
LEFT JOIN rent_boarding_slots AS rbs ON r.id = rbs.rent_id
WHERE r.id = 1;

-- 최신 순 조회
EXPLAIN (ANALYZE, BUFFERS)
SELECT rp.boarding_date, rp.rent_id, rp.member_id, rp.id, rp.passenger_num
FROM rent_participants AS rp
WHERE rp.member_id = 1
ORDER BY rp.boarding_date DESC
LIMIT 10 OFFSET 1000;
-- 애초에 3만개를 한번에 조회하진 않을거임. 페이징 처리로 인해 최대 10개 정도?

-- 그래도 55.462ms 나옴
CREATE INDEX idx_rent_participants_member_id ON rent_participants (member_id)

SELECT COUNT(*)
FROM rent_participants AS rp
WHERE rp.member_id = 1;

-- Deferred Join - SELECT할 column 커버링 인덱스 모두 필요.. 복합 인덱스 값이 많아질수록 복잡함. Covering Index도 있어야 하니 정렬해줘야함.
EXPLAIN (ANALYZE, BUFFERS)
SELECT rp.boarding_date, rp.rent_id, rp.member_id, rp.id, rp.passenger_num
FROM rent_participants rp
INNER JOIN (
    SELECT id
    FROM rent_participants
    WHERE member_id = 1
    ORDER BY boarding_date DESC
    LIMIT 10 OFFSET 1000
) AS subq ON rp.id = subq.id
ORDER BY rp.boarding_date DESC;

-- 무한스크롤 방식 사용 - 커버링 인덱스, JOIN 필요없이 그냥 INDEX만 있으면 됨.
EXPLAIN (ANALYZE, BUFFERS)
SELECT rp.boarding_date, rp.rent_id, rp.member_id, rp.id, rp.passenger_num
FROM rent_participants AS rp
WHERE rp.member_id = 1 AND (boarding_date, id) < ('2025-09-21', 925107)
ORDER BY rp.boarding_date DESC, rp.id DESC
LIMIT 10;

CREATE INDEX idx_rent_participants ON rent_participants(member_id, boarding_date, id);