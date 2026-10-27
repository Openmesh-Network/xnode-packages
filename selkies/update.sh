#!/usr/bin/env bash
set -e

VERSION=2.1.0

git clone https://github.com/selkies-project/selkies
cd selkies
git checkout "${VERSION}"

sed -i 's/requires-python = ">=3\.9"/requires-python = ">=3.10"/g' pyproject.toml

uv venv
uv pip install -e . -v
uv lock 

cd ..
mv ./selkies/uv.lock .
rm -rf selkies