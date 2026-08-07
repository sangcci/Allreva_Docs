# RFC-002: Allreva Git workflow core와 adapter 분리

> 상태: 완료
> 작성일: 2026-08-01
> 관련 Issue: Allreva_Docs#17
> 관련 ADR: [ADR-002: Git workflow는 공통 core와 플랫폼 adapter로 나눈다](../../adr/ADR-002-git-workflow-core.md)
> 후속 정책: [RFC-003: 필수 개발 workflow 표준](RFC-003-development-workflow-standard.md)과 [ADR-003: 모든 개발 작업에 worktree와 두 단계 PR 승인을 적용한다](../../adr/ADR-003-mandatory-development-workflow.md)가 이 RFC의 선택형 explain-diff 정책을 대체한다. 공통 core와 플랫폼 adapter 제안은 완료 상태로 유지한다.
> 관련 구현: `pi-git-commit`

## 제안 요약

기존 `pi-git-commit`의 Git 상태 수집, commitlint preflight, 안전한 staging과 사용자 승인 흐름은 재사용한다. 다만 Pi UI·모델 호출·세션은 공통 코드에서 분리한다.

`Allreva_Harness`에는 harness에 독립적인 Git workflow core를 두고, Pi·Codex·Claude adapter는 각 환경의 UI와 모델 호출만 맡긴다. 제품 저장소는 제목, branch, 라벨, 검증 규칙을 `.allreva/git-workflow.json`에 둔다.

## 검토 배경

현재 구현체인 `pi-git-commit`은 `/commit` 명령으로 실제 변경을 수집하고, AI 또는 heuristic으로 커밋 계획을 만들고, commitlint와 사용자 승인 뒤 stage·commit한다. 이 흐름은 안전하지만 Pi의 `ExtensionAPI`, 대화형 UI, model registry에 직접 의존한다.

반면 BE의 Issue·PR 제목과 라벨 규칙은 GitHub Actions에 따로 있고, branch·Issue·PR 도구는 아직 구현되지 않았다. 같은 규칙을 Pi, Codex, Claude에서 각각 다시 만들면 메시지와 검증 기준이 갈라질 수 있다.

## 목표

- 프로젝트 규칙을 읽고 commit, branch, Issue, PR의 형식을 검증하는 공통 core를 만든다.
- 기존 Pi commit 도구의 안전한 Git 처리와 HITL을 보존한다.
- 플랫폼 adapter가 같은 core를 호출할 수 있게 한다.
- 원격 GitHub 변경과 실제 Git 쓰기는 명시적 사용자 승인 뒤에만 수행한다.

## 이번에는 하지 않는 일

- 기존 `pi-git-commit`을 한 번에 폐기하거나 전면 재작성하지 않는다.
- GitHub Actions의 lint를 제거하지 않는다.
- Issue·PR·branch·commit을 완전 자동으로 생성하거나 병합하지 않는다.
- FE 규칙을 BE 규칙으로 강제하지 않는다.

## 선택지

### 선택지 A: 기존 Pi 도구에 기능을 계속 추가

- 장점: 가장 빠르게 기능을 추가한다.
- 단점: Codex·Claude에서 같은 규칙을 쓰기 어렵고 Pi 의존성이 커진다.
- 영향: 공통 Harness가 아닌 Pi extension이 사실상 기준이 된다.

### 선택지 B: 기존 Pi 도구를 그대로 두고 별도 범용 도구 추가

- 장점: 기존 도구를 건드리지 않는다.
- 단점: commit 규칙과 Git 상태 처리 로직이 두 갈래가 된다.
- 영향: 두 도구의 결과가 달라질 위험이 있다.

### 선택지 C: 공통 core를 추출하고 Pi adapter를 유지

- 장점: Git 규칙과 안전한 처리 로직을 한 번만 관리한다.
- 단점: 추출 과정에서 기존 Pi 도구의 회귀를 주의해야 한다.
- 영향: Pi·Codex·Claude가 각자의 UI로 동일한 검증과 실행 계획을 사용할 수 있다.

## 권장안

선택지 C를 채택한다. 다만 core 추출은 작은 단계로 나눈다.

