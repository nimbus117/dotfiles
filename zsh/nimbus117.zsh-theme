_omz_register_handler _omz_git_prompt_info

getPrompt() {

   prompt=""

   # highlight when in a ranger terminal
   if [ -n "$RANGER_LEVEL"  ]; then
      prompt+="%{$fg[red]%}ranger "
   fi

   # hostname
   prompt+="%{$fg[blue]%}%m "

   # node version
   if which nvm &> /dev/null; then
      node=$(nvm current)
      prompt+="%{$fg[cyan]%}("${node%%.*}") "
   fi

   # directory
   prompt+="%{$fg[green]%}%~ "

   # git branch/status
   prompt+="%{$fg[blue]%}$(git_prompt_info) "

   # fill line
   zero='%([BSUbfksu]|([FK]|){*})'
   promptLength=${#${(S%%)prompt//$~zero/}}
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
   RPS1=${${KEYMAP/vicmd/%{$fg[red]%}<<<}/(main|viins)/%{$fg[green]%}}%{$reset_color%}
   RPS2=$RPS1
   zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

ZSH_THEME_GIT_PROMPT_PREFIX=""
ZSH_THEME_GIT_PROMPT_SUFFIX=""
ZSH_THEME_GIT_PROMPT_DIRTY=" %{$fg[red]%}✗"
ZSH_THEME_GIT_PROMPT_CLEAN=" %{$fg[green]%}✔"

PROMPT='$(getPrompt)'
