-- Simple Verification Script for BetterFit Database
-- Run this in your Supabase SQL editor to verify all tables exist

-- ============================================================================
-- 1. CHECK IF ALL TABLES EXIST
-- ============================================================================

SELECT 
  table_name,
  'EXISTS' as status
FROM information_schema.tables 
WHERE table_schema = 'public' 
AND table_name IN (
  'exercises', 'user_profiles', 'workouts', 'exercise_log', 
  'health_data', 'progress', 'meals', 'meal_foods', 'user_nutrition_goals'
)
ORDER BY table_name;

-- ============================================================================
-- 2. CHECK SAMPLE DATA
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
-- 3. TEST BASIC QUERIES
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
-- 4. CHECK TABLE STRUCTURES
-- ============================================================================

-- Check exercises table structure
SELECT 
  'exercises' as table_name,
  column_name,
  data_type,
  is_nullable
FROM information_schema.columns 
WHERE table_schema = 'public' 
AND table_name = 'exercises'
ORDER BY ordinal_position;

-- ============================================================================
-- 5. CHECK RLS POLICIES
-- ============================================================================

SELECT 
  tablename,
  policyname,
  cmd
FROM pg_policies 
WHERE schemaname = 'public'
AND tablename IN (
  'exercises', 'user_profiles', 'workouts', 'exercise_log', 
  'health_data', 'progress', 'meals', 'meal_foods', 'user_nutrition_goals'
)
ORDER BY tablename, policyname;
