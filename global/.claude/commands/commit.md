---
description: Conventional Commits 형식으로 커밋 메시지 작성. 스테이지된 변경만 대상.
allowed-tools: Bash(git status:*), Bash(git diff:*), Bash(git log:*), Bash(git add:*), Bash(git commit:*)
---

# /commit — 커밋 메시지 작성

## 1. 현재 상태 확인
- `git status`로 스테이지/언스테이지 구분.
- `git diff --cached`로 스테이지된 내용만 읽어라.
- 스테이지 안 돼 있으면 **추가하지 말고** 사용자에게 어떤 파일을 스테이지할지 물어봐라.

## 2. 규칙
- **Conventional Commits**: `type(scope): subject`
  - type: `feat` / `fix` / `refactor` / `perf` / `test` / `docs` / `chore` / `build` / `ci` / `style`
  - scope: 선택. 영향받는 모듈·영역 (예: `auth`, `api/users`, `home-screen`)
  - subject: 현재형, 소문자 시작, 72자 이내, 마침표 없음
- **본문 (선택)**: "왜" 변경했는지. "무엇"은 diff가 설명하니 생략.
- **논리적으로 다른 변경은 섞지 마라.** 섞여 있으면 분리 커밋을 제안하고 승인 요청.

## 3. 금지
- 시크릿, `.env`, 크레덴셜 파일이 포함돼 있으면 중단하고 경고.
- `--amend`는 사용자가 명시적으로 요청할 때만.
- `--no-verify`로 훅 건너뛰지 말 것. 훅이 실패하면 원인을 고치고 재커밋.

## 4. 출력
커밋 메시지를 제시하고 **실행 전 승인**을 받아라. 승인되면:

```
git commit -m "<message>"
```

여러 논리 단위면 각각을 별도 커밋으로 순서대로 제안.

$ARGUMENTS
