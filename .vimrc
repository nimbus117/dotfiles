" ### vundle plugin manager {{{

let new=0
let vundle_readme=expand("$HOME/.vim/bundle/Vundle.vim/README.md")
if !filereadable(vundle_readme)
  echo 'Installing Vundle...'
  echo ''
  silent !mkdir -p "$HOME/.vim/bundle"
  silent !git clone "https://github.com/VundleVim/Vundle.vim" "$HOME/.vim/bundle/Vundle.vim"
  let new=1
endif
filetype off " required
set runtimepath+=$HOME/.vim/bundle/Vundle.vim/
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
" add plugins here {{{
Plugin 'altercation/vim-colors-solarized'
Plugin 'diepm/vim-rest-console'
Plugin 'francoiscabrol/ranger.vim'
Plugin 'google/vim-searchindex'
Plugin 'honza/vim-snippets'
Plugin 'itchyny/lightline.vim'
Plugin 'jiangmiao/auto-pairs'
Plugin 'Konfekt/FastFold'
Plugin 'lifepillar/vim-mucomplete'
Plugin 'majutsushi/tagbar'
Plugin 'mattn/emmet-vim'
Plugin 'mbbill/undotree'
Plugin 'nelstrom/vim-visual-star-search'
Plugin 'sheerun/vim-polyglot'
Plugin 'SirVer/ultisnips'
Plugin 'swekaj/php-foldexpr.vim'
Plugin 'takac/vim-hardtime'
Plugin 'tpope/vim-commentary'
Plugin 'tpope/vim-fugitive.git'
Plugin 'tpope/vim-repeat'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-unimpaired'
Plugin 'ludovicchabant/vim-gutentags'
Plugin 'vim-php/tagbar-phpctags.vim'
Plugin 'vim-scripts/dbext.vim'
Plugin 'Yggdroot/LeaderF'
" }}}
call vundle#end()
if new == 1
  :PluginInstall
  echo 'you may need to close and re-open vim'
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
if !has('gui_running')
  set t_Co=256
endif
" }}}

" netrw - file explorer
let g:netrw_banner = 0 " hide the banner
let g:netrw_liststyle = 3 " tree mode
let g:netrw_list_hide = netrw_gitignore#Hide() " hide files (automatically hides all git-ignored files)

" matchit - extended matching with %
runtime macros/matchit.vim " enable matchit

" MUcomplete - auto complete {{{
set completeopt+=menuone " use the popup menu even if there is only one match
set completeopt+=noselect " do not select a match in the menu
set completeopt-=preview " don't show extra information in preview window
set shortmess+=c " disable completion messages"
let g:mucomplete#enable_auto_at_startup = 1 " enable at startup
let g:mucomplete#buffer_relative_paths = 1 " interpret paths relative to the directory of the current buffer

" custom completion methods
let g:mucomplete#user_mappings = {}
let g:mucomplete#user_mappings.sqla = "\<c-c>a"

" define conditions before a given method is tried
let g:mucomplete#can_complete = {}
let g:mucomplete#can_complete.sql = {
      \ 'sqla': { t -> strlen(&l:omnifunc) > 0 && t =~# '\%(\k\k\)$' }
      \ }

" complete chains
let g:mucomplete#chains = {}
let g:mucomplete#chains.default = [ 'path', 'ulti', 'c-n', 'tags', 'omni' ]
let g:mucomplete#chains.sql = [ 'path', 'c-n', 'sqla' ]
let g:mucomplete#chains.vim = [ 'path', 'cmd', 'omni', 'c-n' ]
" }}}

" hardtime - stop repeating the basic movement keys
let g:hardtime_default_on = 1 " on by default
let g:hardtime_maxcount = 2 " number of times before hardtime starts ignoring subsequent keypresses
let g:hardtime_allow_different_key = 1 " allow a key if it is different from the previous key
let g:hardtime_ignore_quickfix = 1 " allow in quickfix

" leaderF - fuzzy finder {{{
let g:Lf_WindowHeight = 0.2
let g:Lf_DefaultMode = 'NameOnly'
let g:Lf_HideHelp = 1
let g:Lf_StlSeparator = { 'left': '', 'right': '' }
let g:Lf_StlPalette = {
      \   'stlName': {
      \       'ctermfg': 'black',
      \       'ctermbg': 'darkblue'
      \   },
      \   'stlCategory': {
      \       'ctermfg': 'black',
      \       'ctermbg': 'green'
      \   },
      \   'stlNameOnlyMode': {
      \       'ctermfg': 'black',
      \       'ctermbg': 'blue'
      \   },
      \   'stlFullPathMode': {
      \       'ctermfg': 'black',
      \       'ctermbg': 'white'
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
      \       'ctermbg': 'blue'
      \   },
      \   'stlTotal': {
      \       'ctermfg': 'black',
      \       'ctermbg': 'green'
      \   }
      \ }
