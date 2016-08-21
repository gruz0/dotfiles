if !filereadable(expand($HOME.'/.vim/bundle/Vundle.vim/README.md'))
    echo 'Installing Vundle...'
    silent !mkdir -p $HOME/.vim/bundle
    silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
endif

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" tools
Plugin 'VundleVim/Vundle.vim'
Plugin 'scrooloose/nerdtree'
Plugin 'scrooloose/syntastic'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-rails'
Plugin 'ctrlpvim/ctrlp.vim'
Plugin 'mileszs/ack.vim'
Plugin 'rking/ag.vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'othree/html5.vim'
Plugin 'szw/vim-tags'
Plugin 'majutsushi/tagbar'
Plugin 'jelera/vim-javascript-syntax'

" color schemes
Plugin 'cocopon/iceberg.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'nanotech/jellybeans.vim'
Plugin 'tyrannicaltoucan/vim-deep-space'

call vundle#end()
filetype plugin indent on

autocmd filetype crontab setlocal nobackup nowritebackup

syntax enable
colorscheme iceberg

let mapleader=","
let g:solarized_termcolors=256
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_ruby_checkers = ['rubocop', 'mri']
let g:syntastic_mode_map = { 'mode': 'passive', 'active_filetypes': [],'passive_filetypes': [] }
let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1

set showcmd " display incomplete commands
set number " show line numbers
set nowrap " no wrap for lines
set encoding=utf-8 " force encoding
set mousehide " hide mouse cursor
set hidden " hide last match
set visualbell " blink for errors
set noswapfile " skip creating swap files
set tabstop=4 " tab width
set softtabstop=8 " tab like 8 spaces
set shiftwidth=4 " number of spaces to use for each step of indent
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
set wildmenu " enhanced command completion
set cursorline " highlight cursor line
set laststatus=2
set statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set guifont=Droid\ Sans\ Mono\ 12 " set default font
set t_Co=256
set wildignore+=*/.git/*,*/tmp/*,*/log/*,*/node_modules/*,*.so,*.swp,*.zip
set colorcolumn=81

" nav between tabs
nmap <C-j> :tabprevious<CR>
nmap <C-k> :tabnext<CR>

" toggle paste mode
nmap <silent> <F4> :set invpaste<CR>:set paste?<CR>
imap <silent> <F4> <ESC>:set invpaste<CR>:set paste?<CR>

" find merge conflict markers
nmap <silent> <leader>fc <ESC>/\v^[<=>]{7}( .*\|$)<CR>

" NERDTree
nmap <silent> <leader><leader> :NERDTreeToggle<CR>
nmap <silent> <leader>. :TagbarToggle<CR>
nmap <leader>f :NERDTreeFind<CR>

" allow to copy/paste between instances
vmap <leader>y :w! ~/.vbuf<CR>
nmap <leader>y :.w! ~/.vbuf<CR>
nmap <leader>p :r ~/.vbuf<CR>

" disable search highlight
nmap <silent> // :nohlsearch<CR>

" buffer management
map <leader>b :buffers<Return>
map <leader>a :bprev<Return>
map <leader>s :bnext<Return>
map <leader>d :bd<Return>

" insert tab
:inoremap <S-Tab> <C-V><Tab>

runtime macros/matchit.vim
