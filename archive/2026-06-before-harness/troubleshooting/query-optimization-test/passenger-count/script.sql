EXPLAIN ANALYZE
SELECT r.id, rbs.date, rbs.recruitment_count, SUM(rp.passenger_num)
FROM rent AS r
LEFT JOIN rent_boarding_slots AS rbs ON r.id = rbs.rent_id
LEFT JOIN rent_participants AS rp ON rp.rent_id = r.id AND rbs.date = rp.boarding_date
WHERE r.id = 1 AND rbs.date = '2025-09-11' AND r.member_id = 1
GROUP BY r.id, rbs.date, rbs.recruitment_count;

-- create index
CREATE INDEX idx_rent_boarding_slots_rent_id_boarding_date ON rent_boarding_slots (rent_id, boarding_date);
CREATE INDEX idx_rent_participants_rent_id_boarding_date ON rent_participants (rent_id, boarding_date);

-- Denomalization
EXPLAIN ANALYZE
SELECT r.id, rbs.date, rbs.recruitment_count, rbs.passenger_count
FROM rent AS r
LEFT JOIN rent_boarding_slots AS rbs ON r.id = rbs.rent_id
WHERE r.id = 1 AND rbs.date = '2025-09-11' AND r.member_id = 1;

