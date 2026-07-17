import 'package:dart_cli_projet/exceptions/task_exception.dart';
import 'package:dart_cli_projet/interfaces/repository_interface.dart';
import 'package:test/test.dart';

import 'package:dart_cli_projet/models/task.dart';
import 'package:dart_cli_projet/enums/priority.dart';
import 'package:dart_cli_projet/services/task_service.dart';

class FakeRepository implements RepositoryInterface<Task> {
  List<Task> tasks = [];

  @override
  Future<List<Task>> getAll() async {
    return tasks;
  }

  @override
  Future<void> addItems(List<Task> items) async {
    tasks = items;
  }
}

void main() {
  test('Lève une TaskNotFoundException pour un index inexistant', () async {
    final repository = FakeRepository();
    final service = TaskService(repository);

    await service.add(
      Task(title: 'Finir projet', priority: Priority.high),
    );

    expect(
      () => service.complete(5),
      throwsA(isA<TaskNotFoundException>()),
    );
  });

  test('Lève une InvalidIndexException pour un index négatif', () async {
    final repository = FakeRepository();
    final service = TaskService(repository);

    await service.add(
      Task(title: 'Finir projet', priority: Priority.high),
    );

    expect(
      () => service.complete(-1),
      throwsA(isA<InvalidIndexException>()),
    );
  });
}
