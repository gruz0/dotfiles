if !filereadable(expand($HOME.'/.vim/bundle/Vundle.vim/README.md'))
    echo 'Installing Vundle...'
    silent !mkdir -p $HOME/.vim/bundle
    silent !git clone https://github.com/VundleVim/Vundle.vim.git ~/.vim/bundle/Vundle.vim
endif

" Необходимо для корректной работы в El Capitan с zsh
set shell=bash

set nocompatible
filetype off

" Автоматическое считывание конфига Vim после его перезаписи
" au BufWritePost .vimrc so $MYVIMRC

set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

" let Vundle manage Vundle, required
Plugin 'VundleVim/Vundle.vim'

" Сканирует файл на наличие todo, fixme-директив, включается через <Leader>t
let mapleader=','
Plugin 'vim-scripts/TaskList.vim'

" Buffer Explorer
Plugin 'jlanzarotta/bufexplorer'

" Поддержка RuboCop
Plugin 'ngmy/vim-rubocop'
let g:vimrubocop_config = '.rubocop.yml'
let g:vimrubocop_keymap = 0
nmap <C-R> :RuboCop<CR>

" Поддержка Git
Plugin 'tpope/vim-fugitive'
Plugin 'gregsexton/gitv'
let g:Gitv_OpenHorizontal = 0

" Неплохая реализация Git Diff, запуск по ,gd
Plugin 'int3/vim-extradite'
nmap <Leader>gd :Extradite<CR>

" Добавляет в левый сайдбар маркеры +/-/~ для вывода статуса строк из git diff
Plugin 'airblade/vim-gitgutter'
let g:gitgutter_max_signs=9999

" Изменяет строку статуса на более функциональную
Plugin 'bling/vim-airline'

" Enable the list of buffers
let g:airline#extensions#tabline#enabled = 1

" Show just the filename
let g:airline#extensions#tabline#fnamemod = ':t'

" Поддержка CoffeeScript
" В файле *.coffee запускать как :CoffeeCompile vert для тестовой компиляции в JS
Plugin 'kchmck/vim-coffee-script'

" Отправка существующего буфера или куска кода в gist.github.com
Plugin 'mattn/webapi-vim'
Plugin 'mattn/gist-vim'
let g:gist_detect_filetype = 1
let g:gist_open_browser_after_post = 1

" Позволяет выравнивать код по нужному знаку, например, все "=" отбить с единым отступом в коде
" Пример: http://vimcasts.org/episodes/aligning-text-with-tabular-vim/
" Использовать в VisualMode:
" :Tab /=
" :Tab /:\zs
Plugin 'godlygeek/tabular'
if exists(":Tabularize")
	nmap <Leader>a= :Tabularize /=<CR>
	vmap <Leader>a= :Tabularize /=<CR>
	nmap <Leader>a: :Tabularize /:\zs<CR>
	vmap <Leader>a: :Tabularize /:\zs<CR>
endif

" Подсвечивает HEX-значения в CSS/HTML
Plugin 'ap/vim-css-color'

" Дерево файлов и директорий, включается по Ctrl+N
Plugin 'scrooloose/nerdtree'
let g:NERDTreeWinPos = "right"
map <C-N> :NERDTreeToggle<CR>
nmap <C-J> :tabprevious<CR>
nmap <C-K> :tabnext<CR>

" I close vim if the only window left open is a NERDTree
autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

let NERDTreeShowBookmarks=1
let NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1
let NERDTreeBookmarksFile= $HOME . '/.vim/.NERDTreeBookmarks'
let NERDTreeWinSize=35

" Подсветка синтаксиса
Plugin 'vim-syntastic/syntastic'

set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*

let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_check_on_wq = 0
let g:syntastic_ruby_checkers = ['rubocop', 'mri']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_javascript_eslint_exe = 'npm run lint --'

" vim-scripts repos

" Комментирование по //
Plugin 'tComment'
nnoremap <silent> // :TComment<CR>
vnoremap <silent> // :TComment<CR>

" Поддержка EditorConfig (единый конфиг для всех редакторов и IDE)
Plugin 'editorconfig/editorconfig-vim'

" TagBar для отображения структуры файлов
Plugin 'majutsushi/tagbar'
let g:tagbar_left = 1
let g:tagbar_width = 35
nmap <F7> :TagbarToggle<CR>

" Multiple Cursors
Plugin 'terryma/vim-multiple-cursors.git'
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-g>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

Plugin 'slim-template/vim-slim.git'
autocmd BufNewFile,BufRead *.slimbars setlocal filetype=slim

