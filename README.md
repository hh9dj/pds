# PDS

Personal dev shell: portable neovim, tmux and zsh with a minimal config and CLI tooling.

## Install Nix

```
curl -sSf -L https://install.determinate.systems/nix | sh -s -- install
```

Flakes are enabled by default with this installer. Lix also works with the same commands.

## Use

```
nix shell github:hh9dj/pds#pds
```

Contents:

- `nvim/`: Nixvim config built from mini.nvim: mini.pick file and grep pickers, mini.files explorer, mini.base16 light and dark theme, and minimal options
- `tmux/`: `tmux.conf` and `scripts/vim_edit`
- `zsh/zshrc`: bindings, history, aliases; fzf, autosuggestions, syntax highlighting, zoxide and completion are wired in by `default.nix`
- Tools: git, ripgrep, fd, fzf, bat, eza, zoxide, go, python3

Neovim keymaps:

- `<leader><space>`: find files
- `<leader>sg`: live grep
- `<leader>e`: file explorer
- `zz`: quit all
- `<Esc>`: clear search highlight

Switch the theme with `:set background=light` or `:set background=dark`.

Test a change with `nix build .#pds` before pushing.
