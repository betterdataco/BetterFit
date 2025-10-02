# Vercel Deployment Guide for BetterFit

This document provides a comprehensive guide for deploying the BetterFit Flutter web application to Vercel, including the API functions and database integration.

## Table of Contents

- [Overview](#overview)
- [Prerequisites](#prerequisites)
- [Project Structure](#project-structure)
- [Environment Variables](#environment-variables)
- [Deployment Configuration](#deployment-configuration)
- [API Functions](#api-functions)
- [Deployment Steps](#deployment-steps)
- [Troubleshooting](#troubleshooting)
- [Monitoring and Maintenance](#monitoring-and-maintenance)

## Overview

BetterFit is a Flutter web application with serverless API functions deployed on Vercel. The application includes:

- **Frontend**: Flutter web application built with Dart
- **Backend**: Serverless API functions using Node.js
- **Database**: Supabase PostgreSQL database
- **Authentication**: Supabase Auth integration

## Prerequisites

Before deploying, ensure you have:

1. **Vercel Account**: Sign up at [vercel.com](https://vercel.com)
2. **GitHub Repository**: Your code should be in a GitHub repository
3. **Supabase Project**: Set up your Supabase project and database
4. **Flutter SDK**: Version 3.2.6 or higher installed locally
5. **Node.js**: Version 18.x or higher (for API functions)

## Project Structure

```
BetterFit/
├── flutter_application/          # Flutter web app
│   ├── lib/                     # Dart source code
│   ├── web/                     # Web-specific files
│   └── pubspec.yaml            # Flutter dependencies
├── api/                         # Serverless API functions
│   ├── exercises.js            # Exercise API endpoint
│   └── exercises/              # Additional API functions
├── scripts/                     # Build and deployment scripts
│   └── install_flutter.sh      # Flutter installation script
├── supabase/                   # Database migrations and config
├── vercel.json                 # Vercel configuration
└── README.md                   # Project documentation
```

## Environment Variables

Set up the following environment variables in your Vercel project:

### Required Variables

```bash
# Supabase Configuration
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
SUPABASE_SERVICE_ROLE_KEY=your_supabase_service_role_key

# Flutter Environment
FLUTTER_WEB_USE_SKIA=true
```

### Optional Variables

```bash
# API Configuration
API_BASE_URL=https://your-vercel-domain.vercel.app/api
CORS_ORIGIN=https://your-vercel-domain.vercel.app

# Feature Flags
ENABLE_ANALYTICS=false
ENABLE_DEBUG_MODE=false
```

## Deployment Configuration

### Installing Flutter in Vercel's Build Environment

Vercel's build environment doesn't include Flutter by default. The project includes a custom installation script that downloads and configures Flutter during the build process.

#### Flutter Installation Script (`scripts/install_flutter.sh`)

The script performs the following steps:
1. Downloads Flutter SDK version 3.22.2 (configurable)
2. Extracts the Flutter SDK to the build environment
3. Adds Flutter to the PATH
4. Enables web support
5. Runs `flutter pub get` to install dependencies

**Important**: Update the `FLUTTER_VERSION` variable in the script to match your local Flutter version.

### Vercel Configuration (`vercel.json`)

The project includes a `vercel.json` file at the root level configured for both Flutter web frontend and serverless API functions:

```json
{
  "version": 2,
  "buildCommand": "cd flutter_application && flutter build web --release",
  "outputDirectory": "flutter_application/build/web",
  "functions": {
    "api/**/*.js": { "runtime": "@vercel/node@3.0.0" }
  },
  "routes": [
    { "src": "/api/(.*)", "dest": "/api/$1" },
    { "src": "/[^.]*", "dest": "/index.html" }
  ]
}
```

This configuration:
- Uses Vercel version 2 with modern runtime syntax
- Builds Flutter app from the flutter_application subdirectory
- Deploys API functions with @vercel/node@3.0.0 runtime
- Routes API requests to serverless functions
- Routes all other requests to `index.html` for SPA routing
- Separates API routes from frontend routes

### Key Configuration Details

- **Build Command**: `flutter build web --release` - Builds the Flutter app for production
- **Output Directory**: `build/web` - Where Flutter outputs the web build
- **API Functions**: All `.js` files in the `api/` directory are deployed as serverless functions
- **SPA Routing**: All non-file paths route to `index.html` for client-side routing
- **API Routing**: API requests are routed to serverless functions
- **Modern Runtime**: Uses @vercel/node@3.0.0 runtime for API functions

## API Functions

### Exercise API (`/api/exercises`)

**Endpoint**: `GET /api/exercises`

**Query Parameters**:
- `target` - Filter by muscle group (partial match)
- `equipment` - Filter by equipment type
- `category` - Filter by exercise category
- `difficulty` - Filter by difficulty level
- `muscle_group` - Filter by specific muscle group
- `limit` - Number of results (default: 50)
- `offset` - Pagination offset (default: 0)
- `search` - Search exercise names

**Example Request**:
```
GET /api/exercises?target=chest&equipment=dumbbell&limit=10
```

**Response Format**:
```json
{
  "data": [
    {
      "id": 1,
      "name": "Dumbbell Bench Press",
      "muscle_group": "chest",
      "equipment": "dumbbell",
      "category": "strength",
      "difficulty": "intermediate"
    }
  ],
  "meta": {
    "count": 1,
    "limit": 10,
    "offset": 0,
    "filters": {
      "target": "chest",
      "equipment": "dumbbell"
    }
  }
}
```

### Data Integration

The application uses a hybrid approach:

- **API Functions**: Serverless functions for complex business logic
- **Direct Supabase**: Direct database access for simple operations
- **Authentication**: Supabase Auth handles user authentication
- **Real-time Updates**: Supabase real-time subscriptions

## Deployment Steps

### 1. Connect to Vercel

1. Go to [vercel.com](https://vercel.com) and sign in
2. Click "New Project"
3. Import your GitHub repository
4. Select the repository containing your BetterFit project

### 2. Configure Project Settings

1. **Framework Preset**: Select "Other" (not Flutter)
2. **Root Directory**: Leave as default (root of repository)
3. **Install Command**: `bash ./scripts/install_flutter.sh`
4. **Build Command**: Leave empty (configured in vercel.json)
5. **Output Directory**: Leave empty (configured in vercel.json)

### 3. Set Environment Variables

1. In the Vercel dashboard, go to your project settings
2. Navigate to "Environment Variables"
3. Add all required environment variables listed above
4. Set the environment to "Production" (and optionally "Preview" for testing)

### 4. Deploy

1. Click "Deploy" to start the deployment process
2. Vercel will automatically:
   - Install Flutter dependencies
   - Build the web application
   - Deploy API functions with @vercel/node@3.0.0 runtime
   - Configure routing for both frontend and API

### 5. Verify Deployment

1. Check the deployment logs for any errors
2. Test the main application URL
3. Test SPA routing (navigate to different pages and refresh)
4. Test API endpoints (e.g., `/api/exercises`)
5. Verify Supabase connectivity
6. Test authentication flow

## Troubleshooting

### Common Issues

#### 1. Flutter Installation Failures

**Problem**: Flutter installation script fails during build

**Solutions**:
- Verify the `FLUTTER_VERSION` in `scripts/install_flutter.sh` matches your local version
- Check that the Flutter download URL is accessible from Vercel's build environment
- Ensure the script has execute permissions (`chmod +x scripts/install_flutter.sh`)

#### 2. Build Failures

**Problem**: Flutter build fails during deployment

**Solutions**:
- Ensure Flutter SDK version is compatible (3.2.6+)
- Check `pubspec.yaml` for dependency conflicts
- Verify all assets are properly referenced
- Confirm Flutter web is enabled (`flutter config --enable-web`)

#### 3. API Function Errors

**Problem**: API functions return 500 errors

**Solutions**:
- Verify Supabase environment variables are set correctly
- Check API function logs in Vercel dashboard
- Ensure database tables exist and are properly configured
- Verify @vercel/node runtime is correctly specified

#### 4. CORS Issues

**Problem**: Frontend can't access API endpoints

**Solutions**:
- Verify API routes are properly defined in `vercel.json`
- Check that API functions are deployed correctly
- Ensure frontend is making requests to the correct API URL
- Verify CORS headers in API functions

#### 5. Routing Issues

**Problem**: SPA routes don't work (404 errors on refresh)

**Solutions**:
- Verify the routes configuration in `vercel.json`
- Check that `index.html` is being served for all non-file paths
- Ensure the build output contains the correct files

#### 6. Database Connection Issues

**Problem**: API functions can't connect to Supabase

**Solutions**:
- Verify `SUPABASE_URL` and `SUPABASE_ANON_KEY` are correct
- Check Supabase project is active and not paused
- Ensure database is accessible from Vercel's IP ranges

### Debugging Steps

1. **Check Vercel Logs**:
   - Go to your project dashboard
   - Click on the latest deployment
   - Review build and function logs

2. **Test API Locally**:
   ```bash
   # Install Vercel CLI
   npm i -g vercel
   
   # Test locally
   vercel dev
   ```

3. **Verify Environment Variables**:
   ```bash
   # Check if variables are set
   vercel env ls
   ```

## Monitoring and Maintenance

### Performance Monitoring

1. **Vercel Analytics**: Enable in project settings
2. **Function Monitoring**: Monitor API function performance
3. **Database Monitoring**: Use Supabase dashboard for database metrics

### Regular Maintenance

1. **Dependency Updates**: Regularly update Flutter and Node.js dependencies
2. **Security Updates**: Keep Supabase and other dependencies updated
3. **Backup Strategy**: Ensure database backups are configured in Supabase

### Scaling Considerations

1. **API Limits**: Monitor Vercel function execution limits
2. **Database Performance**: Optimize queries and add indexes as needed
3. **CDN**: Vercel automatically provides global CDN for static assets

## Additional Resources

- [Vercel Documentation](https://vercel.com/docs)
- [Flutter Web Documentation](https://flutter.dev/web)
- [Supabase Documentation](https://supabase.com/docs)
- [Vercel CLI Documentation](https://vercel.com/docs/cli)

## Support

For deployment issues:

1. Check Vercel deployment logs
2. Review this documentation
3. Consult Vercel and Flutter community forums
4. Contact the development team for project-specific issues

---

**Last Updated**: December 2024
**Version**: 1.0.0
