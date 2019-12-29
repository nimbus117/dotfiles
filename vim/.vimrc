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
Plug 'curist/vim-angular-template'
Plug 'diepm/vim-rest-console'
Plug 'editorconfig/editorconfig-vim'
Plug 'google/vim-searchindex'
Plug 'honza/vim-snippets'
Plug 'itchyny/lightline.vim'
Plug 'jiangmiao/auto-pairs'
Plug 'jremmen/vim-ripgrep'
Plug 'Konfekt/FastFold'
Plug 'ludovicchabant/vim-gutentags'
Plug 'majutsushi/tagbar'
Plug 'mattn/emmet-vim'
Plug 'maximbaz/lightline-ale'
Plug 'mbbill/undotree'
Plug 'PratikBhusal/vim-grip'
Plug 'sheerun/vim-polyglot'
Plug 'SirVer/ultisnips'
Plug 'swekaj/php-foldexpr.vim'
Plug 'tpope/vim-commentary'
Plug 'tpope/vim-dadbod'
Plug 'tpope/vim-endwise'
Plug 'tpope/vim-eunuch'
Plug 'tpope/vim-fugitive'
Plug 'tpope/vim-repeat'
Plug 'tpope/vim-surround'
Plug 'tpope/vim-unimpaired'
Plug 'vim-php/tagbar-phpctags.vim', { 'do': 'make' }
Plug 'vim-vdebug/vdebug', { 'for': 'php' }
Plug 'w0rp/ale'
Plug 'Yggdroot/LeaderF', { 'do': './install.sh' }
call plug#end()
" }}}
if new == 1
  PlugInstall --sync
endif
" }}}

" ### plugin settings {{{

" lightline - status line {{{
set laststatus=2 " always show status line
set noshowmode " hide insert/replace/visual on last line
let g:lightline#ale#indicator_checking = '...'
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ 'active': {
      \   'left': [[ 'mode', 'paste' ], [ 'gitbranch', 'readonly', 'filename', 'modified' ]],
      \   'right': [[ 'lineinfo' ], [ 'percent' ], [ 'fileInfo' ],
      \     [ 'linter_checking', 'linter_errors', 'linter_warnings' ]]
      \ },
      \ 'component_function': {
      \   'gitbranch': 'LightlineFugitive',
      \   'fileInfo': 'LightlineFileInfo',
      \ },
      \ 'component_expand': {
      \   'linter_checking': 'lightline#ale#checking',
      \   'linter_warnings': 'lightline#ale#warnings',
      \   'linter_errors': 'lightline#ale#errors',
      \ },
      \ 'component_type': {
      \   'linter_warnings': 'warning',
      \   'linter_errors': 'error',
      \ }
      \}

" component functions {{{

" return file and encoding information unless in vertical split
function! LightlineFileInfo() abort
  let l:fileType = &filetype !=# '' ? &filetype : 'no ft'
  let l:fileInfo = &fileformat . ' | ' . &encoding . ' | ' . l:fileType
  return winwidth(0) == &columns ? l:fileInfo : l:fileType
endfunction

" return current git HEAD unless in vertical split
function! LightlineFugitive() abort
  return winwidth(0) == &columns ? fugitive#head() : ''
endfunction
" }}}
" }}}

" netrw - file explorer {{{
let g:netrw_banner = 0 " hide the banner
let g:netrw_liststyle = 3 " tree mode
let g:netrw_list_hide = '\.swp$' " hide *.swp files
" }}}

" leaderF - fuzzy finder {{{
let g:Lf_WindowHeight = 10
let g:Lf_HideHelp = 1
let g:Lf_StlSeparator = {'left': '', 'right': ''}
let g:Lf_StlPalette = {
      \ 'stlName': {'ctermfg': 'black','ctermbg': 'darkblue','cterm': 'NONE'},
      \ 'stlCategory': {'ctermfg': 'black','ctermbg': 'green'},
      \ 'stlNameOnlyMode': {'ctermfg': 'black','ctermbg': 'white'},
      \ 'stlFullPathMode': {'ctermfg': 'black','ctermbg': 'blue'},
      \ 'stlFuzzyMode': {'ctermfg': 'black','ctermbg': 'blue'},
      \ 'stlCwd': {'ctermfg': '195','ctermbg': 'black'},
      \ 'stlBlank': {'ctermfg': 'NONE','ctermbg': 'black'},
      \ 'stlLineInfo': {'ctermfg': 'black','ctermbg': 'green'},
      \ 'stlTotal': {'ctermfg': 'black','ctermbg': 'blue'}
      \ }
