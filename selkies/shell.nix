{
  pkgs ? import <nixpkgs> { },
}:
(pkgs.buildFHSEnv {
  name = "update-env";
  targetPkgs =
    pkgs: with pkgs; [
      uv
      python3
    ];
  runScript = "bash";
}).env
