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
Plugin 'JulesWang/css.vim'
Plugin 'lifepillar/vim-mucomplete'
Plugin 'mattn/emmet-vim'
Plugin 'nelstrom/vim-visual-star-search'
Plugin 'pangloss/vim-javascript'
Plugin 'tpope/vim-fugitive.git'
Plugin 'tpope/vim-surround'
Plugin 'tpope/vim-commentary'
call vundle#end()
if new == 1
	:PluginInstall
	echo 'you may need to close and re-open vim'
endif
" }}}

" ### plugin settings {{{

" lightline - status line
set laststatus=2 " always show status line"
set noshowmode " hide insert, replace or visual on last line
let g:lightline = {
	\ 'colorscheme': 'solarized',
	\ 'active': {
		\ 'left': [ [ 'mode', 'paste'  ],
		\         [ 'gitbranch', 'readonly', 'filename', 'modified'  ] ]
		\ },
	\ 'component_function': {
		\   'gitbranch': 'fugitive#head'
		\ }
	\ }
if !has('gui_running')
	set t_Co=256
endif

" netrw - file explorer
let g:netrw_banner = 0 " hide the banner
let g:netrw_liststyle = 3 " tree mode
let g:netrw_list_hide = netrw_gitignore#Hide() " hide files (automatically hides all git-ignored files)"

" matchit - extended matching with %
runtime macros/matchit.vim " enable matchit

" Emmet - expand html/css abbreviations
let g:user_emmet_install_global = 0 " disable globally (enable for html/ css in autocmd)

" MUcomplete - auto complete
set completeopt+=menuone " use the popup menu even if there is only one match
set completeopt+=noselect " do not select a match in the menu
set shortmess+=c " disable completion messages"
let g:mucomplete#enable_auto_at_startup = 1 " enable at startup
let g:mucomplete#chains = {
	\ 'default' : ['path', 'omni', 'keyn', 'c-n']
	\ }
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

set display+=lastline " show as much as possible of the last line

colorscheme solarized " load color scheme
set background=dark " light/dark
highlight Normal ctermbg=NONE " transparent background

set number " Show line numbers
set numberwidth=3 " set number column to start at 3
set nowrap " don't wrap text
set linebreak " don't split words when wrapping text
set cursorline " highlight current line
set scrolloff=2 " number of screen lines to keep above and below the cursor

"set expandtab " insert space characters whenever the tab key is pressed
set tabstop=2 " number of visual spaces per TAB
set softtabstop=2 " number of spaces in TAB when editing
set shiftwidth=2 "Number of spaces to use for each step of (auto)indent

set autoindent " always set autoindenting on
set smartindent " smart autoindenting when no indent file

set incsearch " search as characters are typed
set hlsearch " highlight all search matches
set ignorecase " case insensitive search
set smartcase " enable case sensitive search when capitals are used

set list " show invisibles
set listchars=tab:│\ ,eol:∙ " set symbols for tabstops and EOLs
highlight SpecialKey ctermbg=NONE ctermfg=magenta guibg=NONE guifg=magenta " tab char colors
highlight NonText ctermbg=NONE ctermfg=darkmagenta guibg=NONE guifg=darkmagenta " eol char colors

set foldmethod=indent " automatically fold on indents
set foldnestmax=3 " sets the maximum nest level of folds
set nofoldenable " start with all folds open
" }}}

" ### key mappings {{{

" set <Leader> key to space bar
nnoremap <SPACE> <Nop>
let mapleader = "\<Space>"

" map jk/kj to exit, doesn't move cursor back
inoremap kj <Esc>`^
inoremap jk <Esc>`^

" use gj/gk for moving up and down unless a number is given
" allows normal movement through soft wrapped lines
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'

" use arrow keys to resize windows
"nnoremap <Up> :resize +2<CR>
"nnoremap <Down> :resize -2<CR>
"nnoremap <Left> :vertical resize +2<CR>
"nnoremap <Right> :vertical resize -2<CR>

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

" go to next buffer
nnoremap <Leader>n :bnext<CR>

" go to previous buffer
nnoremap <Leader>p :bprevious<CR>

" go to alternate buffer
nnoremap <Leader>a :buffer #<CR>

" cycle between windows by pressing <Leader> key twice
nnoremap <Leader><Leader> <c-w>w

" same as <c-w>
nnoremap <Leader>w <c-w>

" open current window in a new tab
nnoremap <Leader>wt <c-w>T

" open a split
nnoremap <Leader>s :split<CR>

" open a vertical split
nnoremap <Leader>v :vsplit<CR>

" open new tab
nnoremap <Leader>to :tabnew<CR>

" close tab
nnoremap <Leader>tc :tabclose<CR>

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
		" disable automatic comment leader insertion
		autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o formatoptions+=j
		" auto-clean fugitive buffers
		autocmd BufReadPost fugitive://* set bufhidden=delete
		" highlight leading spaces
		autocmd BufWinEnter,BufReadPre * setlocal conceallevel=2 concealcursor=nv
		autocmd BufWinEnter * syntax match LeadingSpace /\(^ *\)\@<= / containedin=ALL conceal cchar=·
	augroup END

	augroup vim
		autocmd!
		" set foldmethod to marker when editing
		autocmd FileType vim setlocal foldmethod=marker
		" start with all folds closed
		autocmd FileType vim setlocal foldenable
	augroup END

	augroup ruby
		autocmd!
		" tab key inserts two space characters
		autocmd FileType ruby set expandtab
		autocmd FileType ruby set tabstop=2
		autocmd FileType ruby set softtabstop=2
		autocmd FileType ruby set shiftwidth=2
	augroup END

	augroup htmlCss
		autocmd!
		" enable emmet and use tab key as the abbreviation expander
		autocmd FileType html,css
			\ EmmetInstall |
			\ imap <buffer> <expr> <tab> emmet#expandAbbrIntelligent("\<tab>")
		" disable MUcomplete auto enabled at startup
		autocmd FileType html,css let g:mucomplete#enable_auto_at_startup = 0
	augroup END
endif
" }}}
