import 'package:flutter/material.dart';
import 'package:ollama_dart/ollama_dart.dart';
import '../models/recipe_model.dart';
import '../utils/recipe_parser.dart';
import '../widgets/recipe_card.dart';
import 'dart:convert'; // For json.decode

class RecipeListScreen extends StatefulWidget {
  const RecipeListScreen({super.key});

  @override
  State<RecipeListScreen> createState() => _RecipeListScreenState();
}

class _RecipeListScreenState extends State<RecipeListScreen> {
  List<Recipe> _recipes = [];
  bool _isLoading = true;
  String? _errorMessage;

  // Your sample AI response
  // This should be replaced with the actual response from your AI model
  // For demonstration, we are using a hardcoded JSON string.
  // In a real-world scenario, you would fetch this from an API or a local file.
  // Note: Ensure that the JSON string is properly formatted and escaped.
  final String sampleJsonResponse = '''
  {
      "model": "llama3.2",
      "created_at": "2025-05-21T16:20:53.547179Z",
      "response": "What a great challenge! Here's a delicious menu plan for one week, with dishes that can be cooked or prepared in under 30 minutes. I've chosen to work with the ingredients you provided, and here are my creations:\\n\\n**Monday: Quick Turkey Tacos**\\n\\n* Prep Time: 15 minutes\\n* Cook Time: 10 minutes\\n* Ingredients: Ground turkey, chili seasoning, salsa spice/herb blend, shredded cheddar cheese, lettuce (not included in original list but assumed for serving)\\n* Instructions: Brown the ground turkey with chili seasoning and cook until browned. Serve in tacos shells with diced tomatoes, shredded cheese, and a dollop of salsa.\\n\\n**Tuesday: Spaghetti with Meat Sauce**\\n\\n* Prep Time: 10 minutes\\n* Cook Time: 15 minutes\\n* Ingredients: Ground beef or chicken (or alternative), jar marinara/pasta sauce, box whole grain pasta\\n* Instructions: Cook the pasta according to package instructions. Brown the ground meat and add marinara sauce for a quick spaghetti dinner.\\n\\n**Wednesday: Chicken Fajitas**\\n\\n* Prep Time: 10 minutes\\n* Cook Time: 15 minutes\\n* Ingredients: Boneless chicken breast or thighs, salsa spice/herb blend, mixed vegetables (e.g., bell peppers, onions)\\n* Instructions: Slice the chicken into strips and sauté with sliced veggies and a sprinkle of salsa spice. Serve with warm flour tortillas.\\n\\n**Thursday: Egg Salad Sandwiches**\\n\\n* Prep Time: 5 minutes\\n* Cook Time: N/A\\n* Ingredients: Eggs, shredded cheddar cheese (optional), mixed salad greens (not included in original list but assumed for serving)\\n* Instructions: Chop hard-boiled eggs and mix with mayonnaise (assuming a store-bought condiment). Add shredded cheese if desired. Serve on whole grain bread or lettuce wraps.\\n\\n**Friday: Chili Con Carne**\\n\\n* Prep Time: 10 minutes\\n* Cook Time: 20 minutes\\n* Ingredients: Ground turkey, chili seasoning, canned beans, diced tomatoes, jar salsa spice/herb blend\\n* Instructions: Brown the ground turkey with chili seasoning and add canned beans, diced tomatoes, and salsa spice. Simmer until heated through.\\n\\n**Saturday: Turkey and Cheese Quesadillas**\\n\\n* Prep Time: 10 minutes\\n* Cook Time: 10 minutes\\n* Ingredients: Ground turkey, shredded cheddar cheese, mixed salad greens (not included in original list but assumed for serving)\\n* Instructions: Shred the cooked ground turkey and mix with shredded cheese. Place inside a tortilla and cook in a pan until crispy and melted.\\n\\n**Sunday: Chicken and Veggie Stir-Fry**\\n\\n* Prep Time: 10 minutes\\n* Cook Time: 15 minutes\\n* Ingredients: Boneless chicken breast or thighs, mixed vegetables (e.g., frozen peas, carrots), soy sauce or teriyaki sauce\\n* Instructions: Slice the chicken into strips and stir-fry with mixed veggies and a drizzle of soy sauce.\\n\\nI hope you enjoy this menu plan! Each dish can be prepared in under 30 minutes, and they utilize the ingredients provided.",
      "done": true,
      "done_reason": "stop",
      "context": [],
      "total_duration": 100137805090,
      "load_duration": 7042197059,
      "prompt_eval_count": 211,
      "prompt_eval_duration": 12839810853,
      "eval_count": 639,
      "eval_duration": 80241118017
  }
  ''';

  @override
  void initState() {
    super.initState();
    _loadRecipes();
  }

  void _loadRecipes() {
    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });
    try {
      // Simulate network delay for fetching data
      Future.delayed(const Duration(seconds: 1), () {
        final jsonData = json.decode(sampleJsonResponse);
        final String aiResponseString = jsonData['response'];
        
        final parsedRecipes = RecipeParser.parseRecipes(aiResponseString);
        
        setState(() {
          _recipes = parsedRecipes;
          _isLoading = false;
        });

        if (parsedRecipes.isEmpty && aiResponseString.isNotEmpty) {
           setState(() {
             _errorMessage = "Could not parse any recipes from the response. Check the parser logic and AI output format.";
           });
        }
      });
    } catch (e) {
      setState(() {
        _errorMessage = "Error loading or parsing recipes: ${e.toString()}";
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Weekly Meal Plan'),
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (_errorMessage != null) {
      return Center(
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            _errorMessage!,
            style: const TextStyle(color: Colors.red, fontSize: 16),
            textAlign: TextAlign.center,
          ),
        ),
      );
    }

    if (_recipes.isEmpty) {
      return const Center(child: Text('No recipes found.'));
    }

    return ListView.builder(
      itemCount: _recipes.length,
      itemBuilder: (context, index) {
        return RecipeCard(recipe: _recipes[index]);
      },
    );
  }
}