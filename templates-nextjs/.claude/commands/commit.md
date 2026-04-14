---
description: 현재 스테이지된 변경사항을 Conventional Commits로 커밋한다
---

# 커밋 헬퍼 (Next.js)

## 순서
1. `git status`, `git diff --staged`, 최근 `git log --oneline -10` 확인.
2. 변경을 **논리 단위**로 분리 가능하면 여러 커밋 제안.
3. Conventional Commits 형식으로 메시지 작성.

## 형식
```
<type>(<scope>): <요약, 72자 이내>

<본문 — "왜"를 설명>

<footer — BREAKING CHANGE, Refs #123>
```

## type
- `feat`: 새 기능
- `fix`: 버그 수정
- `refactor`: 동작 변경 없는 구조 개선
- `perf`: 성능 개선
- `style`: 포맷/주석 (기능 변경 없음)
- `test`: 테스트만
- `docs`: 문서만
- `chore`: 빌드/의존성/설정
- `db`: Prisma 스키마/마이그레이션 (별도 커밋 권장)

## scope 예
`auth`, `dashboard`, `api/users`, `prisma`, `ui`, `middleware`, `config`

## 금지
- `.env*`, 비밀키, 대용량 바이너리 포함 금지 — 발견 시 경고 후 중단.
- `--no-verify`, `--amend` (사용자 명시 없으면) 금지.
- `git add .` / `git add -A` 금지 — 구체 파일명만.
- Prisma 마이그레이션 파일 수동 편집 금지 — `migrate dev`로 재생성.
