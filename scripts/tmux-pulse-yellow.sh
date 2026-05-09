#!/usr/bin/env bash
# Claude 작업 완료 윈도우 인덱스 발광 효과 — 2초 주기 3색 ping-pong
# 패턴: 밝음 → 중간 → 어두움 → 중간 → (반복)
PERIOD=2
case $(( $(date +%s) / PERIOD % 4 )) in
  0) printf '%s' '#eed49f' ;;  # bright
  1) printf '%s' '#d4b67a' ;;  # mid
  2) printf '%s' '#b89759' ;;  # dark
  3) printf '%s' '#d4b67a' ;;  # mid (back)
esac
