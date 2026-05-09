#!/usr/bin/env bash
# tmux status bar animation: 카오모지 + mauve 계열 색상 음영 변화
#
# 출력: rounded chevron () + spinner block + rounded chevron ()
#       전체 styled 블록 → tmux #(...) 결과로 직접 렌더
#
# 호출 주기는 tmux 의 status-interval 에 의존 (1초 권장)
# frame / 색상 갱신 주기는 ROTATE_SEC (기본 30초). 같은 버킷 안에선 고정.
# bg=default 사용으로 평시/copy-mode 자동 적응
# 의존: UTF-8 + East Asian Wide 지원 폰트 (Nerd Font 권장)

frames=(
  # 대괄호 [X_X] — 봇/로봇 무드
  '[o_o]'
  '[O_O]'
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
  '[T_T]'
  '[x_x]'
  '[._.]'
  '[?_?]'
  '[!_!]'

  # 소괄호 (X_X) — kaomoji 변형
  '(o_o)'
  '(O_O)'
  '(•_•)'
  '(•‿•)'
  '(^_^)'
  '(-_-)'
  '(~_~)'
  '(¬_¬)'
  '(>_<)'
  '(>.<)'
  '(T_T)'
  '(x_x)'
  '(°_°)'
  '(°o°)'
  '(=_=)'
  '(@_@)'
  '(*_*)'
  '(?_?)'
  '(¯_¯)'
  "('_')"
  "(\$_\$)"
  '(¬‿¬)'
  '(>‿<)'
  '(^‿^)'
  '(o‿o)'
  '(o.O)'
  '(O.o)'
  '(z_z)'

  # 일본 카오모지 — wide char 포함 (행복/사랑)
  '(◕‿◕)'
  '(◠‿◠)'
  '(´∀`)'
  '(◡‿◡)'
  '(✿◠‿◠)'
  '(｡◕‿◕｡)'
  '(＾▽＾)'
  '(≧◡≦)'
  '(✧ω✧)'
  '(♥‿♥)'

  # 슬픔/지침
  '(；ω；)'
  '(╥﹏╥)'
  '(ToT)'
  '(￣ω￣)'
  '(´；ω；`)'
  '(｡ŏ﹏ŏ)'

  # 놀람/혼란
  '(◎_◎)'
  '(°ロ°)'
  '(◔_◔)'
  '(O﹏O)'

  # 화남/짜증
  '(◣_◢)'
  '(╬ಠ益ಠ)'
  '(¬､¬)'

  # 시그니처
  '¯\_(ツ)_/¯'
  'ʕ•ᴥ•ʔ'
  'ヽ(´ー`)ノ'
  '(╯°□°)╯'
  'ᕦ(ò_óˇ)ᕤ'

  # 졸림/평온
  '(¦3[▓▓]'
  '(´-ω-`)'
  '(･ω･)'
  '(￣o￣)'
)

# mauve 계열 색상 음영 (catppuccin mauve #c6a0f6 기준 미세 변형)
colors=(
  '#c6a0f6'  # 기본 mauve
  '#cba2f9'  # 살짝 밝게
  '#bd95ed'  # 살짝 어둡게
  '#cea2f0'  # 핑크 쪽
  '#be9ef9'  # 블루 쪽
  '#d4adf6'  # 연한 핑크
  '#b598ec'  # 톤 다운
  '#dab8f9'  # 연 로지
  '#f5bde6'  # catppuccin pink
  '#b7bdf8'  # catppuccin lavender
)

ROTATE_SEC=30
bucket=$(( $(date +%s) / ROTATE_SEC ))

RANDOM=$bucket
i=$((RANDOM % ${#frames[@]}))
RANDOM=$((bucket + 7919))   # 색상은 다른 시드로 → frame 과 독립적 회전
c=$((RANDOM % ${#colors[@]}))

frame="${frames[$i]}"
color="${colors[$c]}"

LCH=$'\xee\x82\xb6'   #  U+E0B6
RCH=$'\xee\x82\xb4'   #  U+E0B4

printf '#[fg=%s bg=default]%s#[bg=%s fg=#181926] %s #[bg=default fg=%s]%s' \
  "$color" "$LCH" "$color" "$frame" "$color" "$RCH"
