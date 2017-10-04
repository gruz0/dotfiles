if !filereadable(expand($HOME.'/.vim/bundle/Vundle.vim/README.md'))
    echo 'Installing Vundle...'
    silent !mkdir -p $HOME/.vim/bundle
    silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
endif

set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" colors
Plugin 'cocopon/iceberg.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'nanotech/jellybeans.vim'
Plugin 'tyrannicaltoucan/vim-deep-space'

" plugins
Plugin 'VundleVim/Vundle.vim'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-rails'
Plugin 'mileszs/ack.vim'
Plugin 'editorconfig/editorconfig-vim'
Plugin 'othree/html5.vim'
Plugin 'szw/vim-tags'
Plugin 'majutsushi/tagbar'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'abolish.vim'
Plugin 'kchmck/vim-coffee-script'
Plugin 'chase/vim-ansible-yaml'
Plugin 'fishbullet/deoplete-ruby'
Plugin 'padawan-php/deoplete-padawan'
Plugin 'posva/vim-vue'

Plugin 'scrooloose/nerdtree'
let NERDTreeShowHidden=1
let NERDTreeQuitOnOpen=1
let NERDTreeIgnore = ['^\.DS_Store$', '^\.keep$', '\.retry$', '\.pyc$']

Plugin 'ctrlpvim/ctrlp.vim'
let g:ctrlp_user_command = ['.git/', 'git --git-dir=%s/.git ls-files -oc --exclude-standard']

Plugin 'Shougo/deoplete.nvim'
let g:deoplete#enable_at_startup = 1

Plugin 'jlanzarotta/bufexplorer'
let g:bufExplorerDisableDefaultKeyMapping=1
let g:bufExplorerShowRelativePath=1

Plugin 'mxw/vim-jsx'
let g:jsx_ext_required = 0

Plugin 'reedes/vim-lexical'
let g:lexical#spelllang = ['en_us', 'ru_ru']

Plugin 'neomake/neomake'
let g:neomake_ruby_enabled_makers = ['rubocop']
let g:neomake_php_enabled_makers = ['php', 'phpcs']
let g:neomake_php_phpcs_args_standard = 'PSR2'
let g:neomake_javascript_enabled_makers = ['eslint']
" autocmd! BufWritePost * Neomake

call vundle#end()
filetype plugin indent on

let mapleader=','

if has('persistent_undo')
    silent !mkdir ~/.vim/backups > /dev/null 2>&1
    set undodir=~/.vim/backups
    set undofile
endif

syntax on
set t_Co=256
set background=dark
colorscheme jb

set showcmd " display incomplete commands
set number " show line numbers
set nowrap " no wrap for lines
set encoding=utf-8 " force encoding
set mousehide " hide mouse cursor
set hidden " hide last match
set visualbell " blink for errors
set noswapfile " skip creating swap files
set nobackup " do not create tilda files
set nowritebackup " skip io errors
set tabstop=2 " tab width
set shiftwidth=2 " number of spaces to use for each step of indent
set softtabstop=2 " tab visible width
set expandtab " spaces instead tabs
set smarttab " indent using shiftwidth
set autoindent " copy indent from previous line
set backspace=indent,eol,start " backspace through everything
set smartindent " enable nice indent
set shiftround " drop unused spaces
set hlsearch " highlight search results
set ignorecase " ignorecase in patterns
set smartcase " override ignorecase if pattern contains upper case
set incsearch " search while typing
set cursorline " highlight cursor line
set nofoldenable " disable folding
set colorcolumn=81 " highlight rules
set wildmenu " enhanced command completion
set history=1000 " command history
set wildmode=full
set wildchar=<Tab>
set wildcharm=<C-Z>
set wildignore+=*/.git/*,*/tmp/*,*/log/*,*/node_modules/*,*.so,*.swp,*.zip
set statusline=%02n:%<%f\ %h%m%r%=%-14.(%l,%c%V%)\ %P
set statusline+=%#warningmsg#
set statusline+=%*
set laststatus=2
set lazyredraw
set list
set listchars=trail:•,nbsp:≡,tab:>-

highlight ColorColumn ctermbg=8

" auto
au BufWritePre * :%s/\s\+$//e
au BufRead,BufNewFile {Vagrantfile,Gemfile,Capfile} set ft=ruby
au FileType php setl sw=4 sts=4 et
au FileType ruby setl sw=2 sts=2 et
au FileType html setl sw=2 sts=2 et
au FileType javascript setl sw=2 sts=2 et
au FileType yaml setl sw=2 sts=2 et

" russian
set keymap=russian-jcukenwin
set iminsert=0
set imsearch=0

" nerdtree
nmap <silent> <leader><leader> :NERDTreeToggle<CR>
nmap <silent> <leader>f :NERDTreeFind<CR>

" buffer management
nmap <leader>a :bprev<Return>
nmap <leader>s :bnext<Return>
nmap <leader>d :bd<Return>
nmap <leader>b :BufExplorer<CR>

" tab management
nmap <C-t> :tabnew<CR>
nmap <C-j> :tabprevious<CR>
nmap <C-k> :tabnext<CR>

" quick save
nmap <C-s> :w<CR>
nmap <A-s> :w !sudo tee % > /dev/null<CR>

" system buffer
vmap <C-c> "+yi
vmap <C-x> "+c
vmap <C-v> c<ESC>"+p
imap <C-v> <ESC>"+pa

" shared buffer
vmap <Leader>y :w! ~/.vbuf<CR>
nmap <Leader>y :.w! ~/.vbuf<CR>
nmap <Leader>p :r ~/.vbuf<CR>

" toggles
nmap <F4> :set invpaste<CR>:set paste?<CR>
imap <F4> <ESC>:set invpaste<CR>:set paste?<CR>
nmap <F5> :set invwrap<CR>:set wrap?<CR>
nmap <F5> <ESC>:set invwrap<CR>:set wrap?<CR>
nmap <F8> :TagbarToggle<CR>

" search highlight
nmap <silent> // :nohlsearch<CR>
nmap <leader>hl :set hlsearch! hlsearch?<CR>

" format the entire file
nmap <leader>fef :normal! gg=G``<CR>

" find merge conflict markers
nmap <silent> <leader>fc <ESC>/\v^[<=>]{7}( .*\|$)<CR>

" upper and lower string
nmap <leader>u mQviwU`Q
nmap <leader>l mQviwu`Q

" insert tab
:inoremap <S-Tab> <C-V><Tab>

" nighmare mode
map <Up> <NOP>
map <Down> <NOP>
map <Left> <NOP>
map <Right> <NOP>

runtime macros/matchit.vim
