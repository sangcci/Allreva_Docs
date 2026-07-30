import http from "k6/http";
import { check } from "k6";

// const BASE_URL = 'https://allreva.site';
const BASE_URL = "http://localhost:8080";
const VUS = 100;

// nginx Basic Auth 설정 시 필요 (username:password를 base64 인코딩)
// 예: btoa('admin:password') → 'YWRtaW46cGFzc3dvcmQ='
const BASIC_AUTH = "Basic YWRtaW46MTIzNA==";

// dummy-data.sql로 삽입된 첫 번째 member id
// SELECT id FROM member WHERE email = 'loadtest1@test.com';
const FIRST_MEMBER_ID = 1;

export const options = {
  scenarios: {
    concurrent_apply: {
      executor: "shared-iterations",
      vus: VUS, // 동시 실행 VU 수
      iterations: VUS, // 전체 요청 수 (VU당 딱 1번)
      maxDuration: "30s",
    },
  },
};

// 테스트 시작 전 VU별 토큰 미리 발급
export function setup() {
  const tokens = [];
  for (let i = 0; i < VUS; i++) {
    const memberId = FIRST_MEMBER_ID + i;
    const res = http.get(
      `${BASE_URL}/api/test/token/${memberId}`,
      // {
      //   headers: { Authorization: BASIC_AUTH },
      // }
    );
    tokens.push(res.body);
  }
  return { tokens };
}

export default function ({ tokens }) {
  const rawToken = tokens[__VU - 1];
  const token = "Bearer " + rawToken;

  const res = http.post(
    `${BASE_URL}/api/v1/rents/join`,
    JSON.stringify({
      rentId: 1,
      boardingDate: "2026-07-01",
      passengerNum: 1,
      depositorName: "테스트",
      depositorTime: "10:00",
      phone: "010-1234-5678",
      refundType: "REFUND",
      refundAccount: "1234-5678",
    }),
    {
      headers: {
        "Content-Type": "application/json",
        Authorization: token,
      },
    },
  );
  console.log(
    `VU=${__VU} | connecting=${res.timings.connecting}ms | waiting=${res.timings.waiting}ms | duration=${res.timings.duration}ms`,
  );

  check(res, { "status is 200": (r) => r.status === 200 });
}
