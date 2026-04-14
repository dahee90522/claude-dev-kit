#!/usr/bin/env bash
# ─────────────────────────────────────────────────────────────
# claude-dev-kit → GitHub 자동 업로드 스크립트
#
# 사용법:
#   1) 이 스크립트를 claude-dev-kit 폴더 안에 두고 실행 권한 부여
#      chmod +x setup-github.sh
#   2) 실행
#      ./setup-github.sh
#
# 전제:
#   - gh CLI 설치 및 인증 (gh auth status 로 확인)
#     미설치면: macOS → brew install gh, 그 외 → https://cli.github.com
#     미인증이면: gh auth login 실행
#   - git 이 설치되어 있어야 함
#
# 이 스크립트가 하는 일:
#   1. 현재 폴더를 git 레포로 초기화
#   2. 모든 파일 커밋
#   3. GitHub에 Public 레포 "claude-dev-kit" 생성
#   4. main 브랜치로 푸시
# ─────────────────────────────────────────────────────────────

set -euo pipefail

REPO_NAME="claude-dev-kit"
VISIBILITY="public"   # "private" 로 바꾸면 비공개
DESCRIPTION="Claude를 효율적으로 쓰기 위한 개발자 가이드 + 스택별 템플릿 (React Native CLI, Next.js)"

# ── 사전 검사 ─────────────────────────────────────────────────
command -v git >/dev/null 2>&1 || { echo "❌ git이 설치되어 있지 않습니다."; exit 1; }
command -v gh  >/dev/null 2>&1 || { echo "❌ gh CLI가 설치되어 있지 않습니다. https://cli.github.com"; exit 1; }

if ! gh auth status >/dev/null 2>&1; then
  echo "❌ gh CLI 인증이 필요합니다. 먼저 다음을 실행하세요:"
  echo "   gh auth login"
  exit 1
fi

GH_USER=$(gh api user -q .login)
echo "✅ GitHub 사용자: ${GH_USER}"
echo "📦 생성할 레포: ${GH_USER}/${REPO_NAME} (${VISIBILITY})"
echo ""

# ── 이미 존재하는지 체크 ──────────────────────────────────────
if gh repo view "${GH_USER}/${REPO_NAME}" >/dev/null 2>&1; then
  echo "⚠️  이미 ${GH_USER}/${REPO_NAME} 가 존재합니다."
  read -p "   이 로컬 폴더를 원격에 덮어쓰기 푸시할까요? (y/N): " yn
  [[ "${yn}" =~ ^[yY]$ ]] || { echo "중단합니다."; exit 0; }
  SKIP_CREATE=1
else
  SKIP_CREATE=0
fi

# ── git 초기화 ────────────────────────────────────────────────
if [ ! -d .git ]; then
  git init -b main
  echo "✅ git init 완료 (main)"
else
  # 기존 레포라면 브랜치만 확인
  CUR_BRANCH=$(git rev-parse --abbrev-ref HEAD 2>/dev/null || echo "main")
  if [ "${CUR_BRANCH}" != "main" ]; then
    git branch -M main
  fi
  echo "ℹ️  기존 git 레포를 사용합니다."
fi

git add .
if git diff --cached --quiet; then
  echo "ℹ️  스테이지된 변경 없음. 커밋 건너뜀."
else
  git commit -m "chore: initial import — Claude dev kit (RN CLI + Next.js templates + guide)" \
    --author="${GH_USER} <${GH_USER}@users.noreply.github.com>" || \
    git commit -m "chore: initial import — Claude dev kit (RN CLI + Next.js templates + guide)"
  echo "✅ 초기 커밋 완료"
fi

# ── 원격 레포 생성 ────────────────────────────────────────────
if [ "${SKIP_CREATE}" -eq 0 ]; then
  gh repo create "${REPO_NAME}" \
    --"${VISIBILITY}" \
    --description "${DESCRIPTION}" \
    --source=. \
    --remote=origin \
    --push
  echo "✅ 원격 레포 생성 + 푸시 완료"
else
  # 원격 설정이 없으면 추가
  if ! git remote get-url origin >/dev/null 2>&1; then
    git remote add origin "https://github.com/${GH_USER}/${REPO_NAME}.git"
  fi
  git push -u origin main
  echo "✅ 기존 레포에 푸시 완료"
fi

URL="https://github.com/${GH_USER}/${REPO_NAME}"
echo ""
echo "🎉 완료! 레포 확인:"
echo "   ${URL}"
