import 'dart:convert';

class Todo {
  final String id;
  final String title;
  final bool done;
  final DateTime createdAt;

  const Todo({
    required this.id,
    required this.title,
    required this.done,
    required this.createdAt,
  });

  Todo copyWith({String? title, bool? done}) => Todo(
        id: id,
        title: title ?? this.title,
        done: done ?? this.done,
        createdAt: createdAt,
      );

  Map<String, dynamic> toMap() => {
        'id': id,
        'title': title,
        'done': done,
        'createdAt': createdAt.toIso8601String(),
      };

  factory Todo.fromMap(Map<String, dynamic> map) => Todo(
        id: map['id'] as String,
        title: map['title'] as String,
        done: map['done'] as bool,
        createdAt: DateTime.parse(map['createdAt'] as String),
      );

  String toJson() => jsonEncode(toMap());

  factory Todo.fromJson(String source) =>
      Todo.fromMap(jsonDecode(source) as Map<String, dynamic>);
}

