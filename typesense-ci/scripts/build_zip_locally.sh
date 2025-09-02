
#!/usr/bin/env bash
# Local helper to reproduce the CI build on your machine.
set -euo pipefail
REF="${1:-main}"
BIN_NAME="typesense-server"
ARCH="linux-amd64"

rm -rf upstream-typesense
git clone https://github.com/typesense/typesense.git upstream-typesense
cd upstream-typesense
git fetch --all --tags --prune
git checkout "$REF"
git submodule update --init --recursive

if [[ -x "./build.sh" ]]; then
  ./build.sh --package-binary
  TAR="$(ls -1 build-*/${BIN_NAME}-*.tar.gz | head -n1)"
else
  echo "build.sh not found; attempting Bazel build"
  if ! command -v bazel >/dev/null 2>&1; then
    curl -L https://github.com/bazelbuild/bazelisk/releases/latest/download/bazelisk-linux-amd64 -o /usr/local/bin/bazel
    chmod +x /usr/local/bin/bazel
  fi
  bazel build //:${BIN_NAME} --verbose_failures --sandbox_debug
  mkdir -p build-Linux
  cp -v bazel-bin/${BIN_NAME} build-Linux/
  (cd build-Linux && tar -czf ${BIN_NAME}-custom.tar.gz ${BIN_NAME})
  TAR="$(pwd)/build-Linux/${BIN_NAME}-custom.tar.gz"
fi

mkdir -p artifact && tar -xzf "$TAR" -C artifact
cd artifact
strip -s "${BIN_NAME}" || true
zip -9 "${BIN_NAME}-${REF}-${ARCH}.zip" "${BIN_NAME}"
sha256sum "${BIN_NAME}-${REF}-${ARCH}.zip" > SHA256SUMS.txt
echo "Built: $(pwd)/${BIN_NAME}-${REF}-${ARCH}.zip"
