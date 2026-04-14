---
description: Next.js 이슈를 재현→가설→검증 흐름으로 디버깅한다
argument-hint: <에러 메시지 또는 증상>
---

# 체계적 디버깅 (Next.js)

증상: **$ARGUMENTS**

**중요**: 추측 금지. 증거 수집 후 원인 확정 → 수정.

## 진행 순서

### 1. 재현 (Reproduce)
- 어느 환경? dev / build / production(Vercel)?
- Server/Client 어느 쪽 에러?
- Hydration 에러? "Text content does not match..." 경고?
- 특정 라우트에서만? 로그인 상태에서만?
- 최소 재현 또는 실패 테스트 먼저.

### 2. 관찰 (Observe)

**Server 에러:**
- 서버 로그 확인 (dev 콘솔 / Vercel Logs / Datadog)
- Error 객체의 `digest` 기록 → 프로덕션 로그 매칭
- Prisma 에러면 `DEBUG=prisma:query` 로 쿼리 확인

**Client 에러:**
- 브라우저 콘솔 + Network 탭
- React DevTools Profiler로 렌더 원인 추적

**Hydration 미스매치:**
- `Date.now()`, `Math.random()`, 브라우저 전용 API가 서버 렌더에 섞였는지
- `suppressHydrationWarning` 남용 확인
- 조건부 렌더가 `typeof window !== 'undefined'` 로 갈리는지

**빌드 실패:**
- `next build` 출력 전체 읽기
- `npm run build 2>&1 | tee build.log` 후 에러 섹션만 추출

### 3. 가설 — `think hard`
```
가설 A: 캐시 무효화 누락 — 확률 30%
  검증: revalidatePath/revalidateTag 추가 후 재현
가설 B: Server/Client 경계 오류 — 확률 40%
  검증: "use client" 위치 점검, 서버 모듈 import 확인
가설 C: 환경변수 미주입 — 확률 20%
  검증: process.env.* 값 런타임 로깅 (민감정보 제외)
```

### 4. Next.js 특화 '의심 3대장'
- **Hydration 미스매치**: 서버/클라이언트 출력이 다름
- **캐시 동작 혼동**: `fetch` 기본 캐시, `force-dynamic`, 라우트 세그먼트 옵션
- **Server Component 내 클라이언트 훅**: 직접 에러는 아니지만 예상과 다른 동작
- **Middleware 무한 리다이렉트**: matcher 설정 또는 조건 누락
- **Prisma 싱글톤 누락**: dev에서 연결 폭발 (globalThis 패턴 확인)

### 5. 수정 (Fix)
- 회귀 테스트 먼저 (Vitest / Playwright).
- 캐시 관련 수정은 `next build && next start` 로 프로덕션 빌드 재현 필수.
- 같은 버그의 다른 위치가 있는지 grep.

### 6. 보고
```
## 원인
<정확히 무엇이 왜>

## 수정
<파일:줄, 변경 요약>

## 캐시/재검증 영향
<revalidate 대상, 영향 라우트>

## 재발 방지
<테스트 / 린트 규칙 / CI 체크>
```
