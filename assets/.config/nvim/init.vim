" ============================================================
" Neovim config (cleaned for Go, TS/React, Solidity, Markdown)
" ============================================================

" Install the following coc extensions:
" :CocInstall coc-tsserver coc-eslint coc-prettier coc-json coc-prisma

" Bootstrap vim-plug
if !filereadable(expand($HOME.'/.local/share/nvim/site/autoload/plug.vim'))
  silent !curl -fLo ~/.local/share/nvim/site/autoload/plug.vim --create-dirs https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
endif

call plug#begin('~/.local/share/nvim/plugged')

" --- General productivity / UI ---
Plug 'vim-scripts/TaskList.vim'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-unimpaired'
Plug 'airblade/vim-gitgutter'
Plug 'vim-airline/vim-airline'
Plug 'godlygeek/tabular'
Plug 'ap/vim-css-color'
Plug 'scrooloose/nerdtree', { 'on': 'NERDTreeToggle' }
Plug 'tomtom/tcomment_vim'
Plug 'editorconfig/editorconfig-vim'
Plug 'terryma/vim-multiple-cursors'
Plug 'jiangmiao/auto-pairs'
Plug 'tomasr/molokai'

" quickfix improvements
Plug 'romainl/vim-qf'

" --- Git helpers ---
Plug 'zivyangll/git-blame.vim'
Plug 'gregsexton/gitv'

" --- Languages / filetypes ---
Plug 'ekalinin/Dockerfile.vim', { 'for': 'Dockerfile' }
Plug 'fatih/vim-go', { 'do': ':GoInstallBinaries', 'for': 'go' }
Plug 'tomlion/vim-solidity'
Plug 'neoclide/vim-jsx-improve'
Plug 'peitalin/vim-jsx-typescript'
Plug 'pantharshit00/vim-prisma'
Plug 'elzr/vim-json'
Plug 'plasticboy/vim-markdown'

" markdown / writing mode
Plug 'junegunn/goyo.vim'
Plug 'junegunn/limelight.vim'

" --- LSP / completion ---
Plug 'neoclide/coc.nvim', { 'branch': 'release' }

