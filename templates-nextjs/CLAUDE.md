# CLAUDE.md — Next.js 프로젝트

> Claude가 매 세션 시작 시 자동으로 읽습니다. 200줄 이내 유지.
> 상세 문서는 링크로 연결하고, 긴 내용을 여기에 복붙하지 마세요.

## 프로젝트 개요
- **이름**: [프로젝트명]
- **한 줄 설명**: [무엇을 하는지]
- **Next.js**: 14.x (App Router)
- **언어**: TypeScript (strict)
- **런타임**: Node 20+, React 18
- **스타일**: Tailwind CSS + shadcn/ui
- **상태 관리**: Zustand (클라이언트), TanStack Query (서버 상태)
- **DB/ORM**: PostgreSQL + Prisma ([또는 Drizzle])
- **인증**: NextAuth.js v5 (Auth.js)
- **테스트**: Vitest + React Testing Library (+ Playwright for E2E)
- **배포**: Vercel ([또는 AWS/Cloud Run])

## 필수 명령어 (Claude가 자주 사용)

### 개발
```bash
npm run dev                    # http://localhost:3000
npm run dev -- --turbo         # Turbopack (실험)
npm run dev -- -p 3001         # 포트 변경
```

### 품질 게이트 (PR 전 반드시 통과)
```bash
npm run typecheck              # tsc --noEmit
npm run lint                   # next lint / eslint
npm run lint -- --fix
npm run format                 # prettier --write
npm run test                   # Vitest
npm run test -- --coverage
npm run test:e2e               # Playwright (선택)
npm run build                  # 프로덕션 빌드 — PR 전 필수
```

### DB / Prisma
```bash
npx prisma generate
npx prisma migrate dev --name <migration_name>
npx prisma migrate deploy      # 프로덕션용, CI에서만
npx prisma studio              # 로컬 GUI
npx prisma db seed
npx prisma format
```

### 캐시/빌드 문제 해결
```bash
rm -rf .next                   # Next 빌드 캐시
rm -rf node_modules/.cache
npm run build -- --no-lint     # 린트 제외 빌드 디버깅
```

## 코드 스타일
- TypeScript strict. `any` 금지 (불가피하면 `unknown` + 타입 가드).
- **Server Component 기본, Client Component는 필요할 때만** (`"use client"` 선언은 최소한으로).
- 파일명: 라우트는 Next 규약 (`page.tsx`, `layout.tsx`, `loading.tsx`, `error.tsx`), 컴포넌트는 `PascalCase.tsx`, 그 외 `kebab-case.ts`.
- 타입은 `type` 선호, 확장 가능성 있으면 `interface`.
- import 순서: 외부 → `@/` 절대경로 → 상대경로 (eslint-plugin-import).
- 주석은 "왜"만. "무엇"은 코드로 설명.
- Tailwind 클래스 순서: `clsx` + `tailwind-merge` 조합 (`cn()` 유틸 사용).

## 아키텍처 패턴

### App Router 원칙
- **Server Component 우선**: 데이터 페칭은 서버에서. `async` 컴포넌트로 직접 `await`.
- **Client Component 경계**: 이벤트 핸들러·상태·브라우저 API가 필요한 가장 '잎' 컴포넌트에만 `"use client"`.
- **Server Actions** (`"use server"`): 폼 제출·뮤테이션. 단, 무거운 로직은 Route Handler 분리.
- **Route Handlers** (`app/api/*/route.ts`): 외부 노출 API, 웹훅.

### 데이터 페칭
- 서버: `fetch` 내장 캐싱 활용 (`cache`, `revalidate`, `tags`).
- 클라이언트 상태: TanStack Query (서버 데이터의 클라이언트 캐시).
- 변경은 Server Action 또는 Route Handler → `revalidatePath` / `revalidateTag`.

### 폼 / 검증
- React Hook Form + Zod. Server Action에서도 동일 Zod 스키마로 서버 재검증.
- 에러는 `useFormState` / `useActionState`로 폼에 바인딩.

