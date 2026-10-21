# PDS

Personal dev shell: portable neovim, tmux, zsh and opencode with a minimal config and CLI tooling.

## Install Nix

```
curl -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Flakes are enabled by default with this installer. Lix also works with the same commands.

## Use

```
nix shell github:hh9dj/pds#pds
```

## Layout

- `nvim/`: Nixvim config built from mini.nvim: mini.pick file and grep pickers, mini.files explorer, mini.base16 light and dark theme, and minimal options
- `tmux/`: `default.nix`, `tmux.conf` and `scripts/vim_edit`; `default.nix` builds the config and the `tmux` wrapper
- `zsh/`: `default.nix` and `zshrc`; `default.nix` adds fzf, autosuggestions, syntax highlighting, zoxide and completion, and builds the `zsh` wrapper
- `opencode/`: `default.nix` and `opencode.json`; `default.nix` builds the `opencode` wrapper with `OPENCODE_CONFIG`
- `default.nix`: builds each component and assembles the `pds` environment

Tools: git, ripgrep, fd, fzf, bat, eza, zoxide, go, python3.

Neovim keymaps:

- `<leader><space>`: find files
- `<leader>sg`: live grep
- `<leader>e`: file explorer
- `zz`: quit all
- `<Esc>`: clear search highlight

Switch the theme with `:set background=light` or `:set background=dark`.

Test a change with `nix build .#pds` before pushing.
