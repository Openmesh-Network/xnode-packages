{
  inputs = {
    xnode-builders.url = "github:Openmesh-Network/xnode-builders";
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://cuda-maintainers.cachix.org"
    ];
    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "cuda-maintainers.cachix.org-1:0dq3bujKpuEPMCX6U4WylrUDZ9JyUG0VpVZa7CNfq5E="
    ];
  };

  outputs =
    inputs:
    let
      name = "vllm-omni";
      version = "0.16.0";
      requirements = "cpu";
    in
    inputs.xnode-builders.language.python {
      inherit name version;
      pkgsImport =
        if requirements == "cuda" then
          {
            config = {
              allowUnfree = true;
              cudaSupport = true;
            };
          }
        else if requirements == "rocm" then
          {
            config = {
              allowUnfree = true;
              rocmSupport = true;
            };
          }
        else
          { };
      getArgs =
        { pkgs, ... }:
        let
          python = pkgs.python3.override {
            packageOverrides = final: prev: {
              cache-dit = final.buildPythonPackage rec {
                pname = "cache-dit";
                version = "1.2.3";
                src = pkgs.fetchFromGitHub {
                  owner = "vipshop";
                  repo = "cache-dit";
                  tag = "v${version}";
                  sha256 = "sha256-M19OYe2m8+8lMPLWURYIx6s3waBOlJRPLZgJVRkuo0g=";
                };
                format = "pyproject";
                nativeBuildInputs = [
                  final.setuptools
                  final.wheel
                  final.setuptools-scm
                ];
                propagatedBuildInputs = [
                  final.torch
                  final.diffusers
                  final.transformers
                ];
              };

              sox = final.buildPythonPackage rec {
                pname = "sox";
                version = "1.5.0";
                src = final.fetchPypi {
                  inherit pname version;
                  sha256 = "sha256-Ese+W7H1SNiR/hHoLAjPXxoddOIlKY9gCC5a6yRpraA=";
                };
                format = "setuptools";
                propagatedBuildInputs = [ pkgs.sox ];
              };

              fa3-fwd = final.buildPythonPackage rec {
                pname = "fa3-fwd";
                version = "0.0.2";
                src = pkgs.fetchFromGitHub {
                  owner = "ZJY0516";
                  repo = "fa-fwd";
                  rev = "d78665cc8718260915e0ed1b811890f5a9684d38";
                  sha256 = "sha256-f6gc5SvQNSkc4yMIjUJ/A8KB0E6lNpTzlXNaoZLps5o=";
                  fetchSubmodules = true;
                };
                sourceRoot = "source/flash-attention";
                format = "setuptools";
                patches = [ "${src}/hopper_setup_py.patch" ];
                postPatch = ''
                  # https://github.com/ZJY0516/fa-fwd/blob/d78665cc8718260915e0ed1b811890f5a9684d38/build_fa3.sh
                  cd hopper

                  mv flash_attn_interface.py fa3_fwd_interface.py

                  echo "__version__ = \"0.0.2\"" > __init__.py

                  sed -i 's/flash_attn_3/fa3_fwd/g' fa3_fwd_interface.py flash_api_stable.cpp flash_api.cpp
                '';
                env = {
                  # https://github.com/ZJY0516/fa-fwd/blob/d78665cc8718260915e0ed1b811890f5a9684d38/build_fa3.sh
                  FLASH_ATTENTION_DISABLE_BACKWARD = "TRUE";
                  FLASH_ATTENTION_DISABLE_FP16 = "TRUE";
                  FLASH_ATTENTION_DISABLE_LOCAL = "TRUE";
                  FLASH_ATTENTION_FORCE_BUILD = "TRUE";
                  FLASH_ATTENTION_DISABLE_PAGEDKV = "TRUE";

                  CUDA_HOME = "${pkgs.symlinkJoin {
                    name = "cuda-root";
                    paths = [
                      pkgs.cudaPackages.cuda_nvcc
                      pkgs.cudaPackages.cuda_cudart
                      pkgs.cudaPackages.cuda_cccl
                    ];
                  }}";
                };
                nativeBuildInputs = [
                  pkgs.git
                ];
                propagatedBuildInputs = [
                  final.torch
                ];
              };
            };
          };
        in
        {
          inherit python;

          src = pkgs.fetchFromGitHub {
            owner = "vllm-project";
            repo = name;
            tag = "v${version}";
            hash = "sha256-x7ZDqVwqMvkqfEfxZvt2wI8J9Db8IYKsNzi8J41iJGo=";
          };
          extraRequirements = [
            "requirements/${requirements}.txt"
          ];

          extraPackageArgs = {
            propagatedBuildInputs = [ pkgs.python3Packages.vllm ];
          };
        };
    };
}
