" ### vundle plugin manager {{{

let new=0
let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme) 
  echo 'Installing Vundle...'
  echo ''
  silent !mkdir -p ~/.vim/bundle
  silent !git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
  let new=1
endif
set nocompatible " required
filetype off     " required
set runtimepath+=~/.vim/bundle/Vundle.vim/
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
" add plugins here
Plugin 'altercation/vim-colors-solarized'
Plugin 'google/vim-searchindex'
Plugin 'itchyny/lightline.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'Konfekt/FastFold'
Plugin 'lifepillar/vim-mucomplete'
Plugin 'mattn/emmet-vim'
Plugin 'mbbill/undotree'
Plugin 'nelstrom/vim-visual-star-search'
Plugin 'sheerun/vim-polyglot'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-endwise'
Plugin 'tpope/vim-fugitive.git'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'vim-scripts/dbext.vim'
call vundle#end()
if new == 1
  :PluginInstall
  echo 'you may need to close and re-open vim'
endif
" }}}

" ### plugin settings {{{

" -- lightline - status line
set laststatus=2 " always show status line"
set noshowmode " hide insert, replace or visual on last line
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [ [ 'mode', 'paste' ],
      \           [ 'gitbranch', 'readonly', 'filename', 'modified' ] ]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'fugitive#head'
      \ }
      \ }
if !has('gui_running')
  set t_Co=256
endif

" -- netrw - file explorer
let g:netrw_banner = 0 " hide the banner
let g:netrw_liststyle = 3 " tree mode
let g:netrw_list_hide = netrw_gitignore#Hide() " hide files (automatically hides all git-ignored files)"

" -- matchit - extended matching with %
runtime macros/matchit.vim " enable matchit

" -- MUcomplete - auto complete
set completeopt+=menuone " use the popup menu even if there is only one match
set completeopt+=noselect " do not select a match in the menu
set shortmess+=c " disable completion messages"
let g:mucomplete#enable_auto_at_startup = 1 " enable at startup

" custom completion methods
let g:mucomplete#user_mappings = {}
let g:mucomplete#user_mappings.sqla = "\<c-c>a"
let g:mucomplete#user_mappings.sqls = "\<c-c>s"
let g:mucomplete#user_mappings.sqlk = "\<c-c>k"

