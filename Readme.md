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

---------------------------------------------------------------------

-- clone
---------------------------------------------------------------------
git clone https://github.com/hidehitofukushima/dotfiles.git
cd  dotfiles
./setup.sh
-- update repo
git pull origin main
git pullは、以下の2つのコマンドをまとめて実行する便利なコマンドです。
git fetch: リモートリポジトリの最新情報を取得します。この時点では、ローカルリポジトリの作業ディレクトリは変更されません。
git merge: 取得した最新情報を、ローカルリポジトリの現在のブランチに統合（マージ）します。

---------------------------------------------------------------------
-- neovim
---------------------------------------------------------------------
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


---------------------------------------------------------------------
-- tmux
---------------------------------------------------------------------
@~
wget https://github.com/nelsonenzo/tmux-appimage/releases/download/3.5a/tmux.appimage
ただし、これはlinux-x64用のバイナリなので、macosでは、普通に
brew install tmux

mkdir -p ~/.local/bin && ln -sf ~/tmux.appimage ~/.local/bin/tmux


---------------------------------------------------------------------
-- lazygit
---------------------------------------------------------------------
-- lazygit(下記の通りインストール）
lazygit のインストール

go install github.com/jesseduffield/lazygit@latest

# ahihihihih

---------------------------------------------------------------------
-- fonts
---------------------------------------------------------------------
vim.keymap.set('n', '<leader>r', "<cmd>lua require('fzf-lua').lsp_references()<CR>")
vim.keymap.set('n', '<leader>d', "<cmd>lua require('fzf-lua').lsp_definitions()<CR>")
vim.keymap.set('n', '<leader>D', "<cmd>lua require('fzf-lua').lsp_declarations()<CR>")
vim.keymap.set('n', '<leader>i', "<cmd>lua require('fzf-lua').lsp_implementations()<CR>")
vim.keymap.set('n', '<leader>s', "<cmd>lua require('fzf-lua').lsp_document_symbols()<CR>")
vim.keymap.set('n', '<leader>t', "<cmd>lua require('fzf-lua').lsp_typedefs()<CR>")
vim.keymap.set('n', '<leader>l', "<cmd>lua require('fzf-lua').diagnostics_document()<CR>")


mkdir -p ~/.local/share/fonts
# 例: FiraCode Nerd Fontをダウンロード
# 最新版のURLはGitHubで確認してください
wget https://github.com/ryanoasis/nerd-fonts/releases/download/v3.2.1/FiraCode.zip
unzip FiraCode.zip -d ~/.local/share/fonts/
fc-cache -fv
