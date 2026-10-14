{ pkgs }:

let
  inherit (pkgs) lib;

  treesitter = pkgs.vimPlugins.nvim-treesitter.withPlugins (
    p: with p; [
      bash
      c
      go
      json
      lua
      markdown
      markdown_inline
      python
      query
      regex
      toml
      vim
      vimdoc
      yaml
    ]
  );

  pluginPack = pkgs.runCommand "pds-nvim-plugins" { } ''
    mkdir -p $out/pack/pds/start
    ln -s ${pkgs.vimPlugins.snacks-nvim} $out/pack/pds/start/snacks.nvim
    ln -s ${pkgs.vimPlugins.blink-cmp} $out/pack/pds/start/blink.cmp
    ln -s ${pkgs.vimPlugins.luasnip} $out/pack/pds/start/LuaSnip
    ln -s ${pkgs.vimPlugins.friendly-snippets} $out/pack/pds/start/friendly-snippets
    ln -s ${pkgs.vimPlugins.lualine-nvim} $out/pack/pds/start/lualine.nvim
    ln -s ${pkgs.vimPlugins.nvim-web-devicons} $out/pack/pds/start/nvim-web-devicons
    ln -s ${pkgs.vimPlugins.flash-nvim} $out/pack/pds/start/flash.nvim
    ln -s ${pkgs.vimPlugins.nvim-lspconfig} $out/pack/pds/start/nvim-lspconfig
    ln -s ${pkgs.vimPlugins.catppuccin-nvim} $out/pack/pds/start/catppuccin
    ln -s ${treesitter} $out/pack/pds/start/nvim-treesitter
  '';

  nvim = pkgs.writeShellApplication {
    name = "nvim";
    runtimeInputs = [ pkgs.neovim ];
    text = ''
      export PDS_PLUGINS=${pluginPack}
      export PDS_CONFIG=${./nvim}
      exec nvim -u "$PDS_CONFIG/init.lua" "$@"
    '';
  };

  tmuxConf = pkgs.runCommand "pds-tmux.conf" { } ''
    substitute ${./tmux/tmux.conf} $out \
      --replace-fail '@vim_edit@' '${./tmux/scripts/vim_edit}' \
      --replace-fail '@tmux_conf@' "$out"
  '';

  tmux = pkgs.writeShellApplication {
    name = "tmux";
    runtimeInputs = [
      pkgs.tmux
      pkgs.neovim
    ];
    text = ''
      exec tmux -f ${tmuxConf} "$@"
    '';
  };

  zshPrologue = pkgs.writeText "pds-zshrc-prologue" ''
    export EDITOR=nvim VISUAL=nvim SUDO_EDITOR=nvim FCEDIT=nvim

    fpath+=(${pkgs.zsh-completions}/share/zsh/site-functions)
    zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    zstyle ':completion:*' menu select
    autoload -Uz compinit
    mkdir -p "$HOME/.cache/zsh"
    compinit -d "$HOME/.cache/zsh/zcompdump-$ZSH_VERSION"

    source ${pkgs.fzf}/share/fzf/key-bindings.zsh
    source ${pkgs.fzf}/share/fzf/completion.zsh
    source ${pkgs.zsh-autosuggestions}/share/zsh-autosuggestions/zsh-autosuggestions.zsh
    eval "$(${pkgs.zoxide}/bin/zoxide init --cmd cd zsh)"
  '';

  zshEpilogue = pkgs.writeText "pds-zshrc-epilogue" ''
    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  '';

  zdotdir = pkgs.runCommand "pds-zdotdir" { } ''
    mkdir -p $out
    cat ${zshPrologue} ${./zsh/zshrc} ${zshEpilogue} > $out/.zshrc
  '';

  zsh = pkgs.writeShellApplication {
    name = "zsh";
    text = ''
      export ZDOTDIR=${zdotdir}
      exec ${pkgs.zsh}/bin/zsh "$@"
    '';
  };

  tools = with pkgs; [
    git
    ripgrep
    fd
    fzf
    bat
    eza
    zoxide
    # go
    go
    gopls
    gofumpt
    golines
    # python
    python3
    pyright
    ruff
    # nix + lua + bash
    nixd
    nixfmt
    lua-language-server
    stylua
    bash-language-server
  ];
in
pkgs.buildEnv {
  name = "pds";
  paths = [
    nvim
    tmux
    zsh
  ]
  ++ tools;
  pathsToLink = [
    "/bin"
    "/share/man"
  ];
  meta = {
    description = "Personal dev shell: portable neovim + tmux + zsh with minimal config and tooling";
    platforms = lib.platforms.unix;
  };
}
