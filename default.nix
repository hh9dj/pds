{ pkgs, nixvim }:

let
  inherit (pkgs) lib;

  nvim = nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvimWithModule {
    inherit pkgs;
    module = ./nvim;
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
    go
    python3
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
