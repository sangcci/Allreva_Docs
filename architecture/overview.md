# Allreva 구조 개요

Allreva는 HTTP 요청을 처리하는 API 서버와 공연 데이터를 수집하는 배치 서버를 분리하고, 비즈니스 규칙은 `allreva-core`에 둔다. DB, 캐시, 외부 API처럼 교체될 수 있는 구현은 `allreva-support` 아래 모듈로 분리한다.

## 전체 모듈

```text
allreva-api        HTTP API, 인증 처리, SSE 등 API 서버 진입점
allreva-batch      스케줄러와 배치 작업 진입점
allreva-core       유스케이스, 도메인 규칙, port와 repository 인터페이스
allreva-support    DB, 캐시, 저장소, 외부 API, 관측성 구현체
allreva-test       여러 모듈을 조합하는 통합 테스트 지원
```

의존 방향은 아래와 같다.

```text
+--------------+       +---------------+       +------------------+
| allreva-api  | ----> | allreva-core  | <---- | allreva-support  |
+--------------+       +---------------+       +------------------+
        |                                             ^
        +------------ runtime dependency -------------+

+--------------+       +---------------+
| allreva-batch| ----> | allreva-core  |
+--------------+       +---------------+
        |
        +------------ runtime dependency ---> allreva-support
```

`allreva-core`는 API 서버, 배치 서버, support 구현체를 알지 못한다. core가 필요한 외부 기능은 port 또는 repository 인터페이스로 표현하고, support가 이를 구현한다.

## 실행 모듈

### allreva-api

REST API, Spring Security, HTTP 요청 검증, 응답 변환, SSE처럼 HTTP 연결과 직접 관련된 코드를 둔다. Controller는 입력을 core의 command 또는 조회 요청으로 바꾼 뒤 usecase를 호출한다.

### allreva-batch

KOPIS 공연·공연장 데이터 동기화처럼 정해진 시간에 실행하는 작업의 진입점이다. 스케줄러와 배치 실행 정책은 이 모듈에 두고, 업무 규칙은 core를 사용한다.

### allreva-test

여러 모듈을 함께 올려 실제 wiring과 외부 구현체 연결을 확인하는 통합 테스트 지원 모듈이다. 개별 도메인의 단위 테스트를 대신하지 않는다.

## 비즈니스와 구현의 분리

`allreva-core`의 현재 주요 영역은 인증, 회원, 공연과 공연장, 차대절과 수요조사, 알림, 검색이다. 이 영역은 업무 규칙과 usecase 흐름을 가진다.

`allreva-support`에는 아래 구현 모듈이 있다.

```text
db                 PostgreSQL, JPA, Querydsl 등 영속성 구현
global-cache       Redis 기반 공유 저장소와 캐시
local-cache        Caffeine 기반 프로세스 내부 캐시
storage            S3 파일 저장소
observability      로그와 메트릭 설정
oauth-client       OAuth provider 연동
kopis-client       KOPIS 공연 데이터 연동
push-notification  FCM push 알림 연동
```

이 분리는 “기술을 많이 쓰기 위해” 만든 구조가 아니다. DB나 외부 API 구현이 바뀌더라도 핵심 업무 규칙의 변경 범위를 좁히고, 기능 흐름을 코드에서 따라가기 쉽게 만들기 위한 선택이다.
