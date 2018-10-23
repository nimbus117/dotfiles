#!/bin/zsh
# run
# chmod 744 install.sh
# ./install.sh

echo 'WARNING! - this script will replace configuration files on your system.'
echo 'Read through the script before running it. Press [enter] to continue...'
read

# create symlinks in home directory
declare -a arr=(".gitconfig" ".gitignore_global" ".screenrc" ".vimrc" "zsh/.zshrc")
for i in "${arr[@]}"
do
  ln -fsv $(pwd)/$i $HOME/${i##*/}
done

# symlink for IntelliJ vimrc
ln -fsv "$HOME/.vimrc" "$HOME/.ideavimrc"

# symlink for mySimple zsh theme
ln -fsv "$(pwd)/zsh/mySimple.zsh-theme" "$HOME/.oh-my-zsh/themes/mySimple.zsh-theme"
