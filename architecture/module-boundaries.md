# 모듈 경계와 의존성 규칙

Allreva의 모듈 경계는 비즈니스 규칙과 기술 구현이 서로 침범하지 않게 하기 위한 기준이다. 새 기능을 만들 때는 먼저 어느 모듈이 책임져야 하는지 판단한다.

## allreva-core

core는 서비스의 업무 규칙과 usecase를 둔다. API 서버인지, 배치 서버인지, DB가 무엇인지, Redis나 FCM을 쓰는지는 알지 못해야 한다.

core에 둘 수 있는 것:

- application service와 usecase 흐름
- domain aggregate, value object, 정책, 도메인 이벤트
- repository와 외부 연동 port 인터페이스
- command와 query 모델

core에 두지 않는 것:

- Controller와 HTTP request/response
- JPA entity, Querydsl, Redis repository
- Feign client, S3 client, Firebase SDK
- support 구현체의 설정 객체

## allreva-support

support는 core가 정의한 repository와 port의 기술 구현을 둔다. DB, Redis, S3, OAuth, KOPIS, FCM처럼 바뀔 수 있는 기술은 여기에서 관리한다.

support는 domain 객체와 persistence entity 또는 외부 API 응답 사이의 변환도 맡는다. 조회 성능을 위한 projection이나 cache 구현도 support의 책임이다.

## allreva-api와 allreva-batch

API와 batch는 외부 요청이 들어오는 방식만 다르다. 둘 다 core의 usecase를 호출하고, 필요한 support 구현체를 조합한다.

- API는 HTTP 입력 검증, 인증 정보 변환, 응답 변환을 맡는다.
- batch는 스케줄러, 배치 실행 시간, 반복과 재시도 같은 실행 정책을 맡는다.

업무 규칙을 Controller나 Scheduler에 직접 넣지 않는다.

## core 내부의 책임

core는 도메인별로 command, query, domain을 나눈다.

- `domain`: aggregate의 상태 변경과 불변식
- `command`: 상태를 바꾸는 usecase와 그에 필요한 행위
- `query`: 조회 usecase와 조회 모델

application service는 요청 하나의 흐름을 보여 준다. 객체를 찾고 저장하거나 외부 port를 호출하는 세부 절차는 `implementation`의 행위자가 맡는다. aggregate가 스스로 판단할 수 있는 규칙은 domain에 둔다.

## 지켜야 할 규칙

1. core는 api, batch, support 모듈을 참조하지 않는다.
2. 다른 aggregate는 객체로 직접 참조하지 않고 ID로 참조한다.
3. 업무 규칙 위반은 `CustomException`과 도메인별 `*ErrorCode`로 표현한다.
4. HTTP 형식 검증은 API request DTO에서 하고, 업무 규칙 검증은 core에서 한다.
5. DB·캐시·외부 API의 세부 구현은 core 밖에 둔다.
6. 새 모듈은 처음부터 만들지 않는다. 변경 이유와 배포·테스트 경계가 분명해졌을 때 분리를 검토한다.

이 규칙을 지키기 어려운 경우에는 먼저 이유와 대안을 확인한다. 아키텍처 경계를 바꾸는 변경이면 RFC를 작성한다.
