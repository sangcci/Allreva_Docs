# ADR-004: 개발 workflow에서 RFC를 사용하지 않는다

> 결정 상태: 채택됨
> 적용 상태: 적용 중
> 결정일: 2026-08-08
> 관련 ADR: [ADR-003](ADR-003-mandatory-development-workflow.md)의 Issue, worktree, PR gate, merge, cleanup 규칙은 계속 적용한다. 이 ADR은 ADR-003의 모든 작업 RFC 작성 규칙을 제거하는 후속 결정이다.
> 관련 Issue: [Allreva_Docs#22](https://github.com/sangcci/Allreva_Docs/issues/22)

## 결정

개발 workflow에서 RFC를 새로 만들거나 Issue, plan, PR에 연결하지 않는다. Research, 사용자와의 대화, 승인된 plan 뒤에 Issue를 만들고, Issue를 만든 뒤 사용자 승인으로 개발 workflow에 진입한다.

ADR은 여러 작업에 오래 영향을 주는 중요한 아키텍처, 운영 또는 정책 결정을 확정할 때만 작성한다. 단순 작업은 Issue만으로 진행한다.

이 ADR은 [ADR-003](ADR-003-mandatory-development-workflow.md)의 모든 작업 RFC 작성 규칙만 제거한다. ADR-003의 Issue, worktree, PR gate, merge, cleanup 규칙은 대체하지 않는다.

## 이유

검토와 합의는 Research, 사용자와의 대화, 승인된 plan에서 먼저 이뤄진다. 이를 별도 RFC로 다시 남기면 같은 내용을 반복하고 workflow 진입이 늦어진다. 오래 지속되는 중요한 결정만 ADR로 남기면 현재 기준과 이유를 찾을 수 있다.

## 감수한 점

Issue와 승인된 plan에 선택 이유와 범위를 충분히 남겨야 한다. 과거 RFC 기록은 당시 근거로 보존하지만 현재 workflow 기준으로 사용하지 않는다.

## 적용과 검증

Allreva_Docs의 workflow, Issue와 PR 규칙, 결정 안내, 양식을 이 기준으로 갱신한다. 새 workflow 문서에 RFC 생성 또는 연결 요구가 없는지 확인한다.

## 영향

- 모든 작업: Research, 사용자와의 대화, 승인된 plan 뒤 Issue를 만들고 개발 workflow에 진입한다.
- 중요한 아키텍처, 운영, 정책 결정: ADR에 남긴다.
- 기존 RFC: 보존 기록으로만 유지한다.

## 다시 검토할 조건

Issue와 승인된 plan만으로 중요한 결정의 이유나 영향 추적이 반복해서 어려워질 때 검토한다.
