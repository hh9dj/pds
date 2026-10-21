{ pkgs }:

let
  configDir = pkgs.runCommand "pds-opencode-config" { } ''
    mkdir -p $out
    cp ${./opencode.json} $out/opencode.json
    cp ${./AGENTS.md} $out/AGENTS.md
  '';
in
pkgs.writeShellApplication {
  name = "opencode";
  runtimeInputs = [
    pkgs.opencode
    pkgs.git
  ];
  text = ''
    export OPENCODE_CONFIG=${configDir}/opencode.json
    exec ${pkgs.opencode}/bin/opencode "$@"
  '';
}
