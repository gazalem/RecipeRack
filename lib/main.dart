import 'package:flutter/material.dart';
import 'screens/recipe_list_screen.dart';

void main() {
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Recipe App',
      theme: ThemeData(
        primarySwatch: Colors.blue,
        visualDensity: VisualDensity.adaptivePlatformDensity,
      ),
      home: const RecipeListScreen(),
    );
  }
}

// Move InputBoxWithButtons OUTSIDE of MyApp
class InputBoxWithButtons extends StatefulWidget {
  const InputBoxWithButtons({super.key});

  @override
  State<InputBoxWithButtons> createState() => _InputBoxWithButtonsState();
}

class _InputBoxWithButtonsState extends State<InputBoxWithButtons> {
  final TextEditingController _controller = TextEditingController();
  String _displayText = '';
  bool _isEditing = false;

  void _sendText() {
    setState(() {
      _displayText = _controller.text;
      _isEditing = false;
    });
  }

  void _editText() {
    setState(() {
      _isEditing = true;
      _controller.text = _displayText;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        if (_isEditing || _displayText.isEmpty)
          TextField(
            controller: _controller,
            decoration: const InputDecoration(labelText: 'Enter text'),
          ),
        if (_displayText.isNotEmpty && !_isEditing)
          Text(_displayText),
        Row(
          children: [
            ElevatedButton(
              onPressed: _sendText,
              child: const Text('Send'),
            ),
            const SizedBox(width: 8),
            ElevatedButton(
              onPressed: _editText,
              child: const Text('Edit'),
            ),
          ],
        ),
      ],
    );
  }
}