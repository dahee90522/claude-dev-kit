# Claude 개발자 효율화 키트

개발자가 Claude(Claude Code, IDE, 웹 앱)를 효율적으로 쓰기 위한 **실전 가이드 + 즉시 적용 가능한 스택별 템플릿** 묶음입니다.

## 빠른 시작 (3분)

**① 본인 스택에 맞는 템플릿 폴더를 고릅니다.**

| 스택 | 폴더 |
|---|---|
| React Native CLI (모바일) | `templates-react-native-cli/` |
| Next.js (웹) | `templates-nextjs/` |

**② 프로젝트 루트에 복사합니다.**

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

**③ 본인 프로젝트에 맞게 수정합니다.**

- `CLAUDE.md` 상단의 `[프로젝트명]`, 스택 버전, 명령어를 실제 값으로 교체
- `.claude/settings.json` 의 `permissions.allow/deny` 를 본인 환경에 맞게 조정
- `.mcp.json` 에서 쓰지 않는 서버는 삭제, 필요한 것만 남기고 토큰은 환경변수로

**④ 터미널에서 `claude` 실행 → `/plan 새 기능` 으로 플래닝부터 시작.**

## 구성

### 공통
| 파일 | 역할 |
|---|---|
| `Claude_개발자_가이드.docx` | 기획 · 바이브코딩 · MCP · 리팩토링 · 리뷰 · 디버깅 · 문서화 종합 가이드 |
| `README.md` | 이 문서 |

### `templates-react-native-cli/` (모바일)
iOS/Android 빌드, Metro 캐시, CocoaPods, Gradle, Reanimated, 네이티브 모듈 autolinking 등 RN CLI 특화 규칙과 명령어. Sentry·Figma MCP 포함.

### `templates-nextjs/` (웹)
App Router(Server/Client 경계), Server Action, TanStack Query, Prisma, NextAuth, 캐시 전략(`revalidatePath`, `revalidateTag`) 특화. Vercel·Postgres·Playwright·Sentry MCP 포함.

### 두 템플릿 공통 슬래시 커맨드
| 커맨드 | 용도 |
|---|---|
| `/plan` | 탐색 → 계획 → 승인 흐름 강제 (스택별 계획 템플릿 포함) |
| `/review` | 시니어 관점 코드 리뷰 (스택별 체크리스트) |
| `/debug` | 가설 → 검증 기반 디버깅 (스택별 '의심 3대장' 포함) |
| `/commit` | Conventional Commits 형식 |

## 핵심 원칙 (한 장 요약)

- **컨텍스트 예산**: 60% 넘기 전 `/clear` + `progress.md` 로 재시작
- **CLAUDE.md는 200줄 이내**: 상세 문서는 링크로만 연결
- **코드 작성 전 계획 단계 분리**: `/plan` → 승인 → 구현
- **생각 깊이 조절**: 단순은 기본, 아키텍처는 `think hard`, 난제는 `ultrathink` (Claude Code CLI 한정)
- **서브에이전트로 병렬화**: 탐색·리서치는 서브에이전트에 위임해 메인 컨텍스트 보호
- **권한은 명시적으로**: `.claude/settings.json` 의 `deny` 로 위험 명령 차단
- **훅(Hook)은 반드시 실행돼야 하는 일에만**: 포맷터, 타입체크 같은 결정론적 작업

## 라이선스
MIT (자유롭게 복사·수정·배포)
