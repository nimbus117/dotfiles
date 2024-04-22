# register git_prompt_info
if which git &> /dev/null; then
   _omz_register_handler _omz_git_prompt_info
fi

createPrompt() {

   local prompt=""

   # highlight when in a ranger terminal
   if [ -n "$RANGER_LEVEL"  ]; then
      prompt+="%{$fg[red]%}ranger "
   fi

   # hostname
   prompt+="%{$fg[blue]%}%m "

   # node version
   if which nvm &> /dev/null; then
      local node=$(nvm current)
      prompt+="%{$fg[cyan]%}("${node%%.*}") "
   fi

   # directory
   prompt+="%{$fg[green]%}%~ "

   # git branch/status
   if which git &> /dev/null; then
      local gitInfo=$(git_prompt_info)
      if [ -n "$gitInfo" ]; then
         prompt+="%{$fg[blue]%}$gitInfo "
      fi
   fi

   # fill line
   local zero='%([BSUbfksu]|([FK]|){*})'
   local promptLength=${#${(S%%)prompt//$~zero/}}
   prompt+="%{$fg[gray]%}${(r:$COLUMNS-$promptLength::─:)}"

   # new line
   prompt+=$'\n'

   # return status
   prompt+="%(?:%{$fg[green]%}➜ :%{$fg[red]%}➜ )"

   # reset colour
   prompt+="%{$reset_color%}"

   echo $prompt
}

# vi mode indicator
function zle-line-init zle-keymap-select {
   # RPS1=${${KEYMAP/vicmd/%{$fg[red]%}NORMAL}/(main|viins)/%{$fg[green]%}INSERT}%{$reset_color%}
   RPS1=${${KEYMAP/vicmd/%{$fg[red]%}<<<}/(main|viins)/}%{$reset_color%}
   RPS2=$RPS1
   zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔"

PROMPT='$(createPrompt)'