let g:Lf_WildIgnore = {
      \ 'dir': ['.git', 'node_modules'],
      \ 'file': ['*.swp', 'bundle.js', 'tags']
      \}
" }}}

" tagbar - browse tags from the current file
let g:tagbar_compact = 1 " hide help
let g:tagbar_show_linenumbers=2 " show relative line numbers
let g:tagbar_sort = 0 " sort based on order in source file

" ultisnips - snippets in Vim
let g:UltiSnipsExpandTrigger = "<f5>" " snippet expansion
let g:UltiSnipsListSnippets = "<f6>" " snippet list
let g:UltiSnipsJumpForwardTrigger = "<c-f>" " jump forward in snippet
let g:UltiSnipsJumpBackwardTrigger = "<c-b>" " jump back in snippet

" ranger - file explorer
let g:ranger_map_keys = 0 " disable default key mapping

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

set scrolloff=2 " number of screen lines to keep above and below the cursor

set spelllang=en_gb " set spelling language to English GB

set autoindent " always set autoindenting on

set wildmenu " enhanced autocomplete for command menu
" set wildmode=list:longest,full " tab completion options
set wildignore+=*.swp,*/node_modules/*,bundle.js,tags " exclude from wildmenu and vimgrep
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
set listchars=tab:·\ ,eol:· " set symbols for tabstops and EOLs

set foldmethod=indent " by default fold on indents
set foldnestmax=10 " sets the maximum nest level of folds
set nofoldenable " start with all folds open

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
" }}}
" }}}

" ### key mappings {{{

" map jk to exit, doesn't move cursor back
inoremap jk <esc>`^

" ultisnips snippets in mucomplete - select snippet and hit enter to expand
inoremap <silent> <expr> <cr> mucomplete#ultisnips#expand_snippet("\<cr>")

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

" launch LeaderF to navigate tags
nnoremap <leader>c :LeaderfTag<cr>

" open diff tab, see DiffWithSaved function below
nnoremap <leader>d :DiffOpen<cr>

" toggle file explorer
if (executable('ranger'))
  nnoremap <silent> <leader>e :Ranger<CR>
else
  nnoremap <silent> <expr> <leader>e match(expand('%:t'),'Netrw') == -1 ? ':Explore .<cr>' : ':Rexplore<cr>'
endif

" open git diff tab, see DiffWithGit function below
nnoremap <leader>gd :GitDiffOpen<cr>

" search files using grep, see GGrep function below
nnoremap <leader>gg :GGrep 

" open Gstatus
nnoremap <leader>gs :Gstatus<cr>

" search for the word under the cursor using GGrep
nnoremap <leader>gw :GGrep <c-r><c-w> . -rw<cr>

" search help and open in new tab
nnoremap <leader>h :tab help 

" scroll window downwards half a screen
nnoremap <leader>j <c-d>

" scroll window upwards half a screen
nnoremap <leader>k <c-u>

" show buffer list
nnoremap <silent> <leader>l :buffers<cr>

" toggle relative numbering
nnoremap <silent> <leader>n :setlocal relativenumber!<cr>

" toggle paste mode
nnoremap <silent> <leader>p :set paste!<cr>

" find/replace all on word under cursor
nnoremap <leader>r :%s/\<<c-r><c-w>\>\C//g<left><left>

" open Tagbar with autoclose set and disable vim HardTime
nnoremap <silent> <leader>tb :TagbarOpenAutoClose<cr>:HardTimeOff<cr>

" close tab
nnoremap <leader>tc :tabclose<cr>

" open new tab
nnoremap <leader>tn :tabnew<cr>

" close all other tabs
nnoremap <silent> <leader>to :tabonly<cr>

" open vim-rest-console in new tab
nnoremap <silent> <leader>tr :tabedit .vrc.rest<cr>

" toggle Undotree
nnoremap <silent> <leader>ut :UndotreeToggle<cr>

" insert uuid, see InsertUuid function below
nnoremap <silent> <leader>uu :InsertUuid<cr>

" search files using vimgrep, see VGrep function below
nnoremap <leader>vg :VGrep \C<left><left>

" search for the word under the cursor using VGrep
nnoremap <leader>vw :VGrep \<<c-r><c-w>\>\C<cr>

" same as <c-w>
nnoremap <leader>w <c-w>

" open current window in a new tab
nnoremap <leader>wt <c-w>T
" }}}
" }}}

" ### functions {{{

" diff the current buffer and original file {{{
" opens a new tab with a vertical split
" the left window shows the original saved file
" the right window shows the current buffer
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
" }}}

" run git diff against the current buffer {{{
" opens a new tab with a vertical split
" the left window shows the version in the index
" the right window shows the current buffer
function! s:DiffWithGit()
  if exists(':Gdiff')
    tabedit %
    Gvdiff
  else
    echo 'Gdiff not available'
  endif
endfunction
command! GitDiffOpen call s:DiffWithGit()
" }}}

" generate and insert a uuid {{{
" uses uuidgen to generate a uuid
" the uuid is saved to the 'u' register so it can be used again
" the content of the 'u' register is then put after the cursor
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

" search files using vimgrep {{{
" searches in pwd recursively by default
" if any matches are found the quickfix window is opened
function! s:VGrep(searchStr, ...)
  let path = a:0 >= 1 ? a:1 : '**'
  noautocmd execute 'vimgrep' '/'.a:searchStr.'/j' path
  if !empty(getqflist())
    copen
    exec "nnoremap <silent> <buffer> q :cclose<CR>"
  endif
endfunction
command! -nargs=* VGrep call s:VGrep(<f-args>)
" }}}

" search files using grep {{{
" similar to VGrep function above except using grep instead of vimgrep
function! s:GGrep(searchStr, ...)
  let path = a:0 >= 1 ? a:1 : '.'
  let flags = a:0 >= 2 ? a:2 : '-rF'
  let command = 'grep!'.
        \ ' --exclude-dir=.git --exclude-dir=node_modules'.
        \ ' --exclude="*.swp" --exclude=bundle.js --exclude=tags'
  silent execute command flags a:searchStr path
  redraw!
  if !empty(getqflist())
    copen
    exec "nnoremap <silent> <buffer> q :cclose<CR>"
  endif
endfunction
command! -nargs=* GGrep call s:GGrep(<f-args>)
" }}}

" Phplint {{{
" https://github.com/nrocco/vim-phplint
function! s:RunPhplint()
  let l:filename=@%
  let l:phplint_output=system('php -l '.l:filename)
  let l:phplint_list=split(l:phplint_output, "\n")
  if v:shell_error
    cexpr l:phplint_list[:-2]
    copen
    exec "nnoremap <silent> <buffer> q :cclose<CR>"
  else
    cclose
    echomsg l:phplint_list[0]
  endif
endfunction
command! Phplint call s:RunPhplint()
set errorformat+=%m\ in\ %f\ on\ line\ %l
" }}}
" }}}

" ### autocmds {{{

if has('autocmd')
  " misc {{{
  augroup misc
    " remove ALL autocommands for the current group
    autocmd!
    " enable spell checking for certain filetypes
    autocmd FileType markdown,html,text setlocal spell
    " disable automatic comment leader insertion, remove comment leader when joining lines
    autocmd FileType * setlocal formatoptions-=cro formatoptions+=j
    " clean up netrw hidden buffers
    autocmd FileType netrw setlocal bufhidden=wipe
    " enable cursorline highlighting and disable relativenumber in quickfix window
    autocmd FileType qf setlocal cursorline norelativenumber
    " highlight leading spaces with '·'
    autocmd FileType *
          \ syntax match LeadingSpace /\(^ *\)\@<= / containedin=ALL conceal cchar=· |
          \ setlocal conceallevel=2 concealcursor=nv |
          \ highlight Conceal ctermbg=NONE ctermfg=green guibg=NONE guifg=green
    " return to the last cursor position when opening files
    autocmd BufReadPost *
          \ if line("'\"") > 1 && line("'\"") <= line('$') |
          \ exe "normal! g'\"" |
          \ endif
  augroup END
  " }}}

  " folds {{{
  augroup folding
    autocmd!
    " set foldmethod to marker
    autocmd FileType vim
          \ setlocal foldmethod=marker foldenable
    " set foldmethod to syntax
    autocmd FileType ruby,javascript
          \ setlocal foldmethod=syntax foldenable
  augroup END
  " }}}

  " php {{{
  augroup php
    autocmd!
    " run Phplint function after write
    autocmd BufWritePost * if &filetype == "php"
        \ | silent call s:RunPhplint()
        \ | endif
    " start with folds closed
    autocmd FileType php setlocal foldenable
    " set comment string to // (replaces /*  */)
    autocmd FileType php setlocal commentstring=//\ %s
  augroup END
  " }}}
endif
" }}}
