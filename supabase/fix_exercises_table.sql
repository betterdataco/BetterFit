-- Fix for exercises table missing columns
-- This script addresses the "column category does not exist" error

-- First, let's check if the exercises table exists and what columns it has
SELECT 
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'exercises'
ORDER BY ordinal_position;

-- Drop the exercises table if it exists (to recreate with correct structure)
DROP TABLE IF EXISTS public.exercises CASCADE;

-- Recreate the exercises table with the correct structure
CREATE TABLE public.exercises (
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

-- Create indexes for the exercises table
CREATE INDEX idx_exercises_category ON public.exercises(category);
CREATE INDEX idx_exercises_muscle_group ON public.exercises(muscle_group);
CREATE INDEX idx_exercises_difficulty ON public.exercises(difficulty);
CREATE INDEX idx_exercises_equipment ON public.exercises(equipment);

-- Enable Row Level Security
ALTER TABLE public.exercises ENABLE ROW LEVEL SECURITY;

-- Create RLS policy for exercises (read-only for all authenticated users)
CREATE POLICY "Anyone can view exercises" ON public.exercises
  FOR SELECT USING (auth.role() = 'authenticated');

-- Insert sample exercise data
INSERT INTO public.exercises (name, category, muscle_group, equipment, difficulty, instructions, sets, reps, rest_time, calories_burned, image_url, video_url) VALUES
  ('Push-ups', 'strength', 'chest', 'bodyweight', 'beginner', 'Start in a plank position with hands shoulder-width apart. Lower your body until your chest nearly touches the floor, then push back up.', 3, 10, 60, 8, 'https://example.com/pushups.jpg', 'https://example.com/pushups.mp4'),
  ('Squats', 'strength', 'legs', 'bodyweight', 'beginner', 'Stand with feet shoulder-width apart. Lower your body as if sitting back into a chair, keeping your chest up and knees behind toes.', 3, 15, 60, 12, 'https://example.com/squats.jpg', 'https://example.com/squats.mp4'),
  ('Plank', 'core', 'abs', 'bodyweight', 'beginner', 'Hold a plank position with your body in a straight line from head to heels. Engage your core and hold the position.', 3, 30, 45, 6, 'https://example.com/plank.jpg', 'https://example.com/plank.mp4'),
  ('Burpees', 'cardio', 'full_body', 'bodyweight', 'intermediate', 'Start standing, drop into a squat, kick feet back into plank, do a push-up, jump feet forward, and jump up with arms overhead.', 3, 10, 90, 15, 'https://example.com/burpees.jpg', 'https://example.com/burpees.mp4'),
  ('Pull-ups', 'strength', 'back', 'pull-up_bar', 'advanced', 'Hang from a pull-up bar with hands shoulder-width apart. Pull your body up until your chin is over the bar, then lower down.', 3, 8, 120, 10, 'https://example.com/pullups.jpg', 'https://example.com/pullups.mp4'),
  ('Lunges', 'strength', 'legs', 'bodyweight', 'beginner', 'Step forward with one leg and lower your body until both knees are bent at 90 degrees. Push back to starting position.', 3, 12, 60, 10, 'https://example.com/lunges.jpg', 'https://example.com/lunges.mp4'),
  ('Mountain Climbers', 'cardio', 'core', 'bodyweight', 'intermediate', 'Start in plank position. Alternately bring knees toward chest in a running motion while maintaining plank position.', 3, 20, 60, 12, 'https://example.com/mountain_climbers.jpg', 'https://example.com/mountain_climbers.mp4'),
  ('Jumping Jacks', 'cardio', 'full_body', 'bodyweight', 'beginner', 'Start standing, jump feet apart while raising arms overhead, then jump back to starting position.', 3, 30, 45, 8, 'https://example.com/jumping_jacks.jpg', 'https://example.com/jumping_jacks.mp4'),
  ('Dumbbell Rows', 'strength', 'back', 'dumbbells', 'intermediate', 'Bend at waist, hold dumbbell in one hand, pull elbow back to lift weight toward hip.', 3, 12, 90, 10, 'https://example.com/dumbbell_rows.jpg', 'https://example.com/dumbbell_rows.mp4'),
  ('Crunches', 'core', 'abs', 'bodyweight', 'beginner', 'Lie on back with knees bent, lift shoulders off ground using abdominal muscles.', 3, 15, 45, 5, 'https://example.com/crunches.jpg', 'https://example.com/crunches.mp4');

-- Verify the table structure
SELECT 
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'exercises'
ORDER BY ordinal_position;

-- Verify the data was inserted
SELECT COUNT(*) as exercise_count FROM public.exercises;
