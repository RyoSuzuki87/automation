import 'package:flutter/material.dart';
import '../../todo/data/todo_repository.dart';
import '../../todo/model/todo.dart';

class TodoPage extends StatefulWidget {
  const TodoPage({super.key});

  @override
  State<TodoPage> createState() => _TodoPageState();
}

class _TodoPageState extends State<TodoPage> {
  final _repo = TodoRepository();
  final _controller = TextEditingController();
  final _formKey = GlobalKey<FormState>();

  List<Todo> _items = [];
  bool _loading = true;

  @override
  void initState() {
    super.initState();
    _load();
  }

  Future<void> _load() async {
    final items = await _repo.load();
    setState(() {
      _items = items;
      _loading = false;
    });
  }

  Future<void> _add() async {
    if (!_formKey.currentState!.validate()) return;
    final title = _controller.text;
    _controller.clear();
    final next = await _repo.add(title);
    setState(() => _items = next);
  }

  Future<void> _toggle(String id) async {
    final next = await _repo.toggle(id);
    setState(() => _items = next);
  }

  Future<void> _remove(String id) async {
    final next = await _repo.remove(id);
    setState(() => _items = next);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Simple ToDo'),
        actions: [
          IconButton(
            tooltip: 'Reload',
            onPressed: _load,
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      body: _loading
          ? const Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Padding(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
                  child: Form(
                    key: _formKey,
                    child: Row(
                      children: [
                        Expanded(
                          child: TextFormField(
                            controller: _controller,
                            decoration: const InputDecoration(
                              labelText: 'Add a task',
                              border: OutlineInputBorder(),
                            ),
                            onFieldSubmitted: (_) => _add(),
                            validator: (v) {
                              if (v == null || v.trim().isEmpty) {
                                return 'Please enter a task';
                              }
                              return null;
                            },
                          ),
                        ),
                        const SizedBox(width: 8),
                        FilledButton.icon(
                          onPressed: _add,
                          icon: const Icon(Icons.add),
                          label: const Text('Add'),
                        ),
                      ],
                    ),
                  ),
                ),
                const Divider(height: 1),
                Expanded(
                  child: _items.isEmpty
                      ? const Center(
                          child: Text('No tasks yet. Add your first one!'),
                        )
                      : ListView.separated(
                          itemCount: _items.length,
                          separatorBuilder: (_, __) =>
                              const Divider(height: 1, thickness: 0.5),
                          itemBuilder: (context, index) {
                            final t = _items[index];
                            return Dismissible(
                              key: ValueKey(t.id),
                              background: Container(
                                alignment: Alignment.centerLeft,
                                padding: const EdgeInsets.only(left: 16),
                                child: const Icon(Icons.delete_outline),
                              ),
                              secondaryBackground: Container(
                                alignment: Alignment.centerRight,
                                padding: const EdgeInsets.only(right: 16),
                                child: const Icon(Icons.delete_outline),
                              ),
                              onDismissed: (_) => _remove(t.id),
                              child: CheckboxListTile(
                                title: Text(
                                  t.title,
                                  maxLines: 2,
                                  overflow: TextOverflow.ellipsis,
                                  style: t.done
                                      ? const TextStyle(
                                          decoration:
                                              TextDecoration.lineThrough,
                                          fontStyle: FontStyle.italic,
                                        )
                                      : null,
                                ),
                                subtitle: Text(
                                  _formatDate(t.createdAt),
                                  style: Theme.of(context)
                                      .textTheme
                                      .labelSmall
                                      ?.copyWith(
                                        color: Theme.of(context)
                                            .textTheme
                                            .labelSmall
                                            ?.color
                                            ?.withValues(alpha: 0.7),
                                      ),
                                ),
                                value: t.done,
                                onChanged: (_) => _toggle(t.id),
                              ),
                            );
                          },
                        ),
                ),
              ],
            ),
    );
  }

  String _formatDate(DateTime dt) {
    final y = dt.year.toString().padLeft(4, '0');
    final m = dt.month.toString().padLeft(2, '0');
    final d = dt.day.toString().padLeft(2, '0');
    final hh = dt.hour.toString().padLeft(2, '0');
    final mm = dt.minute.toString().padLeft(2, '0');
    return '$y-$m-$d $hh:$mm';
  }
}

