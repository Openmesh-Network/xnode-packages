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

    (inputs.xnode-builders.language.python {
      inherit name version;
      getArgs =
        { pkgs, ... }:
        let
          src = pkgs.fetchFromGitHub {
            owner = "selkies-project";
            repo = "selkies";
            tag = version;
            hash = "sha256-XZ+pi+r2Avck1RnAPQCmPIkYBYse+sVjI1/lfCwgkAs=";
          };
          selkies-web-core =
            (inputs.xnode-builders.language.javascript {
              name = "selkies-web-core";
              inherit version;
              src = src + "/addons/selkies-web-core";
            }).packages.${pkgs.stdenv.hostPlatform.system}.default;
          selkies-dashboard =
            (inputs.xnode-builders.language.javascript {
              name = "selkies-dashboard";
              inherit version;
              src = pkgs.stdenv.mkDerivation {
                inherit version src;
                name = "selkies-dashboard-src-with-web-core";
                dontConfigure = true;
                dontBuild = true;
                installPhase = ''
                  mkdir -p $out
                  mv ./addons/selkies-dashboard/* $out

                  substituteInPlace $out/copy-core.js --replace-fail "../selkies-web-core/dist" "${selkies-web-core}/share/dist"
                  substituteInPlace $out/copy-assets.js --replace-fail "../selkies-web-core/dist" "${selkies-web-core}/share/dist"

                  substituteInPlace $out/src/main.jsx --replace-fail "../.." "${src}/addons"
                  substituteInPlace $out/src/components/* --replace "../../.." "${src}/addons"
                '';
              };
              override.buildNpmPackage.env.SELKIES_INJECT = "1";
            }).packages.${pkgs.stdenv.hostPlatform.system}.default;
        in
        {
          src = pkgs.stdenv.mkDerivation {
            inherit version src;
            name = "${name}-patched";
            dontConfigure = true;
            dontBuild = true;
            installPhase = ''
              mkdir -p $out
              mv ./* $out
              cp ${./uv.lock} $out/uv.lock

              # https://github.com/selkies-project/selkies/blob/main/scripts/ci/build-web.sh
              core=${selkies-web-core}/share/dist
              dashboard=${selkies-dashboard}/share/dist

              web=$out/src/selkies/selkies_web

              rm -rf $web
              cp -r $dashboard $web
              chmod -R u+w $web

              mkdir -p $web/src
              cp $core/selkies-core.js $web/src/
              cp $out/addons/universal-touch-gamepad/universalTouchGamepad.js $web/src/

              printf '%s\n' '"""Bundled web client, served by the stream server as package data."""' > $web/__init__.py

              printf '%s' '{"name":"Selkies","short_name":"Selkies","display":"fullscreen","background_color":"#000000","theme_color":"#000000","icons":[{"src":"icon-512.png","type":"image/png","sizes":"512x512"}],"start_url":"."}' > $web/manifest.json

              cp $out/docs/assets/logo/icon-512x512.png $web/icon-512.png
              cp $out/docs/assets/logo/favicon.ico $web/favicon.ico
            '';
          };

          override = {
            common.uv2nix.pythonSet.override = (
              final: prev: {
                pixelflux = prev.pixelflux.overrideAttrs (old: {
                  appendRunpaths = (old.appendRunpaths or [ ]) ++ [
                    "${pkgs.wayland}/lib"
                    "${pkgs.libva.out}/lib"
                  ];
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
      module = {
        network = false;
        storage = false;
        userService = true;
        options =
          {
            lib,
            ...
          }:
          {
            graphicalSession = {
              option = {
                type = lib.types.bool;
                default = true;
                example = false;
                description = ''
                  Run this service after (as part of) graphical-session.target
                '';
              };
              does =
                { value, service, ... }:
                lib.mkIf value (service {
                  wantedBy = lib.mkForce [ "graphical-session.target" ];
                  partOf = [ "graphical-session.target" ];
                  wants = [ "graphical-session.target" ];
                  after = [ "graphical-session.target" ];
                });
            };
          };
      };
    });
}
