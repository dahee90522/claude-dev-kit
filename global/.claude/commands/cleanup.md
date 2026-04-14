---
description: 주석·콘솔로그·미사용 import 정리. 기능 변경 없이 cosmetic만.
allowed-tools: Read, Glob, Grep, Edit, Bash(git diff:*), Bash(git status:*)
---

# /cleanup — 코드 정리

**기능 변경 금지.** 오직 cosmetic·dead code 제거.

## 1. 대상 파악
- `git status`로 현재 수정 중인 파일만 대상. 전체 리포 청소는 하지 마.
- 사용자가 `$ARGUMENTS`로 경로를 지정하면 그 범위로 한정.

## 2. 제거 대상
- `console.log`, `print`, `dbg!`, `TODO(temp)`, `// debug` 같은 임시 로그
- 사용되지 않는 import / 변수 / 함수
- 주석 처리된 오래된 코드 블록 (버전 관리가 대신함)
- 중복 빈 줄 (3줄 이상 연속)
- 트레일링 whitespace

## 3. 건드리지 말 것
- 기능 동작에 영향을 주는 로그 (에러 로깅, 감사 로그)
- 라이선스·저작권 헤더
- 타입 선언, 테스트 파일의 의도적 console 사용
- "왜"를 설명하는 주석 (특히 "일부러 이렇게 함" 류)

## 4. 출력
수정 전·후 diff를 보여주고 **파일 단위로 승인**을 받아라. 여러 파일이면 한 번에 보여주지 말고 하나씩.

## 5. 마무리
- `lint`·`typecheck`·`test` 중 프로젝트에 있는 것만 돌려라.
- 초록이면 "정리 완료" 한 줄 + 변경 파일 목록.
- 빨강이면 롤백 옵션 제시.

$ARGUMENTS
