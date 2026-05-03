# tmux-for-claude

> Claude Code 등 AI 코딩 에이전트와 함께 쓰기 위해 최적화된 tmux 설정

여러 Claude Code 세션을 페인/윈도우로 띄워 놓고 동시에 작업할 때, **어느 창에서 작업이 끝났는지 한눈에 알 수 있도록** 설계된 tmux 환경입니다. Catppuccin macchiato 테마 기반에 한국어 IME 친화 단축키, copy-mode 시각 강조, 작업 완료 자동 감지 등을 포함합니다.

## 핵심 기능

### 작업 완료 감지 및 시각 알림
- `monitor-silence` 1초 무출력 시 윈도우 인덱스 배경 노랑 강조
- Claude Code **Stop hook**과 연동되어 마지막 응답을 한국어 6자 이내로 자동 요약 (Haiku 사용)
- 윈도우 이름 옆에 `(요약)` 형태로 표시 — 다른 창에서 작업 중에도 어느 Claude가 무엇을 끝냈는지 즉시 파악

### Copy-mode 시각 통일감
- 진입 시 상단/하단 status bar 모두 노란색 토글
- 상단에 `COPY MODE` 라벨 + 스크롤 위치 `[현재/전체]` 표시
- pane border 색상 동시 강조

### 한국어 IME 친화 단축키
| 키 | 동작 | IME 무관 |
|---|---|---|
| `Tab` `\` | last-window | ✅ |
| `+` | new-window | ✅ |
| `[` `]` | window 이동 | ✅ |
| `Left` `Right` | window 이동 | ✅ |
| `Enter` | copy-mode 진입 | ✅ |
| `BSpace` `DC` `x` | kill-pane (확인 popup) | ✅ |

기본 `c` (new-window), `l` (last-window), `n`/`p`도 그대로 살아있음 — 영문 모드에선 표준 키, 한국어 모드에선 대체 키 사용.

### 깔끔한 윈도우 인디케이터
- chevron separator 제거된 사각 박스 형태
- 상태별 색상 구분:
  - 현재 창: mauve
  - 다른 창에서 활성: dark purple
  - 작업 완료(silence + Stop hook): yellow
  - idle: gray

### 화면 가운데 확인 popup
- `Prefix + x` / `BSpace` / `DC` 시 `Yes/No` 메뉴가 화면 정중앙 둥근 박스로 표시
- 한국어 IME 무관

### 카오모지 스피너
- status-right에 mauve 둥근 박스 안 카오모지 표정 표시 (`[•‿•]`, `[^_^]`, `[T_T]` 등)
- 15초 주기로 랜덤 회전, 모든 프레임 5셀 폭으로 통일되어 박스 폭 흔들림 없음

### 추가 편의 단축키
- `Prefix + |` / `-`: 페인 분할
- `Prefix + Shift+화살표`: 페인 이동
- `Prefix + y`: synchronize-panes 토글
- `Shift + 화살표` (prefix 없이): 5줄 스크롤 (자동 copy-mode 진입)
- `Ctrl+Shift + 화살표`: 반 페이지 스크롤
- copy-mode 안에서 `Shift+J/K`: 반 페이지 이동, `↑/↓`: 1줄 viewport 스크롤

## 요구사항

- tmux ≥ 3.2 (`{ ... }` 명령 블록, `display-menu -b` 등 사용)
- Nerd Font (powerline 글리프 ``, `` 및 catppuccin 아이콘 표시용)
- True Color 지원 터미널 (Ghostty / Wezterm / iTerm2 / Kitty / Alacritty 등)
- Bash (스크립트용), `jq` (Stop hook 트랜스크립트 파싱용)
- Claude Code (선택, Stop hook 연동 시)

## 설치

```bash
git clone https://github.com/bellship24/tmux-for-claude.git ~/tmux-for-claude
cd ~/tmux-for-claude
./install.sh
```

`install.sh`는 다음을 수행:
1. `~/.tmux.conf`, `~/.tmux-spinner.sh`, `~/.claude-stop-tmux.sh` 심볼릭 링크 생성
2. TPM(tmux 플러그인 매니저) 설치 (없을 경우)
3. catppuccin 등 플러그인 자동 설치
4. 실행 중인 tmux 세션 즉시 reload

### Claude Code Stop hook 연동 (선택)

`~/.claude/settings.json` 의 `hooks` 항목에 다음을 추가:

```json
{
  "hooks": {
    "Stop": [
      {
        "hooks": [
          { "type": "command", "command": "~/.claude-stop-tmux.sh", "async": true }
        ]
      }
    ]
  }
}
```

전체 예시는 [`examples/claude-settings.json`](examples/claude-settings.json) 참조.

## 디렉토리 구조

```
tmux-for-claude/
├── tmux.conf                       # 메인 설정 (~/.tmux.conf 로 링크)
├── scripts/
│   ├── tmux-spinner.sh             # status-right 카오모지 스피너
│   └── claude-stop-tmux.sh         # Claude Code Stop hook
├── examples/
│   └── claude-settings.json        # Claude Code settings.json 예시
├── install.sh                      # 셋업 자동화
├── LICENSE                         # MIT
└── README.md
```

## 호환성 노트

- **macOS / Linux**: 동작 확인 (저자 환경: macOS 14+)
- **WSL**: 별도 검증 안 됨, 동작할 것으로 예상
- **SSH 원격**: tmux 영속성 활용에 가장 적합한 환경

### cmux와의 차이

[cmux](https://cmux.com/)는 macOS 전용 GUI 터미널로 AI 에이전트용 작업 환경을 1급 기능으로 제공합니다. 이 repo는 다음 환경/취향에 적합합니다:

- macOS 외 플랫폼 (Linux, Windows/WSL)
- SSH/원격 서버에서의 Claude Code 사용
- 기존 tmux 사용자의 워크플로우 유지
- 깊은 커스터마이징을 원하는 경우

## 색상 팔레트 (Catppuccin macchiato)

| 용도 | 색상 |
|---|---|
| 현재 창 | mauve `#c6a0f6` |
| 다른 창 활성 | dark purple `#7a5bb5` |
| 작업 완료 (silence + Stop hook) | yellow `#eed49f` |
| idle | gray (`@thm_overlay_2`) |
| copy-mode bar | yellow `#eed49f` + dark text `#181926` |
| status bar bg (평시) | mantle `#1e2030` |

## 라이선스

[MIT](LICENSE)
