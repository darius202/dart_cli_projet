import 'package:dart_cli_projet/interfaces/repository_interface.dart';
import 'package:test/test.dart';

import 'package:dart_cli_projet/enums/priority.dart';
import 'package:dart_cli_projet/models/base_task.dart';
import 'package:dart_cli_projet/models/task.dart';

import 'package:dart_cli_projet/services/task_service.dart';

class FakeRepository implements RepositoryInterface<BaseTask> {
  final List<BaseTask> tasks = [];

  @override
  Future<List<BaseTask>> getAll() async => List.from(tasks);

  @override
  Future<void> addItems(List<BaseTask> items) async {
    tasks.addAll(items);
  }

  @override
  Future<void> saveAll(List<BaseTask> items) async {
    tasks
      ..clear()
      ..addAll(items);
  }
}

void main() {
  late FakeRepository repository;

  late TaskService service;

  setUp(() {
    repository = FakeRepository();

    service = TaskService(
      repository,
    );
  });

  test('Ajoute une tâche avec le service', () async {
    await service.add(
      Task(
        title: 'Tester service',
        priority: Priority.high,
      ),
    );

    final result = await repository.getAll();

    expect(result.length, 1);

    expect(
      result.first.title,
      'Tester service',
    );
  });

  test('Marque une tâche comme terminée', () async {
    await service.add(
      Task(
        title: 'Terminer tâche',
        priority: Priority.low,
      ),
    );

    await service.complete(0);

    final result = await repository.getAll();

    expect(
      result.first.completed,
      true,
    );
  });

  test('Supprime une tâche avec le service', () async {
    await service.add(
      Task(
        title: 'Supprimer',
        priority: Priority.medium,
      ),
    );

    await service.delete(0);

    final result = await repository.getAll();

    expect(
      result,
      isEmpty,
    );
  });

  test('listByPriority trie du plus prioritaire au moins prioritaire',
      () async {
    await service.add(Task(title: 'Basse', priority: Priority.low));
    await service.add(Task(title: 'Haute', priority: Priority.high));
    await service.add(Task(title: 'Moyenne', priority: Priority.medium));

    final result = await service.listByPriority();

    expect(
      result.map((t) => t.title).toList(),
      ['Haute', 'Moyenne', 'Basse'],
    );
  });

  test('listByDate trie par date croissante, tâches sans date en dernier',
      () async {
    await service.add(Task(title: 'Sans date', priority: Priority.low));
    await service.add(
      Task(
        title: 'Plus tard',
        priority: Priority.low,
        dueDate: DateTime(2026, 12, 31),
      ),
    );
    await service.add(
      Task(
        title: 'Bientôt',
        priority: Priority.low,
        dueDate: DateTime(2026, 1, 1),
      ),
    );

    final result = await service.listByDate();

    expect(
      result.map((t) => t.title).toList(),
      ['Bientôt', 'Plus tard', 'Sans date'],
    );
  });
}
