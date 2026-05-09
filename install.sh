#!/usr/bin/env bash
# tmux-for-claude installer
# - tmux.conf 및 스크립트 심볼릭 링크 생성
# - 심링크 검증 (스크립트 누락 방지)
# - TPM (tmux 플러그인 매니저) 설치
# - tmux 플러그인 자동 설치
# - 실행 중인 tmux 세션 즉시 reload
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> tmux-for-claude install"
echo "Repo: $REPO_DIR"

# 심볼릭 링크 — tmux.conf 가 #(~/.tmux-*.sh) 로 호출하므로 홈 직속에 위치
ln -sfv "$REPO_DIR/tmux.conf"                       "$HOME/.tmux.conf"
ln -sfv "$REPO_DIR/scripts/tmux-spinner.sh"         "$HOME/.tmux-spinner.sh"
ln -sfv "$REPO_DIR/scripts/tmux-pulse-mauve.sh"     "$HOME/.tmux-pulse-mauve.sh"
ln -sfv "$REPO_DIR/scripts/tmux-pulse-yellow.sh"    "$HOME/.tmux-pulse-yellow.sh"
ln -sfv "$REPO_DIR/scripts/tmux-jump-completed.sh"  "$HOME/.tmux-jump-completed.sh"
ln -sfv "$REPO_DIR/scripts/claude-stop-tmux.sh"     "$HOME/.claude-stop-tmux.sh"

# 심링크 검증 — 누락/실패 시 즉시 에러 (이전 사고 재발 방지)
for f in "$HOME/.tmux-spinner.sh" \
         "$HOME/.tmux-pulse-mauve.sh" \
         "$HOME/.tmux-pulse-yellow.sh" \
         "$HOME/.tmux-jump-completed.sh" \
         "$HOME/.claude-stop-tmux.sh"; do
  if [[ ! -x "$f" ]]; then
    echo "ERROR: $f not executable or missing"
    exit 1
  fi
done

# 의존성 — jq (claude-stop-tmux.sh 가 transcript JSON 파싱에 사용)
if ! command -v jq >/dev/null 2>&1; then
  if command -v brew >/dev/null 2>&1; then
    echo "==> Install jq (brew)"
    brew install jq
  else
    echo "WARN: jq not installed. Install manually for Claude Stop hook to work."
  fi
fi

# TPM 설치
if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  echo "==> Install TPM"
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo "==> Install tmux plugins (catppuccin etc.)"
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

# 실행 중인 tmux 세션 reload
if pgrep -x tmux >/dev/null 2>&1; then
  echo "==> Reload running tmux"
  tmux source-file "$HOME/.tmux.conf"
fi

echo ""
echo "Done."
echo ""
echo "Next steps:"
echo "  1. Wire up Claude Code Stop hook (see examples/claude-settings.json)"
echo "  2. Open a new tmux session: tmux new -s work"
