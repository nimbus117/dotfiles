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
)

source $ZSH/oh-my-zsh.sh
#}}}

## aliases {{{

# properly clears the terminal
alias cls='tput reset'

# open snippets file in vim
if [ -f $HOME/code/dotfiles/snippets/snippets.md ]; then
  alias snip="vim $HOME/code/dotfiles/snippets/snippets.md"
fi

# launch screen and open vim in the first window
# or pick an active screen session to reconnect to
alias s='screenPicker'

# http server in current directory (default port 8000)
alias serve="python3 -m http.server"

# turn tree colorization on always
alias tree="tree -C"

# launch node debug
alias nd="node --inspect-brk"
#}}}

## functions {{{

# get the weather
weather() { curl 'wttr.in/'$1 }

# cheat.sh
cheat() { curl -s "https://cheat.sh/"$1 | less }

# load environment variables for ssh-agent and add ssh pass
sshadd() { eval `ssh-agent`; ssh-add }

# open papertrail logs in lnav/less {{{
if command -v papertrail >/dev/null; then
  if command -v lnav >/dev/null; then
    ptf() { papertrail --follow --delay 5 $* | lnav; }
    pt() { papertrail $* | lnav; }
  else
    ptf() { LESS=IRSXN bash -c "papertrail --force-color --follow --delay 5 $* | less +F" }
    pt() { LESS=IRSXN bash -c "papertrail --force-color $* | less +F" }
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
  if [[ $OSTYPE == 'linux-gnu' ]]; then
    xdg-open $url >> /dev/null
  elif [[ $OSTYPE == 'darwin'* ]]; then
    open $url
  fi
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
  screens=`screen -ls | sed '1d;$d'`
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
      screen -d -r `echo $screens | sed -n ${num}'p' | awk '{print $1}'`
    else
      echo "Invalid selection - please enter a number from 0 to $count"
      screenPicker
    fi
  fi
}
#}}}

# get dad joke {{{
joke() {
  joke=`curl -s https://icanhazdadjoke.com/`
  if command -v cowsay >/dev/null && command -v lolcat >/dev/null; then
    cowFile=`cowsay -l | sed "1d" | tr " " "\n" | sort --random-sort | sed 1q`
    echo $joke | cowsay -w -f ${cowFile} | lolcat -a -s 320 -d 6
    echo ""
  else
    echo $joke
  fi
}
#}}}

# dev environment {{{
if [ -f $HOME/code/dotfiles/screen/.screenrcApp ]; then
  devup() { screen -S devenv -c $HOME/code/dotfiles/screen/.screenrcApp }
  devdown() { stopMampApache; pkill node; screen -X quit }
fi
#}}}

# MAMP {{{
startMampApache() { sudo /Applications/MAMP/bin/startApache.sh }

stopMampApache() { sudo /Applications/MAMP/bin/stopApache.sh }
#}}}
#}}}

# environment variables {{{

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
  export PATH=$PATH:/Applications/MAMP/bin/php/php7.0.33/bin
fi

if [ -d  $HOME/.rbenv/bin ]; then
  export PATH=$HOME/.rbenv/bin:$PATH
fi
#}}}

## misc {{{

# load rbenv
if command -v rbenv >/dev/null; then
  eval `rbenv init - --no-rehash`
fi

# required for tilix
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi

# if dircolors, set colour for ls
if [ -f $HOME/.dircolors ]; then
  eval `dircolors $HOME/.dircolors`
fi

# awscli auto completion
if [ -f  $HOME/.local/bin/aws_zsh_completer.sh ]; then
  source  $HOME/.local/bin/aws_zsh_completer.sh
fi

# enter normal mode in zsh vi-mode
bindkey "jk" vi-cmd-mode

# make ctrl-p.n behave like up/down arrows
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search

# stop ctrl-s from freezing the terminal
stty -ixon
#}}}

## mac specific {{{

if [[ $OSTYPE == 'darwin'* ]]; then
  export TERM="screen-256color"
  export LESS_TERMCAP_so=$'\E[30;43m'
  export LESS_TERMCAP_se=$'\E[39;49m'
fi
#}}}
