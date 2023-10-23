if !filereadable(expand($HOME.'/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.local/share/nvim/plugged')

Plug 'vim-scripts/TaskList.vim'
Plug 'tpope/vim-fugitive'
Plug 'gregsexton/gitv'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'godlygeek/tabular'
Plug 'ap/vim-css-color'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
" Plug 'Xuyuanp/nerdtree-git-plugin'
Plug 'vim-syntastic/syntastic'
Plug 'tomtom/tcomment_vim'
Plug 'editorconfig/editorconfig-vim'
" Plug 'majutsushi/tagbar'
Plug 'terryma/vim-multiple-cursors'
Plug 'vim-ctrlspace/vim-ctrlspace'
Plug 'rking/ag.vim'
Plug 'tpope/vim-endwise'
" Plug 'vim-ruby/vim-ruby', { 'for': 'ruby' }
Plug 'jiangmiao/auto-pairs'
Plug 'tomasr/molokai'
Plug 'ekalinin/Dockerfile.vim', { 'for': 'Dockerfile' }
" Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': 'go' }
Plug 'neoclide/coc.nvim', { 'branch': 'release' }
" Plug 'pearofducks/ansible-vim'
Plug 'zivyangll/git-blame.vim'
Plug 'rhysd/git-messenger.vim'
Plug 'tomlion/vim-solidity'
Plug 'neoclide/vim-jsx-improve'
Plug 'pantharshit00/vim-prisma'
" Plug 'yaegassy/coc-intelephense', {'do': 'yarn install --frozen-lockfile'}
" Plug 'iamcco/markdown-preview.nvim', { 'do': { -> mkdp#util#install() }, 'for': ['markdown', 'vim-plug']}
Plug 'elzr/vim-json'
Plug 'plasticboy/vim-markdown'

call plug#end()

filetype plugin indent on

set nocompatible

let mapleader=','

" It needed to use GoBuild, GoRun and automatically switch to the first error in the file
set autowrite

" gitv
let g:Gitv_OpenHorizontal = 0

" vim-gitgutter
let g:gitgutter_max_signs=9999

" vim-airline
let g:airline#extensions#tabline#enabled = 1
let g:airline#extensions#tabline#fnamemod = ':t'
let g:airline_powerline_fonts = 1

" nerdtree
let g:NERDTreeIgnore = ['^node_modules$']
let g:NERDTreeWinPos = "right"
map <C-N> :NERDTreeToggle<CR>

autocmd bufenter * if (winnr("$") == 1 && exists("b:NERDTreeType") && b:NERDTreeType == "primary") | q | endif

let NERDTreeShowBookmarks=0
let NERDTreeChDirMode=2
let NERDTreeQuitOnOpen=1
let NERDTreeShowHidden=1
let NERDTreeBookmarksFile= $HOME . '/.vim/.NERDTreeBookmarks'
let NERDTreeWinSize=50

" syntastic
set statusline+=%#warningmsg#
set statusline+=%{SyntasticStatuslineFlag()}
set statusline+=%*
set updatetime=300

let g:syntastic_check_on_open=1
let g:syntastic_enable_signs=1
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_loc_list_height = 5
let g:syntastic_check_on_wq = 0

let g:syntastic_ruby_checkers = ['rubocop', 'mri']
let g:syntastic_javascript_checkers = ['eslint']
let g:syntastic_solidity_checkers=['solc']
let g:syntastic_solidity_solc_exe=['/usr/local/bin/solc']

" let g:godef_split = 0
" let g:go_fmt_fail_silently = 0
" let g:go_list_type = 'quickfix'
" let g:go_auto_type_info = 1
" let g:go_fmt_command = "goimports"
" let g:syntastic_go_checkers = ['golangci_lint']
" " let g:syntastic_go_checkers = ['./.bin/golangci_lint', 'golangci_lint']
" " let g:syntastic_go_golangci_lint_args = [
" "       \ '--no-config', '--disable-all',
" "       \ '--enable=govet', '--enable=errcheck', '--enable=staticcheck', '--enable=unused', '--enable=gosimple',
" "       \ '--enable=structcheck', '--enable=varcheck', '--enable=ineffassign', '--enable=deadcode', '--enable=bodyclose',
" "       \ '--enable=golint', '--enable=stylecheck', '--enable=gosec', '--enable=interfacer', '--enable=unconvert',
" "       \ '--enable=dupl', '--enable=goconst', '--enable=gocognit', '--enable=rowserrcheck', '--enable=gofmt',
" "       \ '--enable=goimports', '--enable=maligned', '--enable=depguard', '--enable=misspell', '--enable=lll',
" "       \ '--enable=unparam', '--enable=dogsled', '--enable=nakedret', '--enable=prealloc', '--enable=scopelint',
" "       \ '--enable=gocritic', '--enable=gochecknoinits', '--enable=gochecknoglobals', '--enable=godox',
" "       \ '--enable=funlen', '--enable=wsl', '--enable=goprintffuncname']
" let g:go_highlight_types = 1
" let g:go_highlight_fields = 1
" let g:go_highlight_functions = 1
" let g:go_highlight_function_calls = 1
" let g:go_highlight_extra_types = 1
" let g:go_highlight_operators = 1
" let g:go_highlight_build_constraints = 1

let g:syntastic_error_symbol = '❌'
let g:syntastic_style_error_symbol = '⁉️'
let g:syntastic_warning_symbol = '⚠️'
let g:syntastic_style_warning_symbol = '💩'

highlight link SyntasticErrorSign SignColumn
highlight link SyntasticWarningSign SignColumn
highlight link SyntasticStyleErrorSign SignColumn
highlight link SyntasticStyleWarningSign SignColumn

" tcomment_vim
nnoremap <silent> // :TComment<CR>
vnoremap <silent> // :TComment<CR>

" tagbar
" let g:tagbar_left = 1
" let g:tagbar_width = 40
" nmap <F7> :TagbarToggle<CR>
"
" let g:tagbar_type_go = {
" 	\ 'ctagstype' : 'go',
" 	\ 'kinds'     : [
" 		\ 'p:package',
" 		\ 'i:imports:1',
" 		\ 'c:constants',
" 		\ 'v:variables',
" 		\ 't:types',
" 		\ 'n:interfaces',
" 		\ 'w:fields',
" 		\ 'e:embedded',
" 		\ 'm:methods',
" 		\ 'r:constructor',
" 		\ 'f:functions'
" 	\ ],
" 	\ 'sro' : '.',
" 	\ 'kind2scope' : {
" 		\ 't' : 'ctype',
" 		\ 'n' : 'ntype'
" 	\ },
" 	\ 'scope2kind' : {
" 		\ 'ctype' : 't',
" 		\ 'ntype' : 'n'
" 	\ },
" 	\ 'ctagsbin'  : 'gotags',
" 	\ 'ctagsargs' : '-sort -silent'
" \ }


" vim-multiple-cursors
let g:multi_cursor_use_default_mapping=0
let g:multi_cursor_next_key='<C-g>'
let g:multi_cursor_skip_key='<C-x>'
let g:multi_cursor_quit_key='<Esc>'

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

" vim-go
" disable vim-go :GoDef short cut (gd)
" this is handled by LanguageClient [LC]
let g:go_def_mapping_enabled = 0
let g:go_list_type = "quickfix"
let g:go_fmt_command = "goimports"

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

inoremap <silent><expr> <Tab> coc#pum#visible() ? coc#pum#confirm() : "\<C-y>"
inoremap <silent><expr> <S-Tab> coc#pum#visible() ? coc#pum#confirm() : "\<S-Tab>"
inoremap <expr> <cr> coc#pum#visible() ? "\<C-y>" : "\<C-g>u\<CR>"
inoremap <silent><expr> <cr> coc#pum#visible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
" inoremap <expr> <Tab> pumvisible() ? "\<C-n>" : "\<Tab>"
" inoremap <expr> <S-Tab> pumvisible() ? "\<C-p>" : "\<S-Tab>"
" inoremap <expr> <cr> pumvisible() ? "\<C-y>" : "\<C-g>u\<CR>"
" inoremap <silent><expr> <cr> pumvisible() ? coc#_select_confirm() : "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"
autocmd! CompleteDone * if pumvisible() == 0 | pclose | endif

nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

nnoremap <silent> K :call <SID>show_documentation()<CR>

nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

function! s:show_documentation()
  if (index(['vim','help'], &filetype) >= 0)
    execute 'h '.expand('<cword>')
  elseif (coc#rpc#ready())
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

" Highlight the symbol and its references when holding the cursor.
autocmd CursorHold * silent call CocActionAsync('highlight')

if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" ansible-vim
let g:ansible_attribute_highlight = 'a'
let g:ansible_extra_keywords_highlight = 1

au BufRead,BufNewFile playbook*.yml set filetype=yaml.ansible

" gitblame
nnoremap <Leader>b :<C-u>call gitblame#echo()<CR>

" -------------------
" Vim settings
" -------------------

nmap <C-J> :tabprevious<CR>
nmap <C-K> :tabnext<CR>

" make Molokai looks great
set background=dark
set termguicolors
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

set scrolloff=8

set ruler

set cursorline

set showcmd

set hidden

set showmode

" Make the command-line completion better
set wildmenu

" Autocompletion
set wildmode=longest,list,full

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
highlight ColorColumn ctermbg=237 ctermfg=15
highlight CursorLine ctermbg=236
highlight CursorColumn ctermbg=236
let &colorcolumn=join(range(121,999),",")

set textwidth=120

set wrap
set linebreak

" Encodings
set termencoding=utf-8
set encoding=utf8

set hlsearch
set showmatch
set matchtime=5

set number

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
set wildignore+=*.o,*.obj,*.pyc,*/.git/,*/node_modules/*,*/tmp/*,*/log/*,*.so,*.swp,*.zip

" Tab at the end of line
highlight NonText guifg=#4a4a59
highlight SpecialKey guifg=#4a4a59

set listchars=tab:▸\ ,trail:·,extends:❯,precedes:❮,nbsp:×

" Symbol before wrapped line
let &sbr = nr2char(8618).' ' " Show ↪ at the beginning of wrapped lines

" Save cursor position when changing split
au BufLeave * let b:winview = winsaveview()
au BufEnter * if(exists('b:winview')) | call winrestview(b:winview) | endif

" Remove trailing whitespace on save
autocmd BufWritePre * %s/\s\+$//e

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

map <F8> :set list<CR>
map <F9> :set nolist<CR>

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

" function! DeleteEmptyBuffers()
"     let [i, n; empty] = [1, bufnr('$')]
"     while i <= n
"         if bufexists(i) && bufname(i) == ''
"             call add(empty, i)
"         endif
"         let i += 1
"     endwhile
"     if len(empty) > 0
"         exe 'bdelete' join(empty)
"     endif
" endfunction

" diff mode
if &diff
  set diffopt+=iwhite
endif

au! BufRead,BufNewFile *.md setlocal textwidth=80 | let &colorcolumn=join(range(81,999),",")

au BufWritePost Dockerfile* !hadolint %
au BufWritePost *.prisma !npx prisma format %

" Preventing loading default Vim's plugins
let g:loaded_2html_plugin = 1
let g:loaded_gzip = 1
let g:loaded_netrw = 1
let g:loaded_netrwPlugin = 1
let g:loaded_spellfile_plugin = 1
let g:loaded_tarPlugin = 1
let g:loaded_zipPlugin = 1
let g:loaded_zip = 1

runtime macros/matchit.vim

let g:markdown_fenced_languages = ['html', 'ruby', 'sh', 'bash', 'dockerfile', 'go', 'git', 'json=javascript', 'make', 'sql', 'yaml', 'zsh']

let g:python3_host_prog="/usr/local/bin/python3"

set rtp+=/usr/local/opt/fzf

au BufRead,BufNewFile .env.* set filetype=sh

" markdown-preview
" let g:mkdp_auto_close = 0
" nnoremap <Leader>m :MarkdownPreviewToggle<CR>

" vim-markdown
" disable header folding
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:tex_conceal = ""
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1  " for YAML format
let g:vim_markdown_toml_frontmatter = 1  " for TOML format
let g:vim_markdown_json_frontmatter = 1  " for JSON format

" rhysd/git-messenger.vim
let g:git_messenger_no_default_mappings = v:true
nmap M <Plug>(git-messenger)

let g:loaded_perl_provider = 0

" Highlight TODO, FIXME, NOTE, etc.
if has('autocmd') && v:version > 701
  augroup todo
    autocmd!
    autocmd Syntax * call matchadd(
          \ 'Debug',
          \ '\v\W\zs<(NOTE|INFO|IDEA|TODO|FIXME|CHANGED|XXX|BUG|HACK|TRICKY)>'
          \ )
  augroup END
endif
