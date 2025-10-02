-- BetterFit Database Reconciliation Script
-- This script reconciles the existing schema with Flutter app requirements
-- Run this in your Supabase SQL editor to ensure all tables, columns, and relationships are properly set up

-- ============================================================================
-- 1. CREATE MISSING ENUM TYPES (if they don't exist)
-- ============================================================================

DO $$ BEGIN
    CREATE TYPE meal_type AS ENUM ('breakfast', 'lunch', 'dinner', 'snack');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE unit_type AS ENUM ('grams', 'ounces', 'cups', 'tablespoons', 'teaspoons', 'pieces', 'slices');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE fitness_level_type AS ENUM ('beginner', 'intermediate', 'advanced');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE TYPE gender_type AS ENUM ('male', 'female', 'other', 'prefer_not_to_say');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- ============================================================================
-- 2. CREATE MISSING EXERCISES TABLE (required by Flutter app)
-- ============================================================================

CREATE TABLE IF NOT EXISTS public.exercises (
  id SERIAL PRIMARY KEY,
  name TEXT NOT NULL,
  category TEXT NOT NULL,
  muscle_group TEXT NOT NULL,
  equipment TEXT NOT NULL,
  difficulty TEXT NOT NULL,
  instructions TEXT NOT NULL,
  sets INTEGER NOT NULL,
  reps INTEGER NOT NULL,
  rest_time INTEGER NOT NULL, -- in seconds
  calories_burned INTEGER NOT NULL,
  image_url TEXT,
  video_url TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- 3. ENSURE USER_PROFILES TABLE HAS ALL REQUIRED COLUMNS
-- ============================================================================

-- Add missing columns to user_profiles if they don't exist
ALTER TABLE public.user_profiles 
ADD COLUMN IF NOT EXISTS name TEXT,
ADD COLUMN IF NOT EXISTS age INTEGER,
ADD COLUMN IF NOT EXISTS gender gender_type,
ADD COLUMN IF NOT EXISTS height_cm INTEGER,
ADD COLUMN IF NOT EXISTS weight_kg INTEGER,
ADD COLUMN IF NOT EXISTS fitness_level fitness_level_type,
ADD COLUMN IF NOT EXISTS goal TEXT,
ADD COLUMN IF NOT EXISTS gym_access BOOLEAN DEFAULT false;

-- ============================================================================
-- 4. ENSURE ALL REQUIRED TABLES EXIST
-- ============================================================================

-- Create workouts table (if not exists)
CREATE TABLE IF NOT EXISTS public.workouts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  summary TEXT,
  days_per_week INTEGER,
  plan JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create exercise_log table (if not exists)
CREATE TABLE IF NOT EXISTS public.exercise_log (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  exercise_name TEXT NOT NULL,
  date DATE NOT NULL,
  reps INTEGER,
  sets INTEGER,
  duration_minutes INTEGER,
  calories_estimated INTEGER,
  source TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create health_data table (if not exists)
CREATE TABLE IF NOT EXISTS public.health_data (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  date DATE NOT NULL,
  steps INTEGER,
  heart_rate_avg INTEGER,
  sleep_hours DECIMAL(4,2),
  calories_burned INTEGER,
  source TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create progress table (if not exists)
CREATE TABLE IF NOT EXISTS public.progress (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  date DATE NOT NULL,
  weight_kg DECIMAL(5,2),
  notes TEXT,
  summary TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create meals table (if not exists)
CREATE TABLE IF NOT EXISTS public.meals (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  meal_type meal_type NOT NULL,
  meal_date DATE NOT NULL,
  meal_time TIME,
  total_calories INTEGER DEFAULT 0,
  total_protein DECIMAL(8,2) DEFAULT 0,
  total_carbs DECIMAL(8,2) DEFAULT 0,
  total_fat DECIMAL(8,2) DEFAULT 0,
  total_fiber DECIMAL(8,2) DEFAULT 0,
  total_sodium DECIMAL(8,2) DEFAULT 0,
  notes TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create meal_foods table (if not exists)
CREATE TABLE IF NOT EXISTS public.meal_foods (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  meal_id UUID REFERENCES public.meals(id) ON DELETE CASCADE NOT NULL,
  food_name TEXT NOT NULL,
  usda_fdc_id TEXT, -- USDA FoodData Central ID
  quantity DECIMAL(8,2) NOT NULL,
  unit unit_type NOT NULL,
  calories INTEGER DEFAULT 0,
  protein DECIMAL(8,2) DEFAULT 0,
  carbs DECIMAL(8,2) DEFAULT 0,
  fat DECIMAL(8,2) DEFAULT 0,
  fiber DECIMAL(8,2) DEFAULT 0,
  sodium DECIMAL(8,2) DEFAULT 0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create user_nutrition_goals table (if not exists)
CREATE TABLE IF NOT EXISTS public.user_nutrition_goals (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE UNIQUE NOT NULL,
  daily_calories INTEGER DEFAULT 2000,
  daily_protein DECIMAL(8,2) DEFAULT 150.0,
  daily_carbs DECIMAL(8,2) DEFAULT 250.0,
  daily_fat DECIMAL(8,2) DEFAULT 65.0,
  daily_fiber DECIMAL(8,2) DEFAULT 25.0,
  daily_sodium DECIMAL(8,2) DEFAULT 2300.0,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- ============================================================================
-- 5. CREATE INDEXES FOR PERFORMANCE
-- ============================================================================

CREATE INDEX IF NOT EXISTS idx_exercises_category ON public.exercises(category);
CREATE INDEX IF NOT EXISTS idx_exercises_muscle_group ON public.exercises(muscle_group);
CREATE INDEX IF NOT EXISTS idx_exercises_difficulty ON public.exercises(difficulty);
CREATE INDEX IF NOT EXISTS idx_exercises_equipment ON public.exercises(equipment);
CREATE INDEX IF NOT EXISTS idx_meals_user_date ON public.meals(user_id, meal_date);
CREATE INDEX IF NOT EXISTS idx_meals_user_type ON public.meals(user_id, meal_type);
CREATE INDEX IF NOT EXISTS idx_meal_foods_meal_id ON public.meal_foods(meal_id);
CREATE INDEX IF NOT EXISTS idx_workouts_user_id ON public.workouts(user_id);
CREATE INDEX IF NOT EXISTS idx_exercise_log_user_date ON public.exercise_log(user_id, date);
CREATE INDEX IF NOT EXISTS idx_health_data_user_date ON public.health_data(user_id, date);
CREATE INDEX IF NOT EXISTS idx_progress_user_date ON public.progress(user_id, date);

-- ============================================================================
-- 6. ENABLE ROW LEVEL SECURITY
-- ============================================================================

ALTER TABLE public.exercises ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exercise_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.health_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meal_foods ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_nutrition_goals ENABLE ROW LEVEL SECURITY;

-- ============================================================================
-- 7. CREATE RLS POLICIES
-- ============================================================================

-- Exercises table policies (read-only for all authenticated users)
DO $$ BEGIN
    CREATE POLICY "Anyone can view exercises" ON public.exercises
      FOR SELECT USING (auth.role() = 'authenticated');
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- User profiles policies
DO $$ BEGIN
    CREATE POLICY "Users can view own profile" ON public.user_profiles
      FOR SELECT USING (auth.uid() = id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can insert own profile" ON public.user_profiles
      FOR INSERT WITH CHECK (auth.uid() = id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can update own profile" ON public.user_profiles
      FOR UPDATE USING (auth.uid() = id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Workouts policies
DO $$ BEGIN
    CREATE POLICY "Users can view own workouts" ON public.workouts
      FOR SELECT USING (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can insert own workouts" ON public.workouts
      FOR INSERT WITH CHECK (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can update own workouts" ON public.workouts
      FOR UPDATE USING (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can delete own workouts" ON public.workouts
      FOR DELETE USING (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Exercise log policies
DO $$ BEGIN
    CREATE POLICY "Users can view own exercise logs" ON public.exercise_log
      FOR SELECT USING (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can insert own exercise logs" ON public.exercise_log
      FOR INSERT WITH CHECK (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can update own exercise logs" ON public.exercise_log
      FOR UPDATE USING (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can delete own exercise logs" ON public.exercise_log
      FOR DELETE USING (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Health data policies
DO $$ BEGIN
    CREATE POLICY "Users can view own health data" ON public.health_data
      FOR SELECT USING (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can insert own health data" ON public.health_data
      FOR INSERT WITH CHECK (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can update own health data" ON public.health_data
      FOR UPDATE USING (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can delete own health data" ON public.health_data
      FOR DELETE USING (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Progress policies
DO $$ BEGIN
    CREATE POLICY "Users can view own progress" ON public.progress
      FOR SELECT USING (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can insert own progress" ON public.progress
      FOR INSERT WITH CHECK (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can update own progress" ON public.progress
      FOR UPDATE USING (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can delete own progress" ON public.progress
      FOR DELETE USING (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Meals policies
DO $$ BEGIN
    CREATE POLICY "Users can view own meals" ON public.meals
      FOR SELECT USING (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can insert own meals" ON public.meals
      FOR INSERT WITH CHECK (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can update own meals" ON public.meals
      FOR UPDATE USING (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can delete own meals" ON public.meals
      FOR DELETE USING (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Meal foods policies
DO $$ BEGIN
    CREATE POLICY "Users can view own meal foods" ON public.meal_foods
      FOR SELECT USING (
        EXISTS (
          SELECT 1 FROM public.meals 
          WHERE meals.id = meal_foods.meal_id 
          AND meals.user_id = auth.uid()
        )
      );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can insert own meal foods" ON public.meal_foods
      FOR INSERT WITH CHECK (
        EXISTS (
          SELECT 1 FROM public.meals 
          WHERE meals.id = meal_foods.meal_id 
          AND meals.user_id = auth.uid()
        )
      );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can update own meal foods" ON public.meal_foods
      FOR UPDATE USING (
        EXISTS (
          SELECT 1 FROM public.meals 
          WHERE meals.id = meal_foods.meal_id 
          AND meals.user_id = auth.uid()
        )
      );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can delete own meal foods" ON public.meal_foods
      FOR DELETE USING (
        EXISTS (
          SELECT 1 FROM public.meals 
          WHERE meals.id = meal_foods.meal_id 
          AND meals.user_id = auth.uid()
        )
      );
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Nutrition goals policies
DO $$ BEGIN
    CREATE POLICY "Users can view own nutrition goals" ON public.user_nutrition_goals
      FOR SELECT USING (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can insert own nutrition goals" ON public.user_nutrition_goals
      FOR INSERT WITH CHECK (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

DO $$ BEGIN
    CREATE POLICY "Users can update own nutrition goals" ON public.user_nutrition_goals
      FOR UPDATE USING (auth.uid() = user_id);
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- ============================================================================
-- 8. CREATE TRIGGERS AND FUNCTIONS
-- ============================================================================

-- Function to handle new user creation
CREATE OR REPLACE FUNCTION public.handle_new_user()
RETURNS TRIGGER AS $$
BEGIN
  INSERT INTO public.user_profiles (id, email)
  VALUES (NEW.id, NEW.email);
  
  -- Create default nutrition goals
  INSERT INTO public.user_nutrition_goals (user_id)
  VALUES (NEW.id);
  
  RETURN NEW;
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for new user creation (if not exists)
DO $$ BEGIN
    CREATE TRIGGER on_auth_user_created
      AFTER INSERT ON auth.users
      FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- Function to update meal totals when foods are added/updated
CREATE OR REPLACE FUNCTION public.update_meal_totals()
RETURNS TRIGGER AS $$
BEGIN
  UPDATE public.meals
  SET 
    total_calories = (
      SELECT COALESCE(SUM(calories), 0)
      FROM public.meal_foods
      WHERE meal_id = COALESCE(NEW.meal_id, OLD.meal_id)
    ),
    total_protein = (
      SELECT COALESCE(SUM(protein), 0)
      FROM public.meal_foods
      WHERE meal_id = COALESCE(NEW.meal_id, OLD.meal_id)
    ),
    total_carbs = (
      SELECT COALESCE(SUM(carbs), 0)
      FROM public.meal_foods
      WHERE meal_id = COALESCE(NEW.meal_id, OLD.meal_id)
    ),
    total_fat = (
      SELECT COALESCE(SUM(fat), 0)
      FROM public.meal_foods
      WHERE meal_id = COALESCE(NEW.meal_id, OLD.meal_id)
    ),
    total_fiber = (
      SELECT COALESCE(SUM(fiber), 0)
      FROM public.meal_foods
      WHERE meal_id = COALESCE(NEW.meal_id, OLD.meal_id)
    ),
    total_sodium = (
      SELECT COALESCE(SUM(sodium), 0)
      FROM public.meal_foods
      WHERE meal_id = COALESCE(NEW.meal_id, OLD.meal_id)
    ),
    updated_at = NOW()
  WHERE id = COALESCE(NEW.meal_id, OLD.meal_id);
  
  RETURN COALESCE(NEW, OLD);
END;
$$ LANGUAGE plpgsql SECURITY DEFINER;

-- Create trigger for meal totals update (if not exists)
DO $$ BEGIN
    CREATE TRIGGER on_meal_foods_changed
      AFTER INSERT OR UPDATE OR DELETE ON public.meal_foods
      FOR EACH ROW EXECUTE FUNCTION public.update_meal_totals();
EXCEPTION
    WHEN duplicate_object THEN null;
END $$;

-- ============================================================================
-- 9. INSERT SAMPLE EXERCISE DATA (if exercises table is empty)
-- ============================================================================

-- Only insert if the table is empty
INSERT INTO public.exercises (name, category, muscle_group, equipment, difficulty, instructions, sets, reps, rest_time, calories_burned, image_url, video_url)
SELECT * FROM (VALUES
  ('Push-ups', 'strength', 'chest', 'bodyweight', 'beginner', 'Start in a plank position with hands shoulder-width apart. Lower your body until your chest nearly touches the floor, then push back up.', 3, 10, 60, 8, 'https://example.com/pushups.jpg', 'https://example.com/pushups.mp4'),
  ('Squats', 'strength', 'legs', 'bodyweight', 'beginner', 'Stand with feet shoulder-width apart. Lower your body as if sitting back into a chair, keeping your chest up and knees behind toes.', 3, 15, 60, 12, 'https://example.com/squats.jpg', 'https://example.com/squats.mp4'),
  ('Plank', 'core', 'abs', 'bodyweight', 'beginner', 'Hold a plank position with your body in a straight line from head to heels. Engage your core and hold the position.', 3, 30, 45, 6, 'https://example.com/plank.jpg', 'https://example.com/plank.mp4'),
  ('Burpees', 'cardio', 'full_body', 'bodyweight', 'intermediate', 'Start standing, drop into a squat, kick feet back into plank, do a push-up, jump feet forward, and jump up with arms overhead.', 3, 10, 90, 15, 'https://example.com/burpees.jpg', 'https://example.com/burpees.mp4'),
  ('Pull-ups', 'strength', 'back', 'pull-up_bar', 'advanced', 'Hang from a pull-up bar with hands shoulder-width apart. Pull your body up until your chin is over the bar, then lower down.', 3, 8, 120, 10, 'https://example.com/pullups.jpg', 'https://example.com/pullups.mp4'),
  ('Lunges', 'strength', 'legs', 'bodyweight', 'beginner', 'Step forward with one leg and lower your body until both knees are bent at 90 degrees. Push back to starting position.', 3, 12, 60, 10, 'https://example.com/lunges.jpg', 'https://example.com/lunges.mp4'),
  ('Mountain Climbers', 'cardio', 'core', 'bodyweight', 'intermediate', 'Start in plank position. Alternately bring knees toward chest in a running motion while maintaining plank position.', 3, 20, 60, 12, 'https://example.com/mountain_climbers.jpg', 'https://example.com/mountain_climbers.mp4'),
  ('Jumping Jacks', 'cardio', 'full_body', 'bodyweight', 'beginner', 'Start standing, jump feet apart while raising arms overhead, then jump back to starting position.', 3, 30, 45, 8, 'https://example.com/jumping_jacks.jpg', 'https://example.com/jumping_jacks.mp4'),
  ('Dumbbell Rows', 'strength', 'back', 'dumbbells', 'intermediate', 'Bend at waist, hold dumbbell in one hand, pull elbow back to lift weight toward hip.', 3, 12, 90, 10, 'https://example.com/dumbbell_rows.jpg', 'https://example.com/dumbbell_rows.mp4'),
  ('Crunches', 'core', 'abs', 'bodyweight', 'beginner', 'Lie on back with knees bent, lift shoulders off ground using abdominal muscles.', 3, 15, 45, 5, 'https://example.com/crunches.jpg', 'https://example.com/crunches.mp4')
) AS v(name, category, muscle_group, equipment, difficulty, instructions, sets, reps, rest_time, calories_burned, image_url, video_url)
WHERE NOT EXISTS (SELECT 1 FROM public.exercises LIMIT 1);

-- ============================================================================
-- 10. VERIFICATION QUERIES
-- ============================================================================

-- Check if all tables exist
SELECT 
  table_name,
  CASE WHEN table_name IS NOT NULL THEN 'EXISTS' ELSE 'MISSING' END as status
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN (
  'exercises', 'user_profiles', 'workouts', 'exercise_log', 
  'health_data', 'progress', 'meals', 'meal_foods', 'user_nutrition_goals'
);

-- Check if all required columns exist in user_profiles
SELECT 
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'user_profiles'
ORDER BY ordinal_position;

-- Check RLS policies
SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd,
  qual,
  with_check
FROM pg_policies 
WHERE schemaname = 'public'
ORDER BY tablename, policyname;
