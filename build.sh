#!/bin/bash
set -e

echo "Installing Flutter..."
curl -o flutter.zip https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.13.0-stable.zip
unzip -q flutter.zip
export PATH="$PATH:$(pwd)/flutter/bin"

echo "Running flutter doctor..."
flutter doctor

echo "Getting dependencies..."
flutter pub get

echo "Building web..."
flutter build web --release

echo "Verifying build output..."
if [ -d "build/web" ]; then
  echo "Build successful! Output directory: build/web"
  ls -la build/web/
else
  echo "Error: build/web directory not found"
  exit 1
fi
