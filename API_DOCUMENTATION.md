# BetterFit API Documentation

This document describes the Vercel API endpoints for the BetterFit exercise database.

## Base URL

When deployed to Vercel, your API will be available at:
```
https://your-project-name.vercel.app/api
```

## Authentication

Currently, the API uses Supabase's Row Level Security (RLS) with public read access. No authentication is required for GET requests.

## Endpoints

### 1. Get Exercises

**Endpoint:** `GET /api/exercises`

**Description:** Retrieve exercises with optional filtering and pagination.

**Query Parameters:**

| Parameter | Type | Description | Example |
|-----------|------|-------------|---------|
| `target` | string | Filter by muscle group (partial match) | `?target=abs` |
| `equipment` | string | Filter by equipment type (exact match) | `?equipment=dumbbell` |
| `category` | string | Filter by exercise category (exact match) | `?category=strength` |
| `difficulty` | string | Filter by difficulty level (exact match) | `?difficulty=beginner` |
| `muscle_group` | string | Filter by muscle group (exact match) | `?muscle_group=chest` |
| `search` | string | Search exercises by name (partial match) | `?search=push` |
| `limit` | number | Number of results to return (default: 50, max: 100) | `?limit=20` |
| `offset` | number | Number of results to skip (default: 0) | `?offset=10` |

**Available Values:**

- **Categories:** `strength`, `cardio`, `core`, `plyometric`
- **Difficulties:** `beginner`, `intermediate`, `advanced`
- **Equipment:** `bodyweight`, `dumbbell`, `barbell`, `kettlebell`, `resistance_band`, `machine`
- **Muscle Groups:** `chest`, `back`, `legs`, `arms`, `shoulders`, `abs`, `full_body`

**Example Requests:**

```bash
# Get all exercises
GET /api/exercises

# Get chest exercises
GET /api/exercises?muscle_group=chest

# Get beginner strength exercises with dumbbells
GET /api/exercises?category=strength&difficulty=beginner&equipment=dumbbell

# Search for push exercises
GET /api/exercises?search=push

# Get first 10 exercises
GET /api/exercises?limit=10&offset=0

# Get exercises targeting abs
GET /api/exercises?target=abs
```

**Response Format:**

```json
{
  "data": [
    {
      "id": 1,
      "name": "Push-ups",
      "category": "strength",
      "muscle_group": "chest",
      "equipment": "bodyweight",
      "difficulty": "beginner",
      "instructions": "Start in a plank position...",
      "sets": 3,
      "reps": 10,
      "rest_time": 60,
      "calories_burned": 8,
      "image_url": "https://example.com/pushups.jpg",
      "video_url": "https://example.com/pushups.mp4",
      "created_at": "2024-01-01T00:00:00Z",
      "updated_at": "2024-01-01T00:00:00Z"
    }
  ],
  "meta": {
    "count": 1,
    "limit": 50,
    "offset": 0,
    "filters": {
      "target": "abs",
      "equipment": null,
      "category": null,
      "difficulty": null,
      "muscle_group": null,
      "search": null
    }
  }
}
```

### 2. Get Exercise Statistics

**Endpoint:** `GET /api/exercises/statistics`

**Description:** Retrieve aggregated statistics about the exercise database.

**Query Parameters:** None

**Example Request:**

```bash
GET /api/exercises/statistics
```

**Response Format:**

```json
{
  "data": {
    "totalExercises": 20,
    "exercisesByCategory": {
      "strength": 8,
      "cardio": 5,
      "core": 4,
      "plyometric": 3
    },
    "exercisesByDifficulty": {
      "beginner": 7,
      "intermediate": 8,
      "advanced": 5
    },
    "exercisesByMuscleGroup": {
      "chest": 4,
      "back": 3,
      "legs": 5,
      "arms": 2,
      "shoulders": 2,
      "abs": 3,
      "full_body": 1
    },
    "exercisesByEquipment": {
      "bodyweight": 10,
      "dumbbell": 5,
      "barbell": 3,
      "kettlebell": 2
    },
    "averageCaloriesBurned": 12.5,
    "summary": {
      "totalCategories": 4,
      "totalDifficulties": 3,
      "totalMuscleGroups": 7,
      "totalEquipmentTypes": 4
    }
  },
  "meta": {
    "generatedAt": "2024-01-01T12:00:00Z",
    "source": "BetterFit Exercise Database"
  }
}
```

