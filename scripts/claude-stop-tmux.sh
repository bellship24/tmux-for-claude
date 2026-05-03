#!/usr/bin/env bash
# Claude Code Stop hook: tmux window 작업 완료 알림 + 8글자 요약
#
# 동작:
#  1. 해당 pane 의 window 에 @was_active=1 세팅 (tmux.conf 가 갈색 인덱스로 표시)
#  2. 트랜스크립트 마지막 assistant 메시지를 Haiku 로 한국어 요약 (≤8자)
#  3. window 옵션 @claude_summary 에 결과 세팅 → 윈도우 이름 옆 (요약) 표시
#
# 재귀 방지: 이 스크립트가 호출하는 claude -p 자체도 Stop hook 을 트리거하므로
# CLAUDE_STOP_TMUX_DEPTH 환경변수로 중첩 호출 차단.

[ -n "$TMUX_PANE" ] || exit 0

# 재귀 차단
if [ -n "$CLAUDE_STOP_TMUX_DEPTH" ]; then
  exit 0
fi
export CLAUDE_STOP_TMUX_DEPTH=1

# 색상 표시는 즉시 적용 (요약 실패 무관)
tmux set-option -wt "$TMUX_PANE" @was_active 1

# stdin JSON 에서 transcript_path 추출
input="$(cat)"
transcript_path=$(printf '%s' "$input" | jq -r '.transcript_path // empty' 2>/dev/null || true)

[ -n "$transcript_path" ] && [ -f "$transcript_path" ] || exit 0

# 트랜스크립트 역순으로 마지막 assistant 텍스트 추출
if command -v tac >/dev/null 2>&1; then
  reverse() { tac "$1"; }
else
  reverse() { tail -r "$1"; }
fi

last_text=$(reverse "$transcript_path" \
  | jq -r 'select(.type=="assistant") | .message.content[]? | select(.type=="text") | .text' 2>/dev/null \
  | head -1 \
  | head -c 2000)

[ -n "$last_text" ] || exit 0

# Haiku 로 8자 이내 한국어 요약
summary=$(claude -p --model haiku "다음 Claude 응답을 한국어 6자 이내 명사형(예: 버그수정, 테스트통과, 리팩터링)으로 요약. 따옴표·마침표·부연 없이 결과만 한 줄 출력:

$last_text" 2>/dev/null \
  | tr -d '\n"' \
  | head -c 60)

[ -n "$summary" ] || exit 0

# 8자(유니코드 문자) 절단
summary_trimmed="${summary:0:8}"

tmux set-option -wt "$TMUX_PANE" @claude_summary "$summary_trimmed"
