# Path to your oh-my-zsh installation.
  export ZSH=~/.oh-my-zsh

# Set name of the theme to load.
if [ "$(uname 2> /dev/null)" != "Linux"  ]; then
  ZSH_THEME="agnoster"
  DEFAULT_USER=`whoami`
else
  ZSH_THEME="mySimple"
fi

# DISABLE_AUTO_TITLE="true"

# plugins
plugins=(
  git
  colored-man-pages
  rvm
)

source $ZSH/oh-my-zsh.sh

## aliases

# 'cls' properly clears the terminal
alias cls='tput reset'

# 'h' shows history
alias h='history'

# 'hs' to search history
alias hs='history | grep -i'

# 'rb' = ruby
alias rb='ruby'

## functions

# get the weather
weather() {
  if [ $# -eq 0  ]
  then
    curl 'wttr.in/unitedkindom+edinburgh'
  else
    curl 'wttr.in/'$1
  fi
}

# dictionary lookup
dict() {
  if [ $# -eq 0  ]
  then
    echo 'no word given'
  else
    curl -s "dict://dict.org/d:"$1 | tail -n+3 | less
    #curl -s "dict://dict.org/d:"$1 | tail -n+3 | head -n -2| less
  fi
}

# cheat.sh
cheat() {
  curl -s "https://cheat.sh/"$1 | less
}

# open google search for the given args
google() {
  searchStr=
  for i in "$@"; do
    searchStr="$searchStr+$i"
  done
  url="https://www.google.co.uk/search?q="$searchStr
  if [[ $OSTYPE == "linux-gnu" ]]
  then
    xdg-open $url >> /dev/null
  elif [[ $OSTYPE == "darwin"* ]]
  then
    open $url
  fi
}

## environment variables

# home page for w3m browser
export WWW_HOME='www.google.com'

# set default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# from codeclan mac setup script, not sure why??
if [ -d  "$HOME/.bin" ]
then
  export PATH="$HOME/.bin:$PATH"
fi

# recommended by brew doctor
if command -v brew >/dev/null
then
  export PATH="/usr/local/bin:$PATH"
fi

# Add RVM to PATH for scripting. Make sure this is the last PATH variable change.
if [ -d  $HOME/.rvm/bin ]
then
  export PATH="$PATH:$HOME/.rvm/bin"
fi

## misc

# load rbenv
if command -v rbenv >/dev/null
then
  eval "$(rbenv init - --no-rehash)"
fi

