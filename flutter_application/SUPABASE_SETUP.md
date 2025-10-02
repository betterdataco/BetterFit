# BetterFit Supabase Database Setup Guide

## 🗄️ **Database Setup**

### **Step 1: Create Supabase Project**

1. Go to [Supabase Dashboard](https://supabase.com/dashboard)
2. Click "New Project"
3. Choose your organization
4. Enter project details:
   - **Name**: `betterfit-db`
   - **Database Password**: Generate a strong password
   - **Region**: Choose closest to your users
5. Click "Create new project"

### **Step 2: Get Project Credentials**

1. Go to Project Settings → API
2. Copy the following:
   - **Project URL**: `https://your-project-id.supabase.co`
   - **Anon Key**: `your-anon-key`
   - **Service Role Key**: `your-service-role-key` (keep this secret)

### **Step 3: Set Environment Variables**

Create a `.env` file in your Flutter project root:

```bash
SUPABASE_URL=https://your-project-id.supabase.co
SUPABASE_ANON_KEY=your-anon-key
```

### **Step 4: Run Database Setup Script**

1. Go to your Supabase Dashboard
2. Navigate to SQL Editor
3. Copy and paste the contents of `supabase_exercises_setup.sql`
4. Click "Run" to execute the script

## 📊 **Database Schema**

### **Exercises Table**

```sql
CREATE TABLE exercises (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    muscle_group VARCHAR(100) NOT NULL,
    equipment VARCHAR(100) NOT NULL,
    difficulty VARCHAR(50) NOT NULL,
    instructions TEXT NOT NULL,
    sets INTEGER NOT NULL,
    reps INTEGER NOT NULL,
    rest_time INTEGER NOT NULL,
    calories_burned INTEGER NOT NULL,
    image_url TEXT,
    video_url TEXT,
    created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
    updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);
```

### **Indexes for Performance**

- `idx_exercises_category` - For filtering by category
- `idx_exercises_muscle_group` - For filtering by muscle group
- `idx_exercises_difficulty` - For filtering by difficulty
- `idx_exercises_equipment` - For filtering by equipment

### **Views for Analytics**

- `exercises_by_difficulty` - Statistics by difficulty level
- `exercises_by_category` - Statistics by exercise category

## 🔐 **Row Level Security (RLS)**

### **Policies**

1. **Public Read Access**: Anyone can read exercises
2. **Authenticated Write Access**: Only authenticated users can modify exercises
3. **Admin Controls**: Service role has full access

### **Policy Details**

```sql
-- Allow public read access
CREATE POLICY "Allow public read access to exercises" ON exercises
    FOR SELECT USING (true);

-- Allow authenticated users to insert/update/delete
CREATE POLICY "Allow authenticated users to manage exercises" ON exercises
    FOR ALL USING (auth.role() = 'authenticated');
```

## 📱 **Flutter Integration**

### **Step 1: Add Dependencies**

Ensure these are in your `pubspec.yaml`:

```yaml
dependencies:
  supabase_flutter: ^2.3.2
  equatable: ^2.0.5
  flutter_bloc: ^8.1.3
```

### **Step 2: Initialize Supabase**

In your `main.dart`:

```dart
import 'package:supabase_flutter/supabase_flutter.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  
  await Supabase.initialize(
    url: 'YOUR_SUPABASE_URL',
    anonKey: 'YOUR_SUPABASE_ANON_KEY',
  );
  
  runApp(MyApp());
}
```

### **Step 3: Register Dependencies**

In your dependency injection:

```dart
// Register Supabase client
getIt.registerLazySingleton<SupabaseClient>(
  () => Supabase.instance.client,
);

// Register exercise repository
getIt.registerLazySingleton<ExerciseRepository>(
  () => ExerciseRepositoryImpl(getIt<SupabaseClient>()),
);

// Register use cases
getIt.registerLazySingleton(() => GetExercisesUseCase(getIt()));
getIt.registerLazySingleton(() => GetExercisesByCategoryUseCase(getIt()));
getIt.registerLazySingleton(() => SearchExercisesUseCase(getIt()));
```

## 🧪 **Testing the Setup**

### **Step 1: Verify Data Import**

Run this query in Supabase SQL Editor:

```sql
-- Check total exercises
SELECT COUNT(*) as total_exercises FROM exercises;

-- Check by difficulty
SELECT difficulty, COUNT(*) as count 
FROM exercises 
GROUP BY difficulty 
ORDER BY 
    CASE difficulty 
        WHEN 'beginner' THEN 1 
        WHEN 'intermediate' THEN 2 
        WHEN 'advanced' THEN 3 
    END;

-- Check by category
SELECT category, COUNT(*) as count 
FROM exercises 
GROUP BY category 
ORDER BY count DESC;
```

### **Step 2: Test Flutter Integration**

Create a simple test widget:

```dart
class ExerciseTestWidget extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return FutureBuilder<List<Exercise>>(
      future: GetExercisesUseCase(getIt()).call(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return CircularProgressIndicator();
        }
        
        if (snapshot.hasError) {
          return Text('Error: ${snapshot.error}');
        }
        
        final exercises = snapshot.data!;
        return ListView.builder(
          itemCount: exercises.length,
          itemBuilder: (context, index) {
            final exercise = exercises[index];
            return ListTile(
              title: Text(exercise.name),
              subtitle: Text('${exercise.category} - ${exercise.difficulty}'),
            );
          },
        );
      },
    );
  }
}
```

## 📈 **Exercise Categories**

### **Available Categories**
- **Strength**: Weight training, muscle building
- **Cardio**: Cardiovascular exercises
- **Core**: Abdominal and core exercises
- **Plyometric**: Jump training, explosive movements

### **Muscle Groups**
- **Chest**: Pectoral muscles
- **Back**: Latissimus dorsi, trapezius
- **Legs**: Quadriceps, hamstrings, calves
- **Arms**: Biceps, triceps
- **Shoulders**: Deltoids
- **Abs**: Rectus abdominis, obliques
- **Full Body**: Multiple muscle groups

### **Difficulty Levels**
- **Beginner**: Suitable for fitness newcomers
- **Intermediate**: Moderate difficulty
- **Advanced**: High intensity, complex movements

### **Equipment Types**
- **Bodyweight**: No equipment needed
- **Dumbbells**: Free weights
- **Barbell**: Olympic bar exercises
- **Pull-up Bar**: Upper body strength
- **Medicine Ball**: Dynamic movements
- **Kettlebell**: Functional training
- **Box**: Plyometric training
- **Battle Ropes**: High-intensity cardio

## 🔧 **Troubleshooting**

### **Common Issues**

1. **Connection Errors**
   - Verify Supabase URL and keys
   - Check internet connection
   - Ensure project is active

2. **Permission Errors**
   - Verify RLS policies are enabled
   - Check user authentication status
   - Review policy conditions

3. **Data Not Loading**
   - Verify SQL script executed successfully
   - Check table structure matches model
   - Review error logs in Supabase dashboard

### **Debug Queries**

```sql
-- Check if exercises table exists
SELECT EXISTS (
    SELECT FROM information_schema.tables 
    WHERE table_name = 'exercises'
);

-- Check RLS status
SELECT schemaname, tablename, rowsecurity 
FROM pg_tables 
WHERE tablename = 'exercises';

-- Check policies
SELECT * FROM pg_policies 
WHERE tablename = 'exercises';
```

## 🚀 **Next Steps**

1. **Add Real Images**: Replace placeholder URLs with actual exercise images
2. **Add Videos**: Include instructional videos for each exercise
3. **Expand Database**: Add more exercises and categories
4. **User Progress**: Create tables for tracking user workout progress
5. **Workout Plans**: Build workout plan generation system
6. **Analytics**: Implement user analytics and progress tracking

## 📞 **Support**

For issues with:
- **Supabase Setup**: Check [Supabase Documentation](https://supabase.com/docs)
- **Flutter Integration**: Review [Supabase Flutter Guide](https://supabase.com/docs/guides/getting-started/tutorials/with-flutter)
- **Database Queries**: Use [PostgreSQL Documentation](https://www.postgresql.org/docs/)

---

**Note**: Keep your service role key secure and never expose it in client-side code. Use it only for server-side operations or admin functions.












