git clone https://github.com/hidehitofukushima/dotfiles.git
cd  dotfiles
./setup.sh



-- prerequisite
-- neovim
-- ~/.localbin/nvim
-- ~/.local/bin/tmux
-- lazygit(下記の通りインストール）
lazygit のインストール
go install github.com/jesseduffield/lazygit@latest

bashrcのみ、べつのファイルであることに注意





---------------------------------------------------------------------
---------------------------------------------------------------------
リポジトリの更新を反映させる方法
---------------------------------------------------------------------
git pullコマンドを使用することで、ローカルリポジトリ（clone先）をリモートリポジトリ（dotfiles）の最新の状態に更新することができます。

git pullは、以下の2つのコマンドをまとめて実行する便利なコマンドです。

git fetch: リモートリポジトリの最新情報を取得します。この時点では、ローカルリポジトリの作業ディレクトリは変更されません。

git merge: 取得した最新情報を、ローカルリポジトリの現在のブランチに     統合（マージ）します。

実行コマンド
dotfilesリポジトリをcloneしたディレクトリに移動し、以下のコマンドを実行してください。

git pull origin main
