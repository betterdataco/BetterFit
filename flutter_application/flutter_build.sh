#!/usr/bin/env bash
set -euo pipefail

# Install Flutter if not already installed
if ! command -v flutter &> /dev/null; then
    echo "Installing Flutter..."
    git clone https://github.com/flutter/flutter.git -b stable
    export PATH="$PATH:$PWD/flutter/bin"
    flutter doctor
fi

# Enable web support
flutter config --enable-web

# Get Flutter dependencies
echo "Getting Flutter dependencies..."
flutter pub get

# Build for web with proper configuration
echo "Building Flutter web app..."
flutter build web \
  --release \
  --web-renderer html \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY

echo "Build completed successfully!"
