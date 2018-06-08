" ### Setting up Vundle
let notNew=1
let vundle_readme=expand('~/.vim/bundle/Vundle.vim/README.md')
if !filereadable(vundle_readme) 
	echo "Installing Vundle.."
	echo ""
	silent !mkdir -p ~/.vim/bundle
	silent !git clone https://github.com/VundleVim/Vundle.vim ~/.vim/bundle/Vundle.vim
	let notNew=0
endif
set nocompatible " be iMproved, required
filetype off     " required
set rtp+=~/.vim/bundle/Vundle.vim/
call vundle#begin()
Plugin 'VundleVim/Vundle.vim'
"Add bundles here
Plugin 'itchyny/lightline.vim'
Plugin 'altercation/vim-colors-solarized'
Plugin 'mattn/emmet-vim'
Plugin 'jelera/vim-javascript-syntax'
Plugin 'jiangmiao/auto-pairs'
if notNew == 0
	echo "Installing Vundles, please ignore key map error messages"
	echo ""
	:PluginInstall
endif
call vundle#end() 
"must be last
filetype plugin indent on " load filetype plugins/indent settings
" Vundle end

" colour scheme
colorscheme solarized
set background=dark
" colour scheme end

" lightline
set laststatus=2
let g:lightline = {
      \ 'colorscheme': 'solarized',
      \ }
if !has('gui_running')
  set t_Co=256
endif
set noshowmode " Hide Insert, Replace or Visual on last line
" lightline end

" netrw file explorer
let g:netrw_banner = 0 " hide the banner
let g:netrw_liststyle = 3 " tree mode
" netrw end

" ### General Settings

syntax enable " enable syntax highlighting

set number " Show line numbers

"set expandtab " insert space characters whenever the tab key is pressed
set tabstop=2 " number of visual spaces per TAB
set softtabstop=2 " number of spaces in TAB when editing
set shiftwidth=2 "Number of spaces to use for each step of (auto)indent

set cursorline " highlight current line

set wildmenu " visual autocomplete for command menu

set incsearch " search as characters are typed

set spell spelllang=en_gb " enable spell check and set language to English GB

set hidden " causes files to be hidden instead of closed

set history=200 " command line mode history

set list " show invisibles
set listchars=tab:│\ ,eol:∙ " set symbols for tabstops and EOLs
highlight SpecialKey ctermbg=NONE ctermfg=magenta " tab char colors
highlight NonText ctermbg=NONE ctermfg=darkmagenta " eol char colors

set wrap " wrap text
set linebreak " don't split words when wrapping text

set ignorecase " case insensitive search
set smartcase " enable case sensitive search when capitals are used

" ### Mappings

" remap jk/kj to exit
inoremap kj <Esc>`^
inoremap jk <Esc>`^

" use gj/gk for moving up and down unless a number is given
" allows normal movement through soft wrapped lines
nnoremap <expr> j v:count ? 'j' : 'gj'
nnoremap <expr> k v:count ? 'k' : 'gk'
" https://www.reddit.com/r/vim/comments/2k4cbr/problem_with_gj_and_gk/
