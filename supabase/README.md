# BetterFit Database Schema Update

This directory contains the updated database schema that integrates fitness tracking capabilities with the existing nutrition tracking system.

## Files

- `seed.sql` - Complete database schema for fresh installations
- `migration.sql` - Migration script for existing databases
- `config.toml` - Supabase configuration

## Database Schema Overview

### Enhanced User Profiles
The `user_profiles` table now includes fitness-related fields:
- `name`, `age`, `gender`, `height_cm`, `weight_kg`
- `fitness_level` (beginner/intermediate/advanced)
- `goal`, `gym_access`

### New Fitness Tracking Tables

1. **workouts** - Store workout plans and routines
   - `title`, `summary`, `days_per_week`
   - `plan` (JSONB) for flexible workout structure

2. **exercise_log** - Track individual exercise sessions
   - `exercise_name`, `date`, `reps`, `sets`
   - `duration_minutes`, `calories_estimated`, `source`

3. **health_data** - Store health metrics
   - `steps`, `heart_rate_avg`, `sleep_hours`
   - `calories_burned`, `source`

4. **progress** - Track progress over time
   - `weight_kg`, `notes`, `summary`

### Existing Nutrition Tables (Preserved)
- `meals` - Meal tracking
- `meal_foods` - Individual food items in meals
- `user_nutrition_goals` - Nutrition goals

## How to Update Your Database

### Option 1: Fresh Installation
If you're setting up a new database:

1. Go to your Supabase project dashboard
2. Navigate to SQL Editor
3. Copy and paste the contents of `seed.sql`
4. Run the script

### Option 2: Migration (Recommended for Existing Databases)
If you already have data in your database:

1. Go to your Supabase project dashboard
2. Navigate to SQL Editor
3. Copy and paste the contents of `migration.sql`
4. Run the script

The migration script is designed to:
- Add new columns to existing tables safely
- Create new tables only if they don't exist
- Preserve all existing data
- Handle errors gracefully

## Security Features

All tables have Row Level Security (RLS) enabled with policies that ensure:
- Users can only access their own data
- Proper authentication is required for all operations
- Data is automatically associated with the authenticated user

## Data Relationships

- All fitness tables reference `auth.users(id)` for user association
- Existing nutrition tables remain unchanged
- New fitness data is completely separate from nutrition data
- All tables use UUID primary keys for consistency

## Next Steps

After updating your database:

1. Update your Flutter app to include the new fitness tracking features
2. Create new repository classes for the fitness tables
3. Add fitness tracking UI components
4. Test the new functionality

## Troubleshooting

If you encounter any issues:

1. Check the Supabase logs for error messages
2. Verify that all tables were created successfully
3. Test the RLS policies by trying to access data
4. Ensure your Supabase project has the necessary permissions

## Support

For issues with the database schema or migration, check:
- Supabase documentation
- PostgreSQL documentation for specific SQL syntax
- Your Supabase project logs for detailed error messages 