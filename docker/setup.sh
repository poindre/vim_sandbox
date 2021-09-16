set -eux

# setup node.js
if [ ! -x "$(command -v node)" ]; then
  nodenv install 16.9.1
  nodenv global 16.9.1
fi
npm install -g yarn
npm install -g neovim

# setup ruby
rbenv install 3.0.2

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
npm install coc-snippets coc-blade-linter coc-css coc-cssmodules coc-emmet coc-eslint coc-html coc-htmlhint @yaegassy/coc-intelephense coc-json coc-prettier coc-sh coc-stylelint coc-toml coc-tsserver coc-yaml --global-style --ignore-scripts --no-bin-links --no-package-lock --only=prod
