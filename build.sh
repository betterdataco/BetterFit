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

# Build for web with environment variables
flutter build web --release \
  --dart-define=SUPABASE_URL=$SUPABASE_URL \
  --dart-define=SUPABASE_ANON_KEY=$SUPABASE_ANON_KEY \
  --dart-define=USDA_FOOD_DATA_API_KEY=$USDA_FOOD_DATA_API_KEY \
  --dart-define=IS_WEB=true

# List build output
echo '--- build/web ---'
ls -la build/web | sed -n '1,120p'