let g:Lf_PreviewResult = {
      \ 'BufTag': 0,
      \ 'Function': 0,
      \ }
" }}}

" tagbar - browse tags from the current file {{{
let g:tagbar_compact = 1 " hide help
let g:tagbar_show_linenumbers = 2 " show relative line numbers
let g:tagbar_sort = 0 " sort based on order in source file
" }}}

" ultisnips - snippets in vim {{{
let g:UltiSnipsListSnippets = "<f5>" " snippet list
let g:UltiSnipsJumpForwardTrigger = "<tab>" " jump forward in snippet
let g:UltiSnipsJumpBackwardTrigger = "<s-tab>" " jump back in snippet
" }}}

" vim-rest-console - rest requests {{{
let s:vrc_auto_format_response_patterns = {
      \ 'json': 'python -m json.tool',
      \ 'xml': 'xmllint --format -',
      \ }

let g:vrc_curl_opts = {
      \ '--connect-timeout': 10,
      \ '--location': '',
      \ '--include': '',
      \ '--max-time': 60,
      \ '--ipv4': '',
      \ '--insecure': '',
      \ '--silent': '',
      \ }
" }}}

" fastfold - automatic folds {{{
let g:fastfold_force = 1 " prevent on every buffer change
let g:fastfold_fold_movement_commands = [ ']z', '[z' ]
let g:fastfold_fold_command_suffixes = [ 'x','X','o','O','c','C','r','R','m','M' ]
let g:fastfold_minlines = 0
" }}}

" vdebug - vim debugger {{{
if !exists('g:vdebug_options')
  let g:vdebug_options = {}
endif
let g:vdebug_options.break_on_open = 0 " don't break on the first line
" }}}

" ale - asynchronous lint engine {{{
let g:ale_lint_on_text_changed = 'normal' " don't run linters in insert mode
let g:ale_lint_on_insert_leave = 1 " run linters when leaving insert mode
let g:ale_fixers = {
      \ 'javascript': [ 'eslint' ],
      \ 'typescript': ['eslint'],
      \ 'json': [ 'prettier' ],
      \ 'html': [ 'prettier' ],
      \ 'css': [ 'prettier' ],
      \ 'scss': [ 'prettier' ],
      \ }
let g:ale_fix_on_save = 1 " run fixers on save
let g:ale_sign_error = "->"
" }}}

" matchit - extended matching with %
packadd! matchit

" undotree - visualizes undo history
let g:undotree_WindowLayout = 2

" editorconfig - maintain consistent coding styles
let g:EditorConfig_exclude_patterns = [ 'fugitive://.\*' ]

" vim-grip - github readme instant preview
let g:grip_default_map = 0
" }}}

" ### functions/commands {{{

" custom highlighting {{{
function! s:CustomHighlights() abort
  highlight CursorLineNr cterm=NONE " relative line number
  highlight Folded ctermbg=NONE cterm=NONE " fold lines
  highlight htmlArg ctermfg=lightblue " html attributes
  highlight NonText ctermbg=NONE " eol character
  highlight Pmenu ctermfg=black ctermbg=grey " popup menu items
  highlight PmenuSbar ctermfg=black " popup scrollbar
  highlight PmenuSel ctermfg=darkblue " popup menu selected item
  highlight QuickFixLine ctermbg=NONE ctermfg=white " current item in quickfix
  highlight Search ctermbg=black ctermfg=NONE " search match
  highlight SignColumn ctermbg=NONE " sign column/gutter
  highlight SpecialKey ctermbg=NONE " tab/space characters
  highlight SpellBad cterm=underline " spelling mistakes
  highlight TagbarHighlight ctermbg=black " tagbar current tag
endfunction
" }}}

" open a new tab for MongoDB queries using dadbod {{{
function! s:Mongo() abort
  if exists(':DB')
    tabedit .vim.mongo.js
    let b:db = "mongodb:"
    nnoremap <silent> <buffer> <c-j> :.DB<cr><c-w><s-h>
    xnoremap <silent> <buffer> <c-j> :DB<cr><c-w><s-h>
  else
    echo 'DB command not available'
  endif
