# 실험: Blue-Green 전환 순서가 만드는 요청 실패 구간

> 상태: 완료
> 실험일: 2026-07-30
> 관련 Issue: Allreva_BE#116
> 관련 RFC: [Blue-Green 전환 순서 재현과 검증](../../decisions/rfc/completed/2026-07-30-blue-green-switch-order.md)
> 관련 ADR: [Blue-Green 전환은 upstream을 먼저 바꾼다](../../decisions/adr/ADR-001-blue-green-switch-order.md)

## 가설

이전 slot을 Nginx upstream 전환보다 먼저 종료하면, proxy가 종료된 slot을 가리키는 동안 요청 실패가 발생한다. upstream을 먼저 새 slot으로 전환한 뒤 이전 slot을 종료하면 같은 조건에서 실패가 줄어든다.

## 재현 조건

### 환경

- Docker Compose로 실행한 `blue`, `green`, `proxy` 컨테이너
- `blue`, `green`: 응답 본문에 slot 이름을 반환하는 Python mock application
- `proxy`: Nginx upstream을 한 slot으로 전달
- 요청 간격: 기본 25ms
- 이전 slot 종료와 다음 작업 사이의 지연: 기본 2초

실행 환경은 운영 서버와 분리된 로컬 Colima Docker daemon이다.

### 입력과 절차

```bash
cd evidence/2026-07-30-blue-green-switch-order
./scripts/run.sh
```

스크립트는 아래 두 순서를 차례로 실행한다.

1. 현재 순서: `blue` 종료 → 2초 대기 → Nginx upstream을 `green`으로 전환
2. 개선 순서: Nginx upstream을 `green`으로 전환 → 2초 대기 → `blue` 종료

## 측정 항목

- 전체 요청 수
- 2xx가 아닌 요청 수와 실패율
- 최대 연속 실패 요청 수

## 결과

| 시나리오 | 전체 요청 | 실패 요청 | 실패율 | 최대 연속 실패 |
| --- | ---: | ---: | ---: | ---: |
| 현재 순서 | 336 | 4 | 1.19% | 4 |
| 개선 순서 | 416 | 0 | 0% | 0 |

`current-order.csv`에서는 `blue` 종료 뒤 502 1회와 connection error 3회가 기록됐다. `improved-order.csv`에서는 처음 19개 요청이 `blue`, 이후 397개 요청이 `green`에서 반환됐고 실패 요청은 없었다.

실행 후 `results/`에 요청 원본 CSV와 시나리오별 요약 JSON을 저장한다.

## 해석

이 실험 조건에서는 이전 slot을 먼저 종료하면 proxy가 종료된 upstream을 가리키는 요청 실패가 발생했다. 반대로 upstream을 먼저 `green`으로 바꾼 뒤 `blue`를 종료한 순서에서는 같은 지연 조건에서 실패가 없었다.

운영 서버의 실제 가용성을 증명한 결과는 아니다. 다만 현재 전환 순서에 요청 실패 가능성이 있다는 근거와, upstream 선전환이 이를 줄일 수 있다는 근거로 사용한다.

## 한계

mock application과 로컬 Docker 네트워크를 사용한다. 실제 Spring Boot 시작 시간, self-hosted runner 간 지연, 운영 Nginx 설정, 실제 트래픽 패턴을 재현하지 않는다.

## 원본 자료

- `docker-compose.yml`
- `app/server.py`
- `nginx/nginx.conf.template`
- `scripts/run.sh`, `scripts/traffic.py`, `scripts/analyze.py`
- `results/`
