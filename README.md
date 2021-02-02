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

# My Vim Shortcuts

- `\f` - Toggle NERDTree  
- `\t` - Toggle terminal
- `%` - Jump to match (HTML tag or brackets)
- `ci(` - Replace inside parenthesis
- `ddp` - Move current line down one row
- `~` - Switch case of selection
- `D` - Delete rest of line
- `g;` - Jump to last edited location
- `q:` - View command history (then press <enter> to run)
- `q/` - View search history (then press <enter> to run)
- `<ctrl>a` - Increment number under cursor (opposite is <ctrl>x)
- `<ctrl>g` - View current file path (useful with Ggrep search)
 
- `K` - Show documentation for object under cursor  
- `gd` - Goto defintion
- `gi` - Goto implementation
- `\rn` - Rename symbol
- `CTRL-<space>` - Start completion in insert mode
- `\a` - Move selected code to function
- `af` - Select function (in visual mode)
- `ac` - Select class (in visual mode)
- `<space>o` - List all symbols in current document
 
- `:Ggrep` - Search through all files in repo that are not gitignored  
- `]q` - Next match in Ggrep serach
- `[q` - Previous match in Ggrep search

- `:smiley_face:` - Add an emoji (in insert mode)

# Longer Commands

Make a project-wide replacement:

```
:argadd `git ls-files`
:argdo %s/foo/bar/ge | update
```

Note that there is a [known bug](https://github.com/airblade/vim-gitgutter/issues/707) when running a macro on many (50+) files with vim-gitgutter.
To work around this issue, you can use `:GitGutterDisable` before the macro and then `:GitGutterEnable` afterwards.

Run a macro project-wide:

```
:argadd `git ls-files`
:argdo normal @q | update
```

Build a macro manually:

```
:let @q='ggVG:s/foo/bar/ge'
```

Run a macro on a selection:

```
VG:normal @q
```

Sort and remove duplicate lines:

```
:sort u
```

