{ pkgs, nixvim }:

let
  inherit (pkgs) lib;

  nvim = nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvimWithModule {
    inherit pkgs;
    module = ./nvim;
  };

  tmux = import ./tmux { inherit pkgs; };
  zsh = import ./zsh { inherit pkgs; };
  opencode = import ./opencode { inherit pkgs; };

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
    opencode
  ]
  ++ tools;
  pathsToLink = [
    "/bin"
    "/share/man"
  ];
  meta = {
    description = "Personal dev shell: portable neovim + tmux + zsh + opencode with minimal config and tooling";
    platforms = lib.platforms.unix;
  };
}
