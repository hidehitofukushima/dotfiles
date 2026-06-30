" =============================================================================
" ~/.vimrc
" Neovim init.lua からの移植版
" プラグイン / LSP / 補完 / Treesitter / diagnostics なし
" =============================================================================

set nocompatible
set completeopt=menu,menuone,noselect


" -----------------------------------------------------------------------------
" 基本
" -----------------------------------------------------------------------------
let mapleader = " "

filetype plugin indent on
syntax enable

set encoding=utf-8

" Neovim 側の設定を移植
set mouse=
set noswapfile
set number
set nocursorcolumn
set smartindent

set tabstop=2
set shiftwidth=2

" 元の init.lua には expandtab は無かったので、いったん無効のまま。
" Python/Rを書くなら有効化してよい。
" set expandtab

set ignorecase
set smartcase

" Vim ではバッファ移動時に未保存バッファを隠せるようにしておく
set hidden

" Neovim diagnostics 用だったが、Vimでも軽いので残す
set updatetime=200

" Vimのバージョン差で壊れないように条件付き
if exists('&signcolumn')
  set signcolumn=yes
endif

" -----------------------------------------------------------------------------
" 行折り返し設定
" wrap=true を維持
" -----------------------------------------------------------------------------
set wrap
set linebreak

if exists('&breakindent')
  set breakindent
endif

let &showbreak = repeat(' ', 3)

" wrap時は表示行単位で上下移動
nnoremap <expr> j v:count == 0 ? 'gj' : 'j'
nnoremap <expr> k v:count == 0 ? 'gk' : 'k'

" -----------------------------------------------------------------------------
" クリップボード
" -----------------------------------------------------------------------------
" ローカルMacのVimなど、+clipboard がある環境では system clipboard を使う。
" SSH先のVimでは +clipboard が無いことも多いので、条件分岐にする。
if has('clipboard')
  if has('unnamedplus')
    set clipboard=unnamedplus
  else
    set clipboard=unnamed
  endif
endif

" -----------------------------------------------------------------------------
" 補完・検索・コマンドライン補助
" -----------------------------------------------------------------------------
set wildmenu
set wildmode=longest:full,full

" :find で再帰的にファイル検索できるようにする
set path+=**

set wildignore+=*/.git/*
set wildignore+=*/node_modules/*
set wildignore+=*/__pycache__/*
set wildignore+=*.pyc

" ripgrep があれば :grep に使う
if executable('rg')
  set grepprg=rg\ --vimgrep\ --smart-case
  set grepformat=%f:%l:%c:%m
endif

" -----------------------------------------------------------------------------
" netrw
" Oil の代替。
" <leader>e で常にカレントディレクトリを開く。
" -----------------------------------------------------------------------------
let g:netrw_banner = 0
let g:netrw_liststyle = 3
let g:netrw_browse_split = 0
let g:netrw_winsize = 25

nnoremap <leader>e :Explore .<CR>

" -----------------------------------------------------------------------------
" コアキーマップ
" -----------------------------------------------------------------------------

" insert mode escape
inoremap jk <Esc>

" スクロール後にカーソルを中央へ
nnoremap <C-d> <C-d>zz
nnoremap <C-u> <C-u>zz

" 保存・終了
nnoremap <leader>w :write<CR>
nnoremap <leader>q :quit<CR>
nnoremap <leader>Q :wqa<CR>

" バッファ操作
nnoremap <leader>s :edit #<CR>
nnoremap <leader>S :botright split #<CR>

nnoremap <leader>bda :%bdelete!<CR>
nnoremap <leader>bdd :%bdelete<CR>

" 無名レジスタの内容を shell command として実行
" Neovim側の <leader>xx 相当
nnoremap <leader>xx :execute '!' . getreg('"')<CR>

" tmux-sessionizer
if executable('tmux')
  nnoremap <C-g> :silent !tmux neww tmux-sessionizer<CR>:redraw!<CR>
endif


nnoremap <leader>f :r !sn<CR>
