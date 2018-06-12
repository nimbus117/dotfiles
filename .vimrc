" ### vundle plugin manager {{{

let new=0
let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme) 
	echo "Installing Vundle..."
	echo ""
	silent !mkdir -p ~/.vim/bundle
	silent !git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
	let new=1
endif
set nocompatible " required
filetype off     " required
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
" add plugins here
Plugin 'itchyny/lightline.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'mattn/emmet-vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'jiangmiao/auto-pairs'
if new == 1
	:PluginInstall
	echo "you may need to close and re-open vim"
endif
call vundle#end()
" vundle end
" }}}

" ### plugin settings {{{

" lightline status line
set laststatus=2 " always show status line"
set noshowmode " hide insert, replace or visual on last line
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ }
if !has('gui_running')
  set t_Co=256
endif
" lightline end

" netrw file explorer
let g:netrw_banner = 0 " hide the banner
let g:netrw_liststyle = 3 " tree mode
let g:netrw_list_hide = '.*\.swp$,\.orig$' " hide files
" netrw end
" }}}

" ### General Settings {{{

colorscheme solarized " load color scheme"
set background=dark " light/dark

syntax enable " enable syntax highlighting

filetype plugin indent on " enable filetype detection, plugins and indent settings

set number " Show line numbers

"set expandtab " insert space characters whenever the tab key is pressed
set tabstop=2 " number of visual spaces per TAB
set softtabstop=2 " number of spaces in TAB when editing
set shiftwidth=2 "Number of spaces to use for each step of (auto)indent

set cursorline " highlight current line

set wildmenu " visual autocomplete for command menu

set incsearch " search as characters are typed
set hlsearch " highlight all search matches

set spell spelllang=en_gb " enable spell check and set language to English GB

set hidden " causes buffers to be hidden instead of abandoned, allows changing buffer without saving

set history=200 " command line mode history

set list " show invisibles
set listchars=tab:│\ ,eol:∙ " set symbols for tabstops and EOLs
highlight SpecialKey ctermbg=NONE ctermfg=magenta " tab char colors
highlight NonText ctermbg=NONE ctermfg=darkmagenta " eol char colors

set wrap " wrap text
set linebreak " don't split words when wrapping text

set ignorecase " case insensitive search
set smartcase " enable case sensitive search when capitals are used

set foldmethod=indent " automatically fold on indents
set foldnestmax=10 " sets the maximum nest level of folds
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
nnoremap <Leader>j 10j

" move cursor up 10 lines
nnoremap <Leader>k 10k

" inserts a blank line below the current line
nnoremap <CR> o<ESC>k

" inserts a blank line above the current line
nnoremap <Leader><CR> O<ESC>j

" cycle between windows by pressing <Leader> key twice
nnoremap <Leader><Leader> <c-w><c-w>

" stop current search highlighting 
nnoremap <Leader>/ :nohlsearch<CR>

" toggle file explorer
nnoremap <Leader>e :20Lexplore<CR>

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

" open new tab
nnoremap <Leader>to :tabnew<CR>

" close tab
nnoremap <Leader>tc :tabclose<CR>

" see DiffWithSaved function below
nnoremap <Leader>d :DiffOpen<CR>
" }}}

" ### functions {{{

" diff the current buffer and original file
"   opens a new tab with a vertical split
"   the left window shows the original saved file
"   the right window shows the current buffer
function! s:DiffWithSaved()
	let filetype=&ft
	tabedit %
	diffthis
	vnew | r # | normal! 1Gdd
	diffthis
	execute "setlocal bt=nofile bh=wipe nobl noswf ro ft=" . filetype
	setlocal nocursorline
	execute "normal \<c-w>l"
endfunction
command! DiffOpen call s:DiffWithSaved()
" }}}

" ### autocmds {{{

augroup BufReadPost_AllFiles
	" remove ALL autocommands for the current group
	autocmd!
	" return to last edit position when opening files
	autocmd BufReadPost * if line("'\"") > 1 && line("'\"") <= line("$") | exe "normal! g'\"" | endif
augroup END


augroup filetype_vim
	autocmd!
	" set foldmethod to marker when editing vim files
	autocmd FileType vim setlocal foldmethod=marker
	" start with all folds closed
	autocmd FileType vim setlocal foldenable
augroup END
" }}}
