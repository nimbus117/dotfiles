# before oh-my-zsh {{{

if [[ $OSTYPE == 'darwin'* ]]; then
  FPATH="$(brew --prefix)/share/zsh/site-functions:${FPATH}"
fi
#}}}

## oh-my-zsh {{{

# Path to your oh-my-zsh installation
export ZSH=~/.oh-my-zsh

# Set theme
ZSH_THEME="mySimple"

# plugins
plugins=(
  aws
  docker
  docker-compose
  git
  history
  npm
  nvm
  ripgrep
  vi-mode
  z
)

source $ZSH/oh-my-zsh.sh
#}}}

## mac specific {{{

if [[ $OSTYPE == 'darwin'* ]]; then
  export LESS_TERMCAP_so=$'\E[30;43m'
  export LESS_TERMCAP_se=$'\E[39;49m'

  if command -v gls >/dev/null; then
    alias ls="gls --color"
  fi

  if command -v gsed >/dev/null; then
    PATH="/opt/homebrew/opt/gnu-sed/libexec/gnubin:$PATH"
  fi

  if command -v gdircolors >/dev/null; then
    alias dircolors="gdircolors"
  fi

  if [ -d  /opt/homebrew/opt/mongodb-community@4.4/bin ]; then
    export PATH=/opt/homebrew/opt/mongodb-community@4.4/bin:$PATH
  fi

  if [ -d  /opt/homebrew/opt/php@7.4/bin ]; then
    export export PATH=/opt/homebrew/opt/php@7.4/bin:$PATH
    export export PATH=/opt/homebrew/opt/php@7.4/sbin:$PATH
  fi

  # work {{{
  if command -v papertrail >/dev/null; then
    ptf() { papertrail --follow --delay 5 $* }
    pt() { papertrail $* }
  fi

  if [ -f $HOME/code/dotfiles/screen/.screenrcApp ]; then
    startDevServices() {
      brew services start mongodb/brew/mongodb-community@4.4;
      brew services start httpd
    }
    stopDevServices() {
      brew services stop mongodb/brew/mongodb-community@4.4;
      brew services stop httpd
    }

    sessionName=devenv
    devup() { screen -S $sessionName -c $HOME/code/dotfiles/screen/.screenrcApp -d -RR }
    devdown() { stopDevServices; screen -S $sessionName -X quit }
  fi

  alias gpt1='git push origin "$(git symbolic-ref --short HEAD)":t1 --force'
  alias gpt2='git push origin "$(git symbolic-ref --short HEAD)":t2 --force'
  #}}}
fi
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
if command -v less >/dev/null; then
  export LESS=iRSc
fi

# history settings
export HISTFILE="$HOME/.zsh_history"
export HISTSIZE=100000
export SAVEHIST=$HISTSIZE
#}}}

## path {{{

if [ -d  $HOME/.bin ]; then
  export PATH=$HOME/.bin:$PATH
fi

if [ -d  $HOME/.local/bin/ ]; then
  export PATH=$HOME/.local/bin:$PATH
fi

if [ -d  $HOME/.config/composer/vendor/bin ]; then
  export PATH=$PATH:$HOME/.config/composer/vendor/bin
fi
#}}}

## aliases {{{

# properly clears the terminal
alias cls='tput reset'

# list directories
alias l='ls -lh --group-directories-first'
alias ll='ls -lAh --group-directories-first'

# notes function
alias n='notes'

# open
if command -v xdg-open >/dev/null; then
  alias open='xdg-open >/dev/null 2>&1'
fi

# ranger file explorer
if command -v ranger >/dev/null; then
  alias r='source ranger'
fi

# http server in current directory (default port 8000)
if command -v python3 >/dev/null; then
  alias serve='python3 -m http.server'
fi

# open snippets file in vim
if [ -f  $HOME/code/dotfiles/snippets/snippets.md ]; then
  alias snip="vim $HOME/code/dotfiles/snippets/snippets.md"
fi

# always turn colorization on
alias tree='tree -C'

# screen aliases
alias sl='screenPicker'
alias sn='screen'
alias sv='screenVim'

# exit
alias :q='exit'
#}}}

## functions {{{

# get the weather
weather() { curl -s 'wttr.in/'${1:-'edinburgh'} | less }

# cheat.sh
cheat() { curl -s "https://cheat.sh/"$1 | less }

# load environment variables for ssh-agent and add ssh pass
sshadd() { eval $(ssh-agent); ssh-add }

# open google search for the given args {{{
google() {
  searchStr=
  for i in "$@"; do
    searchStr="$searchStr+$i"
  done
  url="https://www.google.co.uk/search?q=$searchStr"
  open $url
}
#}}}

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

# get dad joke {{{
joke() {
  joke=$(curl -s https://icanhazdadjoke.com/)
  if command -v cowsay >/dev/null && command -v lolcat >/dev/null; then
    cowFile=$(cowsay -l | sed "1d" | tr " " "\n" | sort --random-sort | sed 1q)
    echo $joke | cowsay -w -f ${cowFile} | lolcat -a -s 320 -d 6
    echo ""
  else
    echo $joke
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

## misc {{{

# set colours for ls
if [ -f $HOME/.dircolors ]; then
  eval $(dircolors $HOME/.dircolors)
fi

# awscli auto completion
if [ -f  /usr/local/bin/aws_zsh_completer.sh ]; then
  source /usr/local/bin/aws_zsh_completer.sh
fi

# vi mode indicator
function zle-line-init zle-keymap-select {
  RPS1=${${KEYMAP/vicmd/%{$fg[red]%}<<<}/(main|viins)/%{$fg[green]%}}%{$reset_color%}
  RPS2=$RPS1
  zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

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
