#!/bin/zsh
# run
# chmod 744 install.sh
# ./install.sh

echo 'WARNING! - this script will replace configuration files on your system.'
echo 'Read through the script before running it. Press [enter] to continue...'
read

# create symlinks
declare -a arr=(".gitconfig" ".screenrc" ".zshrc" ".vimrc" ".gitignore_global")
for i in "${arr[@]}"
do
	ln -fsv $(pwd)/$i $HOME/$i
done
