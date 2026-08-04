{
  inputs = {
    vllm.url = "path:../../vllm/xpu";
    xnode-builders.follows = "vllm/xnode-builders";
  };

  outputs =
    inputs:
    let
      name = "vllm-omni";
      version = "0.26.0";
    in
    inputs.xnode-builders.language.python {
      inherit name version;
      getArgs =
        { pkgs, ... }:
        {
          src = pkgs.stdenv.mkDerivation {
            inherit version;
            name = "vllm-omni-patched";
            src = pkgs.fetchFromGitHub {
              owner = "vllm-project";
              repo = "vllm-omni";
              tag = "v${version}";
              hash = "sha256-fdoFsnFwqEiq5v1Wdxrrt+Z3E0xqJhEJbLh6XdhdB+k=";
            };
            dontConfigure = true;
            dontBuild = true;
            installPhase = ''
              mkdir -p $out
              mv ./* $out
              cp ${./uv.lock} $out/uv.lock

              # https://github.com/vllm-project/vllm-omni/issues/4932
              sed -i 's|\("vllm_omni" = \["_version.py", "py.typed"\]\)|\1\n"vllm_omni.model_executor.stage_configs" = ["*.yaml"]\n"vllm_omni.platforms.xpu" = ["stage_configs/*.yaml"]\n"vllm_omni.model_executor.models.covo_audio" = ["speaker_prompt/*.npy"]\n"vllm_omni.model_executor.models.step_audio2" = ["assets/*.wav"]\n"vllm_omni.experimental.fullduplex" = ["*.md"]|; s|"vllm_omni" = \["_version.py", "py.typed"\]|"vllm_omni" = ["_version.py", "py.typed", "deploy/*.yaml", "deploy/*.md"]|' $out/pyproject.toml
            '';
          };

          extraPackageArgs.override = pkgs.lib.composeManyExtensions [
            inputs.vllm.extras.${pkgs.stdenv.hostPlatform.system}.overlay
            inputs.vllm.extras.${pkgs.stdenv.hostPlatform.system}.args.extraPackageArgs.override
            (final: prev: {
              vllm-omni = prev.vllm-omni.overrideAttrs (old: {
                env = (old.env or { }) // {
                  VLLM_OMNI_TARGET_DEVICE = "xpu";
                  VLLM_OMNI_VERSION_OVERRIDE = "v${version}";
                };
              });

              antlr4-python3-runtime = prev.antlr4-python3-runtime.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  final.setuptools
                ];
              });

              openai-whisper = prev.openai-whisper.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  final.setuptools
                ];
              });

              fa3-fwd = prev.fa3-fwd.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ final.torch ];
                autoPatchelfIgnoreMissingDeps = (old.autoPatchelfIgnoreMissingDeps or [ ]) ++ [
                  "libc10.so"
                  "libtorch.so"
                  "libtorch_cpu.so"
                  "libcudart.so.13"
                  "libc10_cuda.so"
                  "libtorch_cuda.so"
                ];
              });
            })
          ];
        };
    };
}
