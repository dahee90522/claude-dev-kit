---
description: Next.js 기능 구현 전에 탐색→계획→승인 흐름을 강제한다
argument-hint: <기능 또는 티켓 설명>
---

# 계획 모드 (Next.js App Router)

**$ARGUMENTS** 에 대한 구현 계획을 수립합니다.

## 반드시 지킬 것
- **아직 코드를 작성하지 마세요.** 읽기와 분석만.
- Server/Client 경계, 캐시 전략, DB 변경을 반드시 고려.

## 진행 순서

### 1. 탐색 (Explore) — `ultrathink`
- 영향받는 라우트(`app/**`), 레이아웃, Server Action
- 관련 컴포넌트, TanStack Query 훅, Zod 스키마
- DB: Prisma 스키마 변경 필요한가?
- 인증/인가 가드 위치 (middleware, layout, page)
- 캐시 전략 영향 (revalidate, tags, dynamic)

### 2. 계획 (Plan)
```
## 목표
<한 문장>

## 영향 파일
- app/.../page.tsx (수정/신규)
- src/components/... (신규)
- src/server/... (Server Action)
- prisma/schema.prisma (변경 있다면)

## Server/Client 경계
- Server Component: ...
- Client Component ("use client"): ... (왜 클라이언트여야 하는지)
- Server Action: ...

## 데이터 페칭 / 캐시
- 읽기: <fetch cache 전략 / revalidate / tags>
- 쓰기: Server Action → revalidatePath/revalidateTag(...)
- 클라이언트 캐시: TanStack Query key

## DB 영향
- 마이그레이션 필요: <Y/N>
- 스키마 변경 요약: ...
- 데이터 백필 필요: <Y/N>

## 인증/인가
- 보호 경로: ...
- 권한 체크 위치: ...

## 변경 요약
1. ...
2. ...

## 테스트 전략
- 단위(Vitest): ...
- 컴포넌트(RTL): ...
- E2E(Playwright): <중요 플로우>

## 리스크 / 트레이드오프
- 성능: 번들 크기, N+1, 워터폴
- SEO: 메타데이터, 로딩 UX
- 보안: 입력 재검증, NEXT_PUBLIC 오노출

## 예상 커밋 개수
N 개 (DB / 서버 / 클라이언트 / 테스트 분리)
```

### 3. 승인 대기
계획 제시 후 **반드시 사용자 승인을 기다립니다.**
