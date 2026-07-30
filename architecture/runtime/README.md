# Runtime 구조

이 폴더는 Allreva가 코드 변경을 빌드하고 배포하는 흐름, 그리고 실행 중 관찰할 수 있는 지점을 설명한다. 모듈 책임과 의존성 방향은 상위 [아키텍처 문서](../README.md)에서 다룬다.

- [배포 흐름](delivery.md): GitHub Actions, Docker image, Blue-Green, Nginx 전환

이 문서는 `Allreva_BE` 저장소의 `.github/workflows/CICD.yml`, `deploy/deploy.sh`, `infra/` 설정을 기준으로 작성한다. 비밀값, 내부 IP, 개인 장비 정보는 기록하지 않는다.
