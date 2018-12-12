# Path to your oh-my-zsh installation
  export ZSH=~/.oh-my-zsh

# Set theme
ZSH_THEME="mySimple"

# DISABLE_AUTO_TITLE="true"

# plugins
plugins=(
  git
  colored-man-pages
  history
  cp
  ufw
)

source $ZSH/oh-my-zsh.sh

## aliases

# properly clears the terminal
alias cls='tput reset'

# keep current directory when exiting ranger file explorer
alias r='source ranger'

# screen
alias sc='screen'

# screen -ls
alias sl='screen -ls'

# screen/vim
alias sv='screen -c '$HOME'/.screenrcVim'

# vim
alias v='vim'

# go to MAMP/htdocs
if [ -d  "/Applications/MAMP/htdocs" ]
then
  alias mamp='cd /Applications/MAMP/htdocs'
fi

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

# pick screen session to reconnect to
s() {
  screenls="$(screen -ls 2>&1)"
  count=`echo ${screenls} | wc -l`
  if [ $count -eq 2 ]; then; screen -c $HOME/.screenrcVim
  else
    screens=`echo $screenls | head '-'$(( $count-1 )) | sed 1d`
    echo "1. New session"
    let counter=2
    echo $screens | while read line ; do
      echo $counter'.' $line
      ((counter+=1))
    done
    echo -n "Enter number: "; read num
    if [ $num -eq 1 ]; then; screen -c $HOME/.screenrcVim
    else
      ((num-=1))
      screen -R `echo $screens | sed -n ${num}'p' | cut -f2`
    fi
  fi
}

## environment variables

# home page for w3m browser
export WWW_HOME='www.google.com'

# set default editor
export VISUAL=vim
export EDITOR="$VISUAL"

# if "$HOME/.bin" exists add to PATH variable
if [ -d  "$HOME/.bin" ]
then
  export PATH="$HOME/.bin:$PATH"
fi

# recommended by brew doctor
if command -v brew >/dev/null
then
  export PATH="/usr/local/bin:$PATH"
fi

# add Android tools/emulator to PATH
if [ -d  "$HOME/Android/Sdk" ]
then
  export ANDROID_HOME=$HOME/Android/Sdk
  export PATH=$PATH:$ANDROID_HOME/emulator
  export PATH=$PATH:$ANDROID_HOME/tools
  export PATH=$PATH:$ANDROID_HOME/tools/bin
  export PATH=$PATH:$ANDROID_HOME/platform-tools
fi

# add composer/vendor/bin to PATH
if [ -d  "$HOME/.config/composer/vendor/bin" ]
then
  export PATH=$PATH:$HOME/.config/composer/vendor/bin
fi

# add /Applications/MAMP/Library/bin to PATH
if [ -d  "/Applications/MAMP/Library/bin" ]
then
  export PATH=$PATH:/Applications/MAMP/Library/bin
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

