-- BetterFit Exercises Database Setup
-- Run this script in your Supabase SQL Editor

-- Create exercises table
CREATE TABLE IF NOT EXISTS exercises (
    id SERIAL PRIMARY KEY,
    name VARCHAR(255) NOT NULL,
    category VARCHAR(100) NOT NULL,
    muscle_group VARCHAR(100) NOT NULL,
    equipment VARCHAR(100) NOT NULL,
    difficulty VARCHAR(50) NOT NULL,
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

-- Create indexes for better performance
CREATE INDEX IF NOT EXISTS idx_exercises_category ON exercises(category);
CREATE INDEX IF NOT EXISTS idx_exercises_muscle_group ON exercises(muscle_group);
CREATE INDEX IF NOT EXISTS idx_exercises_difficulty ON exercises(difficulty);
CREATE INDEX IF NOT EXISTS idx_exercises_equipment ON exercises(equipment);

-- Enable Row Level Security (RLS)
ALTER TABLE exercises ENABLE ROW LEVEL SECURITY;

-- Create policy to allow all users to read exercises
CREATE POLICY "Allow public read access to exercises" ON exercises
    FOR SELECT USING (true);

-- Create policy to allow authenticated users to insert exercises (for admins)
CREATE POLICY "Allow authenticated users to insert exercises" ON exercises
    FOR INSERT WITH CHECK (auth.role() = 'authenticated');

-- Create policy to allow authenticated users to update exercises (for admins)
CREATE POLICY "Allow authenticated users to update exercises" ON exercises
    FOR UPDATE USING (auth.role() = 'authenticated');

-- Create policy to allow authenticated users to delete exercises (for admins)
CREATE POLICY "Allow authenticated users to delete exercises" ON exercises
    FOR DELETE USING (auth.role() = 'authenticated');

-- Insert exercise data
INSERT INTO exercises (name, category, muscle_group, equipment, difficulty, instructions, sets, reps, rest_time, calories_burned, image_url, video_url) VALUES
('Push-ups', 'strength', 'chest', 'bodyweight', 'beginner', 'Start in a plank position with hands shoulder-width apart. Lower your body until your chest nearly touches the floor, then push back up.', 3, 10, 60, 8, 'https://example.com/pushups.jpg', 'https://example.com/pushups.mp4'),
('Squats', 'strength', 'legs', 'bodyweight', 'beginner', 'Stand with feet shoulder-width apart. Lower your body as if sitting back into a chair, keeping your chest up and knees behind toes.', 3, 15, 60, 12, 'https://example.com/squats.jpg', 'https://example.com/squats.mp4'),
('Plank', 'core', 'abs', 'bodyweight', 'beginner', 'Hold a plank position with your body in a straight line from head to heels. Engage your core and hold the position.', 3, 30, 45, 6, 'https://example.com/plank.jpg', 'https://example.com/plank.mp4'),
('Burpees', 'cardio', 'full_body', 'bodyweight', 'intermediate', 'Start standing, drop into a squat, kick feet back into plank, do a push-up, jump feet forward, and jump up with arms overhead.', 3, 10, 90, 15, 'https://example.com/burpees.jpg', 'https://example.com/burpees.mp4'),
('Pull-ups', 'strength', 'back', 'pull-up_bar', 'advanced', 'Hang from a pull-up bar with hands shoulder-width apart. Pull your body up until your chin is over the bar, then lower down.', 3, 8, 120, 10, 'https://example.com/pullups.jpg', 'https://example.com/pullups.mp4'),
('Lunges', 'strength', 'legs', 'bodyweight', 'beginner', 'Step forward with one leg and lower your body until both knees are bent at 90 degrees. Push back to starting position.', 3, 12, 60, 10, 'https://example.com/lunges.jpg', 'https://example.com/lunges.mp4'),
('Mountain Climbers', 'cardio', 'core', 'bodyweight', 'intermediate', 'Start in plank position. Alternately bring knees toward chest in a running motion while maintaining plank position.', 3, 20, 60, 12, 'https://example.com/mountain_climbers.jpg', 'https://example.com/mountain_climbers.mp4'),
('Jumping Jacks', 'cardio', 'full_body', 'bodyweight', 'beginner', 'Start standing, jump feet apart while raising arms overhead, then jump back to starting position.', 3, 30, 45, 8, 'https://example.com/jumping_jacks.jpg', 'https://example.com/jumping_jacks.mp4'),
('Dumbbell Rows', 'strength', 'back', 'dumbbells', 'intermediate', 'Bend at waist, hold dumbbell in one hand, pull elbow back while keeping arm close to body.', 3, 12, 90, 8, 'https://example.com/dumbbell_rows.jpg', 'https://example.com/dumbbell_rows.mp4'),
('Bench Press', 'strength', 'chest', 'barbell', 'intermediate', 'Lie on bench, lower barbell to chest, then press back up to starting position.', 4, 8, 120, 12, 'https://example.com/bench_press.jpg', 'https://example.com/bench_press.mp4'),
('Deadlift', 'strength', 'back', 'barbell', 'advanced', 'Stand with feet hip-width apart, bend at hips and knees to lower hands to barbell, then stand up straight.', 4, 6, 180, 15, 'https://example.com/deadlift.jpg', 'https://example.com/deadlift.mp4'),
('Overhead Press', 'strength', 'shoulders', 'barbell', 'intermediate', 'Hold barbell at shoulder level, press overhead until arms are fully extended, then lower back down.', 3, 10, 120, 10, 'https://example.com/overhead_press.jpg', 'https://example.com/overhead_press.mp4'),
('Bicep Curls', 'strength', 'arms', 'dumbbells', 'beginner', 'Hold dumbbells at sides, curl weights up toward shoulders, then lower back down.', 3, 12, 60, 6, 'https://example.com/bicep_curls.jpg', 'https://example.com/bicep_curls.mp4'),
('Tricep Dips', 'strength', 'arms', 'bodyweight', 'intermediate', 'Support yourself on parallel bars, lower body by bending elbows, then push back up.', 3, 10, 90, 8, 'https://example.com/tricep_dips.jpg', 'https://example.com/tricep_dips.mp4'),
('Russian Twists', 'core', 'abs', 'bodyweight', 'intermediate', 'Sit with knees bent, lean back slightly, twist torso from side to side while keeping feet off ground.', 3, 20, 45, 6, 'https://example.com/russian_twists.jpg', 'https://example.com/russian_twists.mp4'),
('High Knees', 'cardio', 'legs', 'bodyweight', 'beginner', 'Run in place, bringing knees up toward chest as high as possible.', 3, 30, 45, 10, 'https://example.com/high_knees.jpg', 'https://example.com/high_knees.mp4'),
('Wall Balls', 'strength', 'full_body', 'medicine_ball', 'intermediate', 'Hold medicine ball at chest, squat down, then throw ball up to target on wall while standing.', 3, 15, 90, 12, 'https://example.com/wall_balls.jpg', 'https://example.com/wall_balls.mp4'),
('Box Jumps', 'plyometric', 'legs', 'box', 'advanced', 'Stand in front of box, jump up onto box with both feet, then step or jump back down.', 3, 10, 120, 15, 'https://example.com/box_jumps.jpg', 'https://example.com/box_jumps.mp4'),
('Kettlebell Swings', 'strength', 'full_body', 'kettlebell', 'intermediate', 'Hold kettlebell with both hands, swing it between legs, then swing forward to chest height.', 3, 15, 90, 14, 'https://example.com/kettlebell_swings.jpg', 'https://example.com/kettlebell_swings.mp4'),
('Battle Ropes', 'cardio', 'full_body', 'battle_ropes', 'intermediate', 'Hold ends of battle ropes, create waves by moving arms up and down rapidly.', 3, 30, 90, 18, 'https://example.com/battle_ropes.jpg', 'https://example.com/battle_ropes.mp4');

-- Create a function to update the updated_at timestamp
CREATE OR REPLACE FUNCTION update_updated_at_column()
RETURNS TRIGGER AS $$
BEGIN
    NEW.updated_at = NOW();
    RETURN NEW;
END;
$$ language 'plpgsql';

-- Create trigger to automatically update updated_at
CREATE TRIGGER update_exercises_updated_at 
    BEFORE UPDATE ON exercises 
    FOR EACH ROW 
    EXECUTE FUNCTION update_updated_at_column();

-- Create views for common queries
CREATE OR REPLACE VIEW exercises_by_difficulty AS
SELECT 
    difficulty,
    COUNT(*) as exercise_count,
    AVG(calories_burned) as avg_calories_burned
FROM exercises 
GROUP BY difficulty 
ORDER BY 
    CASE difficulty 
        WHEN 'beginner' THEN 1 
        WHEN 'intermediate' THEN 2 
        WHEN 'advanced' THEN 3 
    END;

CREATE OR REPLACE VIEW exercises_by_category AS
SELECT 
    category,
    COUNT(*) as exercise_count,
    AVG(calories_burned) as avg_calories_burned
FROM exercises 
GROUP BY category 
ORDER BY exercise_count DESC;

-- Grant permissions
GRANT SELECT ON exercises TO anon;
GRANT SELECT ON exercises TO authenticated;
GRANT ALL ON exercises TO service_role;

GRANT SELECT ON exercises_by_difficulty TO anon;
GRANT SELECT ON exercises_by_difficulty TO authenticated;
GRANT SELECT ON exercises_by_category TO anon;
GRANT SELECT ON exercises_by_category TO authenticated;

-- Verify the data was inserted correctly
SELECT 
    'Total exercises inserted: ' || COUNT(*) as summary
FROM exercises;

SELECT 
    difficulty,
    COUNT(*) as count
FROM exercises 
GROUP BY difficulty 
ORDER BY 
    CASE difficulty 
        WHEN 'beginner' THEN 1 
        WHEN 'intermediate' THEN 2 
        WHEN 'advanced' THEN 3 
    END;
