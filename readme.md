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
mkdir -p ~/.local/bin && ln -sf ~/tmux.appimage ~/.local/bin/tmux


---------------------------------------------------------------------
-- lazygit
---------------------------------------------------------------------
-- lazygit(下記の通りインストール）
lazygit のインストール

go install github.com/jesseduffield/lazygit@latest
