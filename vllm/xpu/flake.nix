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
      version = "0.25.0";
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
              hash = "sha256-ynETIrqTCkB/oGVLLD9UeKuaV7oYl+neP26b/YJMcxg=";
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
              intel-oneapi-runtime-compilers = pkgs.stdenv.mkDerivation rec {
                pname = "intel-oneapi-runtime-compilers";
                version = "2025.3.1-760";

                src = pkgs.fetchurl {
                  url = "https://apt.repos.intel.com/oneapi/pool/main/${pname}-${version}_amd64.deb";
                  hash = "sha256-Y9xKFiJ025AFcyLnELeOFwQe9JMuokd7EaEwAowpT7c=";
                };

                nativeBuildInputs = [
                  pkgs.autoPatchelfHook
                  pkgs.dpkg
                ];
                buildInputs = [
                  pkgs.stdenv.cc.cc.lib
                  pkgs.libz
                ];

                dontConfigure = true;
                dontBuild = true;

                unpackPhase = "dpkg -x $src ./";

                installPhase = ''
                  mkdir -p $out
                  mv opt/intel/oneapi/redist/lib $out
                '';
              };
              intel-oneapi-compiler-dpcpp-cpp-runtime = pkgs.stdenv.mkDerivation rec {
                pname = "intel-oneapi-compiler-dpcpp-cpp-runtime";
                version = "2025.3-2025.3.2-832";

                src = pkgs.fetchurl {
                  url = "https://apt.repos.intel.com/oneapi/pool/main/${pname}-${version}_amd64.deb";
                  hash = "sha256-ZbOqZqGRxbPfCLo1pk/LQudRiXyjy5CTue5C5T/tqJA=";
                };

                nativeBuildInputs = [
                  pkgs.autoPatchelfHook
                  pkgs.dpkg
                ];
                buildInputs = [
                  pkgs.stdenv.cc.cc.lib
                  pkgs.libz
                  pkgs.ocl-icd
                  intel-sycl
                  intel-oneapi-runtime-compilers
                ];

                dontConfigure = true;
                dontBuild = true;

                unpackPhase = "dpkg -x $src ./";

                installPhase = ''
                  mkdir -p $out
                  mv opt/intel/oneapi/compiler/2025.3/lib $out
                '';
              };
              intel-oneapi-openmp = pkgs.stdenv.mkDerivation rec {
                pname = "intel-oneapi-openmp";
                version = "2025.3-2025.3.2-832";

                src = pkgs.fetchurl {
                  url = "https://apt.repos.intel.com/oneapi/pool/main/${pname}-${version}_amd64.deb";
                  hash = "sha256-wt1g64K4tjoa5E6YvZg7G6HBXhyHzfN5AXIxINYWSj8=";
                };

                nativeBuildInputs = [
                  pkgs.autoPatchelfHook
                  pkgs.dpkg
                ];
                buildInputs = [
                  pkgs.stdenv.cc.cc.lib
                  pkgs.libz
                  pkgs.libffi
                  pkgs.ocl-icd
                  pkgs.level-zero
                  intel-sycl
                  intel-oneapi-runtime-compilers
                ];

                dontConfigure = true;
                dontBuild = true;

                unpackPhase = "dpkg -x $src ./";

                installPhase = ''
                  mkdir -p $out
                  mv opt/intel/oneapi/compiler/2025.3/lib $out
                '';
              };
              intel-oneapi-mkl-core = pkgs.stdenv.mkDerivation rec {
                pname = "intel-oneapi-mkl-core";
                version = "2025.3-2025.3.1-8";

                src = pkgs.fetchurl {
                  url = "https://apt.repos.intel.com/oneapi/pool/main/${pname}-${version}_amd64.deb";
                  hash = "sha256-FkhEBmKlFG0gZEVsbnuiOwDb5jy0om41Y+tDtJEqzi8=";
                };

                nativeBuildInputs = [
                  pkgs.autoPatchelfHook
                  pkgs.dpkg
                ];
                buildInputs = [
                  pkgs.stdenv.cc.cc.lib
                  pkgs.onetbb
                ];

                dontConfigure = true;
                dontBuild = true;

                unpackPhase = "dpkg -x $src ./";

                installPhase = ''
                  mkdir -p $out
                  mv opt/intel/oneapi/mkl/2025.3/lib $out
                '';
              };
              intel-oneapi-mkl-sycl-blas = pkgs.stdenv.mkDerivation rec {
                pname = "intel-oneapi-mkl-sycl-blas";
                version = "2025.3-2025.3.1-8";

                src = pkgs.fetchurl {
                  url = "https://apt.repos.intel.com/oneapi/pool/main/${pname}-${version}_amd64.deb";
                  hash = "sha256-3rQTqQmCLBSm7o6ycNXtszUdwcJlYXXvQKf5ngJeaqs=";
                };

                nativeBuildInputs = [
                  pkgs.autoPatchelfHook
                  pkgs.dpkg
                ];
                buildInputs = [
                  pkgs.ocl-icd
                  intel-sycl
                ];

                dontConfigure = true;
                dontBuild = true;

                unpackPhase = "dpkg -x $src ./";

                installPhase = ''
                  mkdir -p $out
                  mv opt/intel/oneapi/mkl/2025.3/lib $out
                '';
              };
              intel-oneapi-mkl-sycl-dft = pkgs.stdenv.mkDerivation rec {
                pname = "intel-oneapi-mkl-sycl-dft";
                version = "2025.3-2025.3.1-8";

                src = pkgs.fetchurl {
                  url = "https://apt.repos.intel.com/oneapi/pool/main/${pname}-${version}_amd64.deb";
                  hash = "sha256-6CWHJoX4uTEw4yyhty0xytgIBC+X+Va16OhgZflNKeg=";
                };

                nativeBuildInputs = [
                  pkgs.autoPatchelfHook
                  pkgs.dpkg
                ];
                buildInputs = [
                  pkgs.ocl-icd
                  intel-sycl
                ];

                dontConfigure = true;
                dontBuild = true;

                unpackPhase = "dpkg -x $src ./";

                installPhase = ''
                  mkdir -p $out
                  mv opt/intel/oneapi/mkl/2025.3/lib $out
                '';
              };
              intel-oneapi-mkl-sycl-lapack = pkgs.stdenv.mkDerivation rec {
                pname = "intel-oneapi-mkl-sycl-lapack";
                version = "2025.3-2025.3.1-8";

                src = pkgs.fetchurl {
                  url = "https://apt.repos.intel.com/oneapi/pool/main/${pname}-${version}_amd64.deb";
                  hash = "sha256-UpbvSpaWiOOvQOvYURYlI+O11PY/6h0vSKjf1qZ1oKU=";
                };

                nativeBuildInputs = [
                  pkgs.autoPatchelfHook
                  pkgs.dpkg
                ];
                buildInputs = [
                  pkgs.ocl-icd
                  intel-sycl
                  intel-oneapi-mkl-sycl-blas
                ];

                dontConfigure = true;
                dontBuild = true;

                unpackPhase = "dpkg -x $src ./";

                installPhase = ''
                  mkdir -p $out
                  mv opt/intel/oneapi/mkl/2025.3/lib $out
                '';
              };
              intel-oneapi-ccl = pkgs.stdenv.mkDerivation rec {
                pname = "intel-oneapi-ccl";
                version = "2021.17-2021.17.2-5";

                src = pkgs.fetchurl {
                  url = "https://apt.repos.intel.com/oneapi/pool/main/${pname}-${version}_amd64.deb";
                  hash = "sha256-dEztryzSRDCfbRsLsyNpOaj2vtdAaw2lfdTdqfMpa2c=";
                };

                nativeBuildInputs = [
                  pkgs.autoPatchelfHook
                  pkgs.dpkg
                ];
                buildInputs = [
                  pkgs.stdenv.cc.cc.lib
                  intel-sycl
                  intel-oneapi-runtime-compilers
                  intel-oneapi-openmp
                ];

                dontConfigure = true;
                dontBuild = true;

                unpackPhase = "dpkg -x $src ./";

                installPhase = ''
                  mkdir -p $out
                  mv opt/intel/oneapi/ccl/2021.17/lib $out
                '';
              };
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
