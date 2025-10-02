-- Create custom types
CREATE TYPE meal_type AS ENUM ('breakfast', 'lunch', 'dinner', 'snack');
CREATE TYPE unit_type AS ENUM ('grams', 'ounces', 'cups', 'tablespoons', 'teaspoons', 'pieces', 'slices');
CREATE TYPE fitness_level_type AS ENUM ('beginner', 'intermediate', 'advanced');
CREATE TYPE gender_type AS ENUM ('male', 'female', 'other', 'prefer_not_to_say');

-- Create enhanced user profiles table (replacing the existing user_profiles)
CREATE TABLE public.user_profiles (
  id UUID REFERENCES auth.users(id) ON DELETE CASCADE PRIMARY KEY,
  email TEXT UNIQUE NOT NULL,
  name TEXT,
  age INTEGER,
  gender gender_type,
  height_cm INTEGER,
  weight_kg INTEGER,
  fitness_level fitness_level_type,
  goal TEXT,
  gym_access BOOLEAN DEFAULT false,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create workouts table
CREATE TABLE public.workouts (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  title TEXT NOT NULL,
  summary TEXT,
  days_per_week INTEGER,
  plan JSONB,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW(),
  updated_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create exercise_log table
CREATE TABLE public.exercise_log (
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

-- Create health_data table
CREATE TABLE public.health_data (
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

-- Create progress table
CREATE TABLE public.progress (
  id UUID DEFAULT gen_random_uuid() PRIMARY KEY,
  user_id UUID REFERENCES auth.users(id) ON DELETE CASCADE NOT NULL,
  date DATE NOT NULL,
  weight_kg DECIMAL(5,2),
  notes TEXT,
  summary TEXT,
  created_at TIMESTAMP WITH TIME ZONE DEFAULT NOW()
);

-- Create meals table (existing nutrition tracking)
CREATE TABLE public.meals (
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

-- Create meal_foods junction table (existing)
CREATE TABLE public.meal_foods (
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

-- Create user nutrition goals table (existing)
CREATE TABLE public.user_nutrition_goals (
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

-- Create indexes for better performance
CREATE INDEX idx_meals_user_date ON public.meals(user_id, meal_date);
CREATE INDEX idx_meals_user_type ON public.meals(user_id, meal_type);
CREATE INDEX idx_meal_foods_meal_id ON public.meal_foods(meal_id);
CREATE INDEX idx_workouts_user_id ON public.workouts(user_id);
CREATE INDEX idx_exercise_log_user_date ON public.exercise_log(user_id, date);
CREATE INDEX idx_health_data_user_date ON public.health_data(user_id, date);
CREATE INDEX idx_progress_user_date ON public.progress(user_id, date);

-- Enable Row Level Security on all tables
ALTER TABLE public.user_profiles ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.workouts ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.exercise_log ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.health_data ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.progress ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meals ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.meal_foods ENABLE ROW LEVEL SECURITY;
ALTER TABLE public.user_nutrition_goals ENABLE ROW LEVEL SECURITY;

-- Create RLS policies for user profiles
CREATE POLICY "Users can view own profile" ON public.user_profiles
  FOR SELECT USING (auth.uid() = id);

CREATE POLICY "Users can insert own profile" ON public.user_profiles
  FOR INSERT WITH CHECK (auth.uid() = id);

CREATE POLICY "Users can update own profile" ON public.user_profiles
  FOR UPDATE USING (auth.uid() = id);

-- Create RLS policies for workouts
CREATE POLICY "Users can view own workouts" ON public.workouts
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own workouts" ON public.workouts
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own workouts" ON public.workouts
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own workouts" ON public.workouts
  FOR DELETE USING (auth.uid() = user_id);

-- Create RLS policies for exercise_log
CREATE POLICY "Users can view own exercise logs" ON public.exercise_log
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own exercise logs" ON public.exercise_log
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own exercise logs" ON public.exercise_log
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own exercise logs" ON public.exercise_log
  FOR DELETE USING (auth.uid() = user_id);

-- Create RLS policies for health_data
CREATE POLICY "Users can view own health data" ON public.health_data
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own health data" ON public.health_data
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own health data" ON public.health_data
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own health data" ON public.health_data
  FOR DELETE USING (auth.uid() = user_id);

-- Create RLS policies for progress
CREATE POLICY "Users can view own progress" ON public.progress
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own progress" ON public.progress
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own progress" ON public.progress
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own progress" ON public.progress
  FOR DELETE USING (auth.uid() = user_id);

-- Create RLS policies for meals (existing)
CREATE POLICY "Users can view own meals" ON public.meals
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own meals" ON public.meals
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own meals" ON public.meals
  FOR UPDATE USING (auth.uid() = user_id);

CREATE POLICY "Users can delete own meals" ON public.meals
  FOR DELETE USING (auth.uid() = user_id);

-- Create RLS policies for meal_foods (existing)
CREATE POLICY "Users can view own meal foods" ON public.meal_foods
  FOR SELECT USING (
    EXISTS (
      SELECT 1 FROM public.meals 
      WHERE meals.id = meal_foods.meal_id 
      AND meals.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can insert own meal foods" ON public.meal_foods
  FOR INSERT WITH CHECK (
    EXISTS (
      SELECT 1 FROM public.meals 
      WHERE meals.id = meal_foods.meal_id 
      AND meals.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can update own meal foods" ON public.meal_foods
  FOR UPDATE USING (
    EXISTS (
      SELECT 1 FROM public.meals 
      WHERE meals.id = meal_foods.meal_id 
      AND meals.user_id = auth.uid()
    )
  );

CREATE POLICY "Users can delete own meal foods" ON public.meal_foods
  FOR DELETE USING (
    EXISTS (
      SELECT 1 FROM public.meals 
      WHERE meals.id = meal_foods.meal_id 
      AND meals.user_id = auth.uid()
    )
  );

-- Create RLS policies for nutrition goals (existing)
CREATE POLICY "Users can view own nutrition goals" ON public.user_nutrition_goals
  FOR SELECT USING (auth.uid() = user_id);

CREATE POLICY "Users can insert own nutrition goals" ON public.user_nutrition_goals
  FOR INSERT WITH CHECK (auth.uid() = user_id);

CREATE POLICY "Users can update own nutrition goals" ON public.user_nutrition_goals
  FOR UPDATE USING (auth.uid() = user_id);

-- Create function to automatically create user profile on signup (enhanced)
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

-- Create trigger to call the function when a user signs up
CREATE TRIGGER on_auth_user_created
  AFTER INSERT ON auth.users
  FOR EACH ROW EXECUTE FUNCTION public.handle_new_user();

-- Create function to update meal totals when foods are added/updated (existing)
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

-- Create trigger to update meal totals when foods change (existing)
CREATE TRIGGER on_meal_foods_changed
  AFTER INSERT OR UPDATE OR DELETE ON public.meal_foods
  FOR EACH ROW EXECUTE FUNCTION public.update_meal_totals();
