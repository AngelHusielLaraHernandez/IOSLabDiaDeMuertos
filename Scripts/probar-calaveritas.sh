#!/bin/bash
set -euo pipefail
raiz="$(cd "$(dirname "$0")/.." && pwd)"
fuentes="$raiz/OfrendaDiaDeMuertosProyecto"
desarrollador="${DEVELOPER_DIR:-/Applications/Xcode.app/Contents/Developer}"
dispositivo="${TASK_SIMULATOR_UDID:-booted}"
temporal="$(mktemp -d "${TMPDIR:-/tmp}/calaveritas-test.XXXXXX")"
trap 'rm -rf "$temporal"' EXIT
sdk="$(env DEVELOPER_DIR="$desarrollador" xcrun --sdk iphonesimulator --show-sdk-path)"
arquitectura="$(uname -m)"
env DEVELOPER_DIR="$desarrollador" xcrun swiftc \
  -sdk "$sdk" -target "$arquitectura-apple-ios26.2-simulator" -swift-version 5 -parse-as-library \
  "$fuentes/Features/MiOfrenda/Models/PersonalizacionOfrenda.swift" \
  "$fuentes/Features/MiOfrenda/Models/ConfiguracionElementosOfrenda.swift" \
  "$fuentes/Features/Ofrenda/Models/MarcoOfrenda.swift" \
  "$fuentes/Core/DesignSystem/IlustracionOfrenda.swift" \
  "$fuentes/Features/MiOfrenda/Services/OfrendasManager.swift" \
  "$fuentes/Features/CalaveritasLiterarias/Models/CalaveritaGuardada.swift" \
  "$fuentes/Features/CalaveritasLiterarias/Services/CalaveritasStore.swift" \
  "$fuentes/Features/CalaveritasLiterarias/Services/CalaveritaGenerator.swift" \
  "$raiz/Tests/CalaveritasRegression.swift" \
  -o "$temporal/calaveritas-tests"
env DEVELOPER_DIR="$desarrollador" xcrun simctl spawn "$dispositivo" "$temporal/calaveritas-tests"