### 인증 / 인가
- 세션은 `auth()` 서버 헬퍼로 가져와 Server Component에서 가드.
- 미들웨어(`middleware.ts`)는 빠른 리다이렉트 전용. 비즈니스 규칙은 페이지/레이아웃에서.

## 디렉토리 구조
```
app/
├── (marketing)/          # route group
├── (app)/
│   ├── layout.tsx
│   └── dashboard/
│       ├── page.tsx
│       └── loading.tsx
├── api/
│   └── <resource>/route.ts
└── layout.tsx
src/
├── components/
│   ├── ui/               # shadcn/ui 원시 컴포넌트
│   └── ...               # 조합 컴포넌트
├── lib/
│   ├── auth.ts
│   ├── db.ts             # Prisma 싱글톤
│   └── utils.ts          # cn(), 기타
├── hooks/
│   └── queries/          # TanStack Query 훅
├── stores/               # Zustand
├── schemas/              # Zod
└── server/               # Server Action 모음
prisma/
├── schema.prisma
└── migrations/
```

## 절대 금지 사항 (Guardrails)
- `.env*` 커밋 금지. `.env.example` 만 커밋.
- 비밀(DB URL, JWT secret, API 키)을 클라이언트 번들에 노출 금지 — `NEXT_PUBLIC_*` 접두사 남용 금지.
- `main` 직접 push 금지. `git push --force` 금지.
- Server Component에서 `useState`/`useEffect` 사용 시도 금지 (Client 경계 혼동).
- Server Action/Route Handler에서 **입력 재검증 없이** DB 호출 금지.
- Prisma migration 파일 수동 편집 금지 (마이그레이션 히스토리 깨짐). 재생성은 `migrate reset`로.
- `console.log` 프로덕션 남기지 말 것 — logger(`pino` 등) 사용.
- `dangerouslySetInnerHTML` 사용 시 반드시 `DOMPurify` 또는 허용 목록 기반 살균.

## 작업 흐름 (반드시 이 순서)
1. **탐색**: 관련 라우트/컴포넌트/스키마를 먼저 읽는다. 코드 금지.
2. **계획**: 변경 파일, 서버/클라이언트 경계, DB 마이그레이션 여부, 캐시 무효화 지점 요약.
3. **승인 대기**: 사용자 확인 후 진행.
4. **구현**: 작은 커밋. DB 마이그레이션은 별 커밋.
5. **검증**: `typecheck → lint → test → build` 모두 초록 확인 후 완료 보고.

## Next.js 특화 체크리스트 (기능 추가 시)
- □ Server/Client 경계가 적절한가? `"use client"` 최소화
- □ `loading.tsx`, `error.tsx` 가 필요한 세그먼트에 있는가?
- □ 메타데이터(`generateMetadata`) 업데이트 (SEO)
- □ 이미지 `next/image`, 폰트 `next/font` 사용
- □ 링크 `next/link`, 프리패치 고려
- □ 캐시 전략 명시: `force-cache` / `no-store` / `revalidate: N` / `tags`
- □ 인증 가드: 보호 라우트는 레이아웃에서 `auth()` 체크
- □ 접근성: 포커스 관리, ARIA, 키보드 네비게이션

## 컨텍스트 관리
- 컨텍스트 60% 넘기 전 진행 상황을 `progress.md`에 저장 후 `/clear`.
- 대용량 탐색(예: 라우트 전반 영향도)은 서브에이전트에 위임.
- Next 빌드 로그가 길면 에러 섹션만 남기고 나머지는 파일로 저장.

## 참고 문서 (필요할 때만)
- [아키텍처 상세](./docs/ARCHITECTURE.md)
- [API 규칙](./docs/API_CONVENTIONS.md)
- [인증 플로우](./docs/AUTH.md)
- [배포 가이드](./docs/DEPLOY.md)
