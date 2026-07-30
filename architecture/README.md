# 아키텍처 문서

이 폴더는 Allreva의 논리 구조를 설명한다. 배포 방식, CI/CD, 관측성처럼 운영과 함께 바뀌는 내용은 `runtime/`에서 다룬다.

- [구조 개요](overview.md): 실행 모듈과 전체 의존 방향
- [모듈 경계](module-boundaries.md): 각 모듈의 책임과 지켜야 할 규칙
- [Runtime 구조](runtime/README.md): CI/CD와 배포 흐름

문서 내용은 `Allreva_BE_Forked`의 `settings.gradle`, 각 모듈의 `build.gradle`, 현재 패키지 구조를 기준으로 확인한다.
