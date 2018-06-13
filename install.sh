#!/bin/zsh
# run
# chmod 744 install.sh
# ./install.sh

# create symlinks from pwd to home directory
declare -a arr=(".gitconfig" ".screenrc" ".zshrc" ".vimrc" ".config")
for i in "${arr[@]}"
do
	echo $i
	rm ~/$i -rf
	ln -sf $(pwd)/$i ~/$i
done
echo "done"
