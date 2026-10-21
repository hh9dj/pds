{ pkgs }:

pkgs.writeShellApplication {
  name = "opencode";
  runtimeInputs = [ pkgs.opencode ];
  text = ''
    export OPENCODE_CONFIG=${./opencode.json}
    exec ${pkgs.opencode}/bin/opencode "$@"
  '';
}
