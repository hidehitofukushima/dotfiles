#!/bin/bash

# 設定ファイルを置くディレクトリを作成
# `-p`オプションにより、ディレクトリが既に存在していてもエラーにならない
mkdir -p ~/.config/nvim
mkdir -p ~/.config/tmux

# nvimの設定ファイルへのシンボリックリンクを作成（または上書き）
# `-s`: シンボリックリンクを作成
# `-f`: リンク先が既に存在する場合、強制的に上書き
ln -sf ~/dotfiles/init.lua ~/.config/nvim/init.lua
echo "nvimの設定をリンクしました。"

# tmuxの設定ファイルへのシンボリックリンクを作成（または上書き）
ln -sf ~/dotfiles/tmux.conf ~/.config/tmux/tmux.conf
echo "tmuxの設定をリンクしました。"

# weztermの設定ファイル
#
#/Users/fukushimahideto/dotfiles/.wezterm.lua
ln -sf ~/dotfiles/wezterm.lua ~/.wezterm.lua
# zshrc
ln -sf ~/dotfiles/zshrc ~/.zshrc
# bashrc
# supercomputer only
ln -sf ~/dotfiles/bash_profile ~/.bash_profile
ln -sf ~/dotfiles/bashrc ~/.bashrc



if [ -f ~/makefile ]; then
	echo "makefileが既に存在します。"
	rm ~/makefile
	rm ~/Makefile
fi
ln -sf ~/dotfiles/makefile ~/makefile
