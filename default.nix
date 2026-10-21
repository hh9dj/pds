{ pkgs, nixvim }:

let
  inherit (pkgs) lib;

  nvim = nixvim.legacyPackages.${pkgs.stdenv.hostPlatform.system}.makeNixvimWithModule {
    inherit pkgs;
    module = ./nvim;
  };

  tmux = import ./tmux { inherit pkgs; };
  opencode = import ./opencode { inherit pkgs; };
in
pkgs.buildEnv {
  name = "pds";
  paths = [
    nvim
    tmux
    opencode
  ];
  pathsToLink = [
    "/bin"
    "/share/man"
  ];
  postBuild = ''
    rm -f $out/bin/nixvim-print-init
  '';
  meta = {
    description = "Minimal portable shell with nvim, tmux and opencode";
    platforms = lib.platforms.unix;
  };
}
