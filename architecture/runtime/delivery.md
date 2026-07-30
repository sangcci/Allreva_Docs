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

## 현재 확인이 필요한 점

현재 `deploy/deploy.sh`는 새 컨테이너의 health check가 통과하면 이전 slot 컨테이너를 먼저 제거하고, 이후 별도 Nginx job이 upstream을 새 slot으로 바꾼다.

이 순서가 실제 요청에 얼마만큼의 실패 구간을 만드는지는 아직 실험으로 확인하지 않았다. 따라서 “무중단 배포”라고 단정하지 않는다. 이 문제는 RFC와 재현 실험으로 확인한 뒤, 결과와 결정은 `decisions/` 및 `evidence/`에 남긴다.

## 운영 문서 갱신 기준

아래가 바뀌면 이 문서를 함께 확인한다.

- CI 검사 항목
- image 태그 또는 registry 방식
- health check 조건
- Blue-Green slot 전환 순서
- Nginx, Tunnel, 관측성 구성
