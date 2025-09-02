#!/bin/bash
# 前提：git cloneで~/.DOTFILESが作成済みであること
# git clone https://github.com/fukushimahideto/dotfiles.git ~/DOTFILES
# cd DOTFILES
# ./setup.sh

# 設定ファイルを置くディレクトリを作成
# `-p`オプションにより、ディレクトリが既に存在していてもエラーにならない
mkdir -p ~/.config/nvim
mkdir -p ~/.config/tmux

# nvimの設定ファイルへのシンボリックリンクを作成（または上書き）
# `-s`: シンボリックリンクを作成
# `-f`: リンク先が既に存在する場合、強制的に上書き
ln -sf ~/DOTFILES/init.lua ~/.config/nvim/init.lua
echo "nvimの設定をリンクしました。"

# tmuxの設定ファイルへのシンボリックリンクを作成（または上書き）
ln -sf ~/DOTFILES/.tmux.conf ~/.config/tmux/tmux.conf
echo "tmuxの設定をリンクしました。"

# weztermの設定ファイル
#
#/Users/fukushimahideto/DOTFILES/.wezterm.lua
ln -sf ~/DOTFILES/.wezterm.lua ~/.wezterm.lua


# bashrc
ln -sf ~/DOTFILES/.bashrc ~/.bashrc
ln -sf ~/DOTFILES/.bashrc ~/.bashrc.intr
ln -sf ~/DOTFILES/.bashrc ~/.bash_profile

