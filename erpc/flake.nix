{
  inputs = {
    xnode-builders.url = "github:Openmesh-Network/xnode-builders";
    nixpkgs.follows = "xnode-builders/nixpkgs";
  };

  outputs =
    inputs:
    let
      name = "erpc";
      version = "0.1.1";
    in
    inputs.xnode-builders.language.go {
      inherit name version;
      getArgs =
        { pkgs, ... }:
        {
          src = pkgs.fetchFromGitHub {
            owner = "erpc";
            repo = "erpc";
            tag = version;
            hash = "sha256-MmgEXLTc41Y/qmf4tQOWuClMyapPOXZWP3MYNpfD7Io=";
          };
          extraPackageArgs = {
            vendorHash = "sha256-UDEdF+BRIuRNL2gwAhGFgatip6PzRpW4Rvt9gKdf3sU=";
          };
        };
      module = {
        storage = false;
        options =
          {
            pkgs,
            lib,
            ...
          }:
          {
            config = {
              option = {
                type = lib.types.attrsOf lib.types.anything;
                default = { };
                example = {
                  server = {
                    listenV4 = true;
                    httpHostV4 = "127.0.0.1";
                    httpPortV4 = 4000;
                  };
                };
                description = ''
                  erpc.yaml 
                '';
              };
              does =
                { value, config, ... }:
                let
                  yaml = (pkgs.formats.yaml { }).generate "erpc.yaml" value;
                in
                config {
                  args = [ "${yaml}" ];
                };
            };
          };
      };
    };
}
