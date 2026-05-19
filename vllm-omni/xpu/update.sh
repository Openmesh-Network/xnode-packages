#!/usr/bin/env nix
#!nix shell nixpkgs#uv nixpkgs#stdenv.cc.cc.lib --command bash
set -e

VERSION=0.21.0rc1
LD_LIBRARY_PATH="/nix/store/ihpdbhy4rfxaixiamyb588zfc3vj19al-gcc-15.2.0-lib/lib"

git clone https://github.com/vllm-project/vllm-omni
cd vllm-omni
git checkout "v${VERSION}"

uv venv

uv pip install setuptools_scm
uv pip install -v -r requirements/xpu.txt --extra-index-url https://pypi.org/simple --extra-index-url https://download.pytorch.org/whl/xpu --index-strategy unsafe-best-match

VLLM_OMNI_TARGET_DEVICE=xpu VLLM_OMNI_VERSION_OVERRIDE="v${VERSION}" uv pip install --no-build-isolation -e . -v --extra-index-url https://pypi.org/simple --extra-index-url https://download.pytorch.org/whl/xpu --index-strategy unsafe-best-match

uv lock --extra-index-url https://pypi.org/simple --extra-index-url https://download.pytorch.org/whl/xpu --index-strategy unsafe-best-match

sed -i 's/{ name = "triton"/{ name = "triton-xpu"/' uv.lock
echo "Manually add optional audio deps of vllm into main required deps"
echo "Manually fix any missing hashes"
sed -i '/\[\[package\]\]$/ { N; N; N; s/\[\[package\]\]\nname = "vllm-omni"\nsource = { editable = "\." }\ndependencies = \[/[[package]]\nname = "vllm"\nversion = "0.21.0"\nsource = { registry = "https:\/\/pypi.org\/simple" }\n\n[[package]]\nname = "vllm-omni"\nsource = { editable = "." }\ndependencies = [\n    { name = "vllm" },\n    { name = "audioop-lts" },/; }' uv.lock

cd ..
mv ./vllm-omni/uv.lock .
rm -rf vllm-omni