#!/usr/bin/env bash
# tmux-for-claude installer
# - tmux.conf 및 스크립트 심볼릭 링크 생성
# - TPM (tmux 플러그인 매니저) 설치
# - tmux 플러그인 자동 설치
# - 실행 중인 tmux 세션 즉시 reload
set -euo pipefail

REPO_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")" && pwd)"

echo "==> tmux-for-claude install"
echo "Repo: $REPO_DIR"

ln -sfv "$REPO_DIR/tmux.conf"                 "$HOME/.tmux.conf"
ln -sfv "$REPO_DIR/scripts/tmux-spinner.sh"   "$HOME/.tmux-spinner.sh"
ln -sfv "$REPO_DIR/scripts/claude-stop-tmux.sh" "$HOME/.claude-stop-tmux.sh"

if [[ ! -d "$HOME/.tmux/plugins/tpm" ]]; then
  echo "==> Install TPM"
  git clone https://github.com/tmux-plugins/tpm "$HOME/.tmux/plugins/tpm"
fi

echo "==> Install tmux plugins (catppuccin etc.)"
"$HOME/.tmux/plugins/tpm/bin/install_plugins"

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
