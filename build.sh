#!/bin/bash

# Set Flutter version
export FLUTTER_VERSION=3.24.0

# Download and extract Flutter
curl -L https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_${FLUTTER_VERSION}-stable.tar.xz | tar -xJ

# Add Flutter to PATH
export PATH="$PWD/flutter/bin:$PATH"

# Navigate to Flutter application directory
cd flutter_application

# Check Flutter version
flutter --version

# Clean and get dependencies
flutter clean
flutter pub get

# Build for web
flutter build web --release

# List build output
echo '--- build/web ---'
ls -la build/web | sed -n '1,120p'