# ADR-003: 모든 개발 작업에 worktree와 두 단계 PR 승인을 적용한다

> 결정 상태: 채택됨
> 적용 상태: 적용 중
> 결정일: 2026-08-06
> 관련 RFC: [RFC-003](../rfc/completed/RFC-003-development-workflow-standard.md)
> 후속 결정: [ADR-004](ADR-004-rfc-trigger-policy.md)가 모든 작업 RFC 작성 규칙만 대체한다. Issue, worktree, PR gate, merge, cleanup 규칙은 계속 적용한다.
> 대체 범위: [ADR-002](ADR-002-git-workflow-core.md)의 필수 workflow, worktree, PR gate 정책만 대체한다. ADR-002의 공통 core와 플랫폼 adapter 분리는 계속 적용한다.
> 관련 Issue: [Allreva_Docs#19](https://github.com/sangcci/Allreva_Docs/issues/19)

## 결정

모든 작업은 Issue와 RFC를 만든다. Research와 plan 뒤 사용자가 개발 workflow 전환을 승인하면, 실행자는 branch 규칙을 검증하고 repository 내부 `.worktrees/`에 작업별 worktree를 만든다. 구현은 그 worktree에서만 한다.

모든 PR 생성 전에는 explain-diff HTML을 만들고 사용자의 변경 이해 승인을 받는다. PR 제목, 본문, 검증, 남은 위험을 보여 준 뒤 PR 생성 승인을 별도로 받는다. 사용자가 GitHub에서 squash merge한 뒤 cleanup 신호를 주면 local worktree와 local branch만 정리한다.

이 ADR은 [ADR-002](ADR-002-git-workflow-core.md)의 필수 workflow, worktree, PR gate 정책을 대체한다. 공통 core와 플랫폼 adapter 분리 결정은 대체하지 않는다.

## 이유

작업 공간 격리와 승인 경계를 모든 실행 환경에서 같은 순서로 적용하기 위해서다. merge와 cleanup은 되돌리기 어렵거나 협업 상태를 바꾸므로 사용자가 맡는다.

## 감수한 점

작은 작업도 Issue와 RFC를 남긴다. 이 문서들은 작업 크기에 맞춰 짧게 쓴다.

## 적용과 검증

Harness에 범용 lifecycle core와 adapter를 추가하고, BE에 설정과 진입 규칙을 연결하는 중이다. worktree 생성, PR gate, cleanup safety는 dry-run과 fixture로 검증한다.

## 영향

- Allreva_Docs: Issue, RFC, ADR, PR 규칙을 새 lifecycle으로 갱신한다.
- Allreva_Harness: config, core, CLI, Pi/Codex/Claude adapter를 구현한다.
- 제품 저장소: `.allreva` 설정과 project adapter를 추적한다.

## 다시 검토할 조건

workflow 비용이 반복적으로 작업 가치보다 크거나, 플랫폼 adapter가 같은 승인 경계를 보장하지 못할 때 다시 검토한다.
