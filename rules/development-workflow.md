# 개발 workflow

Research, 사용자와의 대화, 승인된 plan 뒤에 Issue를 만든다. Issue는 개발 workflow 진입 전 문제, 범위, 완료 조건을 기록한다. ADR은 오래 영향을 주는 중요한 아키텍처, 운영 또는 정책 결정을 확정할 때만 작성한다.

```text
Research -> interactive discussion -> approved plan -> Issue
-> workflow transition approval -> rule validation + worktree
-> implement + verify -> explain-diff approval -> PR creation approval
-> user squash merge -> user cleanup signal -> local cleanup
```

## Research와 plan

작업 전에는 현재 코드, 문서, 위험, 완료 조건을 조사한다. 사용자와 구현 방향, 범위, 위험을 대화로 확인하고 plan을 승인받는다. 그 뒤 Issue에 문제, 범위, 완료 조건을 적는다.

중요하고 오래 지속되는 아키텍처, 운영 또는 정책 결정을 확정하면 ADR에 결정, 이유, 감수한 점을 남긴다. 모든 작업에 작성하지 않는다. 결정 상태는 `채택됨`, 적용 상태는 `미적용`으로 시작한다. 구현 중에는 `적용 중`, 실제 환경 검증 뒤에는 `운영 검증 완료`으로 갱신한다.

## 개발 workflow 전환

Issue를 만든 뒤 실행자는 사용자에게 `이제 이 작업에 대해 개발 workflow로 전환해서 진행할까요?`라고 확인한다. 승인 뒤에만 branch와 worktree를 준비한다.

- `develop` 또는 `main` 직접 변경은 금지한다.
- branch 형식과 Issue 번호를 검증한다.
- worktree는 repository 내부 `.worktrees/` 아래에 만든다.
- worktree 생성이 실패하면 기본 checkout에서 구현하지 않고 중단한다.

## PR gate

모든 PR에 아래 두 승인이 필요하다.

1. 변경 diff의 explain-diff HTML을 만들고, 사용자가 변경 흐름을 이해했는지 확인한다.
2. PR 제목, 본문, 검증, 남은 위험을 보여 주고 PR 생성을 승인받는다.

사용자는 GitHub에서 squash merge한다. agent는 merge하지 않는다.

## cleanup

사용자가 merge 완료와 cleanup을 알린 뒤에만 local worktree와 local branch를 정리한다. 실행 전에는 merged 상태, worktree clean 상태, 보존할 untracked 파일을 확인한다. remote branch 삭제는 GitHub 설정을 따른다.
