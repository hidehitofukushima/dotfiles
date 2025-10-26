#!/bin/zsh

cd $(tmux run "echo #{pane_start_path}")
echo "Current directory: $(pwd)"
echo "Opening GitHub..."


url=$(git remote get-url origin)
echo "Remote URL: $url"

open $url || echo "No remote found"
