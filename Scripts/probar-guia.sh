#!/bin/bash
set -euo pipefail
raiz="$(cd "$(dirname "$0")/.." && pwd)"
fuentes="$raiz/OfrendaDiaDeMuertosProyecto"
desarrollador="${DEVELOPER_DIR:-/Applications/Xcode.app/Contents/Developer}"
temporal="$(mktemp -d "${TMPDIR:-/tmp}/guia-test.XXXXXX")"
trap 'rm -rf "$temporal"' EXIT
sdk="$(env DEVELOPER_DIR="$desarrollador" xcrun --sdk macosx --show-sdk-path)"
env DEVELOPER_DIR="$desarrollador" SDKROOT="$sdk" xcrun --sdk macosx swiftc -swift-version 5 -parse-as-library \
  "$fuentes/Features/Guia/Models/PasoGuiaOfrenda.swift" \
  "$fuentes/Features/Guia/Models/GuiaContextualAmbito.swift" \
  "$fuentes/Features/Guia/Services/GuiaContextualStore.swift" \
  "$fuentes/Features/Guia/Models/GuiaDestacadoLayout.swift" \
  "$fuentes/Features/Guia/Services/GuiaOfrendaStore.swift" \
  "$raiz/Tests/GuiaRegression.swift" -o "$temporal/guia-tests"
"$temporal/guia-tests"
