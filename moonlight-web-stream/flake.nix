{
  inputs = {
    xnode-builders.url = "github:Openmesh-Network/xnode-builders";
    fenix = {
      url = "github:nix-community/fenix";
      inputs.nixpkgs.follows = "xnode-builders/nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      name = "moonlight-web-stream";
      version = "2.10.0";
    in
    inputs.xnode-builders.language.rust {
      inherit name version;
      implementation = "buildRustPackage";
      getArgs =
        { pkgs, ... }:
        let
          src = pkgs.fetchFromGitHub {
            owner = "MrCreativ3001";
            repo = "moonlight-web-stream";
            tag = "v${version}";
            hash = "sha256-he6hKMfG0p0OsLBOf8t43+HprSqRsFzmHBGMSEQIrVI=";
            fetchSubmodules = true;
          };
          fenixPkgs = inputs.fenix.packages.${pkgs.stdenv.hostPlatform.system};
          toolchain = fenixPkgs.toolchainOf {
            channel = "nightly";
            date = "2026-02-13";
            sha256 = "sha256-S4LusOItdSmt4Z+R5llNu9B3h1Lt+BXQuY9BUnl2xFg=";
          };
          rustPlatform = pkgs.makeRustPlatform {
            cargo = toolchain.cargo;
            rustc = toolchain.rustc;
          };
        in
        {
          inherit src rustPlatform;

          extraPackageArgs = {
            cargoHash = "sha256-jDNnV/jxv+safGOAXi5sIcRW3BcKIQxzvLul7Ezplek=";

            npmDeps = pkgs.fetchNpmDeps {
              inherit src;
              hash = "sha256-hT/RM9vdq5CYmZJm0kW0OUos/6uhCvxA8uVxkgFHqZI=";
            };

            npmRoot = ".";

            nativeBuildInputs = [
              pkgs.pkg-config
              pkgs.cmake
              pkgs.nodejs
              pkgs.npmHooks.npmConfigHook
              rustPlatform.bindgenHook
            ];

            buildInputs = [
              pkgs.openssl
            ];

            OPENSSL_ROOT_DIR = "${pkgs.openssl.dev}";
            OPENSSL_INCLUDE_DIR = "${pkgs.openssl.dev}/include";
            OPENSSL_LIB_DIR = "${pkgs.openssl.out}/lib";
            OPENSSL_NO_VENDOR = "1";

            cargoBuildFlags = [
              "--package"
              "web-server"
              "--package"
              "streamer"
            ];

            preBuild = ''
              npm run build
            '';

            postInstall = ''
              mkdir -p $out/bin

              if [ -f target/release/web-server ]; then
                cp target/release/web-server $out/bin/
                chmod +x $out/bin/web-server
              fi
              if [ -f target/release/streamer ]; then
                cp target/release/streamer $out/bin/
                chmod +x $out/bin/streamer
              fi

              mkdir -p $out/share/moonlight-web-stream/static
              cp -r dist/* $out/share/moonlight-web-stream/static/
            '';

            postFixup = ''
              patchelf --add-rpath ${pkgs.lib.makeLibraryPath [ pkgs.openssl ]} $out/bin/web-server
              patchelf --add-rpath ${pkgs.lib.makeLibraryPath [ pkgs.openssl ]} $out/bin/streamer
            '';

            meta = {
              mainProgram = "web-server";
            };
          };
        };
      module = {
        options =
          {
            cfg,
            pkgs,
            lib,
            ...
          }:
          {
            linkStatic = {
              option = {
                type = lib.types.bool;
                default = true;
                example = false;
                description = ''
                  Link /static into the current working directory.
                '';
              };
              does =
                { value, service, ... }:
                service {
                  serviceConfig.ExecStartPre = lib.mkIf value "${lib.getExe' pkgs.coreutils "ln"} --symbolic --no-target-directory --force \"${cfg.package}/share/moonlight-web-stream/static\" \"static\"";
                };
            };

            streamerPath = {
              option = {
                type = lib.types.bool;
                default = true;
                example = false;
                description = ''
                  Set streamer path in the config.
                '';
              };
              does =
                { value, config, ... }:
                config {
                  config.streamer_path = lib.mkIf value (lib.getExe' cfg.package "streamer");
                };
            };

            config = {
              option = {
                type = lib.types.attrsOf lib.types.anything;
                default = { };
                example = {
                  web_server = {
                    bind_address = "0.0.0.0:8080";
                  };
                };
                description = ''
                  ./server/config.json 
                '';
              };
              does =
                { value, config, ... }:
                let
                  json = pkgs.writeText "config.json" (builtins.toJSON value);
                in
                config {
                  args = [
                    "--config-path"
                    "${json}"
                  ];
                };
            };
          };
      };
    };
}
