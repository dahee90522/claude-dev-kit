#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# claude-dev-kit → ~/.claude/ 글로벌 설치 스크립트
#
# 사용법:
#   chmod +x install-global.sh
#   ./install-global.sh
#
# 이 스크립트가 하는 일:
#   1. 기존 ~/.claude/ 가 있으면 ~/.claude.backup-<timestamp>/ 로 백업
#   2. global/CLAUDE.md        → ~/.claude/CLAUDE.md
#   3. global/.claude/*        → ~/.claude/ (settings.json, commands/, agents/)
#   4. global/.mcp.json        → ~/.claude.json 내 mcpServers 로 병합 안내 (수동)
#
# 프로젝트별 .claude/ 와는 독립. Claude Code가 홈 계층을 먼저 로드하고
# 프로젝트 계층을 병합하며, 충돌 시 프로젝트가 우선한다.
# ─────────────────────────────────────────────────────────────

set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"
SRC="${SCRIPT_DIR}/global"
DEST="${HOME}/.claude"

if [ ! -d "${SRC}" ]; then
  echo "❌ ${SRC} 폴더가 없습니다. claude-dev-kit 루트에서 실행하세요."
  exit 1
fi

# ── 1. 기존 ~/.claude 백업 ────────────────────────────────────
if [ -e "${DEST}" ]; then
  TS=$(date +%Y%m%d-%H%M%S)
  BACKUP="${HOME}/.claude.backup-${TS}"
  echo "ℹ️  기존 ${DEST} 를 ${BACKUP} 로 백업합니다."
  mv "${DEST}" "${BACKUP}"
fi

mkdir -p "${DEST}/commands" "${DEST}/agents"

# ── 2. CLAUDE.md ──────────────────────────────────────────────
cp "${SRC}/CLAUDE.md" "${DEST}/CLAUDE.md"
echo "✅ ${DEST}/CLAUDE.md"

# ── 3. settings.json ──────────────────────────────────────────
cp "${SRC}/.claude/settings.json" "${DEST}/settings.json"
echo "✅ ${DEST}/settings.json"

# ── 4. commands ───────────────────────────────────────────────
cp "${SRC}/.claude/commands/"*.md "${DEST}/commands/" 2>/dev/null || true
echo "✅ ${DEST}/commands/*.md"

# ── 5. agents ─────────────────────────────────────────────────
cp "${SRC}/.claude/agents/"*.md "${DEST}/agents/" 2>/dev/null || true
echo "✅ ${DEST}/agents/*.md"

# ── 6. MCP 안내 ───────────────────────────────────────────────
echo ""
echo "ℹ️  글로벌 MCP 설정은 자동 병합하지 않습니다."
echo "   ${SRC}/.mcp.json 을 참고해서 필요한 서버만"
echo "   ~/.claude.json 의 \"mcpServers\" 에 수동으로 병합하세요."
echo "   (시크릿은 환경변수로. 예: GITHUB_TOKEN)"

echo ""
echo "🎉 글로벌 오케스트레이터 설치 완료."
echo "   확인: ls -la ${DEST}"
