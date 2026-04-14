---
description: 현재 브랜치의 Next.js 변경사항을 시니어 관점에서 리뷰한다
argument-hint: [비교할 브랜치, 기본값 main]
---

# 코드 리뷰 (Next.js App Router)

비교 대상: **${ARGUMENTS:-main}**

## 진행 방식
```bash
git diff ${ARGUMENTS:-main}...HEAD
git log ${ARGUMENTS:-main}...HEAD --oneline
```

## 체크리스트 (우선순위 순)

1. **정확성** — 버그, 엣지 케이스, race condition
2. **Server/Client 경계**
   - `"use client"` 가 정말 필요한 곳에만 붙었는가? (이벤트/상태/브라우저 API)
   - Server Component에서 `useState`/`useEffect` 없는가?
   - 클라이언트 컴포넌트가 서버 전용 모듈(fs, db)을 import하지 않는가?
3. **보안**
   - Server Action/Route Handler에서 **입력 재검증** (Zod 등) 및 인가 체크
   - `NEXT_PUBLIC_*` 에 비밀 누출 여부
   - `dangerouslySetInnerHTML` 살균
   - CSRF (Server Action은 기본 보호되지만 Route Handler는 직접 처리)
   - 열린 리다이렉트 (`redirect()` 대상 검증)
4. **캐시 전략**
   - `fetch` 의 `cache` / `next.revalidate` / `tags` 명시됐는가?
   - 뮤테이션 후 `revalidatePath` / `revalidateTag` 호출 누락 없는가?
   - `dynamic`, `revalidate`, `fetchCache` 세그먼트 옵션 의도대로인가?
5. **타입 안전성** — `any` 사용, `params`/`searchParams` 타입, API 응답 타입
6. **성능**
   - 데이터 워터폴 (순차 await 대신 `Promise.all`)
   - 번들 크기: Client Component 비대화, 서버 라이브러리 클라이언트 유입
   - 이미지 `next/image`, 폰트 `next/font`
   - 불필요한 리렌더 (`memo`, `useCallback`, `useMemo`)
7. **접근성** — 시맨틱 HTML, 포커스 관리, ARIA, 키보드
8. **SEO** — `generateMetadata`, Open Graph, sitemap/robots, canonical
9. **테스트 커버리지** — 서버 로직 단위, 컴포넌트, 중요 플로우 E2E
10. **Prisma / DB** — N+1, 트랜잭션 누락, 인덱스 필요성

## 출력 형식

```
## 종합 판단
<머지 가능 / 수정 필요 / 재설계 필요>

## 캐시 / 렌더 영향
- 영향받는 라우트: ...
- 재검증 누락: ...
- 정적/동적 렌더링 변화: ...

## 🔴 Blocking Issues
- [파일:줄] 문제와 제안

## 🟡 Suggestions
- ...

## 🟢 Nits
- ...

## 잘한 점
- ...
```

**중요**: 아첨 금지. 문제 없으면 "문제 없음" 한 줄로.
