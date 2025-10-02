import 'dart:convert';
import 'package:http/http.dart' as http;
import 'package:flutter_application/core/services/environment_service.dart';
import 'package:flutter/foundation.dart';
import '../../domain/models/food_search_result.dart';

class FdaFoodDataService {
  static const String _baseUrl = 'https://api.nal.usda.gov/fdc/v1';
  static String? _apiKey;

  static Future<void> initialize() async {
    print('FDA Service: Initializing...');

    // Use environment service for all platforms
    _apiKey = EnvironmentService.usdaFoodDataApiKey;
    print('FDA Service: API key loaded: ${_apiKey != null ? "YES" : "NO"}');
    if (_apiKey == null) {
      throw Exception(
          'USDA Food Data API key not found in environment variables');
    }
  }

  static Map<String, String> get _headers => {
        'Accept': 'application/json',
        'X-Api-Key': _apiKey!,
      };

  /// Search for foods by query string
  static Future<List<FoodSearchResult>> searchFoods(String query) async {
    print('FDA Service: Starting search for query: "$query"');

    if (_apiKey == null) {
      print('FDA Service: API key is null, initializing...');
      await initialize();
    }

    print('FDA Service: API key loaded: ${_apiKey?.substring(0, 10)}...');

    final uri = Uri.parse('$_baseUrl/foods/search')
        .replace(queryParameters: <String, String>{
      'query': query,
      'pageSize': '25',
      'dataType': 'Foundation,SR Legacy',
      'api_key': _apiKey!, // Add API key as query parameter
    });

    print('FDA Service: Making request to: ${uri.toString()}');

    try {
      // Remove the X-Api-Key header for web compatibility
      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
      });

      print('FDA Service: Response status: ${response.statusCode}');
      print(
          'FDA Service: Response body: ${response.body.substring(0, 200)}...');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final foods = data['foods'] as List;
        print('FDA Service: Found ${foods.length} foods');

        return foods.map((food) => FoodSearchResult.fromJson(food)).toList();
      } else {
        throw Exception(
            'Failed to search foods: ${response.statusCode} - ${response.body}');
      }
    } catch (e) {
      print('FDA Service: Error occurred: $e');
      throw Exception('Error searching foods: $e');
    }
  }

  /// Get detailed food information by FDC ID
  static Future<FoodSearchResult> getFoodDetails(String fdcId) async {
    if (_apiKey == null) {
      await initialize();
    }

    final uri = Uri.parse('$_baseUrl/food/$fdcId')
        .replace(queryParameters: <String, String>{
      'api_key':
          _apiKey!, // Add API key as query parameter for web compatibility
    });

    try {
      // Remove the X-Api-Key header for web compatibility
      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
      });

      print(
          'FDA Service: Food details response status: ${response.statusCode}');
      print(
          'FDA Service: Food details response body: ${response.body.substring(0, 500)}...');

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final foodResult = FoodSearchResult.fromJson(data);

        print(
            'FDA Service: Parsed food result - Description: ${foodResult.description}');
        print(
            'FDA Service: Number of nutrients: ${foodResult.nutrients.length}');

        // Debug nutrition data
        print('FDA Service: Raw foodNutrients structure:');
        final rawNutrients = data['foodNutrients'] as List?;
        if (rawNutrients != null && rawNutrients.isNotEmpty) {
          print('FDA Service: First nutrient raw data: ${rawNutrients.first}');
        }

        for (final nutrient in foodResult.nutrients) {
          print(
              'FDA Service: Nutrient - ${nutrient.nutrientName}: ${nutrient.value} ${nutrient.unitName}');
        }

        return foodResult;
      } else {
        throw Exception('Failed to get food details: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting food details: $e');
    }
  }

  /// Get multiple foods by FDC IDs
  static Future<List<FoodSearchResult>> getFoodsByIds(
      List<String> fdcIds) async {
    if (_apiKey == null) {
      await initialize();
    }

    final uri =
        Uri.parse('$_baseUrl/foods').replace(queryParameters: <String, String>{
      'api_key':
          _apiKey!, // Add API key as query parameter for web compatibility
    });

    try {
      final response = await http.post(
        uri,
        headers: <String, String>{
          'Accept': 'application/json',
          'Content-Type': 'application/json',
        },
        body: jsonEncode({
          'fdcIds': fdcIds,
          'format': 'full',
          'fields':
              'fdcId,description,brandName,brandOwner,foodNutrients,dataType,publicationDate',
        }),
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final foods = data['foods'] as List;

        return foods.map((food) => FoodSearchResult.fromJson(food)).toList();
      } else {
        throw Exception('Failed to get foods by IDs: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting foods by IDs: $e');
    }
  }

  /// Get paginated food catalog
  static Future<List<FoodSearchResult>> getFoodCatalog({
    int pageNumber = 1,
    int pageSize = 25,
    String? dataType,
  }) async {
    if (_apiKey == null) {
      await initialize();
    }

    final queryParams = <String, String>{
      'pageNumber': pageNumber.toString(),
      'pageSize': pageSize.toString(),
      'api_key':
          _apiKey!, // Add API key as query parameter for web compatibility
    };

    if (dataType != null) {
      queryParams['dataType'] = dataType;
    }

    final uri =
        Uri.parse('$_baseUrl/foods/list').replace(queryParameters: queryParams);

    try {
      // Remove the X-Api-Key header for web compatibility
      final response = await http.get(uri, headers: {
        'Accept': 'application/json',
      });

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final foods = data['foods'] as List;

        return foods.map((food) => FoodSearchResult.fromJson(food)).toList();
      } else {
        throw Exception('Failed to get food catalog: ${response.statusCode}');
      }
    } catch (e) {
      throw Exception('Error getting food catalog: $e');
    }
  }

  /// Extract nutrition values from food search result
  static Map<String, double> extractNutritionValues(FoodSearchResult food) {
    final nutrition = <String, double>{};

    print('FDA Service: Extracting nutrition values for: ${food.description}');
    print('FDA Service: Total nutrients to process: ${food.nutrients.length}');

    for (final nutrient in food.nutrients) {
      print(
          'FDA Service: Processing nutrient - ${nutrient.nutrientName}: ${nutrient.value} ${nutrient.unitName}');

      switch (nutrient.nutrientName.toLowerCase()) {
        case 'energy':
        case 'calories':
          nutrition['calories'] = nutrient.value;
          print('FDA Service: Found calories: ${nutrient.value}');
          break;
        case 'protein':
          nutrition['protein'] = nutrient.value;
          print('FDA Service: Found protein: ${nutrient.value}');
          break;
        case 'carbohydrate, by difference':
        case 'carbohydrates':
          nutrition['carbs'] = nutrient.value;
          print('FDA Service: Found carbs: ${nutrient.value}');
          break;
        case 'total lipid (fat)':
        case 'fat':
          nutrition['fat'] = nutrient.value;
          print('FDA Service: Found fat: ${nutrient.value}');
          break;
        case 'fiber, total dietary':
        case 'fiber':
          nutrition['fiber'] = nutrient.value;
          print('FDA Service: Found fiber: ${nutrient.value}');
          break;
        case 'sodium, na':
        case 'sodium':
          nutrition['sodium'] = nutrient.value;
          print('FDA Service: Found sodium: ${nutrient.value}');
          break;
      }
    }

    print('FDA Service: Final nutrition map: $nutrition');
    return nutrition;
  }
}
