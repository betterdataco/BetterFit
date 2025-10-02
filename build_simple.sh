#!/bin/bash
set -e

echo "=== Simple BetterFit Flutter Web Build ==="

# Install Flutter using a different method
echo "Installing Flutter..."
curl -O https://storage.googleapis.com/flutter_infra_release/releases/stable/linux/flutter_linux_3.22.2-stable.tar.xz
tar xf flutter_linux_3.22.2-stable.tar.xz
export PATH="$PATH:`pwd`/flutter/bin"

# Fix git ownership issue
echo "Fixing git ownership..."
git config --global --add safe.directory /vercel/path0/flutter

# Check Flutter
echo "Checking Flutter..."
flutter --version
flutter config --enable-web --no-analytics

# Build the app
echo "Building Flutter web app..."
cd flutter_application
flutter pub get
flutter build web --release

# Verify build
echo "Verifying build..."
if [ ! -f "build/web/flutter.js" ]; then
    echo "ERROR: flutter.js not found!"
    ls -la build/web/
    exit 1
fi

# Copy to output
echo "Copying to output directory..."
cp -r build/web ../web
cd ..

echo "Build complete! Files in web directory:"
ls -la web/
