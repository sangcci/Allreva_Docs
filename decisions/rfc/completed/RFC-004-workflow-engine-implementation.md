# RFC-004: 개발 workflow engine 구현

> 상태: 완료
> 작성일: 2026-08-06
> 관련 Issue: [Allreva_Harness#1](https://github.com/sangcci/Allreva_Harness/issues/1)

## 제안 요약

Allreva_Harness의 공통 core는 workflow config, worktree와 cleanup 안전 검사, 승인 상태, dry-run 계획을 제공한다. Pi, Codex, Claude adapter는 각 환경의 사용자 확인 UI와 실제 Git 또는 GitHub 실행을 담당한다.

## 검토 배경

현재 core는 제목, branch, commit 형식과 Git 상태만 읽는다. worktree, PR gate, cleanup은 구현돼 있지 않다.

## 목표

- config 기반 worktree lifecycle과 승인 경계를 범용적으로 제공한다.
- core는 UI, 모델 호출, GitHub 인증을 갖지 않는다.
- 실제 쓰기 행동은 adapter가 사용자 승인 뒤 수행한다.

## 선택지

### 선택지 A: Pi 전용 extension에 구현
- 장점: 빠르다.
- 단점: Codex와 Claude 규칙이 갈라진다.

### 선택지 B: core와 platform adapter 분리
- 장점: 규칙과 dry-run 결과를 공유한다.
- 단점: adapter별 구현과 테스트가 필요하다.

## 권장안

선택지 B를 채택한다.

## 검증 계획

fixture Git repository에서 branch, worktree, approval, cleanup 거부 경로와 성공 경로를 자동 검증한다.

## 결정이 필요한 점

- 없음. 공통 core와 adapter 분리는 [ADR-002](../../adr/ADR-002-git-workflow-core.md), 필수 workflow와 승인 경계는 [ADR-003](../../adr/ADR-003-mandatory-development-workflow.md)을 따른다.
