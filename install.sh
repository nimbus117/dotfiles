#!/bin/bash

clear
echo -e '\nWARNING! - This script may overwrite user configuration files.
Please read it carefully before running it.
Press [enter] to continue...'
read

# create links in home directory
declare -a dotfiles=(
  "git/.gitconfig"
  "git/.gitignore_global"
  "screen/.screenrc"
  "vim/.vimrc"
  "zsh/.zshrc"
)

for i in "${dotfiles[@]}"
do
  ln -fsv $(pwd)/$i $HOME/${i##*/}
done

# nimbus117 zsh theme
ln -fsv "$(pwd)/zsh/nimbus117.zsh-theme" "$HOME/.oh-my-zsh/themes/nimbus117.zsh-theme"

# ranger conf file
mkdir -p "$HOME/.config/ranger"
ln -fsv "$(pwd)/ranger/rc.conf" "$HOME/.config/ranger/rc.conf"
