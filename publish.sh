#!/usr/bin/env bash
set -euo pipefail

MODULE_DIR="$(cd "$(dirname "$0")" && pwd)"
cd "$MODULE_DIR"

NAME=$(jq -r '.name' metadata.json)
VERSION=$(jq -r '.version' metadata.json)
AUTHOR=$(echo "$NAME" | cut -d- -f1)
MODULE=$(echo "$NAME" | cut -d- -f2-)
PKG_NAME="${AUTHOR}-${MODULE}-${VERSION}"
PKG_DIR="pkg"
BUILD_DIR="${PKG_DIR}/${PKG_NAME}"
TARBALL="${PKG_DIR}/${PKG_NAME}.tar.gz"

echo "==> Building ${PKG_NAME}"

rm -rf "$PKG_DIR"
mkdir -p "$BUILD_DIR"

INCLUDE_FILES=(
  metadata.json
  README.md
  REFERENCE.md
  CHANGELOG.md
  LICENSE
)
INCLUDE_DIRS=(
  manifests
  templates
)

for f in "${INCLUDE_FILES[@]}"; do
  [ -f "$f" ] && cp "$f" "$BUILD_DIR/"
done

for d in "${INCLUDE_DIRS[@]}"; do
  [ -d "$d" ] && cp -r "$d" "$BUILD_DIR/"
done

echo "==> Generating checksums.json"
python3 -c "
import hashlib, json, os, pathlib

checksums = {}
build = pathlib.Path('${BUILD_DIR}')
for p in sorted(build.rglob('*')):
    if p.is_file() and p.name != 'checksums.json':
        rel = str(p.relative_to(build))
        md5 = hashlib.md5(p.read_bytes()).hexdigest()
        checksums[rel] = md5
with open(build / 'checksums.json', 'w') as f:
    json.dump(checksums, f, indent=2)
print(f'  {len(checksums)} files checksummed')
"

echo "==> Creating tarball"
tar czf "$TARBALL" -C "$PKG_DIR" "$PKG_NAME"
SIZE=$(du -h "$TARBALL" | cut -f1)
echo "  ${TARBALL} (${SIZE})"

echo ""
echo "==> Package contents:"
tar tzf "$TARBALL" | head -30
echo ""

if [ "${1:-}" = "--publish" ]; then
  if [ -z "${FORGE_API_KEY:-}" ]; then
    echo "ERROR: Set FORGE_API_KEY environment variable first."
    echo ""
    echo "  export FORGE_API_KEY='your-forge-api-token'"
    echo "  ./publish.sh --publish"
    exit 1
  fi

  echo "==> Publishing ${PKG_NAME} to Puppet Forge..."
  HTTP_CODE=$(curl -sS -o /tmp/forge-response.json -w '%{http_code}' \
    -X POST \
    --header "Authorization: Bearer ${FORGE_API_KEY}" \
    --form "file=@${TARBALL}" \
    https://forgeapi.puppet.com/v3/releases)

  echo ""
  if [ "$HTTP_CODE" = "201" ] || [ "$HTTP_CODE" = "200" ]; then
    echo "SUCCESS: Published ${PKG_NAME} to Puppet Forge!"
    echo "  https://forge.puppet.com/modules/${AUTHOR}/${MODULE}"
  else
    echo "FAILED: HTTP ${HTTP_CODE}"
    jq '.' /tmp/forge-response.json 2>/dev/null || cat /tmp/forge-response.json
    exit 1
  fi
else
  echo "==> Dry run complete. To publish:"
  echo ""
  echo "  export FORGE_API_KEY='your-forge-api-token'"
  echo "  ./publish.sh --publish"
fi
