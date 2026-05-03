#!/usr/bin/env bash
# tmux status bar animation: 다양한 표정 카오모지를 랜덤하게 표시
# 호출 주기는 tmux 의 status-interval 에 의존 (1초 권장)
# 표정 갱신 주기는 ROTATE_SEC (기본 15초). 같은 버킷 안에선 고정.
# 모든 프레임은 ASCII/단일셀 보장 5문자 → 폰트/터미널 무관 박스 폭 고정
# bash 변수 확장 회피 위해 single-quoted 배열 사용

frames=(
  '[o_o]'
  '[O_O]'
  '[o.o]'
  '[o-o]'
  '[•_•]'
  '[•‿•]'
  '[^_^]'
  '[-_-]'
  '[~_~]'
  '[¬_¬]'
  '[¬‿¬]'
  '[+_+]'
  '[*_*]'
  '[u_u]'
  '[T_T]'
  '[x_x]'
  '[._.]'
  '[?_?]'
  '[!_!]'
  '[#_#]'
)
ROTATE_SEC=15
bucket=$(( $(date +%s) / ROTATE_SEC ))
RANDOM=$bucket
i=$((RANDOM % ${#frames[@]}))
printf '%s' "${frames[$i]}"
