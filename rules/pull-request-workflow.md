# PR 작성과 문서 연결 기준

PR은 리뷰어가 코드만 보고 추측하지 않도록, 변경한 이유와 확인한 범위를 짧게 설명하는 기록이다. 모든 PR에는 한두 문장의 배경과 검증 결과를 남긴다.

작은 변경은 정해진 항목을 억지로 길게 채우지 않는다. 실제로 바뀐 점, 확인한 내용, 남은 확인 사항만 사실대로 적는다. PR 제목과 본문에서 가운데점(`·`)을 구분 기호로 쓰지 않는다.

## PR 생성 전 승인

모든 PR은 생성 전에 아래 두 단계를 순서대로 거친다.

1. `explain-diff` HTML을 만들고, 사용자가 변경 흐름을 이해했음을 승인받는다.
2. PR 제목, 본문, 검증 결과, 남은 위험을 사용자에게 보여 준 뒤 PR 생성을 별도로 승인받는다.

실행자는 두 승인을 모두 받기 전 PR을 만들지 않는다. 승인 기록은 [PR template](../.github/PULL_REQUEST_TEMPLATE.md)에 남긴다.

## 병합과 cleanup

사용자만 GitHub에서 squash merge를 수행한다. 실행자는 merge하지 않는다. 사용자가 merge 완료와 cleanup 신호를 준 뒤에만 local worktree와 local branch를 정리한다.

## PR 생성 직전 변경 상태 대조

PR 생성 승인 직전에 `git status --short`, `git diff --cached`, `git diff`를 순서대로 확인한다. `git status --short`의 모든 staged, unstaged, untracked 변경을 이번 PR 범위와 대조한다.

- staged 변경: PR용 commit에 넣을 파일과 diff인지 확인한다.
- unstaged 변경: PR용 commit에 누락 없이 추가할 변경인지, 이번 PR에서 제외할 작업인지 확인한다.
- untracked 변경: PR용 commit에 추가할 파일인지, 생성물이나 다른 작업 파일인지 확인한다.

대조 결과는 [PR template](../.github/PULL_REQUEST_TEMPLATE.md)의 `변경 상태 대조`에 남긴다. 의도하지 않은 변경이나 포함 여부가 불명확한 파일이 있으면 PR을 만들지 않는다.

## PR에 적는 내용

- 배경: 이 PR이 필요한 이유
- 이번 PR에서 한 일: 사용자, API, 데이터, 운영 방식에서 실제로 바뀐 점
- 확인한 내용: 실행한 명령, CI, 수동 확인, 재현 실험
- 남은 확인 사항: 없으면 `없음`, 있으면 이유와 남은 위험
- 관련 Issue: 모든 PR은 작업 Issue를 연결한다.
- 관련 문서: 공식 문서가 바뀌었을 때 Allreva_Docs Issue 또는 PR 링크

## 문서 연결 방식

공식 지식의 기준은 Allreva_Docs다. 코드 PR은 설계 문서 내용을 복사하지 않고, 필요할 때 기준 문서 링크 한 줄만 남긴다. 오래 영향을 주는 중요한 아키텍처, 운영 또는 정책 결정을 확정한 PR만 ADR을 연결한다.

```md
## 관련 문서
- 기준 문서: Allreva_Docs#12
```

문서 변경이 없다면 아래처럼 적는다.

```md
## 관련 문서
- 기준 문서: 없음
```

중앙 Docs의 문서가 바뀌었다고 BE·FE의 `AGENTS.md`나 Skill을 항상 바꾸지는 않는다. 문서 구조, 항상 지켜야 할 규칙, 반복 실행 절차처럼 Agent의 탐색이나 실행 방식이 달라질 때만 로컬 Agent 문서를 함께 갱신한다.
