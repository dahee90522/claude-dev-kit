---
description: 현재 스테이지된 변경사항을 Conventional Commits 형식으로 커밋한다
---

# 커밋 헬퍼

## 순서

1. `git status`, `git diff --staged`, 최근 `git log --oneline -10` 를 확인합니다.
2. 변경을 **논리 단위**로 분리할 수 있으면 여러 커밋으로 나눌 것을 제안하세요.
3. Conventional Commits 형식으로 메시지를 작성합니다.

## 형식

```
<type>(<scope>): <요약, 72자 이내>

<본문 — "왜"를 설명. 무엇은 diff를 보면 안다>

<footer — BREAKING CHANGE, Refs #123 등>
```

## type
- `feat`: 새 기능
- `fix`: 버그 수정
- `refactor`: 동작 변경 없는 구조 개선
- `perf`: 성능 개선
- `test`: 테스트만 추가/수정
- `docs`: 문서만
- `chore`: 빌드/의존성/설정

## 금지
- `.env`, 비밀키, 대용량 바이너리 포함 금지 — 발견 시 경고만 하고 멈춥니다.
- `--no-verify`, `--amend` (사용자가 명시하지 않는 한) 금지.
- 스테이지되지 않은 파일을 임의로 `git add .` 하지 말 것. 구체적 파일명만 추가합니다.
