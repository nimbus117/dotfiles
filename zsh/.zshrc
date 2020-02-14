## oh-my-zsh {{{

# Path to your oh-my-zsh installation
export ZSH=~/.oh-my-zsh

# Set theme
ZSH_THEME="mySimple"

# plugins
plugins=(
  git
  history
  npm
  npx
  nvm
  vi-mode
  z
)

source $ZSH/oh-my-zsh.sh
#}}}

## aliases {{{

# properly clears the terminal
alias cls='tput reset'

# list directories
alias l='ls -lh --group-directories-first'
alias ll='ls -lAh --group-directories-first'

# notes function
alias n='notes'

# launch node debug
if [[ $HOST == 'penguin'* ]]; then
  alias nd='node --inspect-brk=0.0.0.0'
else
  alias nd='node --inspect-brk'
fi

# open
if command -v xdg-open >/dev/null; then
  alias open='xdg-open >/dev/null 2>&1'
fi

# ranger file explorer
if command -v ranger >/dev/null; then
  alias r='source ranger'
fi

# http server in current directory (default port 8000)
alias serve='python3 -m http.server'

# open snippets file in vim
alias snip="vim $HOME/code/dotfiles/snippets/snippets.md"

# always turn colorization on
alias tree='tree -C'

# screen aliases
alias s='screenPicker'
alias sl='screen -ls'
alias sn='screen'
alias sv='screenVim'
#}}}

## functions {{{

# get the weather
weather() { curl 'wttr.in/'$1 }

# cheat.sh
cheat() { curl -s "https://cheat.sh/"$1 | less }

# load environment variables for ssh-agent and add ssh pass
sshadd() { eval $(ssh-agent); ssh-add }

# papertrail functions {{{
if command -v papertrail >/dev/null; then
  if command -v lnav >/dev/null; then
    ptf() { papertrail --follow --delay 5 $* | lnav; }
    pt() { papertrail $* | lnav; }
  fi

  if command -v jq >/dev/null; then
    ptj() { papertrail $* | cut -d' ' -f'7-' | jq }
  fi
fi
#}}}

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
    screen -c $HOME/code/dotfiles/screen/.screenrcVim
  else
    screen
  fi
}
#}}}

# pick screen session to reconnect to or launch a new one {{{
screenPicker() {
  screens=$(screen -ls | sed '1d;$d')
  count=$(echo -n "$screens" | grep -c '^')
  if [ $count -eq 0 ]; then; screenVim
  else
    counter=1
    sessions=
    echo $screens | while read line; do
      sessions+="$counter. $line\n"
      (( counter+=1 ))
    done
    echo '0.  New session'
    echo $sessions | column -t
    echo -n 'Enter number: '
    read num
    if [ $num -eq 0 2> /dev/null ]; then; screenVim
    elif [ $num -gt 0 2> /dev/null ] && [ $num -le $count ]; then
      screen -d -r $(echo $screens | sed -n ${num}'p' | awk '{print $1}')
    else
      echo "\nInvalid selection - please enter a number from 0 to $count\n"
      screenPicker
    fi
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

# dev environment {{{
if [ -f $HOME/code/dotfiles/screen/.screenrcApp ] && [ -d /Applications/MAMP/bin  ]; then
  startMampApache() { sudo /Applications/MAMP/bin/startApache.sh }
  stopMampApache() { sudo /Applications/MAMP/bin/stopApache.sh }

  sessionName=devenv
  devup() { screen -S $sessionName -c $HOME/code/dotfiles/screen/.screenrcApp -d -RR }
  devdown() { stopMampApache; pkill node; screen -S $sessionName -X quit }
fi
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
        _describe 'notes' "($(ls $notesRoot | sed 's/\.md$//g'))"
        ;;
    esac
  fi
}
compdef _notes notes
#}}}
#}}}

## environment variables {{{

# set default editor
export VISUAL=vim
export EDITOR=$VISUAL

# set less options
# I - case insensitive search, R - enable coloured output, S - don't wrap lines
# F - quit if output fits in one screen, X - don't clear the screen on exit
if command -v less >/dev/null; then
  export LESS=IRSFX
fi
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

if [ -d  /Applications/MAMP/Library/bin ]; then
  export PATH=$PATH:/Applications/MAMP/Library/bin
fi

if [ -d  '/Applications/MAMP/bin/php/php7.0.33/bin' ]; then
  export PATH=/Applications/MAMP/bin/php/php7.0.33/bin:$PATH
fi
#}}}

## misc {{{

# required for tilix
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi

# if dircolors, set colour for ls
if [ -f $HOME/.dircolors ]; then
  eval $(dircolors $HOME/.dircolors)
fi

# awscli auto completion
if [ -f  /usr/local/bin/aws_zsh_completer.sh ]; then
  source /usr/local/bin/aws_zsh_completer.sh
fi

# enter normal mode in zsh vi-mode
bindkey "jk" vi-cmd-mode

# make ctrl-p.n behave like up/down arrows
bindkey "^P" up-line-or-beginning-search
bindkey "^N" down-line-or-beginning-search

# set shift-tab to reverse select menus
bindkey -M menuselect '^[[Z' reverse-menu-complete

# don't show % at the end of partial lines
export PROMPT_EOL_MARK=""
#}}}

## mac specific {{{

if [[ $OSTYPE == 'darwin'* ]]; then
  export TERM="screen-256color"
  export LESS_TERMCAP_so=$'\E[30;43m'
  export LESS_TERMCAP_se=$'\E[39;49m'
  if command -v gls >/dev/null; then
    alias ls="gls --color"
  fi
fi
#}}}
