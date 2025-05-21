import '../models/recipe_model.dart';

class RecipeParser {
  static List<Recipe> parseRecipes(String responseText) {
    final List<Recipe> recipes = [];
    // Remove the introductory sentence if present
    final relevantText = responseText.substring(responseText.indexOf("**Monday"));

    // Split the text into blocks for each day.
    // Assuming each recipe block is separated by at least two newlines and starts with "**Day:"
    final dayBlocks = relevantText.split(RegExp(r'\n\s*\n\s*(?=\*\*)'));

    for (var block in dayBlocks) {
      if (block.trim().isEmpty) continue;

      String day = '';
      String name = '';
      String prepTime = 'N/A';
      String cookTime = 'N/A';
      String ingredients = 'N/A';
      String instructions = 'N/A';

      final lines = block.split('\n').map((line) => line.trim()).toList();

      // Extract Day and Name (e.g., "**Monday: Quick Turkey Tacos**")
      final titleLine = lines.firstWhere((line) => line.startsWith('**') && line.endsWith('**'), orElse: () => '');
      if (titleLine.isNotEmpty) {
        final titleContent = titleLine.replaceAll('**', '');
        final parts = titleContent.split(':');
        if (parts.length > 1) {
          day = parts[0].trim();
          name = parts.sublist(1).join(':').trim();
        } else {
          name = titleContent.trim(); // Or handle as an error/unknown
        }
      }

      for (final line in lines) {
        if (line.startsWith('* Prep Time:')) {
          prepTime = line.replaceFirst('* Prep Time:', '').trim();
        } else if (line.startsWith('* Cook Time:')) {
          cookTime = line.replaceFirst('* Cook Time:', '').trim();
        } else if (line.startsWith('* Ingredients:')) {
          ingredients = line.replaceFirst('* Ingredients:', '').trim();
        } else if (line.startsWith('* Instructions:')) {
          instructions = line.replaceFirst('* Instructions:', '').trim();
        }
      }
      // If instructions are multi-line, we might need more sophisticated parsing
      // For now, this takes the first line. If instructions span multiple lines without the prefix,
      // we might need to collect lines until the next '*' or end of block.
      // Let's refine this: assume instructions are everything after '* Instructions:' until the next '*' or end of block.
      final instructionsStartIndex = block.indexOf('* Instructions:');
      if (instructionsStartIndex != -1) {
          final restOfBlockAfterInstructions = block.substring(instructionsStartIndex + '* Instructions:'.length);
          // Find the start of the next potential metadata item (like a new day or a completely new section)
          final nextAttributeIndex = restOfBlockAfterInstructions.indexOf('\n* ');
          if (nextAttributeIndex != -1) {
              instructions = restOfBlockAfterInstructions.substring(0, nextAttributeIndex).trim();
          } else {
              instructions = restOfBlockAfterInstructions.trim();
          }
      }


      if (name.isNotEmpty) { // Only add if we could parse a name
        recipes.add(Recipe(
          day: day,
          name: name,
          prepTime: prepTime,
          cookTime: cookTime,
          ingredients: ingredients,
          instructions: instructions,
        ));
      }
    }
    return recipes;
  }
}