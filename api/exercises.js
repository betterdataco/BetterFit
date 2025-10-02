import { createClient } from '@supabase/supabase-js';

const supabase = createClient(
  process.env.SUPABASE_URL,
  process.env.SUPABASE_ANON_KEY
);

export default async function handler(req, res) {
  // Set CORS headers
  res.setHeader('Access-Control-Allow-Origin', '*');
  res.setHeader('Access-Control-Allow-Methods', 'GET, POST, PUT, DELETE, OPTIONS');
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
    const { 
      target, 
      equipment, 
      category, 
      difficulty, 
      muscle_group,
      limit = 50,
      offset = 0,
      search 
    } = req.query;

    let query = supabase.from('exercises').select('*');

    // Apply filters
    if (target) {
      query = query.ilike('muscle_group', `%${target}%`);
    }

    if (equipment) {
      query = query.eq('equipment', equipment);
    }

    if (category) {
      query = query.eq('category', category);
    }

    if (difficulty) {
      query = query.eq('difficulty', difficulty);
    }

    if (muscle_group) {
      query = query.eq('muscle_group', muscle_group);
    }

    if (search) {
      query = query.ilike('name', `%${search}%`);
    }

    // Apply pagination
    query = query.range(parseInt(offset), parseInt(offset) + parseInt(limit) - 1);

    // Order by name for consistent results
    query = query.order('name');

    const { data, error, count } = await query;

    if (error) {
      console.error('Supabase error:', error);
      return res.status(500).json({ 
        error: 'Failed to fetch exercises',
        details: error.message 
      });
    }

    // Return response with metadata
    res.status(200).json({
      data,
      meta: {
        count: data.length,
        limit: parseInt(limit),
        offset: parseInt(offset),
        filters: {
          target,
          equipment,
          category,
          difficulty,
          muscle_group,
          search
        }
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
