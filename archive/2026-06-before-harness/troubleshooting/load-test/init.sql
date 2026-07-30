INSERT INTO
  member (
    email,
    role,
    provider,
    nickname,
    introduce,
    profile_image_url,
    refund_account,
    created_at,
    updated_at,
    deleted_at
  )
SELECT
  'loadtest' || i || '@test.com',
  'USER',
  'KAKAO',
  '테스트유저' || i,
  '',
  'https://example.com/profile.jpg',
  '국민은행,12345678',
  NOW (),
  NOW (),
  NULL 
FROM
  generate_series (1, 100) AS i;

-- SELECT id FROM member WHERE email LIKE 'loadtest%' ORDER BY id;
INSERT INTO
  rent (
    member_id,
    concert_code,
    title,
    image,
    region,
    boarding_type,
    up_boarding_area,
    up_drop_off_area,
    up_time,
    down_boarding_area,
    down_drop_off_area,
    down_time,
    bus_size,
    bus_type,
    max_passenger,
    price,
    end_date,
    information,
    is_closed,
    created_at,
    updated_at,
    deleted_at
  )
VALUES
  (
    1,
    'TEST-CONCERT-001',
    '테스트 차대절',
    'https://example.com/rent.jpg',
    '서울',
    'ROUND',
    '서울역 앞',
    '공연장 앞',
    '10:00',
    '공연장 앞',
    '서울역 앞',
    '22:00',
    'LARGE',
    'STANDARD',
    45,
    50000,
    '2030-11-30',
    '테스트 차대절 정보',
    false,
    NOW (),
    NOW (),
    NULL
  );

INSERT INTO
  rent_boarding_slots (
    rent_id,
    date,
    recruitment_count,
    passenger_count,
    created_at,
    updated_at,
    deleted_at
  )
VALUES
  (1, '2026-07-01', 50, 0, NOW (), NOW (), NULL);
