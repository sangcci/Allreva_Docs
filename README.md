# Allreva Docs

공연 관람객의 차량 대절 모집과 참여를 지원하는 Allreva 프로젝트 문서 저장소입니다.
기획, API 명세, ERD, 시스템 아키텍처, 모듈 구조, 주요 기능 시퀀스, 성능 개선 및 장애 해결 기록을 관리합니다.

## 핵심 문제 해결 3개

| 구분 | 문서 | 핵심 |
|---|---|---|
| 동시성 문제 | [troubleshooting/동시_신청_Lost_Update_해결.md](troubleshooting/동시_신청_Lost_Update_해결.md) | Atomic UPDATE로 100 VU 동시 신청 환경에서 정원 초과 방지 |
| DB 성능 | [troubleshooting/참여_내역_조회_인덱스_최적화.md](troubleshooting/참여_내역_조회_인덱스_최적화.md) | 복합 인덱스로 조회 성능 70.69ms → 1.02ms 개선 |
| 캐시 | [troubleshooting/로컬_캐시_성능_개선.md](troubleshooting/로컬_캐시_성능_개선.md) | Caffeine 로컬 캐시로 검색 응답 150ms → 5ms 수준 개선 |

## 전체 문서

| 구분 | 문서 | 핵심 |
|---|---|---|
| 프로젝트 개요 | [overview/프로젝트_개요.md](overview/프로젝트_개요.md) | 서비스 목적과 주요 기능 |
| API 명세 | [overview/API_명세.md](overview/API_명세.md) | 주요 API 요청/응답 |
| ERD | [overview/ERD.md](overview/ERD.md) | 핵심 테이블과 관계 |
| 시스템 구조 | [architecture/시스템_아키텍처.md](architecture/시스템_아키텍처.md) | VM 기반 인프라와 배포 구조 |
| 모듈 구조 | [architecture/모듈_구조.md](architecture/모듈_구조.md) | 도메인별 모듈 구성 |
| 주요 시퀀스 | [architecture/주요_시퀀스.md](architecture/주요_시퀀스.md) | 주요 기능 처리 흐름 |
| 동시성 문제 | [troubleshooting/동시_신청_Lost_Update_해결.md](troubleshooting/동시_신청_Lost_Update_해결.md) | Atomic UPDATE로 정원 초과 방지 |
| DB 성능 | [troubleshooting/참여_내역_조회_인덱스_최적화.md](troubleshooting/참여_내역_조회_인덱스_최적화.md) | 복합 인덱스로 조회 성능 개선 |
| 캐시 | [troubleshooting/로컬_캐시_성능_개선.md](troubleshooting/로컬_캐시_성능_개선.md) | Caffeine 로컬 캐시로 반복 조회 비용 감소 |
| 집계 병목 | [troubleshooting/집계_쿼리_병목_개선.md](troubleshooting/집계_쿼리_병목_개선.md) | 역정규화로 신청 인원 집계 비용 감소 |
| 멀티모듈 | [troubleshooting/멀티모듈_구조_개선.md](troubleshooting/멀티모듈_구조_개선.md) | core/support 분리로 비즈니스 흐름과 구현체 책임 분리 |

## 문서 구조

```text
overview/
  프로젝트_개요.md
  API_명세.md
  ERD.md
  컨벤션.md

architecture/
  시스템_아키텍처.md
  모듈_구조.md
  주요_시퀀스.md

troubleshooting/
  동시_신청_Lost_Update_해결.md
  참여_내역_조회_인덱스_최적화.md
  로컬_캐시_성능_개선.md
  집계_쿼리_병목_개선.md
  멀티모듈_구조_개선.md
  N+1_문제_해결.md
  load-test/

images/
  아키텍처, ERD, 성능 개선 이미지
```

## 문제 해결 기록 작성 기준

각 문제 해결 문서는 아래 흐름을 기준으로 정리합니다.

1. 문제 상황: 어떤 도메인에서 어떤 문제가 발생했는지
2. 원인 분석: 실행 계획, 로그, 코드 흐름 등 근거
3. 해결 과정: 검토한 선택지와 최종 선택 이유
4. 결과: 수치, 테스트 결과, 실행 계획 변화
5. 남은 과제: 현재 방식의 한계와 추가 개선점
