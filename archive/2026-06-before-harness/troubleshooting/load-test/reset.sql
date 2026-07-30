-- rent_participants 실제 삭제 + 시퀀스 초기화
DELETE FROM rent_participants
WHERE
  rent_id = 1;

ALTER TABLE rent_participants
ALTER COLUMN id
RESTART WITH 1;

-- 슬롯 카운트 초기화
UPDATE rent_boarding_slots
SET
  passenger_count = 0
WHERE
  rent_id = 1
  AND date = '2026-07-01';
