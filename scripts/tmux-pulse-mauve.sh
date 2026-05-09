#!/usr/bin/env bash
# COPY MODE / 스크롤 위치 박스 발광 효과 — 2초 주기 3색 ping-pong
# 패턴: 밝음 → 중간 → 어두움 → 중간 → (반복)
PERIOD=2
case $(( $(date +%s) / PERIOD % 4 )) in
  0) printf '%s' '#c6a0f6' ;;  # bright
  1) printf '%s' '#b290de' ;;  # mid
  2) printf '%s' '#9e80c5' ;;  # dark
  3) printf '%s' '#b290de' ;;  # mid (back)
esac
