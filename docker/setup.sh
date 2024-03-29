set -eux

# setup Environment Variables
export DOTDIR=${HOME}/.dotfiles
cd ~/

# create Directories
mkdir $HOME/.zsh
mkdir $HOME/.vim
mkdir -p $HOME/.config/nvim
mkdir -p $HOME/.cache/dein/repos/github.com/Shougo

# setup node.js
if [ ! -x "$(command -v node)" ]; then
  nodenv install 16.9.1
  nodenv global 16.9.1
fi
npm install -g yarn
npm install -g neovim

# setup python
pyenv install 2.7.17
pyenv install 3.9.7
pyenv global 2.7.17 3.9.7

# setup ruby
rbenv install 3.0.2
rbenv global 3.0.2

# install neovim
pip install pynvim
pip3 install pynvim
gem install neovim
gem update neovim

# Use package feature to install coc.nvim
mkdir -p ~/.local/share/nvim/site/pack/coc/start
cd ~/.local/share/nvim/site/pack/coc/start
curl --fail -L https://github.com/neoclide/coc.nvim/archive/release.tar.gz | tar xzfv -

# Install extensions
mkdir -p ~/.config/coc/extensions
cd ~/.config/coc/extensions
if [ ! -f package.json ]
then
  echo '{"dependencies":{}}'> package.json
fi

# Change extension names to the extensions you need
npm install coc-snippets coc-blade-linter coc-css coc-cssmodules coc-emmet coc-eslint coc-html coc-htmlhint @yaegassy/coc-intelephense coc-json coc-prettier coc-sh coc-stylelint coc-toml coc-tsserver coc-yaml coc-spell-checker --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod

# Set Git alias
git config --global alias.st status
git config --global alias.cm commit
git config --global alias.ps push
git config --global alias.pl pull

# Install FZF
git clone https://github.com/junegunn/fzf.git ~/.fzf
~/.fzf/install --completion --key-bindings --no-update-rc

if [ `uname` = "Darwin" ]; then
  # Install Homebrew
  if !(type brew > /dev/null 2>&1); then
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)"
  fi

  # Install NERDFont
  cd ~/Library/Fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf

  # Install tig
  if !(type tig > /dev/null 2>&1); then
    brew install tig
  fi

  # Install Ripgrep
  if !(type ripgrep > /dev/null 2>&1); then
    brew install ripgrep
  fi
else
  # Install tig
  mkdir -p ~/.local/share/fonts
  cd ~/.local/share/fonts && curl -fLo "Droid Sans Mono for Powerline Nerd Font Complete.otf" https://github.com/ryanoasis/nerd-fonts/raw/master/patched-fonts/DroidSansMono/complete/Droid%20Sans%20Mono%20Nerd%20Font%20Complete.otf
fi
