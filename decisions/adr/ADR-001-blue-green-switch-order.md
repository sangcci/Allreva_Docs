# ADR-001: Blue-Green 전환은 upstream을 먼저 바꾼다

> 상태: 채택됨
> 결정일: 2026-07-30
> 관련 RFC: [Blue-Green 전환 순서 재현과 검증](../rfc/completed/2026-07-30-blue-green-switch-order.md)
> 관련 Issue: Allreva_BE#116

## 결정

새 slot의 health check가 통과하면 Nginx upstream을 새 slot으로 먼저 전환한다. 이전 slot은 새 upstream 전환 뒤에 종료한다.

운영 배포 스크립트 변경과 실제 서버 검증은 배포 서버가 복구된 뒤 별도 작업으로 진행한다.

## 이유

격리된 Docker 실험에서 이전 slot을 먼저 종료한 현재 순서는 336회 중 4회의 요청 실패를 만들었다. upstream을 먼저 전환한 순서는 416회 중 실패가 없었다.

이 결과는 proxy가 종료된 이전 slot을 가리키는 구간을 줄이는 방향이 필요하다는 근거다.

## 감수한 점

새 upstream 전환이 실제로 적용됐는지 확인한 뒤 이전 slot을 정리해야 하므로, 배포 절차와 rollback 기준이 조금 더 복잡해진다.

이 실험은 mock application과 로컬 Docker 환경에서 실행했다. 실제 Spring Boot 시작 시간, runner 간 지연, 운영 Nginx 설정은 따로 검증해야 한다.

## 영향

- `deploy/deploy.sh`와 Nginx 전환 job의 순서를 조정해야 한다.
- 전환 실패 시 이전 slot을 유지하는 rollback 기준을 정해야 한다.
- 운영 서버가 복구되면 실제 환경에서 health check, upstream 전환, 요청 실패 여부를 확인해야 한다.
- [배포 흐름 문서](../../architecture/runtime/delivery.md)를 실제 구현 결과에 맞게 갱신해야 한다.

## 다시 검토할 조건

- 실제 운영 환경에서 Nginx 전환 순서가 다르게 동작하는 경우
- 배포를 Kubernetes, managed load balancer 등 다른 방식으로 옮기는 경우
