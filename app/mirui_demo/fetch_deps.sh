#!/bin/bash
# fetch_deps.sh - download & vendor mirui's dependency tree (run once,
# needs network). The Vela Rust build is offline/vendored, so the crates
# must exist under external/rust/registry before building mirui_demo.
#
# Usage:  bash app/mirui_demo/fetch_deps.sh
# Then:   ./1700_ap.sh   (or your normal build command)
set -e

HERE="$(cd "$(dirname "$0")" && pwd)"
ROOT="$(cd "$HERE/../../.." && pwd)"          # openvela workspace root
REV=39ed01becace7be4b533d43d2e3e5581a8448351 # mirui 0.46.0 line (verified)
VENDOR="$HERE/vendor"
TMP="$(mktemp -d)"
trap 'rm -rf "$TMP"' EXIT

echo "==> vendoring mirui deps (git rev $REV)"
cat > "$TMP/Cargo.toml" <<EOF
[package]
name = "mirui_vendor_fetch"
version = "0.1.0"
edition = "2021"

[lib]
path = "lib.rs"

[dependencies]
mirui = { git = "https://github.com/W-Mai/mirui", rev = "$REV", default-features = false, features = ["nuttx", "gallery", "quad-aa"] }
EOF
touch "$TMP/lib.rs"

(cd "$TMP" && cargo vendor "$VENDOR")

# cargo vendor flattens workspace members: fix mirui's internal paths.
sed -i.bak 's|^path = "mirui-macros"$|path = "../mirui-macros"|; s|^path = "mirx"$|path = "../mirx"|' \
  "$VENDOR"/mirui/Cargo.toml
rm -f "$VENDOR"/*/Cargo.toml.bak

echo "==> vendoring rust-src deps (for -Zbuild-std)"
RSRC="$(ls -d "$HOME"/.rustup/toolchains/*/lib/rustlib/src/rust/library 2>/dev/null | head -1)"
if [ -z "$RSRC" ]; then
  echo "error: rust-src not found - run: rustup component add rust-src"; exit 1
fi
(cd "$RSRC" && cargo vendor --versioned-dirs "$TMP/std")
cp -rn "$TMP"/std/* "$VENDOR"/

echo "==> linking vendor -> external/rust/registry"
mkdir -p "$ROOT/external/rust"
ln -sfn "$VENDOR" "$ROOT/external/rust/registry"

echo "done. build now: ./1700_ap.sh"
