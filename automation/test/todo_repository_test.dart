import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:simple_todo/features/todo/data/todo_repository.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  setUp(() async {
    SharedPreferences.setMockInitialValues({});
  });

  test('add -> load -> toggle -> remove lifecycle', () async {
    final repo = TodoRepository();

    // initially empty
    expect((await repo.load()).length, 0);

    // add
    final afterAdd = await repo.add('Task A');
    expect(afterAdd.length, 1);
    expect(afterAdd.first.title, 'Task A');
    expect(afterAdd.first.done, false);

    // load persists
    final loaded = await repo.load();
    expect(loaded.length, 1);

    // toggle
    final toggled = await repo.toggle(loaded.first.id);
    expect(toggled.first.done, true);

    // remove
    final removed = await repo.remove(loaded.first.id);
    expect(removed.length, 0);
  });
}

