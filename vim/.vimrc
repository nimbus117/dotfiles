" ### plugin manager {{{

let new=0
if empty(glob('~/.vim/autoload/plug.vim'))
  silent !curl -fLo ~/.vim/autoload/plug.vim --create-dirs
        \ https://raw.githubusercontent.com/junegunn/vim-plug/master/plug.vim
  let new=1
endif
" plugins {{{
call plug#begin('~/.vim/plugged')
Plug 'altercation/vim-colors-solarized'
Plug 'diepm/vim-rest-console'
Plug 'google/vim-searchindex'
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'JulesWang/css.vim'
Plug 'Konfekt/FastFold'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
Plug 'mattn/emmet-vim'
Plug 'mbbill/undotree'
Plug 'nelstrom/vim-visual-star-search'
Plug 'pangloss/vim-javascript'
Plug 'SirVer/ultisnips'
Plug 'swekaj/php-foldexpr.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-php/tagbar-phpctags.vim', { 'do': 'make'  }
Plug 'vim-vdebug/vdebug', { 'for': 'php'  }
Plug 'w0rp/ale'
Plug 'Yggdroot/LeaderF', { 'do': './install.sh'  }
call plug#end()
" }}}
if new == 1
  PlugInstall --sync
endif
" }}}

" ### plugin settings {{{

" lightline - status line {{{
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
" }}}

" netrw - file explorer
let g:netrw_banner = 0 " hide the banner
let g:netrw_liststyle = 3 " tree mode
let g:netrw_list_hide = netrw_gitignore#Hide() " hides all git-ignored files

" matchit - extended matching with %
runtime macros/matchit.vim " enable matchit

" leaderF - fuzzy finder {{{
let g:Lf_WindowHeight = 0.2
let g:Lf_HideHelp = 1
let g:Lf_StlSeparator = { 'left': '', 'right': '' }
let g:Lf_StlPalette = {
      \   'stlName': {
      \       'ctermfg': 'black',
      \       'ctermbg': 'darkblue',
      \       'cterm': 'NONE'
      \   },
      \   'stlCategory': {
      \       'ctermfg': 'black',
      \       'ctermbg': 'green'
      \   },
      \   'stlNameOnlyMode': {
      \       'ctermfg': 'black',
      \       'ctermbg': 'white'
      \   },
      \   'stlFullPathMode': {
      \       'ctermfg': 'black',
      \       'ctermbg': 'blue'
      \   },
      \   'stlFuzzyMode': {
      \       'ctermfg': 'black',
      \       'ctermbg': 'blue'
      \   },
      \   'stlCwd': {
      \       'ctermfg': '195',
      \       'ctermbg': 'black'
      \   },
      \   'stlBlank': {
      \       'ctermfg': 'NONE',
      \       'ctermbg': 'black'
      \   },
      \   'stlLineInfo': {
      \       'ctermfg': 'black',
      \       'ctermbg': 'green'
      \   },
      \   'stlTotal': {
      \       'ctermfg': 'black',
      \       'ctermbg': 'blue'
      \   }
      \ }
let g:Lf_WildIgnore = {
      \ 'dir': ['.git', 'node_modules', 'vendor'],
      \ 'file': ['*.swp', 'bundle.js', 'tags']
      \}
let g:Lf_PreviewResult = {
      \ 'BufTag': 0,
      \ 'Function': 0,
      \}
" }}}

" tagbar - browse tags from the current file {{{
let g:tagbar_compact = 1 " hide help
let g:tagbar_show_linenumbers=2 " show relative line numbers
let g:tagbar_sort = 0 " sort based on order in source file
let g:tagbar_type_javascript = {
      \ 'kinds' : [
      \ 'C:Classes:1:0',
      \ 'M:Methods:1:0',
      \ 'F:Functions:1:0',
      \ 'P:Properties:1:0',
      \ 'V:Variables:1:0',
      \ 'A:Arrays:1:0',
      \ 'O:Objects:1:0',
      \ 'T:Tags:1:0',
      \ 'S:StyledComponents:1:0',
      \ 'G:Generators:1:0',
      \ 'E:Exports:1:0',
      \ 'I:Imports:1:0',
      \ ],
      \ 'sro'        : '.',
      \ 'kind2scope' : {
      \ 'C' : 'Class',
      \ 'M' : 'Method',
      \ }
      \ }
" }}}

" ultisnips - snippets in Vim
let g:UltiSnipsListSnippets = "<f5>" " snippet list
let g:UltiSnipsJumpForwardTrigger = "<tab>" " jump forward in snippet
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>" " jump back in snippet

" vim-rest-console - rest requests {{{
let s:vrc_auto_format_response_patterns = {
      \ 'json': 'python -m json.tool',
      \ 'xml': 'xmllint --format -',
      \}

let g:vrc_curl_opts = {
      \ '--connect-timeout': 10,
      \ '--location': '',
      \ '--include': '',
      \ '--max-time': 60,
      \ '--ipv4': '',
      \ '--insecure': '',
      \ '--silent': '',
      \}