1. read-only config loader, 규칙 validator, Git 상태 inspector를 먼저 만든다.
2. 기존 Pi commit 도구가 이 validator를 사용하도록 옮긴다.
3. status-aware staging·commit 실행 로직을 core로 추출한다.
4. branch, Issue, PR adapter를 추가한다.

## 제안 구조

```text
Allreva_Harness/
├── packages/
│   ├── git-workflow-core/       # Git 상태, config, validator, 실행 계획
│   └── git-workflow-cli/        # JSON 입출력 CLI
├── integrations/
│   ├── pi/                      # Pi UI와 model 호출 adapter
│   ├── codex/                   # Codex agent/skill adapter
│   └── claude/                  # Claude Code agent/skill adapter
└── scripts/

Product repository/
└── .allreva/
    └── git-workflow.json        # 해당 저장소의 규칙
```

core는 모델 호출, UI, GitHub 인증을 갖지 않는다. 입력을 JSON으로 받고 검사·계획 결과를 JSON으로 반환한다. adapter만 모델 제안, 사용자 편집, `gh` 호출, 실제 Git 실행을 맡는다.

## 프로젝트 설정 초안

```json
{
  "version": 1,
  "branch": {
    "base": "develop",
    "pattern": "{type}/#{issue}-{slug}"
  },
  "commit": {
    "conventional": true,
    "requireScope": true
  },
  "issue": {
    "titlePattern": "[TYPE] 설명",
    "types": ["FEAT", "BUG", "DOCS", "REFACTOR", "TEST", "PERF", "CHORE", "HOTFIX", "CI"]
  },
  "pullRequest": {
    "titlePattern": "[#{issue}] 설명"
  }
}
```

이 설정은 GitHub Actions의 최종 lint를 대체하지 않는다. core와 adapter가 사전에 같은 규칙을 확인하게 하는 입력이다.

## Human-in-the-loop

- core의 inspect와 validate는 읽기 전용이다.
- adapter는 branch, stage, commit, Issue, PR, push 같은 쓰기 행동 전에 제안과 검사 결과를 사용자에게 보여 준다.
- 사용자는 진행, 편집, 재생성, 취소 중 하나를 선택한다.
- `explain-diff`는 큰 변경이나 사용자가 이해를 원할 때 Git workflow 자체의 변경에도 선택적으로 적용한다. 이 선택형 정책은 [RFC-003](RFC-003-development-workflow-standard.md)과 [ADR-003](../../adr/ADR-003-mandatory-development-workflow.md)에서 모든 PR의 필수 artifact와 사용자 이해 승인으로 대체됐다.

## 예상 영향과 위험

- 기존 `pi-git-commit`의 hunk 단위 staging 미지원, 일부 커밋 성공 뒤 실패 시 자동 복구하지 않는 경계는 유지하거나 명시적으로 바꿔야 한다.
- commit scope와 BE Issue type은 같은 개념이 아니므로 설정에서 억지로 연결하지 않는다.
- `commands.sem`처럼 임의 shell 명령을 실행하는 설정은 core에서 기본 비활성화하고, 필요하면 adapter의 허용목록으로 제한한다.
- Codex·Claude·Pi의 sandbox와 임시 파일 쓰기 권한이 달라, artifact나 원격 호출은 adapter별 fallback이 필요하다.

## 검증 계획

- 기존 `pi-git-commit`의 config와 fixture Git 상태를 core validator에 적용해 동일한 commitlint 결과가 나오는지 확인한다.
- BE의 Issue·PR 제목 규칙을 core validator와 GitHub Action 양쪽에서 확인한다.
- 각 adapter는 실제 쓰기 대신 dry-run JSON 결과부터 비교한다.
- 사람이 제안을 편집·취소할 수 있고, 승인 전에는 Git·GitHub 쓰기 행동이 없는지 확인한다.

## 결정이 필요한 점

- 없음. core 추출과 Pi adapter 유지 원칙은 합의됐다. 첫 구현 단계의 API와 설정 schema는 이 RFC를 기준으로 구체화한다.

## 관련 자료

- Allreva_BE#119
- `pi-git-commit` README와 `index.ts`
