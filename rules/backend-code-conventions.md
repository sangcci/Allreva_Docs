# BE Java 코드 컨벤션

Allreva BE는 Java 17, Spring Boot, Gradle 멀티모듈 구조를 사용한다. 이 문서는 코드 작성과 리뷰의 기준이며, 실행 시에는 `Allreva_BE/.agents/skills/backend-java-conventions/SKILL.md`를 함께 따른다.

## 모듈과 의존성

모듈 책임과 의존성 방향은 [구조 개요](../architecture/overview.md), [모듈 경계](../architecture/module-boundaries.md)를 따른다. `core`는 API·batch·support 구현체를 참조하지 않는다. 외부 기술과 영속성 구현은 support에 둔다.

도메인 규칙은 domain에, 요청 하나의 흐름은 application에, HTTP 변환은 API에 둔다. aggregate 사이에는 객체 참조 대신 ID를 사용한다.

## Java 표현

- 클래스, interface, enum, record는 PascalCase, 메서드와 필드는 camelCase, 상수는 UPPER_SNAKE_CASE를 사용한다.
- boolean은 `is`, `has`, `can`, `should`처럼 의미가 드러나는 이름을 사용한다.
- 메서드는 한 가지 책임을 갖게 한다. 조건이 깊어지면 guard clause와 의미 있는 private 메서드 분리를 먼저 검토한다.
- 변경하지 않는 지역 변수와 의존성은 가능한 `final`로 둔다. 함께 움직이는 값은 value object나 record로 묶을지 검토한다.
- 반환값에는 `Optional`을 사용할 수 있지만 필드와 파라미터에는 남용하지 않는다. `Optional.get()` 대신 `map`, `flatMap`, `orElseThrow`를 사용한다.
- Stream은 변환·필터링·집계가 읽기 쉬울 때만 사용한다. Stream 내부에서 외부 상태를 변경하지 않는다.
- null 대신 빈 컬렉션이나 명시적인 Optional을 우선한다. null 허용 여부를 모호하게 두지 않는다.

## Spring과 도메인 규칙

- 조회 중심 Service는 클래스 수준 `@Transactional(readOnly = true)`를 기본으로 두고, 쓰기 메서드에만 `@Transactional`을 선언한다.
- API request·response와 application DTO는 특별한 제약이 없으면 record를 사용한다.
- 업무 규칙 위반과 도메인 조회 실패는 `CustomException`과 해당 도메인의 `*ErrorCode` enum으로 표현한다.
- broad catch로 예외를 숨기지 않는다. 복구하거나 변환할 수 있을 때만 catch하며, 로그에는 동작과 식별자를 함께 남긴다.

## 포맷과 검증

Java 포맷의 기준은 Spotless와 Palantir Java Format이다. import 순서나 공백을 수동으로 맞추지 않는다.

```bash
./gradlew spotlessApply
./gradlew spotlessCheck
```

코드 변경 뒤에는 영향 범위에 맞는 테스트를 실행한다. 전체 확인은 아래 명령을 사용한다.

```bash
./gradlew test
./gradlew :allreva-api:bootJar :allreva-batch:bootJar
```

## 관련 기준

- 테스트: [BE 테스트 규칙](backend-test-conventions.md)
- Issue: [Issue 작성과 분류 기준](issue-workflow.md)
- PR: [PR 작성과 문서 연결 기준](pull-request-workflow.md)
- 실행 규칙: `Allreva_BE/AGENTS.md`
