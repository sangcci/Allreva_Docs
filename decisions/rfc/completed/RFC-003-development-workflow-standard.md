# RFC-003: 필수 개발 workflow 표준

> 상태: 완료
> 작성일: 2026-08-06
> 관련 Issue: [Allreva_Docs#19](https://github.com/sangcci/Allreva_Docs/issues/19)
> 관련 구현: [Allreva_Harness#1](https://github.com/sangcci/Allreva_Harness/issues/1), [Allreva_BE#123](https://github.com/sangcci/Allreva_BE/issues/123)

## 제안 요약

모든 작업은 Issue와 RFC를 먼저 남긴다. 사용자가 개발 workflow 전환을 승인하면 검증된 branch 이름으로 `.worktrees/` 아래 격리된 worktree를 만들고 그 안에서만 구현한다.

모든 PR은 생성 전에 `explain-diff` HTML과 사용자 이해 확인을 거친다. PR 본문과 검증 결과를 다시 확인한 뒤 사용자 승인으로 생성한다. 사용자는 GitHub에서 squash merge를 수행하고, cleanup 신호를 준 뒤에만 local worktree와 local branch를 정리한다.

## 검토 배경

현재 규칙은 RFC를 경계 변경에만 요구하고, `explain-diff`도 큰 diff나 사용자가 원하는 경우에 선택적으로 사용한다. 공통 Git workflow core는 형식 검증만 하며 worktree, 승인 기록, PR, cleanup lifecycle을 실행하거나 검사하지 않는다.

## 목표

- 작업 시작, 설계 결정, 구현, PR, merge, cleanup 책임을 분리한다.
- `develop` 직접 변경 대신 작업별 worktree를 기본 실행 공간으로 둔다.
- Pi, Codex, Claude가 같은 규칙을 사용하게 한다.
- 승인 없는 Git 또는 GitHub 쓰기 행동을 막을 수 있는 공통 경계를 만든다.

## 이번에는 하지 않는 일

- GitHub squash merge를 자동 실행하지 않는다.
- 사용자 merge 후 cleanup을 자동 실행하지 않는다.
- 모든 작업에 긴 설계 문서를 요구하지 않는다. RFC는 짧아도 된다.

## 선택지

### 선택지 A: 기존 선택형 규칙 유지
- 장점: 작은 작업이 빠르다.
- 단점: 실행자마다 worktree와 HITL 적용이 달라진다.

### 선택지 B: 모든 작업에 공통 lifecycle 적용
- 장점: 작업 추적, 승인 경계, cleanup 책임이 일관된다.
- 단점: 작은 작업도 Issue와 RFC를 남기는 비용이 생긴다.

## 권장안

선택지 B를 채택한다. Issue와 RFC는 작업 크기에 맞춰 짧게 작성한다.

## 예상 영향과 위험

- Harness에 worktree, approval receipt, cleanup safety 검사가 추가된다.
- 각 제품 저장소는 `.allreva` 설정과 adapter를 추적한다.
- 기존 dirty main worktree는 새 규칙 적용 전 만들어진 변경이므로, 새 worktree에 명시적으로 옮긴다.

## 검증 계획

- worktree 생성 전 branch 형식과 base branch를 검증한다.
- PR 생성 전 explain-diff artifact와 두 승인 상태를 확인한다.
- cleanup 전 merge, worktree clean, local branch 상태를 확인한다.

## 결정이 필요한 점

- 없음. 사용자 승인으로 결정했다.

## 관련 자료

- [ADR-003](../../adr/ADR-003-mandatory-development-workflow.md)
