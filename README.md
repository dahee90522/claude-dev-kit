# Claude 개발자 효율화 키트

개발자가 Claude(Claude Code, IDE, 웹 앱)를 효율적으로 쓰기 위한 **실전 가이드 + 즉시 적용 가능한 템플릿** 묶음입니다.

## 2계층 구조

Claude Code는 설정을 **두 계층**에서 읽어서 병합합니다. 이 키트는 두 계층 모두를 제공합니다.

| 계층 | 위치 | 성격 |
|---|---|---|
| **글로벌 (오케스트레이터)** | `~/.claude/` | 스택 무관한 개인 스타일·공통 워크플로. 모든 프로젝트에 자동 적용. |
| **프로젝트** | `<repo>/.claude/` | 스택·프로젝트별 규칙. 글로벌을 덮어씀. |

충돌 시 **프로젝트 계층이 우선**합니다. 그래서 글로벌에는 "어느 프로젝트에서나 참인 것"만 두고, 스택 특화 규칙은 프로젝트 템플릿에 둡니다.

## 빠른 시작

### 1. 글로벌 오케스트레이터 설치 (1회)

```bash
# 키트 루트에서
./install-global.sh
```

이 스크립트는:
- 기존 `~/.claude/` 가 있으면 `~/.claude.backup-<timestamp>/` 로 백업
- `global/CLAUDE.md` → `~/.claude/CLAUDE.md`
- `global/.claude/settings.json` → `~/.claude/settings.json`
- `global/.claude/commands/*` → `~/.claude/commands/`
- `global/.claude/agents/*` → `~/.claude/agents/`

MCP 설정은 토큰이 걸려 있어 **자동 병합하지 않습니다.** `global/.mcp.json`을 참고해 필요한 서버만 `~/.claude.json`에 수동 병합하세요.

### 2. 프로젝트 템플릿 적용 (프로젝트마다)

본인 스택에 맞는 템플릿을 프로젝트 루트에 복사합니다.

| 스택 | 폴더 |
|---|---|
| React Native CLI (모바일) | `templates-react-native-cli/` |
| Next.js (웹) | `templates-nextjs/` |

```bash
# 예: Next.js 프로젝트
cp templates-nextjs/CLAUDE.md ./CLAUDE.md
mkdir -p .claude/commands
cp -r templates-nextjs/.claude/* ./.claude/
cp templates-nextjs/.mcp.json ./

# 예: React Native CLI 프로젝트
cp templates-react-native-cli/CLAUDE.md ./CLAUDE.md
mkdir -p .claude/commands
cp -r templates-react-native-cli/.claude/* ./.claude/
cp templates-react-native-cli/.mcp.json ./
```

### 3. 프로젝트에 맞게 수정

- `CLAUDE.md` 상단의 `[프로젝트명]`, 스택 버전, 명령어를 실제 값으로 교체
- `.claude/settings.json` 의 `permissions.allow/deny` 를 본인 환경에 맞게 조정
- `.mcp.json` 에서 쓰지 않는 서버는 삭제, 필요한 것만 남기고 토큰은 환경변수로

### 4. 터미널에서 `claude` 실행 → `/plan 새 기능` 으로 플래닝부터 시작

## 구성

### 공통 (루트)
| 파일 | 역할 |
|---|---|
| `Claude_개발자_가이드.docx` | 기획·바이브코딩·MCP·리팩토링·리뷰·디버깅·문서화 종합 가이드 |
| `install-global.sh` | `global/` → `~/.claude/` 설치 스크립트 |
| `setup-github.sh` | 이 키트 자체를 GitHub 레포로 올리는 스크립트 |
| `README.md` | 이 문서 |

### `global/` — 오케스트레이터 계층 (홈에 설치)
| 파일 | 역할 |
|---|---|
| `CLAUDE.md` | 스택 무관한 개인 작업 원칙, 언어·톤, 에이전트 오케스트레이션, 컨텍스트 관리, 생각 깊이 키워드 |
| `.claude/settings.json` | 안전 기본값. `.env`/SSH 키 읽기 차단, 파괴적 git 명령 차단, 패키지 설치는 ask |
| `.claude/commands/plan.md` | 탐색 → 계획 → 승인 흐름 (프로젝트 `/plan`이 없을 때 폴백) |
| `.claude/commands/review.md` | 스택 무관 공통 리뷰 체크리스트 |
| `.claude/commands/debug.md` | 가설-검증 기반 디버깅 |
| `.claude/commands/commit.md` | Conventional Commits |
| `.claude/commands/cleanup.md` | 주석·콘솔로그·dead import 정리 (기능 변경 금지) |
| `.claude/commands/onboard.md` | 새 리포 처음 열었을 때 구조 파악 루틴 |
| `.claude/agents/explore.md` | 대규모 탐색 서브에이전트 |
| `.claude/agents/reviewer.md` | 독립 시니어 리뷰어 서브에이전트 |
| `.mcp.json` | 글로벌 MCP 예시 (filesystem, github, memory) |

### `templates-react-native-cli/` — 모바일 프로젝트 계층
iOS/Android 빌드, Metro 캐시, CocoaPods, Gradle, Reanimated, 네이티브 모듈 autolinking 등 RN CLI 특화 규칙과 명령어. Sentry·Figma MCP 포함.

### `templates-nextjs/` — 웹 프로젝트 계층
App Router(Server/Client 경계), Server Action, TanStack Query, Prisma, NextAuth, 캐시 전략(`revalidatePath`, `revalidateTag`) 특화. Vercel·Postgres·Playwright·Sentry MCP 포함.

### 두 프로젝트 템플릿 공통 슬래시 커맨드
각 스택별로 체크리스트가 특화되어 있어 글로벌 버전을 덮어씁니다.

| 커맨드 | 용도 |
|---|---|
| `/plan` | 탐색 → 계획 → 승인 흐름 (스택별 계획 템플릿 포함) |
| `/review` | 시니어 관점 코드 리뷰 (스택별 체크리스트) |
| `/debug` | 가설 → 검증 기반 디버깅 (스택별 '의심 3대장' 포함) |
| `/commit` | Conventional Commits 형식 |

## 핵심 원칙 (한 장 요약)

- **컨텍스트 예산**: 60% 넘기 전 `/clear` + `progress.md` 로 재시작
- **CLAUDE.md는 200줄 이내**: 상세 문서는 링크로만 연결
- **코드 작성 전 계획 단계 분리**: `/plan` → 승인 → 구현
- **생각 깊이 조절**: 단순은 기본, 아키텍처는 `think hard`, 난제는 `ultrathink` (Claude Code CLI 한정)
- **서브에이전트로 병렬화**: 탐색·리서치는 `explore`에, 독립 리뷰는 `reviewer`에 위임해 메인 컨텍스트 보호
- **권한은 명시적으로**: `settings.json` 의 `deny`·`ask`로 위험 명령 차단
- **훅(Hook)은 반드시 실행돼야 하는 일에만**: 포맷터, 타입체크 같은 결정론적 작업

## 라이선스
MIT (자유롭게 복사·수정·배포)
