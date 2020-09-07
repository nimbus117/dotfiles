#!/bin/bash
# run
# chmod 744 install.sh
# ./install.sh

clear
echo -e '\nWARNING! - This script may overwrite user configuration files.
Please read it carefully before running it.
Press [enter] to continue...'
read

# create links in home directory
declare -a dotfiles=(
  "ctags/.ctags"
  "git/.gitconfig"
  "git/.gitignore_global"
  "screen/.screenrc"
  "vim/.vimrc"
  "zsh/.zshrc"
  "mongo/.mongorc.js"
)

for i in "${dotfiles[@]}"
do
  ln -fsv $(pwd)/$i $HOME/${i##*/}
done

# mySimple zsh theme
ln -fsv "$(pwd)/zsh/mySimple.zsh-theme" "$HOME/.oh-my-zsh/themes/mySimple.zsh-theme"

# universal ctags config
mkdir -p "$HOME/.ctags.d"
ln -fsv "$(pwd)/ctags/universal.ctags" "$HOME/.ctags.d/universal.ctags"

# powershell profile
mkdir -p "$HOME/.config/powershell"
ln -fsv "$(pwd)/powershell/Microsoft.PowerShell_profile.ps1" "$HOME/.config/powershell/Microsoft.PowerShell_profile.ps1"
