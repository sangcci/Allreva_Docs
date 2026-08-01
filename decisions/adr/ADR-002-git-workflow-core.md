# ADR-002: Git workflow는 공통 core와 플랫폼 adapter로 나눈다

> 결정 상태: 채택됨
> 적용 상태: 적용 중
> 결정일: 2026-08-01
> 관련 RFC: [RFC-002: Allreva Git workflow core와 adapter 분리](../rfc/completed/RFC-002-allreva-git-workflow-core.md)
> 관련 Issue: Allreva_Docs#17

## 결정

Allreva Git workflow 도구는 `Allreva_Harness`의 공통 core와 Pi·Codex·Claude adapter로 나눈다. 기존 `pi-git-commit`의 안전한 Git 처리와 HITL은 보존하되, Pi UI·모델 호출·세션 의존성은 adapter에 둔다.

제품 저장소마다 다른 branch, commit, Issue, PR 규칙은 `.allreva/git-workflow.json`에 둔다. GitHub Actions는 최종 lint로 유지하고, core는 사전 검사와 dry-run 결과를 제공한다.

## 이유

기존 `pi-git-commit`은 commitlint preflight, 사용자 승인, status-aware staging을 구현했지만 Pi 전용이다. 이 로직을 공통 core로 분리하면 Pi·Codex·Claude에서 같은 규칙과 안전 경계를 공유할 수 있다.

반대로 UI와 모델 호출까지 core로 옮기면 특정 harness의 특성을 공통 코드에 섞게 된다.

## 감수한 점

core 추출 초기에는 기존 Pi extension과 새 core가 잠시 함께 존재한다. 회귀를 막기 위해 read-only validator와 dry-run부터 옮기고, 실제 commit 실행은 검증 뒤에 추출한다.

플랫폼별 adapter와 프로젝트 설정 파일이 생기므로, 작은 작업에는 도구를 호출하지 않는 기준을 유지해야 한다.

## 적용과 검증

현재 `Allreva_Harness`에는 explain-diff와 cross-harness adapter 구조만 있다. Git workflow core와 CLI는 아직 구현하지 않았다.

첫 적용은 BE의 commit 규칙과 GitHub title lint를 기준으로 한다. 사람이 제안을 검토·편집·취소할 수 있고, 승인 전에는 Git·GitHub 쓰기 행동이 없는지 확인한다.

## 영향

- 기존 `pi-git-commit`은 adapter가 core를 사용하도록 단계적으로 바뀐다.
- BE에는 `.allreva/git-workflow.json`이 추가된다.
- Codex·Claude·Pi adapter는 공통 CLI의 JSON 결과를 각 환경의 UI로 보여 준다.
- FE는 BE 파일럿 결과를 확인한 뒤 별도 설정을 추가한다.

## 다시 검토할 조건

- 공통 core가 Pi extension보다 더 많은 실패·복잡도를 만들 때
- Codex·Claude에서 core CLI를 안전하게 호출할 수 없을 때
- GitHub Actions의 규칙과 project config가 반복해서 어긋날 때
