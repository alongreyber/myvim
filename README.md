# Setup

1. Install Neovim

1. Symlink vim and CoC config from this repo:

```
ln ~/myvim/init.vim ~/.config/nvim/init.vim
ln ~/myvim/coc-settings.json ~/.config/nvim/coc-settings.json
```

1. Install plugins and language servers for CoC:

```
nvim -c PlugInstall
pip install -U jedi-language-server
nvim -c CocInstall coc-vetur
nvim -c CocInstall coc-python
```
