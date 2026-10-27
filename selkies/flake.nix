{
  inputs = {
    xnode-builders.url = "github:Openmesh-Network/xnode-builders";
  };

  outputs =
    inputs:
    let
      name = "selkies";
      version = "2.1.0";
    in
    inputs.xnode-builders.language.python {
      inherit name version;
      getArgs =
        { pkgs, ... }:
        {
          src = pkgs.stdenv.mkDerivation {
            inherit version;
            name = "selkies-patched";
            src = pkgs.fetchFromGitHub {
              owner = "selkies-project";
              repo = "selkies";
              tag = version;
              hash = "sha256-XZ+pi+r2Avck1RnAPQCmPIkYBYse+sVjI1/lfCwgkAs=";
            };
            dontConfigure = true;
            dontBuild = true;
            installPhase = ''
              mkdir -p $out
              mv ./* $out
              cp ${./uv.lock} $out/uv.lock
            '';
          };
        };

      override = { pkgs, ... }: {
        common.uv2nix.pythonSet.override = (
          final: prev: {
            pixelflux = prev.pixelflux.overrideAttrs (old: {
              buildInputs = (old.buildInputs or [ ]) ++ [
                pkgs.libgbm
                pkgs.pixman
                pkgs.libxkbcommon
              ];
            });
          }
        );
      };
    };
}