Plugin 'vim-ctrlspace/vim-ctrlspace'
nnoremap <silent><C-p> :CtrlSpace O<CR>
nnoremap <silent><C-l> :CtrlSpace l<CR>

" File searcher
Plugin 'rking/ag.vim'

if executable("ag")
  let g:CtrlSpaceGlobCommand = 'ag . -l --nocolor -g ""'
endif

" Always start searching from your project root instead of the cwd
let g:ag_working_path_mode="r"

" Wisely add "end" in ruby, endfunction/endif/more
Plugin 'tpope/vim-endwise'

" Vim/Ruby Configuration Files
Plugin 'vim-ruby/vim-ruby'
let ruby_operators = 1
let ruby_space_errors = 1
let g:rubycomplete_rails = 1

" Rails :/
Bundle 'tpope/vim-rails.git'
map <leader>s :A<CR> " Switch between code and the test file

" Dependencies of snipmate
Bundle "MarcWeber/vim-addon-mw-utils"
Bundle "tomtom/tlib_vim"
Bundle "honza/vim-snippets"

" Snippets for our use :)
Bundle 'garbas/vim-snipmate'

" Every one should have a pair (Autogenerate pairs for "{[( )
Bundle 'jiangmiao/auto-pairs'

" Tab completions
Bundle 'ervandew/supertab'

" Molokai theme
Bundle 'tomasr/molokai'

Plugin 'leafgarland/typescript-vim'
Plugin 'peitalin/vim-jsx-typescript'
Plugin 'pangloss/vim-javascript'

Plugin 'mxw/vim-jsx'
let g:jsx_ext_required = 0

Plugin 'ekalinin/Dockerfile.vim'

call vundle#end()

"-------------------------------------------------------
" После этой строки не вставлять никаких Bundle/Plugin!
"-------------------------------------------------------

" Other plugins

filetype plugin indent on

" -------------------
" Vim settings
" -------------------

syntax on

" Configs to make Molokai look great
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

" Make the 'cw' and like commands put a $ at the end instead of just deleting the text and replacing it
" set cpoptions=cesB$

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

" Позволяет выделять квадратные области в визуальном режиме
" set virtualedit=all

" Make the command-line completion better
set wildmenu

" Set command-line completion mode:
"   - on first <Tab>, when more than one match, list all matches and complete
"     the longest common  string
"   - on second <Tab>, complete the next full match and show menu
set wildmode=list:longest,list:full

" When completing by tag, show the whole tag, not just the function name
set showfulltag

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

" Set up the GVim window colors and size
if has("gui_running")
	set guifont=Monaco:h14
	if !exists("g:vimrcloaded")
		winpos 0 0
		winsize 270 90
		let g:vimrcloaded = 1
	endif

	" Set up the gui cursor to look nice
	set guicursor=n-v-c:block-Cursor-blinkon0
	set guicursor+=ve:ver35-Cursor
	set guicursor+=o:hor50-Cursor
	set guicursor+=i-ci:ver25-Cursor
	set guicursor+=r-cr:hor20-Cursor
	set guicursor+=sm:block-Cursor-blinkwait175-blinkoff150-blinkon175

	" set the gui options
	set guioptions-=m  "remove menu bar
	set guioptions-=T  "remove toolbar
	set guioptions-=r  "remove right-hand scroll bar"
endif

" Creates a session
function! MakeSession()
	let b:sessionfile = 'project.vim'
	exe "mksession! " . b:sessionfile
endfunction

" Updates a session, BUT ONLY IF IT ALREADY EXISTS
function! UpdateSession()
	if argc()==0
		let b:sessionfile = "project.vim"
		if (filereadable(b:sessionfile))
			exe "mksession! " . b:sessionfile
			echo "updating session"
		endif
	endif
endfunction

" Loads a session if it exists
function! LoadSession()
	if argc() == 0
		let b:sessionfile = "project.vim"
		if (filereadable(b:sessionfile))
			exe 'source ' b:sessionfile
		else
			echo "No session loaded."
		endif
	else
		let b:sessionfile = ""
		let b:sessiondir = ""
	endif
endfunction

au VimEnter * nested :call LoadSession()
au VimLeave * :call UpdateSession()

" Save cursor position when changing split
if v:version >= 700"{{{
	au BufLeave * let b:winview = winsaveview()
	au BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif
endif"}}}

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

" Snippets
"iabbrev ddate <C-r>=strftime("%F")<CR>

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

map <F2> :set softtabstop=2 tabstop=4 shiftwidth=2<CR> :retab<CR>

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