" define conditions before a given method is tried
let g:mucomplete#can_complete = {}
let g:mucomplete#can_complete.sql = {
      \ 'sqls': { t -> strlen(&l:omnifunc) > 0 && t =~# '\%(\k\k\)$' },
      \ 'sqlk': { t -> strlen(&l:omnifunc) > 0 && t =~# '\%(\k\k\)$' },
      \ 'sqla': { t -> strlen(&l:omnifunc) > 0 && t =~# '\%(\k\k\)$' }
      \ }
" trigger omni-completion after a dot or after two keyword characters
" let g:mucomplete#can_complete.default = {'omni':
"   \ { t -> strlen(&l:omnifunc) > 0 && t =~# '\%(\k\k\|\.\)$' }
"   \ }

" complete chains
let g:mucomplete#chains = {}
let g:mucomplete#chains.default = [ 'path', 'omni', 'c-n' ]
let g:mucomplete#chains.sql = [ 'path', 'sqla', 'c-n' ]
" }}}

" ### General Settings {{{

set encoding=utf-8 " set character encoding

syntax enable " enable syntax highlighting

filetype plugin indent on " enable filetype detection, plugins and indent settings

set lazyredraw " stops the screen being redrawn during some operations, better performance

set hidden " causes buffers to be hidden instead of abandoned, allows changing buffer without saving

set spelllang=en_gb " set spelling language to English GB

set history=200 " command line mode history

set wildmenu " enhanced autocomplete for command menu

set showcmd " Show (partial) command in the last line of the screen

set backspace=2 " allow backspace over indent, eol, start

set cursorline " highlight current line

set scrolloff=2 " number of screen lines to keep above and below the cursor

colorscheme solarized " load color scheme
set background=dark " light/dark
highlight Normal ctermbg=NONE " transparent background

set number " Show line numbers
set numberwidth=3 " set number column to start at 3

set nowrap " don't wrap text
set linebreak " don't split words when wrapping text
set display+=lastline " show as much as possible of the last line

set expandtab " use spaces instead of TAB
set tabstop=2 " number of visual spaces per TAB
set softtabstop=2 " number of spaces in TAB when editing
set shiftwidth=2 " number of spaces to use for each step of (auto)indent

set autoindent " always set autoindenting on
set smartindent " smart autoindenting when no indent file

set incsearch " search as characters are typed
set hlsearch " highlight all search matches
set ignorecase " case insensitive search
set smartcase " enable case sensitive search when capitals are used

set list " show invisibles
set listchars=tab:│\ ,eol:∙ " set symbols for tabstops and EOLs
highlight SpecialKey ctermbg=NONE ctermfg=green guibg=NONE guifg=green " tab char colors
highlight NonText ctermbg=NONE ctermfg=darkmagenta guibg=NONE guifg=darkmagenta " eol char colors

set foldmethod=indent " by default fold on indents
set foldnestmax=10 " sets the maximum nest level of folds
set nofoldenable " start with all folds open

if has('persistent_undo')
  set undofile " use persistent undo
  set undodir=~/.vim/undodir " set persistent undo directory
  " create undo dir if it doesn't exist
  silent !mkdir -p -m 0700 ~/.vim/undodir
endif
" }}}

" ### key mappings {{{

" map jk/kj to exit, doesn't move cursor back
inoremap kj <Esc>`^
inoremap jk <Esc>`^

" use gj/gk for moving up and down unless a number is given
" allows normal movement through soft wrapped lines
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" set <Leader> key to space bar
nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"

" scroll window downwards half a screen
nnoremap <Leader>j <c-d>

" scroll window upwards half a screen
nnoremap <Leader>k <c-u>

" stop current search highlighting
nnoremap <Leader>/ :nohlsearch<CR>

" toggle file explorer
nnoremap <expr> <leader>e match(expand('%:t'),'Netrw') == -1 ? ':Explore<CR>' : ':Rexplore<CR>'

" show buffer list
nnoremap <Leader>l :buffers<CR>

" follow by buffer name and/or <TAB> and hit enter
nnoremap <Leader>b :buffer 

" go to alternate buffer
nnoremap <Leader>a :buffer #<CR>

" cycle between windows by pressing <Leader> key twice
nnoremap <Leader><Leader> <c-w>w

" same as <c-w>
nnoremap <Leader>w <c-w>

" open current window in a new tab
nnoremap <Leader>wt <c-w>T

" close all other tabs
nnoremap <Leader>to :tabonly<CR>

" open new tab
nnoremap <Leader>tn :tabnew<CR>

" close tab
nnoremap <Leader>tc :tabclose<CR>

" toggle Undotree
nnoremap <Leader>ut :UndotreeToggle<CR>

" insert uuid, see InsertUuid function below
nnoremap <Leader>uu :InsertUuid<CR>

" open diff tab, see DiffWithSaved function below
nnoremap <Leader>d :DiffOpen<CR>

" open diff tab, see DiffWithSaved function below
nnoremap <Leader>gd :GitDiffOpen<CR>
" }}}

" ### functions {{{

" diff the current buffer and original file
"   opens a new tab with a vertical split
"   the left window shows the original saved file
"   the right window shows the current buffer
function! s:DiffWithSaved()
  if &modified
    if filereadable(expand('%:p'))
      let filetype=&ft
      tabedit %
      diffthis
      vnew | r # | normal! 1Gdd
      diffthis
      execute 'setlocal bt=nofile bh=wipe nobl noswf ro ft=' . filetype
      setlocal foldmethod=diff
    else
      echo 'no file to diff'
    endif
  else
    echo 'no changes to diff'
  endif
endfunction
command! DiffOpen call s:DiffWithSaved()

" use vim to do a git diff of the current buffer
"   opens a new tab with a vertical split
"   the left window shows the version in the index
"   the right window shows the current buffer
function! s:DiffWithGit()
  if exists(':Gdiff')
    tabedit %
    Gvdiff
  else
    echo 'Gdiff not available'
  endif
endfunction
command! GitDiffOpen call s:DiffWithGit()

" generate and insert a uuid
"   uses uuidgen to generate a uuid
"   the uuid is saved to the 'u' register so it can be used again
"   the content of the 'u' register is then put after the cursor
function! s:InsertUuid()
  if executable('uuidgen')
    call setreg('u', system('uuidgen | tr -d "\n"'), 'c')
    execute "normal! \"up"
  else
    echo 'uuidgen command not found'
  endif
endfunction
command! InsertUuid call s:InsertUuid()
" }}}

" ### autocmds {{{

if has('autocmd')
  augroup misc
    " remove ALL autocommands for the current group
    autocmd!
    " return to the last cursor position when opening files
    autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line('$') | exe "normal! g'\"" | endif
    " disable automatic comment leader insertion, remove comment leader when joining lines
    autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o formatoptions+=j
    " auto-clean fugitive buffers
    autocmd BufReadPost fugitive://* set bufhidden=delete
    " highlight leading spaces with '·'
    autocmd FileType *
          \ syntax match LeadingSpace /\(^ *\)\@<= / containedin=ALL conceal cchar=· |
          \ setlocal conceallevel=2 concealcursor=nv |
          \ highlight Conceal ctermbg=NONE ctermfg=green guibg=NONE guifg=green
  augroup END

  augroup folding
    autocmd!
    " set foldmethod to marker
    autocmd FileType vim
          \ setlocal foldmethod=marker |
          \ setlocal foldenable
    " set foldmethod to syntax
    autocmd FileType ruby,javascript
          \ setlocal foldmethod=syntax |
          \ setlocal foldenable
  augroup END
endif
" }}}
