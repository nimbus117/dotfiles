myPrompt() {

   # local divider="%{$fg[cyan]%} | "
   local divider=" "

   prompt=""

   # Highlight when in a ranger terminal
   if [ -n "$RANGER_LEVEL"  ]; then
      prompt=$prompt"%{$fg[red]%}ranger$divider"
   fi

   # hostname
   prompt=$prompt"%{$fg[blue]%}%m"$divider

   # node version
   if which nvm &> /dev/null; then
      node=$(nvm current)
      prompt=$prompt"%{$fg[cyan]%}("${node%%.*}")"$divider
   fi

   # directory
   prompt=$prompt"%{$fg[green]%}%~"$divider

   # git branch/status
   if [[ -n $(git_prompt_info) ]]; then
      prompt=$prompt"%{$fg[blue]%}$(git_prompt_info)"$divider
   fi

   # fill line
   zero='%([BSUbfksu]|([FK]|){*})'
   promptLength=${#${(S%%)prompt//$~zero/}}
   prompt=$prompt"%{$fg[gray]%}${(r:$COLUMNS-$promptLength::─:)}"

   # new line
   prompt=$prompt$'\n'

   # return status
   prompt=$prompt"%(?:%{$fg[green]%}➜ :%{$fg[red]%}➜ )"

   # reset color
   prompt=$prompt"%{$reset_color%}"

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

PROMPT='$(myPrompt)'
