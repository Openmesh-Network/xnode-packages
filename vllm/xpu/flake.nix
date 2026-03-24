{
  inputs = {
    xnode-builders.url = "github:Openmesh-Network/xnode-builders";
  };

  outputs =
    inputs:
    let
      name = "vllm";
      version = "0.17.1";
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
              rev = "v${version}";
              hash = "sha256-EZozwA+GIjN8/CBNhtdeM3HsPhVdx1/J0B9gvvn2qKU=";
            };
            buildPhase = "";
            installPhase = ''
              mkdir -p $out
              cp -r ./* $out
              cp ${./uv.lock} $out/uv.lock
            '';
          };

          extraPackageArgs.override =
            let
              intel-sycl = pkgs.stdenv.mkDerivation rec {
                name = "intel-sycl";
                version = "6.3.0";
                src = pkgs.fetchzip {
                  url = "https://github.com/intel/llvm/releases/download/v${version}/sycl_linux.tar.gz";
                  hash = "sha256-vJR/dTGp1yoChmK3gyc89QKbQug0dW0AJLV7xuvRDJ4=";
                  stripRoot = false;
                };
                dontConfigure = true;
                dontBuild = true;
                nativeBuildInputs = [ pkgs.autoPatchelfHook ];
                buildInputs = [
                  pkgs.stdenv.cc.cc.lib
                  pkgs.zlib
                  pkgs.ocl-icd
                  pkgs.libxml2_13.out
                ];
                autoPatchelfIgnoreMissingDeps = [
                  "libcuda.so.1"
                  "libnvidia-ml.so.1"
                  "libcupti.so.12"
                  "libamdhip64.so.6"
                ];
                installPhase = ''
                  mkdir -p $out
                  mv ./* $out
                '';
              };
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
              unified-memory-framework = pkgs.stdenv.mkDerivation rec {
                pname = "unified-memory-framework";
                version = "1.1.0";

                src = pkgs.fetchFromGitHub {
                  owner = "oneapi-src";
                  repo = "unified-memory-framework";
                  rev = "v${version}";
                  hash = "sha256-1Z65rNsUNeaeSJmxwpEHPbiU4KEDvyrWL9LyAWFsR1c=";
                };

                nativeBuildInputs = [
                  pkgs.cmake
                ];

                buildInputs = [
                  pkgs.level-zero
                  pkgs.hwloc
                  pkgs.numactl
                  pkgs.onetbb
                ];

                cmakeFlags = [
                  "-DUMF_BUILD_SHARED_LIBRARY=ON"
                  "-DUMF_BUILD_LEVEL_ZERO_PROVIDER=ON"
                  "-DUMF_BUILD_CUDA_PROVIDER=OFF"

                  "-DUMF_BUILD_TESTS=OFF"
                  "-DUMF_BUILD_EXAMPLES=OFF"

                  "-DUMF_BUILD_LIBUMF_POOL_DISJOINT=ON"
                  "-DUMF_LEVEL_ZERO_INCLUDE_DIR=${pkgs.level-zero}/include/level_zero"
                ];

                postPatch = ''
                  substituteInPlace cmake/helpers.cmake \
                    --replace-fail "git describe --always" "echo ${src.rev}"
                '';
              };
              unified-runtime = pkgs.stdenv.mkDerivation {
                pname = "unified-runtime";
                version = "0.12.0";

                src = pkgs.fetchFromGitHub {
                  owner = "intel";
                  repo = "llvm";
                  rev = "186cbd82259adde987b3e614708c7a91401d7652";
                  hash = "sha256-0ySX7G2OE0WixbgO3/IlaQn6YYa8wCGjR1xq3ylbR/U=";
                };

                sourceRoot = "source/unified-runtime";

                postPatch = ''
                  substituteInPlace cmake/FetchOpenCL.cmake \
                      --replace-fail "NO_CMAKE_PACKAGE_REGISTRY" ""

                  rm test/adapters/hip/lit.cfg.py
                  rm test/adapters/cuda/lit.cfg.py

                  cat >> test/lit.cfg.py <<'EOF'
                  config.excludes.add('conformance')

                  config.excludes.add('asan.cpp')
                  config.excludes.add('loader_lifetime.test')
                  EOF
                '';

                nativeBuildInputs = [
                  pkgs.cmake
                  pkgs.ninja
                  pkgs.pkg-config
                  pkgs.python3
                ];

                buildInputs = [
                  pkgs.zlib
                  pkgs.hwloc
                  pkgs.libbacktrace
                  pkgs.hdrhistogram_c
                  pkgs.level-zero
                  pkgs.intel-compute-runtime
                  pkgs.opencl-headers
                  pkgs.ocl-icd

                  pkgs.gtest
                  pkgs.lit
                  pkgs.filecheck

                  unified-memory-framework
                ];

                preCheck = ''
                  export LD_LIBRARY_PATH="${pkgs.intel-compute-runtime.drivers}/lib''${LD_LIBRARY_PATH:+:$LD_LIBRARY_PATH}"
                '';

                cmakeFlags = [
                  (pkgs.lib.cmakeBool "FETCHCONTENT_FULLY_DISCONNECTED" true)
                  (pkgs.lib.cmakeBool "FETCHCONTENT_QUIET" false)
                  (pkgs.lib.cmakeBool "UR_ENABLE_LATENCY_HISTOGRAM" true)
                  (pkgs.lib.cmakeBool "UR_BUILD_TESTS" true)
                  (pkgs.lib.cmakeBool "UR_BUILD_EXAMPLES" true)
                  (pkgs.lib.cmakeBool "UR_BUILD_ADAPTER_L0" true)
                  (pkgs.lib.cmakeBool "UR_BUILD_ADAPTER_L0_V2" true)
                  (pkgs.lib.cmakeBool "UR_BUILD_ADAPTER_OPENCL" true)
                  (pkgs.lib.cmakeBool "UR_BUILD_ADAPTER_CUDA" false)
                  (pkgs.lib.cmakeBool "UR_BUILD_ADAPTER_HIP" false)
                  (pkgs.lib.cmakeBool "UR_BUILD_ADAPTER_NATIVE_CPU" false)
                  (pkgs.lib.cmakeFeature "UR_CONFORMANCE_SELECTOR" "native_cpu:*")
                ];
              };
              intel-pti = pkgs.stdenv.mkDerivation rec {
                pname = "intel-pti";
                version = "0.15.0";

                src = pkgs.fetchFromGitHub {
                  owner = "intel";
                  repo = "pti-gpu";
                  tag = "pti-${version}";
                  hash = "sha256-wBVSsCWh7oB7Hpthn4adQsHRJ98XnYCJWP0qrynrTAQ=";
                };

                sourceRoot = "source/sdk";

                nativeBuildInputs = [
                  pkgs.cmake
                  pkgs.pkg-config
                  pkgs.python3
                  pkgs.autoAddDriverRunpath
                ];

                buildInputs = [
                  (pkgs.level-zero.overrideAttrs (old: rec {
                    version = "1.24.2";
                    src = pkgs.fetchFromGitHub {
                      owner = "oneapi-src";
                      repo = "level-zero";
                      tag = "v${version}";
                      hash = "sha256-5QkXWuMFNsYNsW8lgo9FQIZ5NuLiRZCFKGWedpddi8Y=";
                    };
                  }))
                  pkgs.ocl-icd
                  pkgs.spdlog
                  unified-runtime
                ];

                cmakeFlags = [
                  "-DPTI_BUILD_TESTING=OFF"
                  "-DPTI_BUILD_SAMPLES=OFF"
                  "-DPTI_ENABLE_LOGGING=ON"
                ];
              };
            in
            (final: prev: {
              vllm = prev.vllm.overrideAttrs (old: {
                buildInputs = (old.buildInputs or [ ]) ++ [
                  pkgs.libipt
                ];

                env = (old.env or { }) // {
                  VLLM_TARGET_DEVICE = "xpu";
                  VLLM_VERSION_OVERRIDE = version;
                };
              });

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
                  intel-oneapi-openmp
                ];
                autoPatchelfIgnoreMissingDeps = (old.autoPatchelfIgnoreMissingDeps or [ ]) ++ [
                  "libefa.so.1"
                  "libibverbs.so.1"
                  "librdmacm.so.1"
                  "libucp.so.0"
                  "libpsm2.so.2"
                  "libpsm3-fi.so"
                  "libnuma.so.1"
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

            });
        };
    };
}
