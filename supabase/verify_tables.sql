-- Verification Script for BetterFit Database
-- Run this in your Supabase SQL editor to verify all tables exist

-- ============================================================================
-- 1. CHECK IF ALL TABLES EXIST
-- ============================================================================

SELECT 
  table_name,
  'EXISTS' as status,
  'Table found in database' as note
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN (
  'exercises', 'user_profiles', 'workouts', 'exercise_log', 
  'health_data', 'progress', 'meals', 'meal_foods', 'user_nutrition_goals'
)
ORDER BY table_name;

-- ============================================================================
-- 2. CHECK TABLE STRUCTURES
-- ============================================================================

-- Check exercises table structure
SELECT 
  'exercises' as table_name,
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'exercises'
ORDER BY ordinal_position;

-- Check user_profiles table structure
SELECT 
  'user_profiles' as table_name,
  column_name,
  data_type,
  is_nullable,
  column_default
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'user_profiles'
ORDER BY ordinal_position;

-- ============================================================================
-- 3. CHECK SAMPLE DATA
-- ============================================================================

-- Check if exercises have data
SELECT 
  'exercises' as table_name,
  COUNT(*) as row_count
FROM public.exercises;

-- Show first few exercises
SELECT 
  id,
  name,
  category,
  muscle_group,
  equipment,
  difficulty
FROM public.exercises
ORDER BY id
LIMIT 5;

-- ============================================================================
-- 4. CHECK RLS POLICIES
-- ============================================================================

SELECT 
  schemaname,
  tablename,
  policyname,
  permissive,
  roles,
  cmd
FROM pg_policies 
WHERE schemaname = 'public'
AND tablename IN (
  'exercises', 'user_profiles', 'workouts', 'exercise_log', 
  'health_data', 'progress', 'meals', 'meal_foods', 'user_nutrition_goals'
)
ORDER BY tablename, policyname;

-- ============================================================================
-- 5. CHECK TRIGGERS
-- ============================================================================

SELECT 
  trigger_name,
  event_manipulation,
  event_object_table,
  action_statement
FROM information_schema.triggers
WHERE trigger_schema = 'public'
ORDER BY trigger_name;

-- ============================================================================
-- 6. CHECK FUNCTIONS
-- ============================================================================

SELECT 
  routine_name,
  routine_type,
  data_type
FROM information_schema.routines
WHERE routine_schema = 'public'
AND routine_name IN ('handle_new_user', 'update_meal_totals')
ORDER BY routine_name;

-- ============================================================================
-- 7. TEST BASIC QUERIES
-- ============================================================================

-- Test exercises query (this should work)
SELECT 
  'Test Query: exercises' as test_name,
  COUNT(*) as result
FROM public.exercises
WHERE category = 'strength';

-- Test user_profiles query (this should work even if empty)
SELECT 
  'Test Query: user_profiles' as test_name,
  COUNT(*) as result
FROM public.user_profiles;

-- ============================================================================
-- 8. TROUBLESHOOTING COMMANDS
-- ============================================================================

-- If tables don't show up, try refreshing the database connection
-- This command forces a refresh of the database metadata
SELECT pg_reload_conf();

-- Check if there are any locks on the tables
SELECT 
  schemaname,
  tablename,
  locktype,
  mode
FROM pg_locks l
JOIN pg_tables t ON l.relation = t.tablename::regclass
WHERE t.schemaname = 'public'
AND t.tablename IN (
  'exercises', 'user_profiles', 'workouts', 'exercise_log', 
  'health_data', 'progress', 'meals', 'meal_foods', 'user_nutrition_goals'
);
