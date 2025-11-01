deno no install
curl -fsSL https://deno.land/x/install/install.sh | sh
-- backspaceが
infocmp -x xterm-ghostty | ssh YOUR-SERVER -- tic -x - (ローカルマシンでやること）
zshへ変更。
chsh.ldap -s /bin/zsh
oh-my-zshをインストール
	sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
zshrcのoverrideはしない。
git clone --depth 1 https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install
あとは、tmux, tmux-sesionizerのインストールくらいか。
lsp系は、masonでのサーバーのインストールと、R言語に対してのlanguageserverパッケージのインストールが必要。

###########################################
# git
###########################################
git clone https://github.com/hidehitofukushima/dotfiles.git
cd  dotfiles && setup.sh
git pull origin main

###########################################
# nodejs
###########################################
# curl が使えるならこちら（wgetでも可）
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.39.7/install.sh | bash

# これをzshrcに追加
export NVM_DIR="$HOME/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && \. "$NVM_DIR/nvm.sh"
[ -s "$NVM_DIR/bash_completion" ] && \. "$NVM_DIR/bash_completion"


# nodejs 
nvm install 18  
nvm use 18

###########################################
# neovim
###########################################

brew install cmake ninja gettext curl
eval "$(/opt/homebrew/bin/brew shellenv)"

-- neovim nightlyをインストール
https://github.com/neovim/neovim/blob/master/BUILD.md
@~
-- home directory でgit clone
git clone https://github.com/neovim/neovim
cd neovim && rm -rf builj
make CMAKE_EXTRA_FLAGS="-DCMAKE_INSTALL_PREFIX=$HOME/neovim" && make install 
mkdir -p ~/.local/bin && ln -sf ~/neovim/bin/nvim ~/.local/bin/nvim


###########################################
# tmux
###########################################

wget https://github.com/nelsonenzo/tmux-appimage/releases/download/3.5a/tmux.appimage
ただし、これはlinux-x64用のバイナリなので、macosでは、普通にbrew install tmux
mkdir -p ~/.local/bin && ln -sf ~/tmux.appimage ~/.local/bin/tmux

###########################################
# lazygit
###########################################
-- lazygit(下記の通りインストール）
go install github.com/jesseduffield/lazygit@latest

