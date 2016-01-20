if !filereadable(expand($HOME.'/.vim/bundle/Vundle.vim/README.md'))
    echo 'Installing Vundle...'
    echo ''
    silent !mkdir -p $HOME/.vim/bundle
    silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
endif

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'mileszs/ack.vim'
Plugin 'rking/ag.vim'
Plugin 'kien/ctrlp.vim'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-rails'
Plugin 'tomtom/tcomment_vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'cocopon/iceberg.vim'
Plugin 'altercation/vim-colors-solarized'
call vundle#end()
filetype plugin indent on

syntax enable

set showcmd " display incomplete commands
set background=light
let g:solarized_termcolors=256
colorscheme solarized
set guifont=Droid\ Sans\ Mono\ 12 " set default font
set number " show line numbers
set nowrap " no wrap for lines
set encoding=utf-8 " force encoding
set mousehide " hide mouse cursor
set hidden " hide last match
set visualbell " blink for errors
set noswapfile " skip creating swap files
set tabstop=2 " tab width
set softtabstop=2 " tab like 4 spaces
set shiftwidth=2 " number of spaces to use for each step of indent
set smarttab " indent using shiftwidth
set expandtab " tab with spaces
set autoindent " copy indent from previous line
set backspace=indent,eol,start " backspace through everything
set smartindent " enable nice indent
set shiftround " drop unused spaces
set hlsearch " highlight search results
set ignorecase " ignorecase in patterns
set smartcase " override ignorecase if pattern contains upper case 
set incsearch " search while typing
set guifont=Andale\ Mono:h14 " set font for gui version
set laststatus=2 statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P

let mapleader=","

noremap <Space> 20j
noremap <C-S-j> ddp
noremap <C-S-k> ddkP

nnoremap <c-j> <c-w>j
nnoremap <c-k> <c-w>k
nnoremap <c-h> <c-w>h
nnoremap <c-l> <c-w>l

map <C-n> :NERDTreeToggle<CR>
map <Leader>t :CommandT<Return>
map <Leader>a :bprev<Return>
map <Leader>s :bnext<Return>
map <Leader>d :bd<Return>
map <Leader>f :b 
