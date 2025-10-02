# BetterFit Deployment Guide

## 🚀 **Vercel Web Deployment**

### **Prerequisites**
- Vercel account
- Flutter SDK installed locally
- Git repository connected to Vercel

### **Deployment Steps**

1. **Connect Repository to Vercel**
   ```bash
   # Install Vercel CLI
   npm i -g vercel
   
   # Login to Vercel
   vercel login
   ```

2. **Configure Environment Variables**
   - Go to your Vercel project dashboard
   - Navigate to Settings → Environment Variables
   - Add the following variables:
     ```
     SUPABASE_URL=your_supabase_project_url
     SUPABASE_ANON_KEY=your_supabase_anon_key
     ```

3. **Deploy**
   ```bash
   # Deploy to Vercel
   vercel --prod
   ```

### **Vercel Configuration**
The `vercel.json` file is already configured with:
- Build command: `flutter build web --release`
- Output directory: `build/web`
- SPA routing support
- Optimized caching headers

## 📱 **Mobile App Deployment**

### **Android (Google Play Store)**

1. **Build Release APK**
   ```bash
   flutter build apk --release
   ```

2. **Build App Bundle (Recommended)**
   ```bash
   flutter build appbundle --release
   ```

3. **Upload to Google Play Console**
   - Go to [Google Play Console](https://play.google.com/console)
   - Create new app or update existing
   - Upload the `.aab` file from `build/app/outputs/bundle/release/`

### **iOS (App Store)**

1. **Build for iOS**
   ```bash
   flutter build ios --release
   ```

2. **Archive in Xcode**
   - Open `ios/Runner.xcworkspace` in Xcode
   - Select "Any iOS Device" as target
   - Product → Archive
   - Upload to App Store Connect

## 🔧 **Environment Configuration**

### **Local Development**
1. Copy `env.example` to `.env`
2. Fill in your Supabase credentials
3. Run `flutter pub get`

### **Production Environment**
Set these environment variables in your deployment platform:

```bash
# Required
SUPABASE_URL=https://your-project.supabase.co
SUPABASE_ANON_KEY=your_anon_key

# Optional
APP_NAME=BetterFit
APP_VERSION=1.0.0
ENABLE_HEALTH_INTEGRATION=true
```

## 🏗️ **Build Commands**

### **Web (Vercel)**
```bash
flutter build web --release --web-renderer html
```

### **Android**
```bash
flutter build apk --release
flutter build appbundle --release
```

### **iOS**
```bash
flutter build ios --release
```

## 🔍 **Troubleshooting**

### **Common Issues**

1. **Build Failures**
   - Ensure Flutter SDK is up to date
   - Run `flutter doctor` to check setup
   - Clear build cache: `flutter clean`

2. **Environment Variables**
   - Verify all required variables are set
   - Check variable names match code
   - Restart deployment after adding variables

3. **Supabase Connection**
   - Verify Supabase project is active
   - Check RLS policies are configured
   - Ensure API keys have correct permissions

### **Performance Optimization**

1. **Web Performance**
   - Use `--web-renderer html` for better compatibility
   - Enable gzip compression in Vercel
   - Optimize images and assets

2. **Mobile Performance**
   - Enable R8/ProGuard for Android
   - Use App Bundle instead of APK
   - Optimize native dependencies

## 📊 **Monitoring & Analytics**

### **Vercel Analytics**
- Enable Vercel Analytics in project settings
- Monitor Core Web Vitals
- Track user engagement metrics

### **App Performance**
- Use Firebase Performance Monitoring
- Track crash reports with Firebase Crashlytics
- Monitor API response times

## 🔐 **Security Considerations**

1. **Environment Variables**
   - Never commit `.env` files
   - Use Vercel's environment variable system
   - Rotate API keys regularly

2. **API Security**
   - Implement proper RLS policies in Supabase
   - Use row-level security
   - Validate all user inputs

3. **Mobile Security**
   - Sign apps with proper certificates
   - Enable app signing by Google Play
   - Use App Transport Security (iOS)

## 📈 **Post-Deployment Checklist**

- [ ] Test web app functionality
- [ ] Verify mobile app builds
- [ ] Check environment variables
- [ ] Test Supabase connections
- [ ] Monitor error logs
- [ ] Verify analytics tracking
- [ ] Test user onboarding flow
- [ ] Check health data integration
- [ ] Validate push notifications
- [ ] Test offline functionality

## 🆘 **Support**

For deployment issues:
1. Check Vercel deployment logs
2. Review Flutter build output
3. Verify environment configuration
4. Test locally with production settings












