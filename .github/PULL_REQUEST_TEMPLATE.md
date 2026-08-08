## explain-diff 승인
<!-- PR 생성 전 explain-diff HTML을 만들고, 사용자가 변경 흐름을 이해했음을 승인받으세요. -->
- artifact:
- 사용자 변경 이해 승인:

## PR 생성 승인
<!-- PR 제목, 본문, 검증 결과, 남은 위험을 사용자에게 보여 준 뒤 별도로 승인받으세요. -->
- 제시 항목: PR 제목, 본문, 검증 결과, 남은 위험
- 사용자 PR 생성 승인:

## 배경
<!-- 이 PR이 필요한 이유를 한두 문장으로 적어주세요. 자세한 배경은 Issue와 해당하는 ADR 링크로 넘깁니다. -->

## 이번 PR에서 한 일
<!-- 바뀐 동작이나 문서를 짧게 적어주세요. -->
-

## 확인한 내용
<!-- 실행한 테스트 명령, CI 결과, 수동 확인, 재현 실험을 적어주세요. -->
-

## 변경 상태 대조
<!-- PR 생성 직전에 git status --short, git diff --cached, git diff를 확인하세요. staged, unstaged, untracked 변경이 이번 PR 범위에 포함되는지 적으세요. -->
- `git status --short`:
- staged 변경:
- unstaged 변경:
- untracked 변경:

## 남은 확인 사항
<!-- 없다면 '없음'이라고 적어주세요. 있다면 이유와 남은 위험을 짧게 적어주세요. -->
- 없음

## 관련 문서
<!-- 공식 기준 문서가 바뀌었으면 해당 Issue 또는 PR 링크만 남겨주세요. ADR은 오래 영향을 주는 중요한 아키텍처, 운영 또는 정책 결정에만 연결합니다. -->
- 기준 문서: 없음

## 관련 Issue
- closes #

## 병합과 cleanup
<!-- 사용자만 GitHub에서 squash merge를 수행합니다. merge 완료와 cleanup 신호 뒤에만 local worktree와 local branch를 정리하세요. -->
- squash merge: 사용자 수행
- cleanup 신호:

## 리뷰 시 봐줄 부분 (선택)
<!-- 설계 선택, 트레이드오프, 특히 확인이 필요한 부분이 있으면 적어주세요. -->
