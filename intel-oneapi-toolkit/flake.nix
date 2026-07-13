{
  description = "Intel oneAPI: intel-oneapi-toolkit and its Intel dependencies";

  inputs.nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";

  outputs =
    { self, nixpkgs }:
    let
      pkgs = nixpkgs.legacyPackages.x86_64-linux;
      lib = pkgs.lib;
    in
    {
      packages.x86_64-linux = rec {

        intel-oneapi-tlt-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-tlt-2026.0";
          version = "2026.0.0-220";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-tlt-2026.0-2026.0.0-220_amd64.deb";
            hash = "sha256-ks5emhQEQPqrZ/ADdIskG+oSFR64cdJQmXdbDfPJLRU=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-tlt-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-tlt-2026.0";
          paths = [
            intel-oneapi-tlt-2026_0_raw
          ];
        };

        intel-oneapi-tlt_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-tlt";
          version = "2026.0.0-220";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-tlt-2026.0.0-220_amd64.deb";
            hash = "sha256-2x1bjqnlWIuFB4iti9THMf7XMaZHluIQ7Nswv2CzSaE=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-tlt-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-tlt = pkgs.symlinkJoin {
          name = "intel-oneapi-tlt";
          paths = [
            intel-oneapi-tlt_raw
            intel-oneapi-tlt-2026_0
          ];
        };

        intel-oneapi-libdpstd-devel-2022_12_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-libdpstd-devel-2022.12";
          version = "2022.12.0-345";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-libdpstd-devel-2022.12-2022.12.0-345_amd64.deb";
            hash = "sha256-CTNeLmkHScy/uiVcvE2yXk6wDbaOaCHlVP3utImEAjs=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-libdpstd-devel-2022_12 = pkgs.symlinkJoin {
          name = "intel-oneapi-libdpstd-devel-2022.12";
          paths = [
            intel-oneapi-libdpstd-devel-2022_12_raw
          ];
        };

        intel-oneapi-tcm-1_5_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-tcm-1.5";
          version = "1.5.0-489";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-tcm-1.5-1.5.0-489_amd64.deb";
            hash = "sha256-cSLtd0jVQ0KyTwooOKZPJLVOQwrE0GspYaju/uT/sIk=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            pkgs.stdenv.cc.cc.lib
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-tcm-1_5 = pkgs.symlinkJoin {
          name = "intel-oneapi-tcm-1.5";
          paths = [
            intel-oneapi-tcm-1_5_raw
          ];
        };

        intel-oneapi-tbb-2023_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-tbb-2023.0";
          version = "2023.0.0-724";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-tbb-2023.0-2023.0.0-724_amd64.deb";
            hash = "sha256-9DnrjeRA8Lc5O3Z+nEi/YUpNawwGCTbNLe9XlqyWHYo=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-tcm-1_5
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-tbb-2023_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-tbb-2023.0";
          paths = [
            intel-oneapi-tbb-2023_0_raw
            intel-oneapi-tcm-1_5
          ];
        };

        intel-oneapi-tbb-devel-2023_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-tbb-devel-2023.0";
          version = "2023.0.0-724";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-tbb-devel-2023.0-2023.0.0-724_amd64.deb";
            hash = "sha256-gG8bPE1qSpYenEl97gFS1ge7sDo6Bys/jMHQmwW8gHk=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-tbb-2023_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-tbb-devel-2023_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-tbb-devel-2023.0";
          paths = [
            intel-oneapi-tbb-devel-2023_0_raw
            intel-oneapi-tbb-2023_0
          ];
        };

        intel-oneapi-tbb-devel_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-tbb-devel";
          version = "2023.0.0-724";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-tbb-devel-2023.0.0-724_amd64.deb";
            hash = "sha256-DL4pGKViQK5EJIZIUh9/1xVw7bBgQK15+IVtyM3tzHE=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-tbb-devel-2023_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-tbb-devel = pkgs.symlinkJoin {
          name = "intel-oneapi-tbb-devel";
          paths = [
            intel-oneapi-tbb-devel_raw
            intel-oneapi-tbb-devel-2023_0
          ];
        };

        intel-oneapi-mpi-2021_18_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mpi-2021.18";
          version = "2021.18.0-745";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mpi-2021.18-2021.18.0-745_amd64.deb";
            hash = "sha256-Du1hpDWI/K7GTHsJ9r2AnFInAI5QHQ4SMUiPvSHqxRs=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            pkgs.stdenv.cc.cc.lib
            pkgs.level-zero
            intel-oneapi-openmp-2026_0
          ];
          autoPatchelfIgnoreMissingDeps = [
            "libcuda.so.1" # dynamically loaded at runtime depending on hardware
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mpi-2021_18 = pkgs.symlinkJoin {
          name = "intel-oneapi-mpi-2021.18";
          paths = [
            intel-oneapi-mpi-2021_18_raw
          ];
        };

        intel-oneapi-mpi-devel-2021_18_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mpi-devel-2021.18";
          version = "2021.18.0-745";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mpi-devel-2021.18-2021.18.0-745_amd64.deb";
            hash = "sha256-LVUTl8WeNhwkZoX4CXGzpCrSsRe3IwPNM8O44DsBnlA=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mpi-2021_18
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mpi-devel-2021_18 = pkgs.symlinkJoin {
          name = "intel-oneapi-mpi-devel-2021.18";
          paths = [
            intel-oneapi-mpi-devel-2021_18_raw
            intel-oneapi-mpi-2021_18
          ];
        };

        intel-oneapi-ccl-2022_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-ccl-2022.0";
          version = "2022.0.0-49301";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-ccl-2022.0-2022.0.0-49301_amd64.deb";
            hash = "sha256-EAMDT+q6zAMqYFS0Znlg99qC3zePt6MxlWv8jBBqTWA=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mpi-2021_18
            pkgs.stdenv.cc.cc.lib
            pkgs.libfabric
            intel-oneapi-runtime-compilers
            intel-oneapi-compiler-dpcpp-cpp
            intel-oneapi-openmp-2026_0
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-ccl-2022_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-ccl-2022.0";
          paths = [
            intel-oneapi-ccl-2022_0_raw
            intel-oneapi-mpi-2021_18
          ];
        };

        intel-oneapi-ccl-devel-2022_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-ccl-devel-2022.0";
          version = "2022.0.0-49301";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-ccl-devel-2022.0-2022.0.0-49301_amd64.deb";
            hash = "sha256-BiyS3RzchCt7GDR+MGgw4QDM4mPDVOtvPViqcb/VTW4=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mpi-devel-2021_18
            intel-oneapi-ccl-2022_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-ccl-devel-2022_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-ccl-devel-2022.0";
          paths = [
            intel-oneapi-ccl-devel-2022_0_raw
            intel-oneapi-mpi-devel-2021_18
            intel-oneapi-ccl-2022_0
          ];
        };

        intel-oneapi-ccl-devel_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-ccl-devel";
          version = "2022.0.0-49301";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-ccl-devel-2022.0.0-49301_amd64.deb";
            hash = "sha256-1FnlsXc5xdksJ+foPQVsKVi8zuB6keMStqAeY5x9AjE=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-ccl-devel-2022_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-ccl-devel = pkgs.symlinkJoin {
          name = "intel-oneapi-ccl-devel";
          paths = [
            intel-oneapi-ccl-devel_raw
            intel-oneapi-ccl-devel-2022_0
          ];
        };

        intel-oneapi-umf-1_1_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-umf-1.1";
          version = "1.1.0-340";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-umf-1.1-1.1.0-340_amd64.deb";
            hash = "sha256-hwWplwQsdvZyKLQTUYR1ThzT+PaLZim8smHB1blYzng=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-tcm-1_5
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-umf-1_1 = pkgs.symlinkJoin {
          name = "intel-oneapi-umf-1.1";
          paths = [
            intel-oneapi-umf-1_1_raw
            intel-oneapi-tcm-1_5
          ];
        };

        intel-oneapi-openmp-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-openmp-2026.0";
          version = "2026.0.0-947";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-openmp-2026.0-2026.0.0-947_amd64.deb";
            hash = "sha256-OpzogcQ529gVCufzLaAte5grz6bv9nlXTo8FrY0sD1c=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-umf-1_1
            pkgs.zlib
            intel-sycl
            intel-oneapi-runtime-compilers
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-openmp-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-openmp-2026.0";
          paths = [
            intel-oneapi-openmp-2026_0_raw
            intel-oneapi-umf-1_1
          ];
        };

        intel-oneapi-compiler-shared-runtime-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-compiler-shared-runtime-2026.0";
          version = "2026.0.0-947";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-compiler-shared-runtime-2026.0-2026.0.0-947_amd64.deb";
            hash = "sha256-A1fITXPO4K+NTGgr2ykJCL+EKIXowkk28+flgVnpdF4=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            # intel-oneapi-openmp-2026_0
            pkgs.libz
            pkgs.onetbb
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-compiler-shared-runtime-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-compiler-shared-runtime-2026.0";
          paths = [
            intel-oneapi-compiler-shared-runtime-2026_0_raw
            #intel-oneapi-openmp-2026_0
          ];
        };

        intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-compiler-dpcpp-cpp-runtime-2026.0";
          version = "2026.0.0-947";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-compiler-dpcpp-cpp-runtime-2026.0-2026.0.0-947_amd64.deb";
            hash = "sha256-t9uDositBqtfCA+17HxbAENTFX+SwN25rz7OBCLZokk=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-compiler-shared-runtime-2026_0
            intel-oneapi-tbb-2023_0
            intel-oneapi-umf-1_1
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-compiler-dpcpp-cpp-runtime-2026.0";
          paths = [
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0_raw
            intel-oneapi-compiler-shared-runtime-2026_0
            intel-oneapi-tbb-2023_0
            intel-oneapi-umf-1_1
          ];
        };

        intel-oneapi-dpcpp-debugger-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-dpcpp-debugger-2026.0";
          version = "2026.0.0-220";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-dpcpp-debugger-2026.0-2026.0.0-220_amd64.deb";
            hash = "sha256-0k/cXDWROJCjnAyIRyFSqw7VMIGKp2byw/ozVyhgYKk=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            pkgs.stdenv.cc.cc.lib
            pkgs.zlib
            pkgs.level-zero
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-dpcpp-debugger-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-dpcpp-debugger-2026.0";
          paths = [
            intel-oneapi-dpcpp-debugger-2026_0_raw
          ];
        };

        intel-oneapi-compiler-shared-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-compiler-shared-2026.0";
          version = "2026.0.0-947";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-compiler-shared-2026.0-2026.0.0-947_amd64.deb";
            hash = "sha256-Z79Guv82dVrtIxOBxfW4peWwpLmmFwysPrvhKb02q/k=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-compiler-shared-runtime-2026_0
            intel-oneapi-dpcpp-debugger-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-compiler-shared-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-compiler-shared-2026.0";
          paths = [
            intel-oneapi-compiler-shared-2026_0_raw
            intel-oneapi-compiler-shared-runtime-2026_0
            intel-oneapi-dpcpp-debugger-2026_0
          ];
        };

        intel-oneapi-dev-utilities-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-dev-utilities-2026.0";
          version = "2026.0.0-230";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-dev-utilities-2026.0-2026.0.0-230_amd64.deb";
            hash = "sha256-/IEWE1etbjabP556OEkk5Ub2QIiimR4DgQQ+cY/oBVA=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-dev-utilities-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-dev-utilities-2026.0";
          paths = [
            intel-oneapi-dev-utilities-2026_0_raw
          ];
        };

        intel-oneapi-dpcpp-cpp-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-dpcpp-cpp-2026.0";
          version = "2026.0.0-947";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-dpcpp-cpp-2026.0-2026.0.0-947_amd64.deb";
            hash = "sha256-/6X8nw5/c8P0QlTQMClv3Ci1ifUVkjVC9zldlHGFdSg=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
            intel-oneapi-compiler-shared-2026_0
            intel-oneapi-tbb-devel-2023_0
            intel-oneapi-dev-utilities-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-dpcpp-cpp-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-dpcpp-cpp-2026.0";
          paths = [
            intel-oneapi-dpcpp-cpp-2026_0_raw
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
            intel-oneapi-compiler-shared-2026_0
            intel-oneapi-tbb-devel-2023_0
            intel-oneapi-dev-utilities-2026_0
          ];
        };

        intel-oneapi-compiler-dpcpp-cpp-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-compiler-dpcpp-cpp-2026.0";
          version = "2026.0.0-947";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-compiler-dpcpp-cpp-2026.0-2026.0.0-947_amd64.deb";
            hash = "sha256-3+Z654SuEUOoWLQf8/d6uaUS6qU+zbsqDq0/xAU1EMc=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-dpcpp-cpp-2026_0
            intel-oneapi-libdpstd-devel-2022_12
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-compiler-dpcpp-cpp-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-compiler-dpcpp-cpp-2026.0";
          paths = [
            intel-oneapi-compiler-dpcpp-cpp-2026_0_raw
            intel-oneapi-dpcpp-cpp-2026_0
            intel-oneapi-libdpstd-devel-2022_12
          ];
        };

        intel-oneapi-compiler-dpcpp-cpp_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-compiler-dpcpp-cpp";
          version = "2026.0.0-947";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-compiler-dpcpp-cpp-2026.0.0-947_amd64.deb";
            hash = "sha256-Xv/bKeu/ryloswe2P+mOFy7hcfK/tZ0iGZY25wl5DiA=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-compiler-dpcpp-cpp-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-compiler-dpcpp-cpp = pkgs.symlinkJoin {
          name = "intel-oneapi-compiler-dpcpp-cpp";
          paths = [
            intel-oneapi-compiler-dpcpp-cpp_raw
            intel-oneapi-compiler-dpcpp-cpp-2026_0
          ];
        };

        intel-oneapi-compiler-fortran-runtime-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-compiler-fortran-runtime-2026.0";
          version = "2026.0.0-947";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-compiler-fortran-runtime-2026.0-2026.0.0-947_amd64.deb";
            hash = "sha256-aF5EjkYXwMBTV7CDyd4TnNsk7rkX2H3rMYiTvxrmUio=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-compiler-shared-runtime-2026_0
            intel-oneapi-mpi-2021_18
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-compiler-fortran-runtime-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-compiler-fortran-runtime-2026.0";
          paths = [
            intel-oneapi-compiler-fortran-runtime-2026_0_raw
            intel-oneapi-compiler-shared-runtime-2026_0
          ];
        };

        intel-oneapi-compiler-fortran-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-compiler-fortran-2026.0";
          version = "2026.0.0-947";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-compiler-fortran-2026.0-2026.0.0-947_amd64.deb";
            hash = "sha256-s4aOvcso7wtn7KMIGoU3sb9E8geTBQ0nZ1IIiW0goRc=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mpi-2021_18
            intel-oneapi-compiler-shared-2026_0
            intel-oneapi-compiler-fortran-runtime-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-compiler-fortran-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-compiler-fortran-2026.0";
          paths = [
            intel-oneapi-compiler-fortran-2026_0_raw
            intel-oneapi-mpi-2021_18
            intel-oneapi-compiler-shared-2026_0
            intel-oneapi-compiler-fortran-runtime-2026_0
          ];
        };

        intel-oneapi-ipp-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-ipp-2026.0";
          version = "2026.0.0-717";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-ipp-2026.0-2026.0.0-717_amd64.deb";
            hash = "sha256-JbPhEdfab2YkNa5Ho1A6ZszG3guFvXVyXKg9jX1VuX4=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-tbb-2023_0
            intel-oneapi-openmp-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-ipp-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-ipp-2026.0";
          paths = [
            intel-oneapi-ipp-2026_0_raw
            intel-oneapi-tbb-2023_0
            intel-oneapi-openmp-2026_0
          ];
        };

        intel-oneapi-ipp-devel-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-ipp-devel-2026.0";
          version = "2026.0.0-717";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-ipp-devel-2026.0-2026.0.0-717_amd64.deb";
            hash = "sha256-iBzhR9En0U7WBulMPKnszZQ3u62aTW94HQOHr47cJF8=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-ipp-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-ipp-devel-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-ipp-devel-2026.0";
          paths = [
            intel-oneapi-ipp-devel-2026_0_raw
            intel-oneapi-ipp-2026_0
          ];
        };

        intel-oneapi-ipp-devel_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-ipp-devel";
          version = "2026.0.0-717";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-ipp-devel-2026.0.0-717_amd64.deb";
            hash = "sha256-/h0xixrMFWf9T1XM2i852x/67Q53779U+jddlQ/M3nw=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-ipp-devel-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-ipp-devel = pkgs.symlinkJoin {
          name = "intel-oneapi-ipp-devel";
          paths = [
            intel-oneapi-ipp-devel_raw
            intel-oneapi-ipp-devel-2026_0
          ];
        };

        intel-oneapi-ippcp-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-ippcp-2026.0";
          version = "2026.0.0-471";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-ippcp-2026.0-2026.0.0-471_amd64.deb";
            hash = "sha256-UaKU9pEWmlHUPMPriGxKd5ZZzTDwes4gAbqIac4WSfM=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            pkgs.openssl
            intel-oneapi-runtime-compilers
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-ippcp-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-ippcp-2026.0";
          paths = [
            intel-oneapi-ippcp-2026_0_raw
          ];
        };

        intel-oneapi-ippcp-devel-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-ippcp-devel-2026.0";
          version = "2026.0.0-471";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-ippcp-devel-2026.0-2026.0.0-471_amd64.deb";
            hash = "sha256-ySYaKUrTkEBOId2aRQYGOGo0M0Q/YiA3LUhS8rkMcls=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-ippcp-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-ippcp-devel-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-ippcp-devel-2026.0";
          paths = [
            intel-oneapi-ippcp-devel-2026_0_raw
            intel-oneapi-ippcp-2026_0
          ];
        };

        intel-oneapi-ippcp-devel_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-ippcp-devel";
          version = "2026.0.0-471";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-ippcp-devel-2026.0.0-471_amd64.deb";
            hash = "sha256-/Q4ZoO8JmW1Bay1MlR19WATphmzcism7SRb0nI97R78=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-ippcp-devel-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-ippcp-devel = pkgs.symlinkJoin {
          name = "intel-oneapi-ippcp-devel";
          paths = [
            intel-oneapi-ippcp-devel_raw
            intel-oneapi-ippcp-devel-2026_0
          ];
        };

        intel-oneapi-mkl-classic-include-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-classic-include-2026.0";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-classic-include-2026.0-2026.0.0-908_amd64.deb";
            hash = "sha256-xt8qgNREc2A3/kT09oHPBKhXWc9m9nVrE4ZPTxrPJr4=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mkl-classic-include-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-classic-include-2026.0";
          paths = [
            intel-oneapi-mkl-classic-include-2026_0_raw
          ];
        };

        intel-oneapi-mkl-sycl-include-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-sycl-include-2026.0";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-sycl-include-2026.0-2026.0.0-908_amd64.deb";
            hash = "sha256-4w4eFK4yvRgk7Si+F46oiSHCca1yq38eK5IU3J0t5xk=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mkl-classic-include-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mkl-sycl-include-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-sycl-include-2026.0";
          paths = [
            intel-oneapi-mkl-sycl-include-2026_0_raw
            intel-oneapi-mkl-classic-include-2026_0
          ];
        };

        intel-oneapi-mkl-core-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-core-2026.0";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-core-2026.0-2026.0.0-908_amd64.deb";
            hash = "sha256-PMWICE6YIK8jfJDbpMFUblDy1+AqFdAHJQTtTM92TsA=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-tbb-2023_0
            intel-oneapi-openmp-2026_0
            intel-oneapi-mpi-2021_18
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mkl-core-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-core-2026.0";
          paths = [
            intel-oneapi-mkl-core-2026_0_raw
            intel-oneapi-tbb-2023_0
            intel-oneapi-openmp-2026_0
          ];
        };

        intel-oneapi-mkl-sycl-blas-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-sycl-blas-2026.0";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-sycl-blas-2026.0-2026.0.0-908_amd64.deb";
            hash = "sha256-syB48YBasSb3gzMna7hg8ojTonhdwQG0ud9JnNNfp20=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mkl-core-2026_0
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mkl-sycl-blas-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-sycl-blas-2026.0";
          paths = [
            intel-oneapi-mkl-sycl-blas-2026_0_raw
            intel-oneapi-mkl-core-2026_0
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
          ];
        };

        intel-oneapi-mkl-sycl-lapack-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-sycl-lapack-2026.0";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-sycl-lapack-2026.0-2026.0.0-908_amd64.deb";
            hash = "sha256-WjHSIvpSfJa9eqi7x4GaEUF8x+a6OIA7VeIkVBqraMM=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mkl-sycl-blas-2026_0
            intel-oneapi-mkl-core-2026_0
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mkl-sycl-lapack-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-sycl-lapack-2026.0";
          paths = [
            intel-oneapi-mkl-sycl-lapack-2026_0_raw
            intel-oneapi-mkl-sycl-blas-2026_0
            intel-oneapi-mkl-core-2026_0
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
          ];
        };

        intel-oneapi-mkl-sycl-dft-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-sycl-dft-2026.0";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-sycl-dft-2026.0-2026.0.0-908_amd64.deb";
            hash = "sha256-5BaO0fzjXhlVISX9wnvOCCDnNI60KEL0Nz8F9/xfNjU=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mkl-core-2026_0
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mkl-sycl-dft-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-sycl-dft-2026.0";
          paths = [
            intel-oneapi-mkl-sycl-dft-2026_0_raw
            intel-oneapi-mkl-core-2026_0
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
          ];
        };

        intel-oneapi-mkl-sycl-sparse-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-sycl-sparse-2026.0";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-sycl-sparse-2026.0-2026.0.0-908_amd64.deb";
            hash = "sha256-FVJ4LvytFBKAZm8F21mDz87E4JSldnIXB4bHteH/X5w=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mkl-sycl-blas-2026_0
            intel-oneapi-mkl-core-2026_0
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mkl-sycl-sparse-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-sycl-sparse-2026.0";
          paths = [
            intel-oneapi-mkl-sycl-sparse-2026_0_raw
            intel-oneapi-mkl-sycl-blas-2026_0
            intel-oneapi-mkl-core-2026_0
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
          ];
        };

        intel-oneapi-mkl-sycl-vm-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-sycl-vm-2026.0";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-sycl-vm-2026.0-2026.0.0-908_amd64.deb";
            hash = "sha256-XVGdX+CkzfbNaJ7qT5fxvb6z7tHVCNRkhqV/By9jPNY=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mkl-core-2026_0
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mkl-sycl-vm-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-sycl-vm-2026.0";
          paths = [
            intel-oneapi-mkl-sycl-vm-2026_0_raw
            intel-oneapi-mkl-core-2026_0
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
          ];
        };

        intel-oneapi-mkl-sycl-rng-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-sycl-rng-2026.0";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-sycl-rng-2026.0-2026.0.0-908_amd64.deb";
            hash = "sha256-rmkQzWImqaOA34RoSSiL8Hxe2gOHiWuQggz5BKKe5KA=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mkl-core-2026_0
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mkl-sycl-rng-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-sycl-rng-2026.0";
          paths = [
            intel-oneapi-mkl-sycl-rng-2026_0_raw
            intel-oneapi-mkl-core-2026_0
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
          ];
        };

        intel-oneapi-mkl-sycl-stats-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-sycl-stats-2026.0";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-sycl-stats-2026.0-2026.0.0-908_amd64.deb";
            hash = "sha256-8Trvx7LH1SIkKPK4whQM5eHnDPY1OG+tz5M4+RRo3Hc=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mkl-core-2026_0
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mkl-sycl-stats-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-sycl-stats-2026.0";
          paths = [
            intel-oneapi-mkl-sycl-stats-2026_0_raw
            intel-oneapi-mkl-core-2026_0
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
          ];
        };

        intel-oneapi-mkl-sycl-data-fitting-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-sycl-data-fitting-2026.0";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-sycl-data-fitting-2026.0-2026.0.0-908_amd64.deb";
            hash = "sha256-2EsOI1HIot47UDYA5gS++2iQQaVh1HAsd7QGmazy6JE=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mkl-core-2026_0
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mkl-sycl-data-fitting-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-sycl-data-fitting-2026.0";
          paths = [
            intel-oneapi-mkl-sycl-data-fitting-2026_0_raw
            intel-oneapi-mkl-core-2026_0
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
          ];
        };

        intel-oneapi-mkl-sycl-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-sycl-2026.0";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-sycl-2026.0-2026.0.0-908_amd64.deb";
            hash = "sha256-d2xP9NId5n2UvUoo5Marye0kx4sSS/2zIr32vI5jxBs=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mkl-sycl-blas-2026_0
            intel-oneapi-mkl-sycl-lapack-2026_0
            intel-oneapi-mkl-sycl-dft-2026_0
            intel-oneapi-mkl-sycl-sparse-2026_0
            intel-oneapi-mkl-sycl-vm-2026_0
            intel-oneapi-mkl-sycl-rng-2026_0
            intel-oneapi-mkl-sycl-stats-2026_0
            intel-oneapi-mkl-sycl-data-fitting-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mkl-sycl-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-sycl-2026.0";
          paths = [
            intel-oneapi-mkl-sycl-2026_0_raw
            intel-oneapi-mkl-sycl-blas-2026_0
            intel-oneapi-mkl-sycl-lapack-2026_0
            intel-oneapi-mkl-sycl-dft-2026_0
            intel-oneapi-mkl-sycl-sparse-2026_0
            intel-oneapi-mkl-sycl-vm-2026_0
            intel-oneapi-mkl-sycl-rng-2026_0
            intel-oneapi-mkl-sycl-stats-2026_0
            intel-oneapi-mkl-sycl-data-fitting-2026_0
          ];
        };

        intel-oneapi-mkl-core-devel-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-core-devel-2026.0";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-core-devel-2026.0-2026.0.0-908_amd64.deb";
            hash = "sha256-XA0Tw2hJ/VjCGXWVDhNDzZdwt9gfx/Js6+4JNly/jSE=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mkl-core-2026_0
            intel-oneapi-mkl-classic-include-2026_0
            intel-oneapi-mpi-2021_18
            intel-oneapi-compiler-dpcpp-cpp
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';

          postFixup = ''
            rm "$out/include/intel64" # broken symlink
          '';
        };

        intel-oneapi-mkl-core-devel-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-core-devel-2026.0";
          paths = [
            intel-oneapi-mkl-core-devel-2026_0_raw
            intel-oneapi-mkl-core-2026_0
            intel-oneapi-mkl-classic-include-2026_0
          ];
        };

        intel-oneapi-mkl-sycl-devel-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-sycl-devel-2026.0";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-sycl-devel-2026.0-2026.0.0-908_amd64.deb";
            hash = "sha256-CKX5lBNgsh3EqT3ywHHRd4simpkyvf31PEvvX/OZnqs=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mkl-sycl-include-2026_0
            intel-oneapi-mkl-sycl-2026_0
            intel-oneapi-mkl-core-devel-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mkl-sycl-devel-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-sycl-devel-2026.0";
          paths = [
            intel-oneapi-mkl-sycl-devel-2026_0_raw
            intel-oneapi-mkl-sycl-include-2026_0
            intel-oneapi-mkl-sycl-2026_0
            intel-oneapi-mkl-core-devel-2026_0
          ];
        };

        intel-oneapi-mkl-cluster-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-cluster-2026.0";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-cluster-2026.0-2026.0.0-908_amd64.deb";
            hash = "sha256-MUZykjgAi64CSGvSSUP/0LkgCVBs5qPq3kFq+Tlkruk=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mkl-core-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mkl-cluster-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-cluster-2026.0";
          paths = [
            intel-oneapi-mkl-cluster-2026_0_raw
            intel-oneapi-mkl-core-2026_0
          ];
        };

        intel-oneapi-mkl-cluster-devel-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-cluster-devel-2026.0";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-cluster-devel-2026.0-2026.0.0-908_amd64.deb";
            hash = "sha256-7V1+lvuty36CwI5CqklX1W9aqpMM1vG6yTQrl9bsbRQ=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mkl-core-devel-2026_0
            intel-oneapi-mkl-cluster-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mkl-cluster-devel-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-cluster-devel-2026.0";
          paths = [
            intel-oneapi-mkl-cluster-devel-2026_0_raw
            intel-oneapi-mkl-core-devel-2026_0
            intel-oneapi-mkl-cluster-2026_0
          ];
        };

        intel-oneapi-mkl-classic-devel-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-classic-devel-2026.0";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-classic-devel-2026.0-2026.0.0-908_amd64.deb";
            hash = "sha256-/EdT2HNbMjTKdccLhwfBr1Hly+H83StguX9KvzSVw4A=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mkl-classic-include-2026_0
            intel-oneapi-mkl-core-devel-2026_0
            intel-oneapi-mkl-cluster-devel-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mkl-classic-devel-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-classic-devel-2026.0";
          paths = [
            intel-oneapi-mkl-classic-devel-2026_0_raw
            intel-oneapi-mkl-classic-include-2026_0
            intel-oneapi-mkl-core-devel-2026_0
            intel-oneapi-mkl-cluster-devel-2026_0
          ];
        };

        intel-oneapi-mkl-devel-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-devel-2026.0";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-devel-2026.0-2026.0.0-908_amd64.deb";
            hash = "sha256-kisGhYL0AzNcwaRo+YzUFfoFKnKqeRiOunv+h9El1Lo=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mkl-sycl-devel-2026_0
            intel-oneapi-mkl-classic-devel-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mkl-devel-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-devel-2026.0";
          paths = [
            intel-oneapi-mkl-devel-2026_0_raw
            intel-oneapi-mkl-sycl-devel-2026_0
            intel-oneapi-mkl-classic-devel-2026_0
          ];
        };

        intel-oneapi-mkl-devel_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mkl-devel";
          version = "2026.0.0-908";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mkl-devel-2026.0.0-908_amd64.deb";
            hash = "sha256-3SwnlIszJ6v4hhvwIGXpSeCrlAWPsjq/7eIAf/i9vlk=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mkl-devel-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mkl-devel = pkgs.symlinkJoin {
          name = "intel-oneapi-mkl-devel";
          paths = [
            intel-oneapi-mkl-devel_raw
            intel-oneapi-mkl-devel-2026_0
          ];
        };

        intel-oneapi-vtune_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-vtune";
          version = "2026.0.0-325";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-vtune-2026.0.0-325_amd64.deb";
            hash = "sha256-O4E7Qr/1lfkjvj1ycpLMbn/VM1hxdZOpV+u+N/FmY9o=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-vtune = pkgs.symlinkJoin {
          name = "intel-oneapi-vtune";
          paths = [
            intel-oneapi-vtune_raw
          ];
        };

        intel-oneapi-dnnl-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-dnnl-2026.0";
          version = "2026.0.0-688";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-dnnl-2026.0-2026.0.0-688_amd64.deb";
            hash = "sha256-gNtlTnxlqt6rMOkstyTkNgTJ395H0efFrn7d8g8L38M=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-tbb-2023_0
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-dnnl-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-dnnl-2026.0";
          paths = [
            intel-oneapi-dnnl-2026_0_raw
            intel-oneapi-tbb-2023_0
            intel-oneapi-compiler-dpcpp-cpp-runtime-2026_0
          ];
        };

        intel-oneapi-dnnl-devel-2026_0_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-dnnl-devel-2026.0";
          version = "2026.0.0-688";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-dnnl-devel-2026.0-2026.0.0-688_amd64.deb";
            hash = "sha256-vdp4+Pvnq6vKRnBZyf5TLWkklsV86lMgj8h0epNJwos=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-dnnl-2026_0
            intel-oneapi-tbb-devel-2023_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-dnnl-devel-2026_0 = pkgs.symlinkJoin {
          name = "intel-oneapi-dnnl-devel-2026.0";
          paths = [
            intel-oneapi-dnnl-devel-2026_0_raw
            intel-oneapi-dnnl-2026_0
            intel-oneapi-tbb-devel-2023_0
          ];
        };

        intel-oneapi-dnnl-devel_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-dnnl-devel";
          version = "2026.0.0-688";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-dnnl-devel-2026.0.0-688_amd64.deb";
            hash = "sha256-DLOT7FyZLpjPeF2GtsU+4uF3T7kXh8o0l+es2jI60ps=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-dnnl-devel-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-dnnl-devel = pkgs.symlinkJoin {
          name = "intel-oneapi-dnnl-devel";
          paths = [
            intel-oneapi-dnnl-devel_raw
            intel-oneapi-dnnl-devel-2026_0
          ];
        };

        intel-oneapi-dev-utilities_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-dev-utilities";
          version = "2026.0.0-230";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-dev-utilities-2026.0.0-230_amd64.deb";
            hash = "sha256-ewXetC5IAbvg1AJMBQvH0D0gGHkbPyYg70kzg+jBptE=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-dev-utilities-2026_0
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-dev-utilities = pkgs.symlinkJoin {
          name = "intel-oneapi-dev-utilities";
          paths = [
            intel-oneapi-dev-utilities_raw
            intel-oneapi-dev-utilities-2026_0
          ];
        };

        intel-oneapi-mpi-devel_raw = pkgs.stdenv.mkDerivation {
          pname = "intel-oneapi-mpi-devel";
          version = "2021.18.0-745";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/intel-oneapi-mpi-devel-2021.18.0-745_amd64.deb";
            hash = "sha256-n9oeHzd9kPTh74jKRqKjuOJ7zxqyOKhH+21oz10NwWo=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            intel-oneapi-mpi-devel-2021_18
            # TODO: add non-Intel buildInputs (e.g. pkgs.zlib)
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

        intel-oneapi-mpi-devel = pkgs.symlinkJoin {
          name = "intel-oneapi-mpi-devel";
          paths = [
            intel-oneapi-mpi-devel_raw
            intel-oneapi-mpi-devel-2021_18
          ];
        };

        intel-oneapi-toolkit = pkgs.symlinkJoin {
          name = "intel-oneapi-toolkit";
          paths = [
            intel-oneapi-tlt
            intel-oneapi-libdpstd-devel-2022_12
            intel-oneapi-tbb-devel
            intel-oneapi-ccl-devel
            intel-oneapi-compiler-dpcpp-cpp
            intel-oneapi-compiler-fortran-2026_0
            intel-oneapi-ipp-devel
            intel-oneapi-ippcp-devel
            intel-oneapi-mkl-devel
            intel-oneapi-vtune
            intel-oneapi-dnnl-devel
            intel-oneapi-dev-utilities
            intel-oneapi-mpi-devel
          ];
        };

        default = intel-oneapi-toolkit;

        intel-oneapi-runtime-compilers = pkgs.stdenv.mkDerivation rec {
          pname = "intel-oneapi-runtime-compilers";
          version = "2026.0.0-947";

          src = pkgs.fetchurl {
            url = "https://apt.repos.intel.com/oneapi/pool/main/${pname}-${version}_amd64.deb";
            hash = "sha256-jNkKsTGZWXqtAt6Wq12lY+8YQ/3S/V/+TbEqxGLNdEI=";
          };

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            pkgs.stdenv.cc.cc.lib
            pkgs.libz
          ];

          dontConfigure = true;
          dontBuild = true;

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p "$out"
            for dir in lib share include bin; do
              while IFS= read -r found; do
                [ -d "$found" ] || continue
                mkdir -p "$out/$dir"
                rsync -a "$found"/ "$out/$dir"/
              done < <(find . -mindepth 2 -maxdepth 8 -type d -name "$dir" 2>/dev/null)
            done
          '';
        };

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

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
          ];

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

        unified-memory-framework = pkgs.stdenv.mkDerivation rec {
          pname = "unified-memory-framework";
          version = "1.1.0";

          src = pkgs.fetchFromGitHub {
            owner = "oneapi-src";
            repo = "unified-memory-framework";
            tag = "v${version}";
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

        unified-runtime = pkgs.intel-llvm.unified-runtime;

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

        intel-ocloc = pkgs.stdenv.mkDerivation rec {
          name = "intel-ocloc";
          version = "26.18.38308.1";

          src = pkgs.fetchurl {
            url = "https://github.com/intel/compute-runtime/releases/download/${version}/${name}_${version}-0_amd64.deb";
            hash = "sha256-82y4pomTU8YcxyYbZQ8of0plKsrarYWRA738Ufk7boo=";
          };

          dontConfigure = true;
          dontBuild = true;

          nativeBuildInputs = [
            pkgs.autoPatchelfHook
            pkgs.dpkg
            pkgs.rsync
          ];

          buildInputs = [
            pkgs.stdenv.cc.cc.lib
          ];

          unpackPhase = "dpkg -x $src ./";

          installPhase = ''
            mkdir -p $out/{bin,lib}
            mv ./usr/bin/ocloc-26.18.1 $out/bin/ocloc
            mv ./usr/lib/x86_64-linux-gnu/libocloc.so $out/lib
          '';
        };
      };
    };
}
