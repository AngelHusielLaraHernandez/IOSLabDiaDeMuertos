#!/bin/bash
set -euo pipefail
raiz="$(cd "$(dirname "$0")/.." && pwd)"
desarrollador="${DEVELOPER_DIR:-/Applications/Xcode.app/Contents/Developer}"
temporal="$(mktemp -d "${TMPDIR:-/tmp}/captura-test.XXXXXX")"
trap 'rm -rf "$temporal"' EXIT
env DEVELOPER_DIR="$desarrollador" xcrun --sdk macosx swiftc -swift-version 5 -parse-as-library \
  "$raiz/OfrendaDiaDeMuertosProyecto/Features/Ofrenda/ThreeD/OfrendaCaptureFraming.swift" \
  "$raiz/Tests/CapturaOfrendaRegression.swift" -o "$temporal/captura-tests"
"$temporal/captura-tests"
