#!/bin/bash
set -euo pipefail
raiz="$(cd "$(dirname "$0")/.." && pwd)"
fuentes="$raiz/OfrendaDiaDeMuertosProyecto"
desarrollador="${DEVELOPER_DIR:-/Applications/Xcode.app/Contents/Developer}"
dispositivo="${TASK_SIMULATOR_UDID:-booted}"
temporal="$(mktemp -d "${TMPDIR:-/tmp}/lectura-test.XXXXXX")"
trap 'rm -rf "$temporal"' EXIT
sdk="$(env DEVELOPER_DIR="$desarrollador" xcrun --sdk iphonesimulator --show-sdk-path)"
arquitectura="$(uname -m)"
env DEVELOPER_DIR="$desarrollador" SDKROOT="$sdk" xcrun --sdk iphonesimulator swiftc \
  -sdk "$sdk" -target "$arquitectura-apple-ios26.2-simulator" -swift-version 5 -parse-as-library \
  "$fuentes/Features/Ofrenda/Models/HistoriaElemento.swift" \
  "$fuentes/Features/Tradiciones/Models/LugarCultural.swift" \
  "$fuentes/Features/Tradiciones/Data/TradicionesCatalog.swift" \
  "$fuentes/Features/Ofrenda/Data/ReferenciasOfrenda.swift" \
  "$fuentes/Features/Ofrenda/Models/TextoLecturaOfrenda.swift" \
  "$fuentes/Features/Ofrenda/Services/LectorVozOfrenda.swift" \
  "$raiz/Tests/LecturaVozRegression.swift" -o "$temporal/lectura-tests"
env DEVELOPER_DIR="$desarrollador" xcrun simctl spawn "$dispositivo" "$temporal/lectura-tests"
