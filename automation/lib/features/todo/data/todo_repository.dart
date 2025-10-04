import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import '../../todo/model/todo.dart';

class TodoRepository {
  static const _storageKey = 'simple_todo:list';

  Future<List<Todo>> load() async {
    final prefs = await SharedPreferences.getInstance();
    final raw = prefs.getStringList(_storageKey) ?? <String>[];
    return raw
        .map((e) => Todo.fromMap(jsonDecode(e) as Map<String, dynamic>))
        .toList()
      ..sort((a, b) => b.createdAt.compareTo(a.createdAt));
  }

  Future<void> _saveAll(List<Todo> items) async {
    final prefs = await SharedPreferences.getInstance();
    final data =
        items.map((e) => jsonEncode(e.toMap())).toList(growable: false);
    await prefs.setStringList(_storageKey, data);
  }

  Future<List<Todo>> add(String title) async {
    final items = await load();
    final todo = Todo(
      id: DateTime.now().microsecondsSinceEpoch.toString(),
      title: title.trim(),
      done: false,
      createdAt: DateTime.now(),
    );
    final next = [todo, ...items];
    await _saveAll(next);
    return next;
  }

  Future<List<Todo>> toggle(String id) async {
    final items = await load();
    final next = items
        .map((t) => t.id == id ? t.copyWith(done: !t.done) : t)
        .toList(growable: false);
    await _saveAll(next);
    return next;
  }

  Future<List<Todo>> remove(String id) async {
    final items = await load();
    final next = items.where((t) => t.id != id).toList(growable: false);
    await _saveAll(next);
    return next;
  }

  Future<void> clearAll() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove(_storageKey);
  }
}

