#!/bin/sh
# Sync kubernetes/stacks/<name>/*.yaml from GitHub into k0s' Manifest Deployer
# directory. k0s watches /var/lib/k0s/manifests and applies (and prunes) by itself.
#
# Only needs curl, tar, cmp and find. Meant to run from a systemd timer as root.
#
# Safety rules:
#  - Only stacks listed in the state file are ever modified or deleted, so the
#    stacks managed by k0s itself (calico, coredns, ...) are never touched.
#  - A stack that already exists in DEST but is not in the state file is skipped.
#  - Files are replaced atomically (temp file without a .yaml suffix, then mv),
#    so k0s never sees a half-written or missing file.
set -eu

REPO="${REPO:-nasa9084/infrastructure}"
REF="${REF:-main}"
DEST="${DEST:-/var/lib/k0s/manifests}"
STATE="${STATE:-/var/lib/k0s-manifest-sync/managed}"
# For testing: a directory laid out like kubernetes/stacks (skips the download).
SRC_DIR="${SRC_DIR:-}"

umask 022
work=$(mktemp -d)
trap 'rm -rf "$work"' EXIT

if [ -z "$SRC_DIR" ]; then
  curl -fsSL --retry 3 --max-time 120 \
    "https://codeload.github.com/${REPO}/tar.gz/refs/heads/${REF}" \
    -o "$work/repo.tar.gz"
  mkdir "$work/repo"
  tar -xzf "$work/repo.tar.gz" -C "$work/repo" --strip-components=1
  SRC_DIR="$work/repo/kubernetes/stacks"
fi

if [ ! -d "$SRC_DIR" ]; then
  echo "error: $SRC_DIR not found; leaving $DEST untouched" >&2
  exit 1
fi

mkdir -p "$(dirname "$STATE")" "$DEST"
touch "$STATE"

valid_name() {
  case "$1" in
    ''|*[!a-z0-9-]*|-*) return 1 ;;
    *) return 0 ;;
  esac
}

new_state="$work/managed.new"
: > "$new_state"

# 1. create / update stacks that exist in the repo
for src in "$SRC_DIR"/*/; do
  [ -d "$src" ] || continue
  name=$(basename "$src")
  if ! valid_name "$name"; then
    echo "skip: invalid stack name '$name'" >&2
    continue
  fi
  dst="$DEST/$name"
  if [ -e "$dst" ] && ! grep -qx "$name" "$STATE"; then
    echo "skip: $dst exists but is not managed by this script" >&2
    continue
  fi
  echo "$name" >> "$new_state"
  mkdir -p "$dst"
  for f in "$src"*.yaml; do
    [ -e "$f" ] || continue
    base=$(basename "$f")
    if ! cmp -s "$f" "$dst/$base"; then
      cp "$f" "$dst/.$base.tmp"
      mv -f "$dst/.$base.tmp" "$dst/$base"
      echo "updated $name/$base"
    fi
  done
  for f in "$dst"/*.yaml; do
    [ -e "$f" ] || continue
    base=$(basename "$f")
    if [ ! -e "$src$base" ]; then
      rm -f "$f"
      echo "removed $name/$base"
    fi
  done
done

# 2. remove stacks that were managed before but are gone from the repo
while IFS= read -r name; do
  [ -n "$name" ] || continue
  grep -qx "$name" "$new_state" && continue
  valid_name "$name" || continue
  if [ -d "$DEST/$name" ]; then
    echo "removed stack $name"
    rm -rf "${DEST:?}/$name"
  fi
done < "$STATE"

cp "$new_state" "$STATE.tmp"
mv -f "$STATE.tmp" "$STATE"