" }}}

" fastfold - automatic folds
let g:fastfold_force = 1 " prevent on every buffer change
let g:fastfold_fold_movement_commands = [']z', '[z']
let g:fastfold_fold_command_suffixes =  ['x','X','o','O','c','C','r','R','m','M']

" vdebug - vim debugger
if !exists('g:vdebug_options')
  let g:vdebug_options = {}
endif
let g:vdebug_options.break_on_open = 0 " don't break on the first line

" ale - asynchronous lint engine
let g:ale_lint_on_text_changed = 'never' " disable ale when typing
" }}}

" ### general settings {{{

set encoding=utf-8 " set character encoding

syntax enable " enable syntax highlighting

filetype plugin indent on " enable filetype detection, plugins and indent settings

colorscheme solarized " load color scheme

set background=dark " light/dark

set lazyredraw " stops the screen being redrawn during some operations, better performance

set hidden " causes buffers to be hidden instead of abandoned, allows changing buffer without saving

set history=500 " command line mode history

set showcmd " Show (partial) command in the last line of the screen

set backspace=2 " allow backspace over indent, eol, start

set scrolloff=5 " number of screen lines to keep above and below the cursor

set spelllang=en_gb " set spelling language to English GB

set autoindent " always set autoindenting on

set sessionoptions-=options " when saving a session do not save all options and mappings

set complete-=i " do not scan included files when using c-p/c-n

set t_Co=256 " set number of colors

set completeopt+=menuone " use the popup menu even if there is only one match
set completeopt-=preview " don't show extra information in preview window

