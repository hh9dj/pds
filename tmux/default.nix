{ pkgs }:

let
  tmuxConf = pkgs.runCommand "pds-tmux.conf" { } ''
    substitute ${./tmux.conf} $out \
      --replace-fail '@vim_edit@' '${./scripts/vim_edit}' \
      --replace-fail '@tmux_conf@' "$out"
  '';
in
pkgs.writeShellApplication {
  name = "tmux";
  runtimeInputs = [
    pkgs.tmux
    pkgs.neovim
  ];
  text = ''
    exec tmux -f ${tmuxConf} "$@"
  '';
}
