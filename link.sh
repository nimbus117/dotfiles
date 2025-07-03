#!/bin/bash

# create links in home directory
declare -a dotfiles=(
  "dircolors/dircolors"
  "git/gitconfig"
  "git/gitignore_global"
  "jetbrains/ideavimrc"
  "tmux/tmux.conf"
  # "vim/vimrc"
  # "screen/screenrc"
  "zsh/p10k.zsh"
  "zsh/zshrc"
)

for i in "${dotfiles[@]}"
do
  ln -fsv $(pwd)/$i $HOME/.${i##*/}
done

# ranger conf
mkdir -p "$HOME/.config/ranger"
ln -fsv "$(pwd)/ranger/rc.conf" "$HOME/.config/ranger/rc.conf"

# nvim conf
mkdir -p "$HOME/.config/nvim"
ln -fsv "$(pwd)/nvim/init.lua" "$HOME/.config/nvim/init.lua"
