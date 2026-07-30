# CI/CD와 배포 흐름

Allreva BE는 PR에서 포맷·테스트·실행 JAR를 확인하고, `develop`에 push되면 Docker image를 만든 뒤 self-hosted runner에서 Blue-Green 방식으로 배포한다.

## 흐름

```text
+-------------+     +----------------+     +-------------+
| pull request| --> | GitHub Actions | --> | CI checks   |
+-------------+     +----------------+     +-------------+
                            |
                            | push to develop
                            v
+----------------+     +----------------+     +-------------------+
| Docker image   | <-- | build and push | <-- | GitHub Actions    |
+----------------+     +----------------+     +-------------------+
        |
        v
+----------------+     +----------------+     +-------------------+
| app-blue/green | <-- | WAS runner     | <-- | Nginx runner      |
+----------------+     +----------------+     +-------------------+
        |                                              |
        +---------------- health check ----------------+
                                                       |
                                                       v
                                              +----------------+
                                              | Nginx upstream |
                                              +----------------+
```

## PR 검증

모든 PR에서는 아래 작업이 실행된다.

- `./gradlew spotlessCheck`
- `./gradlew test`
- `:allreva-api:bootJar`, `:allreva-batch:bootJar`

PR 제목은 `[#이슈번호] 설명` 형식을 검사한다. Issue 제목은 작업 유형 접두사와 한국어 설명을 사용한다.

## develop 배포

`develop`에 push되면 CI 성공 뒤에 아래 순서로 진행한다.

1. API JAR를 빌드한다.
2. Docker Hub에 `${APP_NAME}:latest` image를 push한다.
3. WAS runner가 image를 pull하고, 현재 동작 중인 slot과 반대 slot에 컨테이너를 띄운다.
4. 새 컨테이너의 `/actuator/health`를 최대 30회 확인한다.
5. Nginx runner가 deploy job의 `active-slot` 출력을 받아 upstream port를 바꾸고 Nginx를 reload한다.

Nginx와 Cloudflare Tunnel은 별도 runtime 구성으로 실행한다. Nginx exporter는 `stub_status`를 Prometheus 형식으로 노출한다.

## 현재 확인한 점

현재 `deploy/deploy.sh`는 새 컨테이너의 health check가 통과하면 이전 slot 컨테이너를 먼저 제거하고, 이후 별도 Nginx job이 upstream을 새 slot으로 바꾼다.

격리된 Docker 실험에서 이 순서는 336회 중 4회의 요청 실패를 만들었다. Nginx upstream을 먼저 새 slot으로 바꾼 뒤 이전 slot을 종료한 순서는 416회 중 실패가 없었다. 실험 조건과 결과는 [Blue-Green 전환 순서 RFC](../../decisions/rfc/completed/2026-07-30-blue-green-switch-order.md), 결정은 [ADR-001](../../decisions/adr/ADR-001-blue-green-switch-order.md)에 남겼다.

이 결과는 로컬 mock 환경의 근거다. 실제 운영 서버에서 같은 결과가 난다고 보장하지 않으며, 서버가 복구된 뒤 health check, upstream 전환, 요청 실패 여부를 별도로 확인한다.

## 운영 문서 갱신 기준

아래가 바뀌면 이 문서를 함께 확인한다.

- CI 검사 항목
- image 태그 또는 registry 방식
- health check 조건
- Blue-Green slot 전환 순서
- Nginx, Tunnel, 관측성 구성
