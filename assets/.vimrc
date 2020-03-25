if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  autocmd VimEnter * PlugInstall --sync | source $MYVIMRC
endif

call plug#begin('~/.vim/plugged')
Plug 'vim-scripts/TaskList.vim'
Plug 'jlanzarotta/bufexplorer'
Plug 'ngmy/vim-rubocop', { 'for': 'ruby' }
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv'
Plug 'airblade/vim-gitgutter'
Plug 'bling/vim-airline'
Plug 'kchmck/vim-coffee-script', { 'for': 'coffee' }
Plug 'godlygeek/tabular'
Plug 'ap/vim-css-color'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'vim-syntastic/syntastic'
Plug 'tomtom/tcomment_vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'majutsushi/tagbar'
Plug 'terryma/vim-multiple-cursors'
Plug 'slim-template/vim-slim', { 'for': 'slim' }
Plug 'vim-ctrlspace/vim-ctrlspace'
Plug 'rking/ag.vim'
Plug 'tpope/vim-endwise'
Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'jiangmiao/auto-pairs'
Plug 'tomasr/molokai'
Plug 'leafgarland/typescript-vim', { 'for': 'javascript' }
Plug 'peitalin/vim-jsx-typescript', { 'for': 'javascript' }
Plug 'pangloss/vim-javascript', { 'for': 'javascript' }
Plug 'ekalinin/Dockerfile.vim', { 'for': 'Dockerfile' }
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': 'go' }
Plug 'neoclide/coc.nvim', {'branch': 'release'}
call plug#end()

set nocompatible

let mapleader=','

" vim-rubocop
let g:vimrubocop_config = '.rubocop.yml'
let g:vimrubocop_keymap = 0
nmap <C-R> :RuboCop<CR>

" gitv
let g:Gitv_OpenHorizontal = 0

" vim-gitgutter
let g:gitgutter_max_signs=9999

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'

" tabular
nmap <Leader>a= :Tabularize /=<CR>
vmap <Leader>a= :Tabularize /=<CR>
nmap <Leader>a: :Tabularize /:\zs<CR>
vmap <Leader>a: :Tabularize /:\zs<CR>

" nerdtree
let g:NERDTreeWinPos = "right"
map <C-N> :NERDTreeToggle<CR>
nmap <C-J> :tabprevious<CR>
nmap <C-K> :tabnext<CR>

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1
let NERDTreeBookmarksFile= $HOME . '/.vim/.NERDTreeBookmarks'
let NERDTreeWinSize=35

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set updatetime=100

let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_check_on_wq = 0
let g:syntastic_ruby_checkers = ['rubocop', 'mri']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = 'npm run lint --'
let g:godef_split = 0
let g:go_fmt_fail_silently = 0
let g:go_list_type = 'quickfix'
let g:go_auto_type_info = 1
let g:go_fmt_command = "goimports"
let g:syntastic_go_checkers = ['golangci_lint']
let g:syntastic_go_golangci_lint_args = [
      \ '--no-config', '--disable-all',
      \ '--enable=govet', '--enable=errcheck', '--enable=staticcheck', '--enable=unused', '--enable=gosimple',
      \ '--enable=structcheck', '--enable=varcheck', '--enable=ineffassign', '--enable=deadcode', '--enable=bodyclose',
      \ '--enable=golint', '--enable=stylecheck', '--enable=gosec', '--enable=interfacer', '--enable=unconvert',
      \ '--enable=dupl', '--enable=goconst', '--enable=gocognit', '--enable=rowserrcheck', '--enable=gofmt',
      \ '--enable=goimports', '--enable=maligned', '--enable=depguard', '--enable=misspell', '--enable=lll',
      \ '--enable=unparam', '--enable=dogsled', '--enable=nakedret', '--enable=prealloc', '--enable=scopelint',
      \ '--enable=gocritic', '--enable=gochecknoinits', '--enable=gochecknoglobals', '--enable=godox',
      \ '--enable=funlen', '--enable=wsl', '--enable=goprintffuncname']
let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" tcomment_vim
nnoremap <silent> // :TComment<CR>
vnoremap <silent> // :TComment<CR>

" tagbar
let g:tagbar_left = 1
let g:tagbar_width = 40
nmap <F7> :TagbarToggle<CR>

let g:tagbar_type_go = {
	\ 'ctagstype' : 'go',
	\ 'kinds'     : [
		\ 'p:package',
		\ 'i:imports:1',
		\ 'c:constants',
		\ 'v:variables',
		\ 't:types',
		\ 'n:interfaces',
		\ 'w:fields',
		\ 'e:embedded',
		\ 'm:methods',
		\ 'r:constructor',
		\ 'f:functions'
	\ ],
	\ 'sro' : '.',
	\ 'kind2scope' : {
		\ 't' : 'ctype',
		\ 'n' : 'ntype'
	\ },
	\ 'scope2kind' : {
		\ 'ctype' : 't',
		\ 'ntype' : 'n'
	\ },
	\ 'ctagsbin'  : 'gotags',
	\ 'ctagsargs' : '-sort -silent'
\ }


" vim-multiple-cursors
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-g>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

" vim-slim
autocmd BufNewFile,BufRead *.slimbars setlocal filetype=slim

" vim-ctrlspace
nnoremap <silent><C-p> :CtrlSpace O<CR>
nnoremap <silent><C-l> :CtrlSpace l<CR>

" vim-endwise
let g:endwise_no_mappings=1

