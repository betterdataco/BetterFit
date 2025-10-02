# BetterFitAi - Your Personal Trainer on Your Phone

BetterFitAi is a comprehensive fitness and nutrition tracking application built with Flutter, designed to be your personal trainer and nutritionist in your pocket. The app combines advanced AI-driven insights with real-time health data to provide personalized workout plans, meal tracking, and progress monitoring.

## 🏋️ **Overview**

BetterFitAi is a cross-platform mobile and web application that helps users achieve their fitness goals through:

- **Personalized Workout Plans** - AI-generated exercise routines based on your fitness level and goals
- **Nutrition Tracking** - Comprehensive meal logging with USDA Food Database integration
- **Progress Monitoring** - Real-time tracking of fitness metrics and achievements
- **Health Integration** - Sync with health apps and wearable devices
- **AI-Powered Insights** - Smart recommendations and progress analysis

## 🏗️ **Architecture**

The application follows clean architecture principles with a feature-first project structure:

```
BetterFit/
├── flutter_application/          # Flutter mobile & web app
│   ├── lib/
│   │   ├── core/                # Core utilities and services
│   │   ├── features/            # Feature modules
│   │   └── main.dart           # App entry point
│   ├── assets/                 # Images and resources
│   └── web/                   # Web-specific configurations
├── api/                        # Serverless API functions
├── supabase/                  # Database migrations and setup
└── scripts/                   # Build and deployment scripts
```

## 📱 **Core Modules**

### **1. Authentication & User Management**
- **Supabase Auth Integration** - Secure user authentication
- **Profile Management** - User profiles with fitness goals and preferences
- **Onboarding Flow** - Guided setup for new users
- **Settings & Preferences** - Customizable app settings

### **2. Exercise & Workout Management**
- **Exercise Database** - Comprehensive library of exercises with instructions
- **Workout Plans** - AI-generated personalized workout routines
- **Progress Tracking** - Track sets, reps, and weights
- **Exercise Categories** - Organized by muscle groups and equipment

### **3. Nutrition & Meal Tracking**
- **USDA Food Database** - Real-time nutrition data from USDA API
- **Meal Logging** - Track daily food intake with detailed nutrition info
- **Nutrition Goals** - Set and monitor macro and micronutrient targets
- **Food Search** - Advanced search with barcode scanning capability

### **4. Progress & Analytics**
- **Health Metrics** - Track weight, body fat, measurements
- **Achievement System** - Gamified progress tracking
- **AI Insights** - Smart recommendations based on progress
- **Weekly Reports** - Comprehensive progress summaries

### **5. Health Integration**
- **Wearable Device Sync** - Connect with fitness trackers
- **Health App Integration** - Import data from Apple Health/Google Fit
- **Real-time Monitoring** - Live health metrics tracking

## 🛠️ **Technology Stack**

### **Frontend**
- **Flutter** - Cross-platform mobile and web development
- **Dart** - Programming language
- **BLoC/Cubit** - State management
- **GoRouter** - Navigation
- **Hive** - Local database

### **Backend**
- **Supabase** - Backend-as-a-Service
- **PostgreSQL** - Database
- **Serverless Functions** - API endpoints
- **Real-time Subscriptions** - Live data updates

### **APIs & Integrations**
- **USDA Food Data API** - Nutrition information
- **Supabase Auth** - User authentication
- **Health APIs** - Device integration

### **Deployment**
- **Vercel** - Web deployment
- **GitHub** - Version control
- **Flutter Web** - Web platform support

## 🚀 **Getting Started**

### **Prerequisites**
- Flutter SDK 3.24.0+
- Node.js 18.x+
- Supabase account
- USDA Food Data API key

### **Environment Setup**

1. **Clone the repository**
   ```bash
   git clone https://github.com/betterdataco/BetterFit.git
   cd BetterFit
   ```

2. **Install dependencies**
   ```bash
   cd flutter_application
   flutter pub get
   ```

3. **Configure environment variables**
   ```bash
   # Create .env file
   SUPABASE_URL=your_supabase_project_url
   SUPABASE_ANON_KEY=your_supabase_anon_key
   USDA_FOOD_DATA_API_KEY=your_usda_api_key
   ```

4. **Set up Supabase**
   - Create a new Supabase project
   - Run the database setup script from `supabase_exercises_setup.sql`
   - Configure authentication settings

5. **Run the application**
   ```bash
   flutter run
   ```

## 📊 **Database Schema**

### **Core Tables**
- **user_profiles** - User information and fitness goals
- **exercises** - Exercise library with instructions
- **workouts** - Workout plans and routines
- **meals** - Meal tracking and nutrition data
- **progress_data** - Health metrics and progress tracking
- **achievements** - User achievements and milestones

## 🔧 **API Endpoints**

### **Exercise API**
- `GET /api/exercises` - Get exercise library
- `GET /api/exercises/statistics` - Get exercise statistics

### **Nutrition API**
- Integration with USDA Food Data API
- Real-time nutrition information
- Food search and details

## 🎨 **Features**

### **User Experience**
- **Dark/Light Mode** - Adaptive theming
- **Responsive Design** - Works on all screen sizes
- **Offline Support** - Core features work without internet
- **Accessibility** - Screen reader and accessibility support

### **AI & Analytics**
- **Smart Recommendations** - AI-powered workout and nutrition suggestions
- **Progress Analysis** - Detailed insights into fitness trends
- **Goal Tracking** - Personalized goal setting and monitoring
- **Predictive Analytics** - Forecast progress and outcomes

## 🚀 **Deployment**

### **Web Deployment (Vercel)**
1. Set up environment variables in Vercel
2. Connect GitHub repository
3. Deploy using the included build scripts

### **Mobile Deployment**
- **iOS** - Build and deploy to App Store
- **Android** - Build and deploy to Google Play Store

## 📈 **Roadmap**

### **Phase 1** ✅
- [x] Core app structure
- [x] Authentication system
- [x] Basic exercise tracking
- [x] Nutrition logging

### **Phase 2** 🚧
- [ ] AI workout recommendations
- [ ] Advanced progress analytics
- [ ] Social features
- [ ] Wearable device integration

### **Phase 3** 📋
- [ ] Personal trainer AI
- [ ] Advanced nutrition planning
- [ ] Community features
- [ ] Premium subscriptions

## 🤝 **Contributing**

We welcome contributions! Please see our contributing guidelines for details on how to:
- Report bugs
- Suggest features
- Submit pull requests
- Set up development environment

## 📄 **License**

This project is licensed under the MIT License - see the LICENSE file for details.

## 📞 **Support**

- **Email**: support@betterfitai.com
- **Documentation**: [docs.betterfitai.com](https://docs.betterfitai.com)
- **Issues**: [GitHub Issues](https://github.com/betterdataco/BetterFit/issues)

## 🙏 **Acknowledgments**

- **USDA** - For providing comprehensive nutrition data
- **Supabase** - For backend infrastructure
- **Flutter Team** - For the amazing framework
- **Open Source Community** - For various packages and tools

---

**BetterFitAi** - Empowering your fitness journey with AI-driven insights and personalized training. 🏋️‍♀️💪