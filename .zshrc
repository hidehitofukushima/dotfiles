# =========================================================================
# NVM (Node.js) の設定 - Web開発などで使うなら残す
# =========================================================================
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"

# =========================================================================
# ghcup (Haskell) の設定 - Haskell言語を使うなら残す
# =========================================================================
[ -f "/Users/fukushimahideto/.ghcup/env" ] && . "/Users/fukushimahideto/.ghcup/env"

# =========================================================================
# rbenv の設定 - Rubyのバージョン管理に必須
# =========================================================================
eval "$(rbenv init - zsh)"

# =========================================================================
# Condaの設定 - 必要時に手動で 'conda activate' を実行するため、
# ここには何も書かないか、コメントアウトしておく
# =========================================================================
# # >>> conda initialize >>>
# # ... (condaのブロック) ...
# # <<< conda initialize <<<
alias s1='ssh sutil_ny1fh'
alias s2='ssh slogin_ny1fh'
alias s3='ssh sutil_hfukushi'
alias s4='ssh sutil_mt1ny'
eval "$(rbenv init -)"
export PATH=$(go env GOPATH)/bin:$PATH

# Created by `pipx` on 2025-08-18 13:53:28
export PATH="~/.local/bin:$PATH"
PATH="$PATH:/Applications/WezTerm.app/Contents/MacOS"
export PATH

