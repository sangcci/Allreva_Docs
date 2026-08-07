# RFC-005: BE 개발 workflow 연결

> 상태: 완료
> 작성일: 2026-08-06
> 관련 Issue: [Allreva_BE#123](https://github.com/sangcci/Allreva_BE/issues/123)

## 제안 요약

BE는 공통 Harness workflow config와 project adapter를 추적한다. BE의 GitHub title lint와 PR template은 최종 원격 검증으로 유지하고, worktree와 PR 전 explain-diff 규칙은 Harness adapter가 수행한다.

## 검토 배경

BE에는 Pi 전용 보호 설정과 title lint만 있다. `.allreva/git-workflow.json`은 형식 validator에 연결했지만 아직 추적되지 않았고 lifecycle을 실행하지 않는다.

## 목표

- BE branch, Issue, PR, commit 규칙을 공통 config로 공유한다.
- BE 작업을 `.worktrees/`에서 시작하게 한다.
- PR 생성 전 두 승인과 검증 기록을 남긴다.

## 선택지

### 선택지 A: BE 전용 shell workflow
- 장점: 빠르다.
- 단점: 플랫폼별 규칙이 갈라진다.

### 선택지 B: Harness config와 adapter 연결
- 장점: 공통 lifecycle을 사용한다.
- 단점: Harness 구현에 의존한다.

## 권장안

선택지 B를 채택한다.

## 검증 계획

BE worktree에서 config 검증, adapter discovery, PR 전 gate dry-run을 확인한다.

## 결정이 필요한 점

- 없음. [ADR-003](../../adr/ADR-003-mandatory-development-workflow.md)을 따른다.
