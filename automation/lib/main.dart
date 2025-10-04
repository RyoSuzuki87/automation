import 'package:flutter/material.dart';
import 'features/todo/ui/todo_page.dart';

void main() {
  WidgetsFlutterBinding.ensureInitialized();
  runApp(const SimpleTodoApp());
}

class SimpleTodoApp extends StatelessWidget {
  const SimpleTodoApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Simple ToDo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorSchemeSeed: Colors.teal,
        useMaterial3: true,
      ),
      home: const TodoPage(),
    );
  }
}

