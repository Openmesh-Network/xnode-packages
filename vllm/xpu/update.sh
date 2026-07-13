#!/usr/bin/env bash
set -e

VERSION=0.25.0

git clone https://github.com/vllm-project/vllm
cd vllm
git checkout "v${VERSION}"

uv venv

uv pip install -v -r requirements/xpu.txt --extra-index-url https://pypi.org/simple --extra-index-url https://download.pytorch.org/whl/xpu --index-strategy unsafe-best-match

VLLM_TARGET_DEVICE=xpu VLLM_VERSION_OVERRIDE="v${VERSION}" uv pip install --no-build-isolation -e .[audio] -v --extra-index-url https://pypi.org/simple --extra-index-url https://download.pytorch.org/whl/xpu --index-strategy unsafe-best-match || echo "WARN: build vllm package in update failed"

uv lock --extra-index-url https://pypi.org/simple --extra-index-url https://download.pytorch.org/whl/xpu --index-strategy unsafe-best-match

sed -i 's/{ name = "triton"/{ name = "triton-xpu"/' uv.lock
echo "Manually add optional audio deps of vllm into main required deps"
echo "Manually fix any missing hashes"

cd ..
mv ./vllm/uv.lock .
rm -rf vllm
