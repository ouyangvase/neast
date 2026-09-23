#!/bin/bash
set -euo pipefail

cd "$(dirname "$0")"

echo "Updating CocoaPods spec repo (required for Firebase 12.15.0)..."
pod repo update

echo "Installing pods..."
pod install --repo-update

echo "Done. You can now run: flutter run"
