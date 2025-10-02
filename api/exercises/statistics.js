import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_ANON_KEY
);

export default async function handler(req, res) {
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, OPTIONS');
  res.setHeader('Access-Control-Allow-Headers', 'Content-Type, Authorization');

  // Handle preflight requests
  if (req.method === 'OPTIONS') {
    res.status(200).end();
    return;
  }

  // Only allow GET requests
  if (req.method !== 'GET') {
    return res.status(405).json({ error: 'Method not allowed' });
  }

  try {
    // Get statistics from views
    const [categoryStats, difficultyStats] = await Promise.all([
      supabase.from('exercises_by_category').select('*'),
      supabase.from('exercises_by_difficulty').select('*')
    ]);

    if (categoryStats.error) {
      console.error('Category stats error:', categoryStats.error);
      return res.status(500).json({ 
        error: 'Failed to fetch category statistics',
        details: categoryStats.error.message 
      });
    }

    if (difficultyStats.error) {
      console.error('Difficulty stats error:', difficultyStats.error);
      return res.status(500).json({ 
        error: 'Failed to fetch difficulty statistics',
        details: difficultyStats.error.message 
      });
    }

    // Get equipment and muscle group stats
    const [equipmentResponse, muscleGroupResponse, caloriesResponse] = await Promise.all([
      supabase.from('exercises').select('equipment'),
      supabase.from('exercises').select('muscle_group'),
      supabase.from('exercises').select('calories_burned')
    ]);

    if (equipmentResponse.error || muscleGroupResponse.error || caloriesResponse.error) {
      console.error('Stats error:', { equipmentResponse, muscleGroupResponse, caloriesResponse });
      return res.status(500).json({ 
        error: 'Failed to fetch exercise statistics',
        details: 'Database query failed'
      });
    }

    // Calculate equipment stats
    const exercisesByEquipment = {};
    equipmentResponse.data.forEach(exercise => {
      const equipment = exercise.equipment;
      exercisesByEquipment[equipment] = (exercisesByEquipment[equipment] || 0) + 1;
    });

    // Calculate muscle group stats
    const exercisesByMuscleGroup = {};
    muscleGroupResponse.data.forEach(exercise => {
      const muscleGroup = exercise.muscle_group;
      exercisesByMuscleGroup[muscleGroup] = (exercisesByMuscleGroup[muscleGroup] || 0) + 1;
    });

    // Calculate average calories burned
    const totalCalories = caloriesResponse.data.reduce((sum, exercise) => sum + exercise.calories_burned, 0);
    const averageCaloriesBurned = totalCalories / caloriesResponse.data.length;

    // Format category stats
    const exercisesByCategory = {};
    categoryStats.data.forEach(stat => {
      exercisesByCategory[stat.category] = stat.exercise_count;
    });

    // Format difficulty stats
    const exercisesByDifficulty = {};
    difficultyStats.data.forEach(stat => {
      exercisesByDifficulty[stat.difficulty] = stat.exercise_count;
    });

    const statistics = {
      totalExercises: caloriesResponse.data.length,
      exercisesByCategory,
      exercisesByDifficulty,
      exercisesByMuscleGroup,
      exercisesByEquipment,
      averageCaloriesBurned: Math.round(averageCaloriesBurned * 100) / 100,
      summary: {
        totalCategories: Object.keys(exercisesByCategory).length,
        totalDifficulties: Object.keys(exercisesByDifficulty).length,
        totalMuscleGroups: Object.keys(exercisesByMuscleGroup).length,
        totalEquipmentTypes: Object.keys(exercisesByEquipment).length
      }
    };

    res.status(200).json({
      data: statistics,
      meta: {
        generatedAt: new Date().toISOString(),
        source: 'BetterFit Exercise Database'
      }
    });

  } catch (error) {
    console.error('API error:', error);
    res.status(500).json({ 
      error: 'Internal server error',
      details: error.message 
    });
  }
}
