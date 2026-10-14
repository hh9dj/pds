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

- `nvim/`: neovim config (snacks picker/explorer, blink.cmp, treesitter, LSP for go, python, nix, lua, bash)
- `tmux/`: `tmux.conf` and `scripts/vim_edit`
- `zsh/zshrc`: bindings, history, aliases; fzf, autosuggestions, syntax highlighting, zoxide and completion are wired in by `default.nix`
- Tools: git, ripgrep, fd, fzf, bat, eza, zoxide, go/gopls/gofumpt/golines, python3/pyright/ruff, nixd/nixfmt, lua-language-server/stylua, bash-language-server

Test a change with `nix build .#pds` before pushing.
