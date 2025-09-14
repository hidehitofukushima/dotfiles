#!/bin/bash

# 設定ファイルを置くディレクトリを作成
# `-p`オプションにより、ディレクトリが既に存在していてもエラーにならない
mkdir -p ~/.config/nvim
mkdir -p ~/.config/tmux

# nvimの設定ファイルへのシンボリックリンクを作成（または上書き）
# `-s`: シンボリックリンクを作成
# `-f`: リンク先が既に存在する場合、強制的に上書き
ln -sf ~/dotfiles/nvim/init.lua ~/.config/nvim/init.lua
echo "nvimの設定をリンクしました。"

# tmuxの設定ファイルへのシンボリックリンクを作成（または上書き）
ln -sf ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
echo "tmuxの設定をリンクしました。"

# tmux-sessionizerの設定ファイルへのシンボリックリンクを作成する
ln -sf ~/dotfiles/tmux/tmux-sessionizer ~/.config/tmux-sessionizer/tmux-sessionizer

# weztermの設定ファイル
ln -sf ~/dotfiles/wezterm/wezterm.lua ~/.wezterm.lua
# zshrc
ln -sf ~/dotfiles/shell/zshrc ~/.zshrc
# bashrc
ln -sf ~/dotfiles/shell/bash_profile ~/.bash_profile

ln -sf ~/dotfiles/shell/bashrc ~/.bashrc

if [ -f ~/makefile ]; then
	echo "makefileが既に存在します。"
	rm ~/makefile
fi
if [ -f ~/Makefile ]; then
	echo "Makefileが既に存在します。"
	rm ~/Makefile
fi
ln -sf ~/dotfiles/makefile ~/makefile
