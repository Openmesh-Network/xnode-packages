{
  inputs = {
    xnode-builders.url = "github:Openmesh-Network/xnode-builders";
    intel-oneapi-toolkit = {
      url = "path:../../intel-oneapi-toolkit";
      inputs.nixpkgs.follows = "xnode-builders/nixpkgs";
    };
  };

  outputs =
    inputs:
    let
      name = "vllm";
      version = "0.27.1";
    in
    inputs.xnode-builders.language.python {
      inherit name version;
      getArgs =
        { pkgs, ... }:
        {
          src = pkgs.stdenv.mkDerivation {
            inherit version;
            name = "vllm-patched";
            src = pkgs.fetchFromGitHub {
              owner = "vllm-project";
              repo = "vllm";
              tag = "v${version}";
              hash = "sha256-1cl0Cn6nCj2DpP3uNRrtzOdZkO5Vila1GCQGY2xdib4=";
            };
            patches = [ ./memory.patch ];
            dontConfigure = true;
            dontBuild = true;
            installPhase = ''
              mkdir -p $out
              mv ./* $out
              cp ${./uv.lock} $out/uv.lock
            '';
          };

          extraPackageArgs.override =
            let
              intel-oneapi-toolkit = inputs.intel-oneapi-toolkit.packages.${pkgs.stdenv.hostPlatform.system};
              intel-sycl = intel-oneapi-toolkit.intel-sycl;
              intel-oneapi-runtime-compilers = intel-oneapi-toolkit.intel-oneapi-runtime-compilers;
              intel-oneapi-compiler-dpcpp-cpp-runtime =
                intel-oneapi-toolkit.intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0;
              intel-oneapi-openmp = intel-oneapi-toolkit.intel-oneapi-openmp-2026_0;
              intel-oneapi-mkl-core = intel-oneapi-toolkit.intel-oneapi-mkl-core-2026_0;
              intel-oneapi-mkl-sycl-blas = intel-oneapi-toolkit.intel-oneapi-mkl-sycl-blas-2026_0;
              intel-oneapi-mkl-sycl-dft = intel-oneapi-toolkit.intel-oneapi-mkl-sycl-dft-2026_0;
              intel-oneapi-mkl-sycl-lapack = intel-oneapi-toolkit.intel-oneapi-mkl-sycl-lapack-2026_0;
              intel-oneapi-mpi = intel-oneapi-toolkit.intel-oneapi-mpi-2021_18;
              intel-oneapi-ccl = intel-oneapi-toolkit.intel-oneapi-ccl-2022_0;
              intel-pti = intel-oneapi-toolkit.intel-pti;
              eth-psm3-fi = pkgs.stdenv.mkDerivation rec {
                name = "eth-psm3-fi";
                version = "12.1.0.1";

                src = pkgs.fetchFromGitHub {
                  owner = "intel";
                  repo = "eth-psm3-fi";
                  tag = "v${version}";
                  hash = "sha256-FU0d64jiFOzuMwu19bZA/B2tSEcH2gENwCcZtSbKrfU=";
                };

                buildInputs = [
                  pkgs.rdma-core
                  pkgs.numactl
                  pkgs.libuuid
                ];

                configureFlags = [ "--with-oneapi-ze=${pkgs.level-zero}" ];
              };
            in
            (final: prev: {
              vllm = prev.vllm.overrideAttrs (
                old:
                let
                  sycl-root = pkgs.symlinkJoin {
                    name = "sycl-root";
                    paths = [
                      intel-oneapi-toolkit.default
                      intel-sycl
                    ];
                  };
                in
                {
                  nativeBuildInputs = (old.nativeBuildInputs or [ ]) ++ [
                    sycl-root
                  ];
                  buildInputs = (old.buildInputs or [ ]) ++ [
                    pkgs.libipt
                  ];

                  env = (old.env or { }) // {
                    VLLM_TARGET_DEVICE = "xpu";
                    VLLM_VERSION_OVERRIDE = "v${version}";
                    SYCL_ROOT = "${sycl-root}";
                  };
                }
              );

              intel-pti = prev.intel-pti.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  pkgs.level-zero
                  intel-oneapi-runtime-compilers
                ];
              });

              intel-cmplr-lib-ur = prev.intel-cmplr-lib-ur.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  pkgs.ocl-icd
                  intel-sycl
                  intel-oneapi-runtime-compilers
                ];
              });

              onemkl-sycl-sparse = prev.onemkl-sycl-sparse.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  pkgs.ocl-icd
                  intel-sycl
                  intel-oneapi-mkl-sycl-blas
                ];
              });

              onemkl-sycl-dft = prev.onemkl-sycl-dft.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  pkgs.ocl-icd
                  intel-sycl
                ];
              });

              onemkl-sycl-lapack = prev.onemkl-sycl-lapack.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  pkgs.ocl-icd
                  intel-sycl
                  intel-oneapi-mkl-sycl-blas
                ];
              });

              onemkl-sycl-blas = prev.onemkl-sycl-blas.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  pkgs.ocl-icd
                  intel-sycl
                ];
              });

              onemkl-sycl-rng = prev.onemkl-sycl-rng.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  pkgs.ocl-icd
                  intel-sycl
                ];
              });

              tbb = prev.tbb.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.hwloc ];
              });

              torchaudio = prev.torchaudio.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ final.torch ];
                autoPatchelfIgnoreMissingDeps = (old.autoPatchelfIgnoreMissingDeps or [ ]) ++ [
                  "libc10.so"
                  "libtorch.so"
                  "libtorch_cpu.so"
                  "libtorch_xpu.so"
                  "libtorch_python.so"
                ];
              });

              umf = prev.umf.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.hwloc ];
              });

              torchvision = prev.torchvision.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ final.torch ];
                autoPatchelfIgnoreMissingDeps = (old.autoPatchelfIgnoreMissingDeps or [ ]) ++ [
                  "libc10.so"
                  "libtorch.so"
                  "libtorch_cpu.so"
                  "libtorch_xpu.so"
                  "libtorch_python.so"
                ];
              });

              numba = prev.numba.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.onetbb ];
              });

              vllm-xpu-kernels = prev.vllm-xpu-kernels.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  pkgs.level-zero
                  final.torch
                  intel-sycl
                  intel-oneapi-runtime-compilers
                ];
                autoPatchelfIgnoreMissingDeps = (old.autoPatchelfIgnoreMissingDeps or [ ]) ++ [
                  "libc10.so"
                  "libc10_xpu.so"
                  "libtorch.so"
                  "libtorch_cpu.so"
                  "libtorch_xpu.so"
                  "libtorch_python.so"
                ];
              });

              intel-openmp = prev.intel-openmp.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  pkgs.ocl-icd
                  pkgs.level-zero
                  intel-sycl
                  intel-oneapi-runtime-compilers
                ];
              });

              impi-rt = prev.impi-rt.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  pkgs.level-zero
                  pkgs.rdma-core
                  pkgs.ucx
                  pkgs.libpsm2
                  pkgs.numactl
                  intel-oneapi-openmp
                  eth-psm3-fi
                ];
                postInstall = ''
                  rm -rf $out/bin/libfabric
                '';
              });

              intel-sycl-rt = prev.intel-sycl-rt.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  pkgs.level-zero
                  intel-oneapi-runtime-compilers
                  intel-oneapi-compiler-dpcpp-cpp-runtime
                ];
              });

              oneccl = prev.oneccl.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  intel-sycl
                  intel-oneapi-runtime-compilers
                  intel-oneapi-openmp
                  intel-oneapi-mpi
                ];
              });

              intel-opencl-rt = prev.intel-opencl-rt.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  pkgs.libz
                  pkgs.onetbb
                  intel-oneapi-runtime-compilers
                ];
              });

              mkl = prev.mkl.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [ pkgs.onetbb ];
              });

              torch = prev.torch.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  intel-sycl
                  intel-oneapi-runtime-compilers
                  intel-oneapi-mkl-core
                  intel-oneapi-mkl-sycl-blas
                  intel-oneapi-mkl-sycl-dft
                  intel-oneapi-mkl-sycl-lapack
                  intel-oneapi-ccl
                  intel-pti
                ];
              });

              xgrammar = prev.xgrammar.overrideAttrs (old: {
                autoPatchelfIgnoreMissingDeps = (old.autoPatchelfIgnoreMissingDeps or [ ]) ++ [
                  "libtvm_ffi.so"
                ];
              });

              auto-round-lib = prev.auto-round-lib.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  pkgs.ocl-icd
                  intel-sycl
                  intel-oneapi-compiler-dpcpp-cpp-runtime
                  intel-oneapi-openmp
                ];
              });

              torchcodec = prev.torchcodec.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  pkgs.ffmpeg_7.lib
                  pkgs.ffmpeg_8.lib
                  pkgs.ffmpeg.lib

                  pkgs.libheif
                ];

                autoPatchelfIgnoreMissingDeps = (old.autoPatchelfIgnoreMissingDeps or [ ]) ++ [
                  # FFmpeg 4/5/6 ABI variants — unused, torchcodec probes and skips at runtime
                  "libavutil.so.56"
                  "libavcodec.so.58"
                  "libavformat.so.58"
                  "libavdevice.so.58"
                  "libavfilter.so.7"
                  "libswscale.so.5"
                  "libswresample.so.3"

                  "libavutil.so.57"
                  "libavcodec.so.59"
                  "libavformat.so.59"
                  "libavdevice.so.59"
                  "libavfilter.so.8"
                  "libswscale.so.6"

                  "libavutil.so.58"
                  "libavcodec.so.60"
                  "libavformat.so.60"
                  "libavdevice.so.60"
                  "libavfilter.so.9"
                  "libswscale.so.7"
                  "libswresample.so.4"

                  # CUDA-only torch backend libs — not needed/present on xpu builds
                  "libtorch.so"
                  "libtorch_cpu.so"
                  "libtorch_cuda.so"
                  "libc10.so"
                  "libc10_cuda.so"
                  "libnvrtc.so.13"
                  "libcudart.so.13"
                ];
              });
            });
        };
    };
}
