# BE 테스트 규칙

Allreva BE 테스트는 단위 테스트, module slice 테스트, 통합 테스트를 구분한다. 테스트는 구현 세부보다 도메인 규칙, 경계 변환, 실제 wiring을 확인해야 한다. 실행 시에는 `Allreva_BE/.agents/skills/backend-testing-conventions/SKILL.md`를 함께 따른다.

## 테스트 위치와 종류

테스트는 대상 코드가 속한 Gradle 모듈의 `src/test/java`에 둔다. 공통 애플리케이션 wiring과 여러 모듈 연결은 `allreva-test` 모듈에서 확인한다.

| 종류 | 대상 | 기반 클래스·도구 |
| --- | --- | --- |
| 단위 테스트 | 순수 domain 로직, mapper, client adapter, 단일 Service 협력 | JUnit 5, AssertJ, Mockito |
| DB slice 테스트 | JPA repository와 DB adapter | `DataJpaTestSupport`, PostgreSQL Testcontainers |
| 외부 연동 테스트 | OAuth·HTTP client 등 경계 adapter | WireMock 또는 대상 모듈의 test support |
| 통합 테스트 | application 흐름과 실제 모듈 wiring | `allreva-test`의 `IntegrationTestSupport` |

`IntegrationTestSupport`는 PostgreSQL, Redis, LocalStack S3, WireMock과 API application context를 올린다. 이 기반을 쓰는 테스트는 공유 container에 남긴 데이터를 `@AfterEach` 등으로 정리한다.

## 테스트 작성 기준

- JUnit 5의 `@Nested`와 `@DisplayName`으로 기능, 조건, 기대 결과를 드러낸다. 한글 식별자를 쓰는 테스트에는 `@SuppressWarnings("NonAsciiCharacters")`를 선언한다.
- 단위 테스트의 mock은 BDDMockito(`given`, `willReturn`, `then`)를 우선한다. 여러 결과를 함께 확인할 때는 AssertJ `assertSoftly`를 사용한다.
- Fixture는 테스트 대상 도메인 가까이에 두고, 기본 생성 메서드와 필요한 값만 바꾸는 메서드를 분리한다.
- 단순 저장·조회 위임만 검증하지 않는다. 분기, 권한, 예외, 변환, 경계 조건처럼 실패 가능성이 있는 동작을 우선한다.
- 예외 테스트는 `CustomException`의 `errorCode`까지 확인한다.
- API request validation은 API 모듈에서, 영속성 쿼리와 mapping은 DB slice 테스트에서, 여러 계층의 wiring은 통합 테스트에서 확인한다.
- 시간, 외부 HTTP, 저장소 같은 환경 의존성은 test support와 mock·container로 통제한다. 실제 외부 서비스에 의존하지 않는다.

## 실행 기준

변경한 모듈의 테스트를 먼저 실행하고, 병합 전 또는 여러 모듈 변경에는 전체 테스트를 실행한다.

```bash
./gradlew :<module>:test
./gradlew test
./gradlew spotlessCheck
```

CI는 `spotlessCheck`, 전체 테스트, API·batch bootJar 생성을 확인한다. 실제 CI 기준은 [CI/CD와 배포 흐름](../architecture/runtime/delivery.md)을 따른다.

## 관련 기준

- 코드: [BE Java 코드 컨벤션](backend-code-conventions.md)
- 실행 규칙: `Allreva_BE/AGENTS.md`
