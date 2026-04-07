" colorscheme
colorscheme slate
" === core ===
set hidden
set number

" === undo ===
set undofile
set undodir=~/.vim/undo

" === indent ===
set tabstop=2
set shiftwidth=2
set expandtab
set smartindent

" === search ===
set hlsearch
set incsearch

" === clipboard ===
set clipboard=unnamed

" === misc ===
set noswapfile
set timeoutlen=300
let mapleader = "\<Space>"

call plug#begin()

" 既に ~/.fzf を持っている前提
Plug '~/.fzf'
Plug 'junegunn/fzf.vim'

call plug#end()

" 本当に残す基本だけ
set hidden
set splitbelow
set splitright
set ignorecase
set smartcase

" fd があれば :Files 系の候補生成を軽くする
if executable('fd')
  let $FZF_DEFAULT_COMMAND = 'fd --type f --hidden --exclude .git'
endif

" fzf は下 40% に出す
let g:fzf_layout = { 'down': '40%' }

" :Buffers で既に開いている window に飛ぶ
let g:fzf_vim = {}
let g:fzf_vim.buffers_jump = 1


" leader はデフォルトの \ のまま
nnoremap <silent> <leader>f :Files<CR>
nnoremap <silent> <leader>b :Buffers<CR>
nnoremap <silent> <leader>g :Rg<CR>
nnoremap <silent> <leader>c :Commands<CR>
nnoremap <silent> <leader>w :w<CR>
nnoremap <silent> <leader>q :q<CR>
inoremap jk <Esc>

