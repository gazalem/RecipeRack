import 'dart:convert';
import 'package:http/http.dart' as http; // Add http package to pubspec.yaml http: ^1.4.0

class ApiService {
  final String _baseUrl = "http://localhost:11434/api/generate"; // e.g., http://localhost:11434/api/generate

  // Future<Map<String, dynamic>> fetchRecipesFromOllama(List<String> ingredients) async {
  Future fetchRecipesFromOllama() async {
    // Prepare the request body based on Ollama's API requirements
    final requestBody = {
      "model": "llama3.2",
      // "prompt": "Suppose that you are a terrific chef. Create a menu for one week and be cooked or preprared bellow 30 min with the following ingridients:\n ${ingredients.join(', ')}."
      "prompt": "Suppose that you are a terrific chef. Create a menu for one week and be cooked or preprared bellow 30 min with the following ingridients please specified the prep time, the cooking time, the ingredient amount for every recipe:\n 2 pounds ground turkey, chicken or beef, 11⁄2 pounds boneless chicken, 1 dozen eggs, 1 pack shredded cheddar or Mexican blend cheese, 1 package mixed salad greens of your choice, 1 package fresh or frozen vegetables of your choice, 1 box whole grain pasta, 1 jar marinara/pasta sauce, 1 box instant brown rice, 2 cans beans of your choice, 1 pack chili seasoning, 1 15-ounce can diced tomatoes or tomato sauce, 1 bottle soy sauce or teriyaki sauce, 1 jar salsa spice/herb blend of your choice (e.g., Italian, Cajun, lemon pepper, seasoned salt), Salad dressing of your choice.",
      "stream": false,
      "format": {
        "type": "object",
        "properties": {
          "recipes": {
            "type": "array",
            "items": {
              "type": "object",
              "properties": {
                "day": { "type": "string" },
                "name": { "type": "string" },
                "prepTime": { "type": "string" },
                "cookTime": { "type": "string" },
                "ingredients": {
                  "type": "array",
                  "items": { "type": "string" }
                },
                "instructions": { "type": "string" }
              },
              "required": ["day", "name", "prepTime", "cookTime", "ingredients", "instructions"]
            }
          }
        },
        "required": ["recipes"]
      }
    };

    try {
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {"Content-Type": "application/json"},
        body: json.encode(requestBody),
      );

      if (response.statusCode == 200) {
        // return json.decode(response.body);// as Map<String, dynamic>;
        var jsonResponse = json.decode(response.body);
        return jsonResponse['response']; // Decode the JSON response
      } else {
        // Handle server errors (e.g., 4xx, 5xx)
        throw Exception('Failed to load recipes from API: ${response.statusCode} ${response.body}');
      }
    } catch (e) {
      // Handle network errors or other exceptions
      throw Exception('Error connecting to API: $e');
    }
  }
}