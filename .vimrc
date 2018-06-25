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
Plugin 'itchyny/lightline.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'mattn/emmet-vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'jiangmiao/auto-pairs'
Plugin 'tpope/vim-fugitive.git'
call vundle#end()
if new == 1
	:PluginInstall
	echo 'you may need to close and re-open vim'
endif
" }}}

" ### plugin settings {{{

" lightline status line
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

" netrw file explorer
let g:netrw_banner = 0 " hide the banner
let g:netrw_liststyle = 3 " tree mode
let g:netrw_list_hide = '.*\.swp$,\.orig$' " hide files
" }}}

" ### General Settings {{{

set encoding=utf-8 " set character encoding

syntax enable " enable syntax highlighting

filetype plugin indent on " enable filetype detection, plugins and indent settings

set lazyredraw " stops the screen being redrawn during some operations, better performance

set ttyfast " fast terminal connection, smooth!

set hidden " causes buffers to be hidden instead of abandoned, allows changing buffer without saving

set spell spelllang=en_gb " enable spell check and set language to English GB

set history=200 " command line mode history

set wildmenu " enhanced autocomplete for command menu

set showcmd " Show (partial) command in the last line of the screen

set backspace=2 " allow backspace over indent, eol, start

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

" move cursor down 10 lines
nnoremap <Leader>j 20j

" move cursor up 10 lines
nnoremap <Leader>k 20k

" inserts a blank line below the current line
nnoremap <CR> o<ESC>k

" inserts a blank line above the current line
nnoremap <Leader><CR> O<ESC>j

" stop current search highlighting
nnoremap <Leader>/ :nohlsearch<CR>

" toggle file explorer
"nnoremap <Leader>e :20Lexplore<CR>
"nnoremap <Leader>e :Rexplore<CR>
nnoremap <expr> <leader>e match(expand('%:t'),'Netrw') == -1 ? ':Explore<CR>' : ':Rexplore<CR>'
"nnoremap <expr> <leader>e match(expand('%:t'),'Netrw') == -1 ? ':edit.<CR>' : ':Rexplore<CR>'
"nnoremap <expr> <leader>e match(expand('%:t'),'Netrw') == -1 ? ':edit.<CR>' : '<c-^>'
"nnoremap <expr> <leader>e exists(':Rexplore') ? ':Rexplore<CR>' : ':Explore<CR>'

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

" open a split with file explorer
nnoremap <Leader>s :split.<CR>

" open a vertical split with file explorer
nnoremap <Leader>v :vsplit.<CR>

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
	augroup vimrc
		" remove ALL autocommands for the current group
		autocmd!

		" return to the last cursor position when opening files
		autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line('$') | exe "normal! g'\"" | endif

		" disable automatic comment leader insertion
		autocmd FileType * setlocal formatoptions-=c formatoptions-=r formatoptions-=o

		" set foldmethod to marker when editing vim files
		autocmd FileType vim setlocal foldmethod=marker
		" start with all folds closed
		autocmd FileType vim setlocal foldenable

		" auto-clean fugitive buffers
		autocmd BufReadPost fugitive://* set bufhidden=delete
	augroup END
endif
" }}}