## Error Responses

All endpoints return consistent error responses:

**400 Bad Request:**
```json
{
  "error": "Invalid parameters",
  "details": "Limit must be between 1 and 100"
}
```

**405 Method Not Allowed:**
```json
{
  "error": "Method not allowed"
}
```

**500 Internal Server Error:**
```json
{
  "error": "Failed to fetch exercises",
  "details": "Database connection failed"
}
```

## CORS Support

All endpoints support CORS and can be called from web applications:

- **Access-Control-Allow-Origin:** `*`
- **Access-Control-Allow-Methods:** `GET, POST, PUT, DELETE, OPTIONS`
- **Access-Control-Allow-Headers:** `Content-Type, Authorization`

## Rate Limiting

Currently, no rate limiting is implemented. Consider implementing rate limiting for production use.

## Environment Variables

The API requires the following environment variables to be set in Vercel:

```bash
SUPABASE_URL=your_supabase_project_url
SUPABASE_ANON_KEY=your_supabase_anon_key
```

## Usage Examples

### JavaScript/TypeScript

```javascript
// Get all exercises
const response = await fetch('https://your-api.vercel.app/api/exercises');
const data = await response.json();

// Get chest exercises with pagination
const response = await fetch(
  'https://your-api.vercel.app/api/exercises?muscle_group=chest&limit=10&offset=0'
);
const data = await response.json();

// Get exercise statistics
const response = await fetch('https://your-api.vercel.app/api/exercises/statistics');
const stats = await response.json();
```

### Flutter/Dart

```dart
import 'package:http/http.dart' as http;
import 'dart:convert';

class ExerciseApiService {
  static const String baseUrl = 'https://your-api.vercel.app/api';

  Future<List<Exercise>> getExercises({
    String? target,
    String? equipment,
    String? category,
    String? difficulty,
    String? muscleGroup,
    String? search,
    int limit = 50,
    int offset = 0,
  }) async {
    final queryParams = <String, String>{};
    
    if (target != null) queryParams['target'] = target;
    if (equipment != null) queryParams['equipment'] = equipment;
    if (category != null) queryParams['category'] = category;
    if (difficulty != null) queryParams['difficulty'] = difficulty;
    if (muscleGroup != null) queryParams['muscle_group'] = muscleGroup;
    if (search != null) queryParams['search'] = search;
    queryParams['limit'] = limit.toString();
    queryParams['offset'] = offset.toString();

    final uri = Uri.parse('$baseUrl/exercises').replace(queryParameters: queryParams);
    final response = await http.get(uri);

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return (data['data'] as List)
          .map((json) => Exercise.fromJson(json))
          .toList();
    } else {
      throw Exception('Failed to load exercises');
    }
  }

  Future<Map<String, dynamic>> getStatistics() async {
    final response = await http.get(Uri.parse('$baseUrl/exercises/statistics'));
    
    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception('Failed to load statistics');
    }
  }
}
```

## Deployment

1. **Install Dependencies:**
   ```bash
   npm install
   ```

2. **Set Environment Variables in Vercel:**
   - Go to your Vercel project dashboard
   - Navigate to Settings > Environment Variables
   - Add `SUPABASE_URL` and `SUPABASE_ANON_KEY`

3. **Deploy:**
   ```bash
   vercel --prod
   ```

## Monitoring and Logs

Monitor your API usage through the Vercel dashboard:
- **Function Logs:** View execution logs and errors
- **Analytics:** Track request volume and performance
- **Edge Network:** Monitor global performance

## Security Considerations

1. **Input Validation:** All query parameters are validated
2. **SQL Injection Protection:** Using Supabase client prevents SQL injection
3. **CORS Configuration:** Configured for cross-origin requests
4. **Error Handling:** Sensitive information is not exposed in error messages
5. **Rate Limiting:** Consider implementing rate limiting for production

## Future Enhancements

- [ ] Authentication and authorization
- [ ] Rate limiting
- [ ] Caching with Redis
- [ ] Webhook support for real-time updates
- [ ] GraphQL endpoint
- [ ] Bulk operations
- [ ] Exercise recommendations API
