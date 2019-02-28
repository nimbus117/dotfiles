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
  nvm
)

source $ZSH/oh-my-zsh.sh

## aliases

# properly clears the terminal
alias cls='tput reset'

# keep current directory when exiting ranger file explorer
if command -v ranger >/dev/null
then
  alias r='source ranger'
fi

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
    curl 'wttr.in'
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
  screens=`screen -ls | sed '1d;$d'`
  count=$(echo -n "$screens" | grep -c '^')
  if [ $count -eq 0 ]; then; screen -c $HOME/.screenrcVim
  else
    echo "0. New session"
    let counter=1
    echo $screens | while read line ; do
      echo $counter'.' $line
      (( counter+=1 ))
    done
    echo -n "Enter number: "; read num
    if [ $num -eq 0 2> /dev/null ]; then; screen -c $HOME/.screenrcVim
    elif [ $num -gt 0 2> /dev/null ] && [ $num -le $count ]; then
      screen -d -r `echo $screens | sed -n ${num}'p' | awk '{print $1}'`
    else
      echo "Invalid input - enter a number from 0 to $count"
    fi
  fi
}

# load environment variables for ssh-agent and add ssh pass
sshadd() {
  eval "$(ssh-agent)"
  ssh-add
}

# get dad joke
joke() {
  joke=`curl -s https://icanhazdadjoke.com/`
  if command -v cowsay >/dev/null && command -v lolcat >/dev/null
  then
    cowFile=`cowsay -l | sed "1d" | tr " " "\n" | sort --random-sort | sed 1q`
    echo $joke | cowsay -w -f ${cowFile} | lolcat -a -s 320 -d 6
    echo ""
  else
    echo $joke
  fi
}
# show all
# for f in `cowsay -l | sed "1d"`; do; cowsay -f $f "Hello, I am $f"; done | lolcat

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

# required for tilix
if [ $TILIX_ID ] || [ $VTE_VERSION ]; then
  source /etc/profile.d/vte.sh
fi

# if dircolors, set colour for ls
if [ -f $HOME/.dircolors ]
then
  eval `dircolors $HOME/.dircolors`
fi
