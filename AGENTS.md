# Allreva_Docs 작업 안내

이 저장소는 Allreva를 설명하고, 중요한 판단과 검증 근거를 남기는 사람 중심의 기록 공간이다. 문서는 한국어를 기본으로 쓴다. 코드·API·명령어·클래스 이름처럼 바꾸면 의미가 흐려지는 식별자만 원문 영어를 유지한다.

## 먼저 읽을 문서

- 문서 전체 구조와 신뢰 수준: [INDEX.md](INDEX.md)
- 문장과 구성 기준: [writing-guide.md](writing-guide.md)
- 기존 자료의 보존 위치: [archive/2026-06-before-harness/README.md](archive/2026-06-before-harness/README.md)

## 문서 위치

- `architecture/`: 시스템과 모듈 경계, 데이터와 API의 큰 구조
- `rules/`: Issue·PR, 개발, 테스트와 품질 기준
- `architecture/runtime/`: CI/CD, 배포, 관측성, 장애 대응 기준
- `decisions/rfc/`: 이전 workflow의 보존 기록. 새 RFC를 만들거나 연결하지 않는다.
- `decisions/adr/`: 확정된 중요한 결정과 이유
- `decisions/templates/`: ADR 작성 양식
- `.github/`: GitHub가 실제로 사용하는 Issue Form과 PR template

## 작업 원칙

1. README는 외부 방문자를 위한 표면 문서다. 내부 지식의 색인 역할을 맡기지 않는다.
2. 새 문서는 목적에 맞는 폴더에 두고, 사실·가설·결정을 섞어 쓰지 않는다.
3. 코드 동작을 설명하는 문서는 BE 또는 FE 코드와 대조해 확인한다. 확인하지 못한 내용은 사실처럼 단정하지 않는다.
4. 중요한 변경은 관련 Issue, PR, 코드 저장소 경로를 문서에 남긴다.
5. `archive/`는 보존용 자료다. 현재 기준으로 인용하거나 Agent의 구현 규칙으로 사용하지 않는다.
6. 한 문서에 모든 배경을 넣지 않는다. 필요한 경우 관련 문서로 연결한다.
7. ASCII 다이어그램은 Markdown code block 안에 쓰고, 상자·선·화살표·라벨은 영문과 ASCII 문자만 사용한다.
8. Issue와 PR은 정해진 항목을 기계적으로 길게 채우지 않는다. 변경 크기에 맞춰 실제로 바뀐 점, 확인한 내용, 남은 확인 사항을 짧고 사실적으로 쓴다.
9. 개발 workflow에서는 새 RFC를 만들거나 Issue, plan, PR에 연결하지 않는다. 여러 작업에 오래 영향을 주는 중요한 아키텍처, 운영, 정책 결정만 ADR로 남긴다.
