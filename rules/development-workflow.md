# 개발 workflow

모든 작업은 아래 순서를 따른다. 작은 작업도 Issue와 RFC를 남기되, 내용은 작업 크기에 맞춰 짧게 쓴다.

```text
Research -> Plan -> Issue -> short RFC -> workflow 전환 승인
-> rule validation + worktree -> implement + verify
-> explain-diff approval -> PR creation approval -> user squash merge
-> user cleanup signal -> local cleanup
```

## Research와 plan

작업 전에는 현재 코드, 문서, 위험, 완료 조건을 조사한다. 구현 방향이 정리되면 Issue에 문제와 완료 조건을 적고 RFC에 선택지와 권장안을 적는다.

ADR은 여러 작업에 영향을 주거나 장기 기준이 되는 중요한 결정을 확정할 때만 작성한다. 모든 작업에 요구하지 않는다. 결정 상태는 `채택됨`, 적용 상태는 `미적용`으로 시작한다. 구현 중에는 `적용 중`, 실제 환경 검증 뒤에는 `운영 검증 완료`으로 갱신한다.

## 개발 workflow 전환

실행자는 사용자에게 `이제 이 작업에 대해 개발 workflow로 전환해서 진행할까요?`라고 확인한다. 승인 뒤에만 branch와 worktree를 준비한다.

- `develop` 또는 `main` 직접 변경은 금지한다.
- branch 형식과 Issue 번호를 검증한다.
- worktree는 repository 내부 `.worktrees/` 아래에 만든다.
- worktree 생성이 실패하면 기본 checkout에서 구현하지 않고 중단한다.

## PR gate

모든 PR에 아래 두 승인이 필요하다.

1. 변경 diff의 explain-diff HTML을 만들고, 사용자가 변경 흐름을 이해했는지 확인한다.
2. PR 제목, 본문, 검증 결과, 남은 위험을 보여 주고 PR 생성을 승인받는다.

사용자는 GitHub에서 squash merge한다. agent는 merge하지 않는다.

## cleanup

사용자가 merge 완료와 cleanup을 알린 뒤에만 local worktree와 local branch를 정리한다. 실행 전에는 merged 상태, worktree clean 상태, 보존할 untracked 파일을 확인한다. remote branch 삭제는 GitHub 설정을 따른다.
