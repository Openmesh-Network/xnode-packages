{
  pkgs ? import <nixpkgs> { },
}:
(pkgs.buildFHSEnv {
  name = "update-env";
  targetPkgs =
    pkgs: with pkgs; [
      uv
      python3
      stdenv.cc.cc.lib
      libz
      portaudio
    ];
  runScript = "bash";
}).env
