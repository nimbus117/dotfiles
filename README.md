# Dev Environment Setup

### brew
```
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
echo "export PATH=/opt/homebrew/bin:$PATH" >> ~/.bash_profile && source ~/.bash_profile
```
```
brew install \
bat \
coreutils \
gnu-sed \
highlight \
neovim \
ranger \
ripgrep \
tmux \
tree \
wget \
zsh
```

### iterm2
```
brew install --cask iterm2
```
```
wget -P $TMPDIR https://raw.githubusercontent.com/catppuccin/iterm/refs/heads/main/colors/catppuccin-mocha.itermcolors
open "$TMPDIR"catppuccin-mocha.itermcolors
```

### oh-my-zsh
```
sh -c "$(curl -fsSL https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"
```

### powerlevel10k
```
git clone https://github.com/romkatv/powerlevel10k.git $ZSH_CUSTOM/themes/powerlevel10k
```

### tmux plugin manager
```
git clone https://github.com/tmux-plugins/tpm ~/.tmux/plugins/tpm
```

### link dotfiles
```
./link.sh
```

### install meslo nerd font patched for powerlevel10k
```
p10k configure
```

### bat colorscheme
```
mkdir -p "$(bat --config-dir)/themes"
wget -P "$(bat --config-dir)/themes" https://github.com/catppuccin/bat/raw/main/themes/Catppuccin%20Mocha.tmTheme
bat cache --build
```

### install nvm
```
curl -o- https://raw.githubusercontent.com/nvm-sh/nvm/v0.40.1/install.sh | bash
```
