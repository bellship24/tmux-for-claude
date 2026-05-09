#!/usr/bin/env bash
# 다음 작업완료(silence + @was_active=1) 윈도우로 순환 점프
# 현재 윈도우 이후 첫 번째 → 없으면 처음으로 순환
# 작업완료 창 없으면 무동작

set -euo pipefail

current=$(tmux display-message -p '#{window_index}')

# 작업완료 윈도우 인덱스 모음 (정렬)
candidates=$(tmux list-windows -F '#{window_index} #{window_silence_flag} #{@was_active}' \
  | awk '$2 == 1 && $3 == 1 {print $1}' | sort -n)

[[ -z "$candidates" ]] && exit 0

# 현재 이후 첫 번째
next=$(echo "$candidates" | awk -v cur="$current" '$1 > cur {print; exit}')

# 없으면 처음으로 순환
[[ -z "$next" ]] && next=$(echo "$candidates" | head -1)

tmux select-window -t "$next"
