# ------------------------------
# Oh My Zsh 設定
# ------------------------------
export ZSH="$HOME/.oh-my-zsh"
ZSH_THEME="gozilla"

# プラグイン
plugins=(
  git
  zsh-autosuggestions
)

# ------------------------------
# 環境変数
# ------------------------------
# PATH（先頭に追加）
export PATH="$HOME/.local/bin:$HOME/.opencode/bin:$PATH"

# ロケール
export LANG="ja_JP.UTF-8"
export LC_CTYPE="ja_JP.UTF-8"

export MISE_EXPERIMENTAL=1

# ------------------------------
# 履歴設定
# ------------------------------
HISTFILE="$HOME/.zsh_history"
HISTSIZE=100000
SAVEHIST=100000

setopt APPEND_HISTORY
setopt INC_APPEND_HISTORY
setopt SHARE_HISTORY
setopt EXTENDED_HISTORY
setopt HIST_IGNORE_ALL_DUPS
setopt HIST_REDUCE_BLANKS

# ------------------------------
# Oh My Zsh 読み込み
# ------------------------------
source "$ZSH/oh-my-zsh.sh"

# ------------------------------
# ツール連携
# ------------------------------
# mise（シェル起動時に自動有効化）
if [ -x "$HOME/.local/bin/mise" ]; then
  eval "$("$HOME/.local/bin/mise" activate zsh)"
fi

# direnv
if command -v direnv >/dev/null 2>&1; then
  eval "$(direnv hook zsh)"
fi

# syntax-highlighting は最後に読み込む
if [ -f "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh" ]; then
  source "${ZSH_CUSTOM:-$HOME/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh"
fi

# ------------------------------
# エイリアス
# ------------------------------
alias ll='ls -lah'
alias gs='git switch'