endfunction
command! Mongo call s:Mongo()
" }}}

" open vim-rest-console in new tab
command! Vrc tabedit .vrc.rest

" format json
command! -range=% JSON <line1>,<line2>!python -m json.tool
" }}}

" ### autocmds {{{

if has('autocmd')
  augroup misc
    " remove all autocommands for the current group
    autocmd!
    " disable automatic comment leader insertion, remove comment leader when joining lines
    autocmd FileType * setlocal formatoptions-=cro formatoptions+=j
    " clean up netrw hidden buffers, enable line numbers
    autocmd FileType netrw setlocal bufhidden=wipe |
          \ let g:netrw_bufsettings -= "nonu"
    " disable relativenumber, set scrolloff to 1 and map q to :q in quickfix window
    autocmd FileType qf setlocal norelativenumber scrolloff=1 cursorline |
          \ execute "nnoremap <silent> <buffer> q :q<cr>"
    " set foldmethod to marker
    autocmd FileType vim,zsh,screen setlocal foldmethod=marker foldenable
    " set foldmethod to syntax
    autocmd FileType ruby,javascript,json,c,scss setlocal foldmethod=syntax
    " set php comment string to // (replaces /*  */)
    autocmd FileType php setlocal commentstring=//\ %s
    " each VRC buffer uses a different display buffer
    autocmd FileType rest let b:vrc_output_buffer_name =
          \ "__VRC_" . substitute(system('echo $RANDOM'), '\n\+$', '', '') . "__" |
          \ setlocal foldmethod=indent nofoldenable
    " set javascript omnicomplete function
    autocmd FileType javascript setlocal omnifunc=javascriptcomplete#CompleteJS
    " use ale for typescript omnifunc and goto definition
    autocmd FileType typescript setlocal omnifunc=ale#completion#OmniFunc | 
          \ nnoremap  :ALEGoToDefinition<cr>
    " treat '-' as a regular word character
    autocmd FileType html,css,scss setlocal iskeyword+=-
    " set textwidth to 80 for markdown
    autocmd FileType markdown setlocal textwidth=80
    " return to the last cursor position when opening files
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line('$') |
          \ exe "normal! g`\"" |
          \ endif
    " cursorline in current window and normal mode only
    autocmd InsertLeave,WinEnter * set cursorline
    autocmd InsertEnter,WinLeave * set nocursorline
    " call CustomHighlights function when changing colorscheme
    autocmd ColorScheme * call s:CustomHighlights()
  augroup END
endif
" }}}

" ### general settings {{{

colorscheme solarized " set color scheme
filetype plugin indent on " enable filetype detection, plugins and indent settings
syntax enable " enable syntax highlighting

set autoindent " copy indent from current line when starting a new line
set background=dark " light/dark
set backspace=2 " allow backspace over indent, eol, start
set complete-=i " do not scan included files when using c-p/c-n
set completeopt-=preview " don't show extra information in preview window
set diffopt+=vertical " always use vertical diffs
set display+=lastline " show as much as possible of the last line
set encoding=utf-8 " set character encoding
set foldnestmax=5 " sets the maximum nest level of folds
set hidden " causes buffers to be hidden instead of abandoned, allows changing buffer without saving
set history=1000 " command line mode history
set incsearch " search as characters are typed
set lazyredraw " stops the screen being redrawn during some operations, better performance
set linebreak " don't split words when wrapping text
set listchars=space:·,tab:»\ ,eol:¬ " set symbols for invisible characters
set nofoldenable " start with all folds open
set nowrap " don't wrap text
set nrformats-=octal " don't treat numbers as octal when using ctrl-a
set number " show line numbers
set numberwidth=3 " set number column to start at 3
set pumheight=10 " popup menu max height
set relativenumber " show relative line numbers
set scrolloff=2 " number of screen lines to keep above and below the cursor
set sessionoptions-=options " when saving a session do not save all options and mappings
set shortmess+=I " disable intro message when starting vim
set showcmd " show (partial) command in the last line of the screen
set signcolumn=number " display signs in the number column
set spelllang=en_gb " set spelling language to English GB
set splitbelow " splitting a window will put the new window below the current one
set splitright " splitting a window vertically will put the new window to the right of the current one
set synmaxcol=1000 " only highlight the first 1000 columns
set wildignorecase " case is ignored when completing file names
set wildmenu " enhanced autocomplete for command menu