set wildmenu " enhanced autocomplete for command menu
set wildignore+=*.swp,*/node_modules/*,*/vendor/*,bundle.js,tags " exclude from wildmenu and vimgrep
set wildignorecase " case is ignored when completing file names

set number " show line numbers
set relativenumber " show relative line numbers
set numberwidth=3 " set number column to start at 3

set nowrap " don't wrap text
set linebreak " don't split words when wrapping text
set display+=lastline " show as much as possible of the last line

set expandtab " use spaces instead of TAB
set tabstop=2 " number of visual spaces per TAB
set softtabstop=2 " number of spaces in TAB when editing
set shiftwidth=2 " number of spaces to use for each step of (auto)indent

set incsearch " search as characters are typed
set hlsearch " highlight all search matches
set ignorecase " case insensitive search
set smartcase " enable case sensitive search when capitals are used

set list " show invisibles
set listchars=tab:·\ ,eol:·,extends:> " set symbols for tabstops and EOLs

set foldmethod=indent " by default fold on indents
set foldnestmax=5 " sets the maximum nest level of folds
set nofoldenable " start with all folds closed

if has('persistent_undo')
  set undofile " use persistent undo
  set undodir=$HOME/.vim/undodir " set persistent undo directory
  " create undo dir if it doesn't exist
  silent !mkdir -p -m 0700 "$HOME/.vim/undodir"
endif

" highlighting {{{
highlight Folded ctermbg=NONE cterm=NONE " no background color or underline on fold lines
highlight SpecialKey ctermbg=NONE ctermfg=green " tab char colors
highlight NonText ctermbg=NONE ctermfg=darkmagenta " eol char colors
highlight SpellBad cterm=underline " underline spelling mistakes
highlight SignColumn ctermbg=NONE " no background color for gutter/column
" }}}

" php settings {{{
let php_sql_query = 1 " highlight SQL syntax
let php_baselib = 1 " highlight Baselib methods
let php_htmlInStrings = 1 " highlight HTML syntax
" }}}
" }}}

" ### key mappings {{{

" map jk to exit, doesn't move cursor back
inoremap jk <esc>`^

" swap quote and backtick in normal mode
nnoremap ' `
nnoremap ` '

" set <leader> key to space bar
nnoremap <space> <nop>
let mapleader = "\<Space>"

" leader key bindings {{{

" cycle between windows by pressing <leader> key twice
nnoremap <leader><leader> <c-w>w

" stop current search highlighting
nnoremap <silent> <leader>/ :nohlsearch<cr>

" go to alternate buffer
nnoremap <silent> <leader>a :buffer #<cr>

" launch LeaderF to navigate ctags
nnoremap <silent> <leader>c :LeaderfTag<cr>

" toggle file explorer
nnoremap <silent> <expr> <leader>e match(expand('%:t'),'Netrw') == -1 ? ':Explore .<cr>' : ':Rexplore<cr>'

" open git diff tab, see DiffWithGit function below
nnoremap <leader>gd :GitDiff<cr>

" search files using grep, see GGrep function below
nnoremap <leader>gg :GGrep 

" open Gstatus
nnoremap <silent> <leader>gs :Gstatus<cr>:resize 10<cr>

" search for the word under the cursor using GGrep
nnoremap <silent> <leader>gw :GGrep <c-r><c-w> . -rw<cr>

" search help and open in new tab
nnoremap <leader>h :tab help 

" scroll window downwards half a screen
nnoremap <leader>j <c-d>

" scroll window upwards half a screen
nnoremap <leader>k <c-u>

" toggle line wrapping
nnoremap <leader>l :set wrap!<cr>:set wrap?<cr>

" save current session as .vimsess
nnoremap <leader>ms :mksession! .vimsess<cr>

" launch LeaderF to navigate MRU
nnoremap <silent> <leader>mr :LeaderfMru<cr>

" toggle relative numbering
nnoremap <silent> <leader>n :setlocal relativenumber!<cr>

" toggle paste mode
nnoremap <silent> <leader>p :set paste!<cr>

" find/replace all on word under cursor
nnoremap <leader>r :%s/\<<c-r><c-w>\>\C//g<left><left>

" source the session saved in .vimsess
nnoremap <silent> <leader>ss :source .vimsess<cr>

" open Tagbar with autoclose set
nnoremap <silent> <leader>tb :TagbarOpenAutoClose<cr>

" close tab
nnoremap <silent> <leader>tc :tabclose<cr>

" open new tab
nnoremap <silent> <leader>tn :tabnew<cr>

" close all other tabs
nnoremap <silent> <leader>to :tabonly<cr>

" open vim-rest-console in new tab
nnoremap <silent> <leader>tr :tabedit .vrc.rest<cr>

" toggle Undotree
nnoremap <silent> <leader>ut :UndotreeToggle<cr>

" search files using vimgrep, see VGrep function below
nnoremap <leader>vg :VGrep \C<left><left>

" search for the word under the cursor using VGrep
nnoremap <silent> <leader>vw :VGrep \<<c-r><c-w>\>\C<cr>

" same as <c-w>
nnoremap <leader>w <c-w>

" open current window in a new tab
nnoremap <leader>wt <c-w>T
" }}}
" }}}

" ### functions {{{

" run git diff against the current buffer {{{
" opens a new tab with a vertical split
" the left window shows the version in the index
" the right window shows the current buffer
function! s:GitDiff()
  if exists(':Gdiff')
    tabedit %
    Gvdiff
  else
    echo 'Gdiff not available'
  endif
endfunction
command! GitDiff call s:GitDiff()
" }}}

" search files using vimgrep {{{
" searches in pwd recursively by default
" if any matches are found the quickfix window is opened
function! s:VGrep(searchStr, ...)
  let path = a:0 >= 1 ? a:1 : '**'
  noautocmd execute 'vimgrep' '/'.a:searchStr.'/j' path
  if !empty(getqflist())
    copen
    exec "nnoremap <silent> <buffer> q :cclose<cr>"
  endif
endfunction
command! -nargs=* VGrep call s:VGrep(<f-args>)
" }}}

" search files using grep {{{
" similar to VGrep function above except using grep instead of vimgrep
function! s:GGrep(searchStr, ...)
  let path = a:0 >= 1 ? a:1 : '.'
  let flags = a:0 >= 2 ? a:2 : '-rF'
  let command = 'grep! -I'.
        \ ' --exclude-dir=.git --exclude-dir=node_modules --exclude-dir=vendor'.
        \ ' --exclude="*.swp" --exclude=bundle.js --exclude=tags'
  silent execute command flags a:searchStr path
  redraw!
  if !empty(getqflist())
    copen
    exec "nnoremap <silent> <buffer> q :cclose<cr>"
  endif
endfunction
command! -nargs=* GGrep call s:GGrep(<f-args>)
" }}}
" }}}

" ### autocmds {{{

if has('autocmd')
  augroup misc
    " remove ALL autocommands for the current group
    autocmd!
    " enable spell checking for certain filetypes
    autocmd FileType markdown,html,text setlocal spell
    " clean up netrw hidden buffers
    autocmd FileType netrw setlocal bufhidden=wipe
    " enable cursorline highlighting and disable relativenumber in quickfix window
    autocmd FileType qf setlocal cursorline norelativenumber
    " set foldmethod to marker
    autocmd FileType vim setlocal foldmethod=marker foldenable
    " set foldmethod to syntax
    autocmd FileType ruby,javascript setlocal foldmethod=syntax foldenable
    " start with folds closed
    autocmd FileType php setlocal foldenable
    " set php comment string to // (replaces /*  */)
    autocmd FileType php setlocal commentstring=//\ %s
    " disable automatic comment leader insertion, remove comment leader when joining lines
    autocmd FileType * setlocal formatoptions-=cro formatoptions+=j
    " highlight leading spaces with '·'
    autocmd FileType *
          \ syntax match LeadingSpace /\(^ *\)\@<= / containedin=ALL conceal cchar=· |
          \ setlocal conceallevel=2 concealcursor=nv |
          \ highlight Conceal ctermbg=NONE ctermfg=green
    " return to the last cursor position when opening files
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line('$') |
          \ exe "normal! g`\"" |
          \ endif
  augroup END
endif
" }}}