" fuzzy finder
Plug 'junegunn/fzf', { 'do': { -> fzf#install() } }
Plug 'junegunn/fzf.vim'

call plug#end()

" ============================================================
" Core settings
" ============================================================

filetype plugin indent on

let mapleader=','

" It needed to use GoBuild, GoRun and automatically switch to the first error
set autowrite

" ------------------------------------------------------------
" Plugin configuration
" ------------------------------------------------------------

" gitv
let g:Gitv_OpenHorizontal = 0

" vim-gitgutter
let g:gitgutter_max_signs = 9999

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

" vim-multiple-cursors
let g:multi_cursor_use_default_mapping = 0
let g:multi_cursor_next_key = '<C-g>'
let g:multi_cursor_skip_key = '<C-x>'
let g:multi_cursor_quit_key = '<Esc>'

" tcomment_vim - use Ctrl+/ (Ctrl-_) for commenting
nnoremap <silent> <C-_> :TComment<CR>
vnoremap <silent> <C-_> :TComment<CR>

" fzf
nnoremap <leader>f :Files<CR>
nnoremap <C-p> :Files<CR>
nnoremap <leader>g :Rg<CR>
nnoremap <leader>b :Buffers<CR>
nnoremap <leader>h :Helptags<CR>

" Use ripgrep for fzf file list and ignore noisy dirs
if executable('rg')
  let $FZF_DEFAULT_COMMAND = 'rg --files --hidden --follow ' .
        \ '--glob "!.git/*" ' .
        \ '--glob "!node_modules/*" ' .
        \ '--glob "!.next/*" ' .
        \ '--glob "!.turbo/*" ' .
        \ '--glob "!.vercel/*"'
endif

" vim-go (Go)
let g:godef_split = 0
let g:go_fmt_fail_silently = 0
let g:go_list_type = 'quickfix'
let g:go_auto_type_info = 1
let g:go_fmt_command = "goimports"

let g:go_highlight_types = 1
let g:go_highlight_fields = 1
let g:go_highlight_functions = 1
let g:go_highlight_function_calls = 1
let g:go_highlight_extra_types = 1
let g:go_highlight_operators = 1
let g:go_highlight_build_constraints = 1

" disable vim-go :GoDef short cut (gd) – handled by coc
let g:go_def_mapping_enabled = 0

" gitblame
nnoremap <Leader>B :<C-u>call gitblame#echo()<CR>

" ------------------------------------------------------------
" coc.nvim (LSP / completion)
" ------------------------------------------------------------

set cmdheight=2
set updatetime=300        " used by CocActionAsync highlight
set shortmess+=c
set signcolumn=yes

function! s:check_back_space() abort
  let col = col('.') - 1
  return !col || getline('.')[col - 1] =~# '\s'
endfunction

" Tab / Shift-Tab for completion menu
inoremap <silent><expr> <Tab>
      \ coc#pum#visible() ? coc#pum#next(1) :
      \ <SID>check_back_space() ? "\<Tab>" :
      \ coc#refresh()
inoremap <silent><expr> <S-Tab>
      \ coc#pum#visible() ? coc#pum#prev(1) : "\<C-h>"

" Enter to confirm selection or insert newline
inoremap <silent><expr> <CR>
      \ coc#pum#visible() ? coc#pum#confirm() :
      \ "\<C-g>u\<CR>\<c-r>=coc#on_enter()\<CR>"

" Go-to mappings
nmap <silent> gd <Plug>(coc-definition)
nmap <silent> gy <Plug>(coc-type-definition)
nmap <silent> gi <Plug>(coc-implementation)
nmap <silent> gr <Plug>(coc-references)

" Diagnostics
nmap <silent> [g <Plug>(coc-diagnostic-prev)
nmap <silent> ]g <Plug>(coc-diagnostic-next)

" Hover docs
function! s:show_documentation()
  if index(['vim','help'], &filetype) >= 0
    execute 'h '.expand('<cword>')
  elseif coc#rpc#ready()
    call CocActionAsync('doHover')
  else
    execute '!' . &keywordprg . " " . expand('<cword>')
  endif
endfunction

nnoremap <silent> K :call <SID>show_documentation()<CR>

" Highlight the symbol and its references when holding the cursor
autocmd CursorHold * silent call CocActionAsync('highlight')

" Scroll inside floating windows with C-f/C-b
if has('nvim-0.4.0') || has('patch-8.2.0750')
  nnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  nnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
  inoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(1)\<cr>" : "\<Right>"
  inoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? "\<c-r>=coc#float#scroll(0)\<cr>" : "\<Left>"
  vnoremap <silent><nowait><expr> <C-f> coc#float#has_scroll() ? coc#float#scroll(1) : "\<C-f>"
  vnoremap <silent><nowait><expr> <C-b> coc#float#has_scroll() ? coc#float#scroll(0) : "\<C-b>"
endif

" ------------------------------------------------------------
" Vim settings
" ------------------------------------------------------------

" Tabs / indent
set tabstop=4
set shiftwidth=4
set softtabstop=4
set smarttab
set autoindent

" make Molokai look great
set background=dark
set termguicolors
let g:molokai_original=1
let g:rehash256=1
colorscheme molokai

" Set the status line
set statusline=%<%f%h%m%r%=\ %l,%c%V
set laststatus=2

set scrolloff=8
set ruler
set cursorline
set showcmd
set hidden
set showmode

" Better command-line completion
set wildmenu
set wildmode=longest,list,full

" Search behavior
set ignorecase
set smartcase
set incsearch
set nowrapscan

" Highlight 120 column
highlight ColorColumn ctermbg=237 ctermfg=15
highlight CursorLine ctermbg=236
highlight CursorColumn ctermbg=236
let &colorcolumn=join(range(121,999),",")

set textwidth=120
set wrap
set linebreak

" Encodings
if !has('nvim') && exists('+termencoding')
  set termencoding=utf-8
endif
set encoding=utf-8

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

" Fix <Backspace> key (for old Mac OS X Terminal / Vim)
set t_kb=
if !has('nvim')
  fixdel
endif

" Split behavior
set splitright
set splitbelow

" Git commit messages
autocmd FileType gitcommit setlocal spell textwidth=72

" Nightmare mode – disable arrow keys
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

" diff mode
if &diff
  set diffopt+=iwhite
endif

" Distraction-free buffer (centered, no splits/statusline)
nnoremap <leader>z :Goyo<CR>

" Close preview window when completion is done
augroup CocCompletion
  autocmd!
  autocmd CompleteDone * if pumvisible() == 0 | pclose | endif
augroup END

" Markdown: 80 columns, adjust colorcolumn
augroup MarkdownLocal
  autocmd!
  autocmd BufRead,BufNewFile *.md setlocal textwidth=80 | let &l:colorcolumn=join(range(81,999),",")
augroup END

" Goyo + Limelight
augroup GoyoLimelight
  autocmd!
  autocmd User GoyoEnter Limelight
  autocmd User GoyoLeave Limelight!
augroup END

" Trim trailing whitespace
augroup TrimTrailingWhitespace
  autocmd!
  autocmd BufWritePre * %s/\s\+$//e
augroup END

" Restore last cursor position
augroup RestoreCursor
  autocmd!
  autocmd BufReadPost * if line("'\"") > 0 && line("'\"") <= line("$") | execute "normal! g`\"" | endif
augroup END

" Extra filetype / tools
augroup ExtraFiletypesAndTools
  autocmd!
  autocmd BufRead,BufNewFile .env.* set filetype=sh
  autocmd BufWritePost Dockerfile*  silent !hadolint %
  autocmd BufWritePost *.prisma     silent !npx prisma format %
augroup END

" ------------------------------------------------------------
" Mappings
" ------------------------------------------------------------

" Tab navigation
nmap <C-J> :tabprevious<CR>
nmap <C-K> :tabnext<CR>

" pressing ; will go into command mode
nnoremap ; :

" Disable the F1 key (which normally opens help)
noremap <F1> <nop>

" Space for open/close folds if exist
nnoremap <silent> <Space> @=(foldlevel('.')?'za':"\<Space>")<CR>
vnoremap <Space> zf

map <F8> :set list<CR>
map <F9> :set nolist<CR>

" ------------------------------------------------------------
" Built-in plugins / providers / runtime tweaks
" ------------------------------------------------------------

" Prevent loading some default Vim plugins
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

let g:loaded_perl_provider = 0

" vim-markdown
let g:vim_markdown_folding_disabled = 1
let g:vim_markdown_conceal = 0
let g:tex_conceal = ""
let g:vim_markdown_math = 1
let g:vim_markdown_frontmatter = 1  " for YAML format
let g:vim_markdown_toml_frontmatter = 1  " for TOML format
let g:vim_markdown_json_frontmatter = 1  " for JSON format

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