set expandtab " use spaces instead of tabs
set shiftwidth=2 " number of spaces to use for each step of (auto)indent
set tabstop=2 " number of visual spaces per TAB

if has('persistent_undo')
  set undofile " use persistent undo
  set undodir=$HOME/.vim/undodir " set persistent undo directory
  " create undo dir if it doesn't exist
  silent !mkdir -p -m 0700 "$HOME/.vim/undodir"
endif
" }}}

" ### language specific settings {{{

" php {{{
let php_baselib = 1 " highlight baselib methods
let php_htmlInStrings = 1 " highlight HTML syntax
" }}}

" markdown {{{
let g:markdown_folding = 1 " enable markdown folding
" }}}

" assembly {{{
let g:asmsyntax = 'nasm' " set filetype for .asm
" }}}
" }}}

" ### key mappings {{{

" map jk to exit
inoremap jk <esc>

" swap quote and backtick in normal mode
nnoremap ' `
nnoremap ` '

" make ctrl-p/n behave like up and down arrows in command line mode
cnoremap <c-p> <up>
cnoremap <c-n> <down>

" leader key bindings {{{

" set <leader> key to space bar
nnoremap <space> <nop>
let mapleader = "\<space>"

" cycle between windows by pressing <leader> key twice
nnoremap <leader><leader> <c-w>w
" toggle search highlighting
nnoremap <silent> <leader>/ :setlocal hlsearch!<cr>:set hlsearch?<cr>
" go to alternate buffer
nnoremap <silent> <leader>a :buffer #<cr>
" launch LeaderF to search tags (ctags)
nnoremap <silent> <leader>c :LeaderfTag<cr>
" toggle file explorer
nnoremap <silent> <expr> <leader>e &ft == 'netrw' ? ':Rexplore<cr>' : ':Explore<cr>'
" open git diff of current buffer in a new tab
nnoremap <silent> <leader>gd :tabedit %<cr>:Gdiffsplit!<cr>
" search files using ripgrep
nnoremap <leader>gg :Rg<space>
" open git log of current buffer file in a new tab
nnoremap <silent> <leader>gl :tabedit %<cr>:Glog %:p<cr>
" open Gstatus
nnoremap <silent> <leader>gs :Gstatus<cr><c-w>T
" search for the word under the cursor using ripgrep
nnoremap <silent> <leader>gw :Rg -w <c-r><c-w><cr>
" search help and open in new tab
nnoremap <leader>h :tab help<space>
" show/hide invisibles
nnoremap <silent> <leader>i :setlocal list!<cr>
" toggle line wrapping
nnoremap <leader>l :setlocal wrap!<cr>:setlocal wrap?<cr>
" save current session as .vimsess
nnoremap <leader>ms :mksession! .vimsess<cr>
" launch LeaderF to search recently used files in the current directory
nnoremap <silent> <leader>mr :LeaderfMruCwd<cr>
" toggle relative numbering
nnoremap <silent> <leader>n :setlocal relativenumber!<cr>: set relativenumber?<cr>
" toggle paste mode
nnoremap <silent> <leader>p :set paste!<cr>
" find/replace all on word under cursor
nnoremap <leader>r :%s/\<<c-r><c-w>\>\C//g<left><left>
" toggle spell checking
nnoremap <silent> <leader>sp :setlocal spell!<cr>:setlocal spell?<cr>
" source the session saved in .vimsess
nnoremap <silent> <leader>ss :source .vimsess<cr>
" open tagbar with autoclose set
nnoremap <silent> <leader>tb :TagbarOpenAutoClose<cr>
" close tab
nnoremap <silent> <leader>tc :tabclose<cr>
" open new tab
nnoremap <silent> <leader>tn :tabnew<cr>
" close all other tabs
nnoremap <silent> <leader>to :tabonly<cr>
" toggle undotree
nnoremap <silent> <leader>ut :UndotreeToggle<cr>
" same as <c-w>
nnoremap <leader>w <c-w>
" open current window in a new tab
nnoremap <leader>wt <c-w>T
" }}}
" }}}
