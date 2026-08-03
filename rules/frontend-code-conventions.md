# FE 코드 컨벤션

Allreva FE는 React 19, TypeScript, Vite SPA와 TanStack Query를 기준으로 작성한다. 이 문서는 사람이 합의한 기준이며, 실행 시에는 `Allreva_FE/.agents/skills/frontend-conventions/SKILL.md`를 함께 따른다.

## 적용 범위

이 기준은 컴포넌트, 훅, API 호출, 폼, 상태, effect, 접근성 검토에 적용한다. Next.js App Router, React Server Components, Server Action 같은 규칙은 현재 FE가 Vite SPA이므로 적용하지 않는다.

이 기준은 `typescript-react-nextjs-patterns`의 React·TypeScript·TanStack Query·접근성 내용을 참고해 정리했다. 원본의 Next.js 전용 규칙은 FE 코드 기준에 포함하지 않는다.

## 타입과 외부 데이터

- `any`, 근거 없는 `as`, `@ts-ignore`로 타입 오류를 피하지 않는다. `unknown`을 좁히거나 명시적인 type guard를 사용한다.
- 컴포넌트 props는 `interface`로 선언하고, `children`은 `React.ReactNode`로 선언한다.
- API 응답, URL 파라미터, 폼 입력, 브라우저 저장소처럼 애플리케이션 밖에서 들어오는 데이터는 새로 만들거나 크게 바꾸는 경계부터 Zod 등으로 런타임 검증한다.
- 기존 API 응답 타입의 Zod 전환은 기능 변경과 무관하게 한꺼번에 하지 않는다. 관련 기능을 수정할 때 경계별로 옮긴다.

## 상태와 effect

- 서버 데이터는 TanStack Query가 소유한다. 사용자 편집용 draft가 아닌 한 query 데이터를 `useState`에 복사하지 않는다.
- 화면의 기본값은 effect에서 동기적으로 복사하지 않고 render에서 계산한다. 사용자가 수정한 값만 별도 draft 상태로 둔다.
- `useState`와 `useReducer`는 지역 UI 상태에 사용한다. 여러 화면에서 드물게 바뀌는 값은 Context, URL로 공유해야 하는 필터나 탐색 상태는 URL 상태를 검토한다.
- effect는 외부 시스템과 동기화할 때만 사용한다. 의존성은 안정적이고 완전해야 하며 listener, timer, subscription은 cleanup한다.
- 측정된 문제 없이 `useMemo`, `useCallback`, `React.memo`를 추가하지 않는다.

## 컴포넌트와 접근성

- native element를 감싼 컴포넌트는 필요한 HTML attribute를 전달한다.
- 재사용 컴포넌트의 callback은 가능하면 browser event 대신 도메인 값을 전달한다.
- 모든 input에는 연결된 label 또는 `aria-label`을 둔다. 오류 메시지는 보조기술이 알 수 있게 표시하며, 필요한 경우 `role="alert"`를 사용한다.
- 상호작용 요소는 keyboard로 조작 가능하고 접근 가능한 이름을 가져야 한다.

## API와 TanStack Query

- API 함수는 `src/api`, 공유 request·response 타입은 `src/types`, query와 mutation 조합은 `src/queries`에 둔다.
- 새 도메인 또는 재사용되는 query 설정에는 namespaced query key와 query-key factory를 사용한다.
- 화면은 loading, error, empty 상태를 처리한다. 로딩 전 query 결과를 존재한다고 단정하지 않는다.
- mutation 성공 뒤에는 영향을 받은 cache만 갱신하거나 무효화한다.

## 확인 방법

코드 변경 뒤에는 아래 명령을 실행한다.

```bash
npm run lint
npm run build
```

## 관련 기준

- FE 실행 규칙: `Allreva_FE/AGENTS.md`
- FE Agent Skill: `Allreva_FE/.agents/skills/frontend-conventions/SKILL.md`
- Issue 기준: [Issue 작성과 분류 기준](issue-workflow.md)
- PR 기준: [PR 작성과 문서 연결 기준](pull-request-workflow.md)
- 참고: [typescript-react-nextjs-patterns](https://github.com/leejpsd/typescript-react-nextjs-patterns)
