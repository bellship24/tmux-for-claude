#!/usr/bin/env bash
# Claude Code Stop hook: tmux window 작업 완료 알림
#
# 동작: 해당 pane 의 window 에 @was_active=1 세팅
#       → tmux.conf 가 노란 인덱스로 표시 (해당 window 방문 시 자동 해제)

[ -n "$TMUX_PANE" ] || exit 0

tmux set-option -wt "$TMUX_PANE" @was_active 1
