#!/bin/bash
# run
# chmod 744 install.sh
# ./install.sh

echo 'WARNING! - this script will replace configuration files on your system.'
echo 'Read through the script before running it. Press [enter] to continue...'
read

# create links in home directory
declare -a dotfiles=(
  "ctags/.ctags"
  "git/.gitconfig"
  "git/.gitignore_global"
  "screen/.screenrc"
  "screen/.screenrcVim"
  "vim/.vimrc"
  "zsh/.zshrc"
)

for i in "${dotfiles[@]}"
do
  ln -fsv $(pwd)/$i $HOME/${i##*/}
done

# link for mySimple zsh theme
ln -fsv "$(pwd)/zsh/mySimple.zsh-theme" "$HOME/.oh-my-zsh/themes/mySimple.zsh-theme"

# link for vscode user settings.json
#ln -fsv "$(pwd)/vscode/settings.json" "$HOME/.config/Code/User/settings.json"
