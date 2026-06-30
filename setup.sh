#!/bin/bash

# 設定ファイルを置くディレクトリを作成
# `-p`オプションにより、ディレクトリが既に存在していてもエラーにならない
mkdir -p ~/.config/tmux
mkdir -p ~/.config/tmux-sessionizer

ln -sf ~/dotfiles/tmux/tmux.conf ~/.config/tmux/tmux.conf
ln -sf ~/dotfiles/tmux/tmux-sessionizer ~/.config/tmux-sessionizer/tmux-sessionizer
ln -sf ~/dotfiles/vimrc ~/.vimrc
ln -sf ~/dotfiles/zsh/zshrc ~/.zshrc


