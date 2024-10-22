## before oh-my-zsh {{{

# brew autocomplete
if [[ $OSTYPE == 'darwin'* ]] && command -v brew >/dev/null; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi
#}}}

## oh-my-zsh {{{

# path to your oh-my-zsh installation
export ZSH=~/.oh-my-zsh

# Set theme
ZSH_THEME="nimbus117"

# plugins
plugins=(
  aws
  docker
  docker-compose
  git
  history
  npm
  nvm
  vi-mode
  z
)

source $ZSH/oh-my-zsh.sh
#}}}

## environment variables {{{

# set default editor
export VISUAL=vim
export EDITOR=vim

# don't show % at the end of partial lines
export PROMPT_EOL_MARK=""

# set less options
# i - case insensitive search (unless pattern contains capital)
# R - enable coloured output
# S - don't wrap lines
# c - clear-screen - Causes full screen repaints to be painted from the top line down
export LESS=iRSc

# fix less highlighting on mac
export LESS_TERMCAP_so=$'\E[30;43m'
export LESS_TERMCAP_se=$'\E[39;49m'

# history settings
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE

# bat (cat replacement) color scheme
export BAT_THEME='Solarized (dark)'
#}}}

## aliases {{{

# properly clears the terminal
alias cls='tput reset'

# list directories
alias l='ls -lh --group-directories-first'
alias ll='ls -lAh --group-directories-first'

# notes function
alias n='notes'

# exit
alias :q='exit'

# screen aliases
alias sl='screenPicker'
alias sn='screen'
alias sv='screenVim'

# always turn colorization on
alias tree='tree -C'

# ranger file explorer
if command -v ranger >/dev/null; then
  alias r='source ranger'
fi

# bat (cat replacement)
if command -v bat >/dev/null; then
  alias cat='bat'
elif command -v batcat >/dev/null; then
  alias cat='batcat'
fi

# http server in current directory (default port 8000)
if command -v python3 >/dev/null; then
  alias serve='python3 -m http.server'
fi

# open snippets file in vim
if [ -f $HOME/code/dotfiles/snippets/snippets.md ]; then
  alias snip="vim $HOME/code/dotfiles/snippets/snippets.md"
fi

# replace ls with gls if installed
if command -v gls >/dev/null; then
  alias ls="gls --color"
fi

# replace dircolors with gdircolors if installed
if command -v gdircolors >/dev/null; then
  alias dircolors="gdircolors"
fi

# replace sed with gsed if installed
if command -v gsed >/dev/null; then
  alias sed="gsed"
fi
#}}}

## functions {{{

# get the weather
weather() { curl -s 'wttr.in/'${1:-'edinburgh'} | less }

# cheat.sh
cheat() { curl -s "https://cheat.sh/"$1 | less }

# load environment variables for ssh-agent and add ssh pass
sshadd() { eval $(ssh-agent); ssh-add }

# launch screen with .screenVim config file {{{
# ( source .screenrc then open vim )
screenVim() {
  if [ -f $HOME/code/dotfiles/screen/.screenrcVim ]; then
    screen -c $HOME/code/dotfiles/screen/.screenrcVim $*
  else
    screen $*
  fi
}
#}}}

# pick screen session to reconnect to {{{
screenPicker() {
  list=$(screen -ls | sed '1d;$d')
  count=$(echo -n "$list" | grep -c '^')
  if [ $count -gt 0 ]; then
    counter=1
    sessions=
    echo $list | while read line; do
      sessions+="$counter. $line\n"
      (( counter+=1 ))
    done
    echo $sessions | column -t
    echo -n 'Enter number: '
    read num
    if [ $num -gt 0 2> /dev/null ] && [ $num -le $count ]; then
      screen -d -r $(echo $list | sed -n ${num}'p' | awk '{print $1}')
    else
      echo "\nInvalid selection - please enter a number from 1 to $count\n"
      screenPicker
    fi
  else
    echo "No screen sessions"
  fi
}
#}}}

# open notes in vim {{{
notesRoot=$HOME/notes
notes() {
  if [ -d $notesRoot ]; then
    if [ -z "$1" ]; then
      1=notes
    fi
    vim $notesRoot/$1.md -c "cd $notesRoot"
  else
    echo "create directory $notesRoot"
  fi
}

# autocomplete for above notes function
function _notes(){
  if [ -d $notesRoot ]; then
    local state 
    _arguments '1:notes:->notesRoot'
    case $state in
      notesRoot)
        _describe 'notes' "($((cd $notesRoot && ls *.md) | sed 's/\.md$//'))"
        ;;
    esac
  fi
}
compdef _notes notes
#}}}

# run a command in the background {{{
background() {
  nohup $* &>/dev/null &
}
#}}}

# make a folder and cd into it {{{
function mk(){
  mkdir -p $1
  cd $1
}
#}}}
#}}}

## key bindings {{{

# enter normal mode in zsh vi-mode
bindkey "jk" vi-cmd-mode

# make ctrl-p/n behave like up/down arrows
bindkey "^P" up-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search

# set shift-tab to reverse select menus
bindkey -M menuselect '^[[Z' reverse-menu-complete

# edit current command line in $EDITOR
bindkey -M vicmd "^V" edit-command-line
#}}}

## misc {{{

# set colours for ls
if [ -f $HOME/.dircolors ]; then
  eval $(dircolors $HOME/.dircolors)
fi

# awscli auto completion
if [ -f  /usr/local/bin/aws_zsh_completer.sh ]; then
  source /usr/local/bin/aws_zsh_completer.sh
fi
#}}}
