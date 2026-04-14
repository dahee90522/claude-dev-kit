---
description: 새 프로젝트를 처음 열었을 때 구조·스택·관례를 파악하는 루틴.
allowed-tools: Read, Glob, Grep, Bash(ls:*), Bash(cat:*), Bash(git log:*), Bash(git branch:*)
---

# /onboard — 프로젝트 온보딩

새 리포를 처음 열었을 때 이 커맨드로 시작해라. **아무 코드도 쓰지 마.**

## 1. 메타 정보
다음 파일이 있으면 읽고 요약:
- `README.md`, `CLAUDE.md`, `CONTRIBUTING.md`
- `package.json` / `pyproject.toml` / `Cargo.toml` / `go.mod` / `pom.xml` / `build.gradle`
- `.nvmrc`, `.tool-versions`, `.python-version`

## 2. 스택·빌드 도구 식별
- 언어, 프레임워크, 패키지 매니저 (npm/pnpm/yarn/bun/pip/poetry)
- 빌드 / 테스트 / 린트 스크립트가 있는 위치
- 타입 체커가 있는가? (tsc, mypy, pyright)
- 테스트 러너 (jest/vitest/pytest/…)

## 3. 아키텍처 파악
- 최상위 디렉토리 구조를 `tree -L 2` 수준으로 요약.
- `src/` 혹은 `app/` 아래 주요 모듈을 3~5개 뽑아 각각의 책임을 한 줄씩.
- 진입점(entry point)은 어디인가?

## 4. 개발 워크플로
- 브랜치 전략 (`git branch -a`, `git log --oneline -20`)
- PR 템플릿, CI 설정 (`.github/workflows/`, `.gitlab-ci.yml`)
- 린트·포맷터 설정 파일
- 기존 이슈/PR에서 코드 스타일 힌트 추출

## 5. 보고 형식

다음 5단락으로 요약 (각 3줄 이내):

- **스택**: 언어·프레임워크·주요 라이브러리
- **구조**: 디렉토리와 각 책임
- **워크플로**: 어떻게 개발·테스트·배포하는가
- **관례**: 코드 스타일, 네이밍, 커밋 메시지 패턴
- **질문**: 문서나 코드만으로 명확하지 않은 부분 (사용자에게 확인받을 질문 3개 이하)

## 6. 제안
- 이 프로젝트에 `CLAUDE.md`가 없다면 초안을 만들지 제안.
- `.claude/commands/` 가 비어 있다면 `/plan`, `/review`, `/debug`, `/commit`을 스택에 맞게 커스터마이즈할지 제안.

$ARGUMENTS
