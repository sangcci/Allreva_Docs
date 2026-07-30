- `api`: 서버 Servlet Context Path
- `v1`: API 버전 관리
- swagger: [swagger 문서](https://allreva.site/swagger-ui/index.html) (Local: http://localhost:8080/swagger-ui/index.html)

"화면 용어 차용" 자체는 맞는 방향이지만, 화면명(main, detail-page)보단 그 화면이 요구하는 데이터 의미(suggestions, summary)로 한단계 추상화하는 걸 추천. 화면이 바뀌어도 데이터 의미는 잘 안 바뀌니까.

## API 목록

| 분류 | 메서드 | 경로 | 설명 |
| :--- | :--- | :--- | :--- |
| 공연 API | GET | /api/v1/concerts | 공연장 관련 공연 목록 조회 |
| 공연 API | GET | /api/v1/concerts/main | 메인 콘서트 목록 조회 |
| 공연 API | GET | /api/v1/concerts/search | 콘서트 검색 목록 조회 |
| 공연 API | GET | /api/v1/concerts/suggestions | 콘서트 자동완성 제안 |
| 공연 API | GET | /api/v1/concerts/{concertCode} | 공연 상세 조회 |
| 공연장 API | GET | /api/v1/concert-halls/{hallCode} | 공연장 상세 조회 |
| 수요조사 API | DELETE | /api/v1/surveys | 수요조사 삭제 |
| 수요조사 API | DELETE | /api/v1/surveys/apply/{participantId} | 수요조사 참여 취소 |
| 수요조사 API | GET | /api/v1/surveys/list | 수요조사 목록 조회 |
| 수요조사 API | GET | /api/v1/surveys/main | 메인 수요조사 목록 조회 |
| 수요조사 API | GET | /api/v1/surveys/member/apply/list | 내가 참여한 수요조사 목록 조회 |
| 수요조사 API | GET | /api/v1/surveys/member/list | 내가 개설한 수요조사 목록 조회 |
| 수요조사 API | GET | /api/v1/surveys/search | 수요조사 검색 목록 조회 |
| 수요조사 API | GET | /api/v1/surveys/suggestions | 수요조사 자동완성 제안 |
| 수요조사 API | GET | /api/v1/surveys/{surveyId} | 수요조사 상세 조회 |
| 수요조사 API | PATCH | /api/v1/surveys | 수요조사 수정 |
| 수요조사 API | POST | /api/v1/surveys | 수요조사 개설 |
| 수요조사 API | POST | /api/v1/surveys/apply | 수요조사 참여 |
| 차 대절 API | DELETE | /api/v1/rents | 차 대절 삭제 |
| 차 대절 API | DELETE | /api/v1/rents/join | 차 대절 참여 취소 |
| 차 대절 API | GET | /api/v1/rents/list | 차 대절 목록 조회 |
| 차 대절 API | GET | /api/v1/rents/me/hosted | 내가 개설한 차 대절 목록 조회 |
| 차 대절 API | GET | /api/v1/rents/me/hosted/{id} | 내가 개설한 차 대절 상세 조회 |
| 차 대절 API | GET | /api/v1/rents/me/joined | 내가 참여한 차 대절 목록 조회 |
| 차 대절 API | GET | /api/v1/rents/me/joined/{id} | 내가 참여한 차 대절 상세 조회 |
| 차 대절 API | GET | /api/v1/rents/search | 차 대절 검색 목록 조회 |
| 차 대절 API | GET | /api/v1/rents/suggestions | 차 대절 자동완성 제안 |
| 차 대절 API | GET | /api/v1/rents/{id} | 차 대절 상세 조회 |
| 차 대절 API | PATCH | /api/v1/rents | 차 대절 수정 |
| 차 대절 API | PATCH | /api/v1/rents/close | 차 대절 마감 |
| 차 대절 API | PATCH | /api/v1/rents/join | 차 대절 참여 수정 |
| 차 대절 API | POST | /api/v1/rents | 차 대절 등록 |
| 차 대절 API | POST | /api/v1/rents/join | 차 대절 참여 |
| 회원 API | DELETE | /api/v1/members/refund-account | 환불 계좌 삭제 |
| 회원 API | GET | /api/v1/members | 회원 정보 조회 |
| 회원 API | GET | /api/v1/members/check-nickname | 닉네임 중복 확인 |
| 회원 API | PATCH | /api/v1/members/info | 회원 프로필 수정 |
| 회원 API | POST | /api/v1/members/refund-account | 환불 계좌 등록 |
| 회원 API | POST | /api/v1/members/register | 회원 가입 |
| 인증 API | GET | /api/v1/auth/login/check | 로그인 체크 |
| 인증 API | GET | /api/v1/auth/logout | 로그아웃 |
| 인증 API | GET | /api/v1/auth/token/kakao | 카카오 로그인 |
| 인증 API | GET | /api/v1/auth/token/reissue | 토큰 재발급 |
| 알림 API | DELETE | /api/v1/notifications/device-token | 디바이스 토큰 삭제 |
| 알림 API | GET | /api/v1/notifications | 알림 목록 조회 |
| 알림 API | PATCH | /api/v1/notifications/read | 알림 읽음 처리 |
| 알림 API | POST | /api/v1/notifications/device-token | 디바이스 토큰 등록 |
| 알림 SSE API | GET | /api/v1/notifications/subscribe | SSE 구독 |
| 스토리지 API | POST | /api/v1/storage/presigned-urls | 파일 업로드 URL 생성 |
| 스토리지 API | POST | /api/v1/storage/presigned-urls/delete | 파일 삭제 URL 생성 |
| 검색 API | GET | /api/v1/search/popular | 인기 검색어 Top 10 조회 |
| [테스트] 인증 API | GET | /api/test/token/{memberId} | 테스트 토큰 발급 |
