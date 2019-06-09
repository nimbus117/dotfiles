set nocompatible " make vim behave in a more useful way

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
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-php/tagbar-phpctags.vim', {'do': 'make'}
Plug 'vim-vdebug/vdebug', {'for': 'php'}
Plug 'w0rp/ale'
Plug 'Yggdroot/LeaderF', {'do': './install.sh'}
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
let g:netrw_list_hide = '\.swp$' " hide *.swp files

" matchit - extended matching with %
runtime macros/matchit.vim " enable matchit

" leaderF - fuzzy finder {{{
let g:Lf_WindowHeight = 0.2
let g:Lf_HideHelp = 1
let g:Lf_StlSeparator = {'left': '', 'right': ''}
let g:Lf_StlPalette = {
      \   'stlName': {'ctermfg': 'black','ctermbg': 'darkblue','cterm': 'NONE'},
      \   'stlCategory': {'ctermfg': 'black','ctermbg': 'green'},
      \   'stlNameOnlyMode': {'ctermfg': 'black','ctermbg': 'white'},
      \   'stlFullPathMode': {'ctermfg': 'black','ctermbg': 'blue'},
      \   'stlFuzzyMode': {'ctermfg': 'black','ctermbg': 'blue'},
      \   'stlCwd': {'ctermfg': '195','ctermbg': 'black'},
      \   'stlBlank': {'ctermfg': 'NONE','ctermbg': 'black'},
      \   'stlLineInfo': {'ctermfg': 'black','ctermbg': 'green'},
      \   'stlTotal': {'ctermfg': 'black','ctermbg': 'blue'}
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
let g:tagbar_show_linenumbers = 2 " show relative line numbers
let g:tagbar_sort = 0 " sort based on order in source file
let g:tagbar_type_javascript = {
      \ 'kinds': [
      \ 'C:Classes:1:0', 'M:Methods:1:0', 'F:Functions:1:0',
      \ 'P:Properties:1:0', 'V:Variables:1:0', 'A:Arrays:1:0',
      \ 'O:Objects:1:0', 'T:Tags:1:0', 'S:StyledComponents:1:0',
      \ 'G:Generators:1:0', 'E:Exports:1:0', 'I:Imports:1:0'
      \ ],
      \ 'sro': '.',
      \ 'kind2scope': {'C' : 'Class', 'M' : 'Method'}
      \ }
" ruby tags - gem install ripper-tags
if executable('ripper-tags')
  let g:tagbar_type_ruby = {
        \ 'kinds'      : [
        \ 'm:modules', 'c:classes', 'C:constants',
        \ 'F:singleton methods', 'f:methods', 'a:aliases'
        \ ],
        \ 'kind2scope' : {'c' : 'class', 'm' : 'class'},
        \ 'scope2kind' : {'class' : 'c'},
        \ 'ctagsbin'   : 'ripper-tags',
        \ 'ctagsargs'  : ['-f', '-']
        \ }
endif
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
let g:fastfold_minlines= 0

" vdebug - vim debugger
if !exists('g:vdebug_options')
  let g:vdebug_options = {}
endif
let g:vdebug_options.break_on_open = 0 " don't break on the first line

" ale - asynchronous lint engine
let g:ale_lint_on_text_changed = 'never' " don't run linters when making changes
let g:ale_lint_on_insert_leave = 1 " run linters when leaving insert mode
" }}}

" ### general settings {{{

filetype plugin indent on " enable filetype detection, plugins and indent settings
syntax enable " enable syntax highlighting
colorscheme solarized " load color scheme
set background=dark " light/dark
set t_Co=256 " set number of colors
set encoding=utf-8 " set character encoding
set lazyredraw " stops the screen being redrawn during some operations, better performance
set hidden " causes buffers to be hidden instead of abandoned, allows changing buffer without saving
set backspace=2 " allow backspace over indent, eol, start
set scrolloff=5 " number of screen lines to keep above and below the cursor
set history=500 " command line mode history
set showcmd " Show (partial) command in the last line of the screen
set spelllang=en_gb " set spelling language to English GB
set autoindent " copy indent from current line when starting a new line
set sessionoptions-=options " when saving a session do not save all options and mappings
set listchars=space:·,tab:»\ ,eol:¬ " set symbols for invisible characters
set pumheight=10 " popup menu max height
set nrformats-=octal " don't treat numbers as octal when using ctrl-a
set shortmess+=I " disable intro message when starting vim

set splitbelow " splitting a window will put the new window below the current one
set splitright " splitting a window will put the new window to the right of the current one

set complete-=i " do not scan included files when using c-p/c-n
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

set foldmethod=indent " by default fold on indents
set foldnestmax=5 " sets the maximum nest level of folds
set nofoldenable " start with all folds closed

set expandtab " use spaces instead of TAB
set tabstop=2 " number of visual spaces per TAB
set softtabstop=2 " number of spaces in TAB when editing
set shiftwidth=2 " number of spaces to use for each step of (auto)indent

set incsearch " search as characters are typed
set hlsearch " highlight all search matches
set ignorecase " case insensitive search
set smartcase " enable case sensitive search when capitals are used

if has('persistent_undo')
  set undofile " use persistent undo
  set undodir=$HOME/.vim/undodir " set persistent undo directory
  " create undo dir if it doesn't exist
  silent !mkdir -p -m 0700 "$HOME/.vim/undodir"
endif

" highlighting {{{
highlight Folded ctermbg=NONE cterm=NONE " no background color or underline on fold lines
highlight SpecialKey ctermbg=NONE " tab/space char colors
highlight NonText ctermbg=NONE " eol char colors
highlight SpellBad cterm=underline " underline spelling mistakes
highlight SignColumn ctermbg=NONE " no background color for gutter/column
highlight Pmenu ctermfg=black ctermbg=grey " popup menu items
highlight PmenuSel ctermfg=darkblue " popup menu selected item
highlight PmenuSbar ctermfg=black " scrollbar
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

" leader key bindings {{{

" set <leader> key to space bar
nnoremap <space> <nop>
let mapleader = "\<Space>"

" cycle between windows by pressing <leader> key twice
nnoremap <leader><leader> <c-w>w
" stop current search highlighting
nnoremap <silent> <leader>/ :nohlsearch<cr>
" go to alternate buffer
nnoremap <silent> <leader>a :buffer #<cr>
" launch LeaderF to search tags (ctags)
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
" show/hide invisibles
nnoremap <silent> <leader>i :setlocal list!<cr>
" scroll window downwards half a screen
nnoremap <leader>j <c-d>
" scroll window upwards half a screen
nnoremap <leader>k <c-u>
" toggle line wrapping
nnoremap <leader>l :set wrap!<cr>:set wrap?<cr>
" save current session as .vimsess
nnoremap <leader>ms :mksession! .vimsess<cr>
" launch LeaderF to search recently used files in the current directory
nnoremap <silent> <leader>mr :LeaderfMruCwd<cr>
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

" ### functions/commands {{{

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
  endif
endfunction
command! -nargs=* GGrep call s:GGrep(<f-args>)
" }}}

" format json using python
command! FormatJSON %!python -m json.tool
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
    autocmd FileType qf setlocal cursorline norelativenumber |
          \ exec "nnoremap <silent> <buffer> q :q<cr>"
    " set foldmethod to marker
    autocmd FileType vim setlocal foldmethod=marker foldenable
    " set foldmethod to syntax
    autocmd FileType ruby,javascript setlocal foldmethod=syntax foldenable
    " start with folds closed
    autocmd FileType php setlocal foldenable
    " set php comment string to // (replaces /*  */)
    autocmd FileType php setlocal commentstring=//\ %s
    " each VRC buffer uses a different display buffer
    autocmd FileType rest let b:vrc_output_buffer_name =
          \ "__VRC_" . substitute(system('echo $RANDOM'), '\n\+$', '', '') . "__"
    " disable automatic comment leader insertion, remove comment leader when joining lines
    autocmd FileType * setlocal formatoptions-=cro formatoptions+=j
    " return to the last cursor position when opening files
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line('$') |
          \ exe "normal! g`\"" |
          \ endif
  augroup END
endif
" }}}