" ag
let g:CtrlSpaceGlobCommand = 'ag . -l --nocolor -g ""'
let g:ag_working_path_mode="r"

" vim-ruby
let ruby_operators = 1
let ruby_space_errors = 1
let g:rubycomplete_rails = 1

" vim.coc
set cmdheight=2
set shortmess+=c
set signcolumn=yes

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1]  =~# '\s'
endfunction

inoremap <silent><expr> <Tab>
      \ pumvisible() ? "\<C-n>" :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()

inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

" -------------------
" Vim settings
" -------------------

" make Molokai looks great
set background=dark
let g:molokai_original=1
let g:rehash256=1
set t_Co=256
colorscheme molokai

" Tabstops
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab

" Automatically indent
set autoindent

" Set the search scan to wrap lines
set wrapscan

" Makes command line two lines high
set ch=2

" Show invisibles
set list

" Set the status line
set statusline=%<%f%h%m%r%=\ %l,%c%V
set laststatus=2

" Оставляем курсор при прокрутке экрана всегда по центру
set scrolloff=8

" Всегда показываем курсор
set ruler

" Добавляет подчёркивание текущей строки, в которой находится курсор
set cursorline

" Показывает незавершённые команды в статусной строке
set showcmd

" Не удалять буфер когда переключаемся в следующий
set hidden

" Показывает текущий режим в последней строке
set showmode

" Make the command-line completion better
set wildmenu

" set the search scan so that it ignores case when the search is all lower
" case but recognizes uppercase if it's specified
set ignorecase
set smartcase

" Incrementally match the search
set incsearch

" Stop searching at the end of file
set nowrapscan

" add some line space for easy reading
set linespace=1

" Highlight 120 column
if exists('+colorcolumn')
	highlight ColorColumn ctermbg=237 ctermfg=15
	highlight CursorLine ctermbg=236
	highlight CursorColumn ctermbg=236
	let &colorcolumn=join(range(121,999),",")
else
	autocmd BufWinEnter * let w:m2=matchadd('ErrorMsg', '\%>120v.\+', -1)
end

set textwidth=120

set wrap
set linebreak

" Encodings
set termencoding=utf-8
set encoding=utf8

" Подсветка искомой строки, соответствие скобок и время мигания
set hlsearch
set showmatch
set matchtime=5

set number

" Отключаем шум и звуки
set novisualbell
set noerrorbells
set vb t_vb=

" Folding
set foldenable
set foldmethod=marker
set foldlevel=100
set foldopen=block,hor,mark,percent,quickfix,tag
set foldlevel=0

" Turn off backup files and swap
set nobackup
set noswapfile

" Write swap file to disk after every 50 characters
set updatecount=50

" Ignore certain types of files on completion
set wildignore+=*.o,*.obj,*.pyc,.git,.svn,vendor/gems/*

" Tab at the end of line
if has('multi_byte')
	highlight NonText guifg=#4a4a59
	highlight SpecialKey guifg=#4a4a59

	if version >= 700
		set listchars=tab:▸\ ,trail:·,extends:❯,precedes:❮,nbsp:×
	else
		set listchars=tab:»\ ,trail:·,extends:>,precedes:<,nbsp:_
	endif
endif

" Symbol before wrapped line
if has("linebreak")
    let &sbr = nr2char(8618).' ' " Show ↪ at the beginning of wrapped lines
endif

" Save cursor position when changing split
if v:version >= 700
	au BufLeave * let b:winview = winsaveview()
	au BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
endif

" Remove whitespaces from all file
function! TrimWhitespace()
	%s/\s\+$//e
endfunction
command! TrimWhitespace call TrimWhitespace()

" Go back to the position the cursor was on the last time this file was edited
au BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$")|execute("normal `\"")|endif

" Fix my <Backspace> key (in Mac OS X Terminal)
set t_kb=
if ! has('nvim')
	fixdel
endif

" ----------------------------------------------------------
" Mappings
" ----------------------------------------------------------

" pressing ; will go into command mode
nnoremap ; :

" Disable the F1 key (which normally opens help)
" coz I hit it accidentally.
noremap <F1> <nop>

" Space for open/close folds if exist
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

" use CTRL-F for omni completion
imap <C-F> 

" use <F6> to toggle line numbers
nmap <silent> <F6> :set number!<CR>

map <F8> :set list<CR>
map <F9> :set nolist<CR>

" Открывать сплиты окон справа и снизу
set splitright
set splitbelow

autocmd FileType gitcommit setlocal spell textwidth=72

" Nightmare mode
noremap <Up> <NOP>
noremap <Down> <NOP>
noremap <Left> <NOP>
noremap <Right> <NOP>

" Delays when using escape key in terminal
" https://github.com/mhinz/vim-galore/blob/master/README.md
set timeout           " for mappings
set timeoutlen=1000   " default value
set ttimeout          " for key codes
set ttimeoutlen=10    " unnoticeable small value

runtime macros/matchit.vim

function! DeleteEmptyBuffers()
    let [i, n; empty] = [1, bufnr('$')]
    while i <= n
        if bufexists(i) && bufname(i) == ''
            call add(empty, i)
        endif
        let i += 1
    endwhile
    if len(empty) > 0
        exe 'bdelete' join(empty)
    endif
endfunction

" diff mode
if &diff
  set diffopt+=iwhite
endif

au! BufRead,BufNewFile *.md setlocal textwidth=80 | let &colorcolumn=join(range(81,999),",")
