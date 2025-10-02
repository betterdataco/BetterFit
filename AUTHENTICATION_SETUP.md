# BetterFitAi Authentication Setup Guide

This guide will help you set up Google Sign-In and Apple Sign-In for BetterFitAi.

## 🔐 **Overview**

BetterFitAi supports three authentication methods:
- **Email/Password** (Magic Link) - Already configured
- **Google Sign-In** - Requires Google Cloud Console setup
- **Apple Sign-In** - Requires Apple Developer Account setup

## 🚀 **Google Sign-In Setup**

### **Step 1: Google Cloud Console Setup**

1. **Go to [Google Cloud Console](https://console.cloud.google.com/)**
2. **Create a new project** or select existing one
3. **Enable APIs:**
   - Go to "APIs & Services" > "Library"
   - Search and enable "Google+ API"
   - Search and enable "Google Sign-In API"

### **Step 2: Create OAuth 2.0 Credentials**

1. **Go to "APIs & Services" > "Credentials"**
2. **Click "Create Credentials" > "OAuth 2.0 Client IDs"**
3. **Create credentials for each platform:**

#### **Web Application**
- **Application type:** Web application
- **Name:** BetterFitAi Web
- **Authorized JavaScript origins:**
  - `https://your-domain.vercel.app`
  - `http://localhost:3000` (for development)
- **Authorized redirect URIs:**
  - `https://your-domain.vercel.app/auth/callback`
  - `http://localhost:3000/auth/callback`

#### **Android Application**
- **Application type:** Android
- **Name:** BetterFitAi Android
- **Package name:** `com.betterfitai.app` (or your package name)
- **SHA-1 certificate fingerprint:** Get from your keystore

#### **iOS Application**
- **Application type:** iOS
- **Name:** BetterFitAi iOS
- **Bundle ID:** `com.betterfitai.app` (or your bundle ID)

### **Step 3: Get Client IDs**

Copy the following from your Google Cloud Console:
- **Web client ID** (for Flutter web)
- **Android client ID** (for Android app)
- **iOS client ID** (for iOS app)

## 🍎 **Apple Sign-In Setup**

### **Step 1: Apple Developer Account**

1. **Go to [Apple Developer Console](https://developer.apple.com/)**
2. **Sign in with your Apple Developer account**

### **Step 2: Create App ID**

1. **Go to "Certificates, Identifiers & Profiles"**
2. **Click "Identifiers" > "+"**
3. **Select "App IDs" > "Continue"**
4. **Configure:**
   - **Description:** BetterFitAi
   - **Bundle ID:** `com.betterfitai.app` (must match your app)
   - **Capabilities:** Check "Sign In with Apple"
5. **Click "Continue" > "Register"**

### **Step 3: Create Service ID (for Web)**

1. **Go to "Identifiers" > "+"**
2. **Select "Services IDs" > "Continue"**
3. **Configure:**
   - **Description:** BetterFitAi Web
   - **Identifier:** `com.betterfitai.web` (unique identifier)
4. **Check "Sign In with Apple"**
5. **Configure Sign In with Apple:**
   - **Primary App ID:** Select your app ID
   - **Domains and Subdomains:** `your-domain.vercel.app`
   - **Return URLs:** `https://your-domain.vercel.app/auth/callback`

### **Step 4: Create Private Key**

1. **Go to "Keys" > "+"**
2. **Configure:**
   - **Key Name:** BetterFitAi Apple Sign-In
   - **Check "Sign In with Apple"**
3. **Click "Continue" > "Register"**
4. **Download the .p8 file** (you can only download once!)

## 🔧 **Supabase Configuration**

### **Step 1: Configure Google OAuth Provider**

1. **Go to your Supabase Dashboard**
2. **Navigate to "Authentication" > "Providers"**
3. **Enable "Google" provider**
4. **Add your Google OAuth credentials:**
   - **Client ID:** Your Google Web client ID
   - **Client Secret:** Your Google client secret

### **Step 2: Configure Apple OAuth Provider**

1. **In Supabase Dashboard > "Authentication" > "Providers"**
2. **Enable "Apple" provider**
3. **Add your Apple credentials:**
   - **Client ID:** Your Apple Service ID
   - **Client Secret:** Generate using your private key
   - **Team ID:** Your Apple Developer Team ID
   - **Key ID:** Your Apple Sign-In key ID
   - **Private Key:** Content of your .p8 file

### **Step 3: Configure Redirect URLs**

Add these URLs to your Supabase project:
- `https://your-domain.vercel.app/auth/callback`
- `io.supabase.betterfitai://login-callback/`

## 🌐 **Environment Variables**

Add these to your Vercel project environment variables:

```bash
# Supabase
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key

# Google Sign-In
GOOGLE_WEB_CLIENT_ID=your_google_web_client_id
GOOGLE_ANDROID_CLIENT_ID=your_google_android_client_id
GOOGLE_IOS_CLIENT_ID=your_google_ios_client_id

# Apple Sign-In
APPLE_CLIENT_ID=your_apple_service_id
APPLE_SERVICE_ID=your_apple_service_id

# USDA Food Data API
USDA_FOOD_DATA_API_KEY=your_usda_api_key
```

## 📱 **Platform-Specific Configuration**

### **Android Configuration**

1. **Add `google-services.json` to `android/app/`**
2. **Update `android/app/build.gradle`:**
   ```gradle
   apply plugin: 'com.google.gms.google-services'
   ```

### **iOS Configuration**

1. **Add `GoogleService-Info.plist` to `ios/Runner/`**
2. **Update `ios/Runner/Info.plist`:**
   ```xml
   <key>CFBundleURLTypes</key>
   <array>
     <dict>
       <key>CFBundleURLName</key>
       <string>REVERSED_CLIENT_ID</string>
       <key>CFBundleURLSchemes</key>
       <array>
         <string>YOUR_REVERSED_CLIENT_ID</string>
       </array>
     </dict>
   </array>
   ```

## 🧪 **Testing**

### **Development Testing**

1. **Run the app locally:**
   ```bash
   flutter run -d chrome
   ```

2. **Test each authentication method:**
   - Email sign-in
   - Google sign-in
   - Apple sign-in (iOS only)

### **Production Testing**

1. **Deploy to Vercel**
2. **Test on different devices:**
   - Web browsers
   - Android devices
   - iOS devices

## 🚨 **Troubleshooting**

### **Common Issues**

1. **Google Sign-In not working:**
   - Check client IDs are correct
   - Verify redirect URLs match
   - Ensure APIs are enabled

2. **Apple Sign-In not working:**
   - Verify bundle ID matches
   - Check service ID configuration
   - Ensure private key is correct

3. **Supabase errors:**
   - Check OAuth provider configuration
   - Verify redirect URLs
   - Check environment variables

### **Debug Steps**

1. **Check browser console for errors**
2. **Verify environment variables are set**
3. **Test with different browsers/devices**
4. **Check Supabase logs**

## 📚 **Additional Resources**

- [Google Sign-In Flutter Documentation](https://pub.dev/packages/google_sign_in)
- [Apple Sign-In Flutter Documentation](https://pub.dev/packages/sign_in_with_apple)
- [Supabase Auth Documentation](https://supabase.com/docs/guides/auth)
- [Google OAuth 2.0 Documentation](https://developers.google.com/identity/protocols/oauth2)
- [Apple Sign-In Documentation](https://developer.apple.com/sign-in-with-apple/)

## 🎯 **Next Steps**

Once you have the credentials:

1. **Set up the environment variables in Vercel**
2. **Configure Supabase OAuth providers**
3. **Test the authentication flow**
4. **Deploy and verify everything works**

The code is already implemented and ready to use once you provide the credentials!
