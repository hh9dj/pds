# PDS

Minimal portable shell with nvim, tmux and opencode.

Only nvim, tmux, and opencode are included.

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
- `opencode/`: `default.nix`, `opencode.json` and `AGENTS.md`; `default.nix` builds the config directory and the `opencode` wrapper with `OPENCODE_CONFIG`
- `default.nix`: builds each component and assembles the `pds` environment

Neovim keymaps:

- `<leader><space>`: find files
- `<leader>sg`: live grep
- `<leader>e`: file explorer
- `zz`: quit all
- `<Esc>`: clear search highlight

Switch the theme with `:set background=light` or `:set background=dark`.

Test a change with `nix build .#pds` before pushing.
