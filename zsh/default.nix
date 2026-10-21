{ pkgs }:

let
  prologue = pkgs.writeText "pds-zshrc-prologue" ''
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

  epilogue = pkgs.writeText "pds-zshrc-epilogue" ''
    source ${pkgs.zsh-syntax-highlighting}/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
  '';

  zdotdir = pkgs.runCommand "pds-zdotdir" { } ''
    mkdir -p $out
    cat ${prologue} ${./zshrc} ${epilogue} > $out/.zshrc
  '';
in
pkgs.writeShellApplication {
  name = "zsh";
  text = ''
    export ZDOTDIR=${zdotdir}
    exec ${pkgs.zsh}/bin/zsh "$@"
  '';
}
