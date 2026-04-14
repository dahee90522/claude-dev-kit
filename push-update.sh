#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# claude-dev-kit → 기존 GitHub 레포에 업데이트 푸시
#
# 사용법:
#   chmod +x push-update.sh
#   ./push-update.sh
#
# 전제:
#   - gh CLI 설치·인증 완료 (gh auth status)
#   - 이 폴더가 github.com/<user>/claude-dev-kit 레포와 연결돼 있거나,
#     같은 레포가 이미 remote에 존재
# ─────────────────────────────────────────────────────────────

set -euo pipefail

REPO_NAME="claude-dev-kit"
BRANCH="main"

# ── 사전 검사 ─────────────────────────────────────────────────
command -v git >/dev/null 2>&1 || { echo "❌ git 없음"; exit 1; }
command -v gh  >/dev/null 2>&1 || { echo "❌ gh CLI 없음"; exit 1; }
gh auth status >/dev/null 2>&1 || { echo "❌ gh 인증 필요: gh auth login"; exit 1; }

GH_USER=$(gh api user -q .login)
REMOTE_URL="https://github.com/${GH_USER}/${REPO_NAME}.git"

# ── git 상태 확인 ─────────────────────────────────────────────
if [ ! -d .git ]; then
  echo "ℹ️  git 레포가 아닙니다. 초기화합니다."
  git init -b "${BRANCH}"
fi

CUR_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "${BRANCH}")
if [ "${CUR_BRANCH}" != "${BRANCH}" ]; then
  git branch -M "${BRANCH}"
fi

# ── remote 설정 ───────────────────────────────────────────────
if git remote get-url origin >/dev/null 2>&1; then
  CUR_URL=$(git remote get-url origin)
  if [ "${CUR_URL}" != "${REMOTE_URL}" ]; then
    echo "ℹ️  origin을 ${REMOTE_URL} 로 재설정"
    git remote set-url origin "${REMOTE_URL}"
  fi
else
  git remote add origin "${REMOTE_URL}"
fi

# ── 원격이 앞서 있으면 먼저 rebase ────────────────────────────
git fetch origin "${BRANCH}" 2>/dev/null || true
if git rev-parse --verify "origin/${BRANCH}" >/dev/null 2>&1; then
  AHEAD=$(git rev-list --count "HEAD..origin/${BRANCH}" 2>/dev/null || echo "0")
  if [ "${AHEAD}" -gt 0 ]; then
    echo "ℹ️  원격이 ${AHEAD} 커밋 앞섬. rebase 시도."
    git pull --rebase origin "${BRANCH}"
  fi
fi

# ── 변경사항 커밋 ─────────────────────────────────────────────
git add .
if git diff --cached --quiet; then
  echo "ℹ️  커밋할 변경 없음."
else
  git commit -m "feat: add global orchestrator layer (~/.claude/ defaults + install-global.sh)

- global/CLAUDE.md: 스택 무관 개인 작업 원칙·톤·오케스트레이션
- global/.claude/settings.json: 안전 기본값 (.env/SSH 차단, 파괴적 git 차단)
- global/.claude/commands/: /plan /review /debug /commit /cleanup /onboard
- global/.claude/agents/: explore, reviewer 서브에이전트
- global/.mcp.json: 글로벌 MCP 예시
- install-global.sh: ~/.claude/ 로 일괄 설치 (기존은 자동 백업)
- push-update.sh: 기존 레포 업데이트용
- README: 2계층 (글로벌 + 프로젝트) 구조 설명 갱신"
  echo "✅ 커밋 완료"
fi

# ── 푸시 ──────────────────────────────────────────────────────
git push -u origin "${BRANCH}"
echo ""
echo "🎉 업데이트 푸시 완료:"
echo "   https://github.com/${GH_USER}/${REPO_NAME}"
