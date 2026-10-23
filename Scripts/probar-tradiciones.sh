#!/bin/bash
set -euo pipefail
raiz="$(cd "$(dirname "$0")/.." && pwd)"
fuentes="$raiz/OfrendaDiaDeMuertosProyecto"
desarrollador="${DEVELOPER_DIR:-/Applications/Xcode.app/Contents/Developer}"
dispositivo="${TASK_SIMULATOR_UDID:-booted}"
temporal="$(mktemp -d "${TMPDIR:-/tmp}/tradiciones-test.XXXXXX")"
trap 'rm -rf "$temporal"' EXIT
sdk="$(env DEVELOPER_DIR="$desarrollador" xcrun --sdk iphonesimulator --show-sdk-path)"
arquitectura="$(uname -m)"
env DEVELOPER_DIR="$desarrollador" xcrun swiftc \
  -sdk "$sdk" -target "$arquitectura-apple-ios26.2-simulator" -swift-version 5 -parse-as-library \
  "$fuentes/Core/DesignSystem/IlustracionOfrenda.swift" \
  "$fuentes/Features/Ofrenda/Models/ElementoOfrenda.swift" \
  "$fuentes/Features/Ofrenda/Data/OfrendaCatalog.swift" \
  "$fuentes/Features/Tradiciones/Models/LugarCultural.swift" \
  "$fuentes/Features/Tradiciones/Data/TradicionesCatalog.swift" \
  "$fuentes/Features/Tradiciones/Services/MapasCulturales.swift" \
  "$fuentes/Features/Tradiciones/Services/ProgresoRecorridoStore.swift" \
  "$raiz/Tests/TradicionesRegression.swift" \
  -o "$temporal/tradiciones-tests"
env DEVELOPER_DIR="$desarrollador" xcrun simctl spawn "$dispositivo" "$temporal/tradiciones-tests"
