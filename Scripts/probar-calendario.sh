#!/bin/bash
set -euo pipefail
raiz="$(cd "$(dirname "$0")/.." && pwd)"
fuentes="$raiz/OfrendaDiaDeMuertosProyecto"
desarrollador="${DEVELOPER_DIR:-/Applications/Xcode.app/Contents/Developer}"
dispositivo="${TASK_SIMULATOR_UDID:-booted}"
temporal="$(mktemp -d "${TMPDIR:-/tmp}/calendario-test.XXXXXX")"
trap 'rm -rf "$temporal"' EXIT
sdk="$(env DEVELOPER_DIR="$desarrollador" xcrun --sdk iphonesimulator --show-sdk-path)"
arquitectura="$(uname -m)"
env DEVELOPER_DIR="$desarrollador" xcrun swiftc \
  -sdk "$sdk" -target "$arquitectura-apple-ios26.2-simulator" -swift-version 5 -parse-as-library \
  "$fuentes/Features/Ofrenda/Models/CalendarioMuertos.swift" \
  "$raiz/Tests/CalendarioRegression.swift" \
  -o "$temporal/calendario-tests"
env DEVELOPER_DIR="$desarrollador" xcrun simctl spawn "$dispositivo" "$temporal/calendario-tests"
