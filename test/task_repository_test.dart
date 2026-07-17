import 'dart:io';

import 'package:test/test.dart';

import 'package:dart_cli_projet/enums/priority.dart';
import 'package:dart_cli_projet/models/task.dart';
import 'package:dart_cli_projet/repositories/task_repository.dart';

void main() {
  late Directory tempDir;
  late String path;

  setUp(() {
    tempDir = Directory.systemTemp.createTempSync('task_repository_test');
    path = '${tempDir.path}/tasks.json';
  });

  tearDown(() {
    tempDir.deleteSync(recursive: true);
  });

  test('getAll crée un fichier JSON vide si absent', () async {
    final repository = TaskRepository(path: path);

    final tasks = await repository.getAll();

    expect(tasks, isEmpty);
    expect(File(path).existsSync(), isTrue);
  });

  test('addItems persiste les tâches dans le fichier JSON', () async {
    final repository = TaskRepository(path: path);

    await repository.addItems([
      Task(title: 'Apprendre Dart', priority: Priority.high),
    ]);

    final content = File(path).readAsStringSync();

    expect(content, contains('Apprendre Dart'));
  });

  test('les données survivent à la recréation du repository (redémarrage)',
      () async {
    await TaskRepository(path: path).addItems([
      Task(title: 'Persister', priority: Priority.medium),
    ]);

    final tasks = await TaskRepository(path: path).getAll();

    expect(tasks.length, 1);
    expect(tasks.first.title, 'Persister');
  });

  test('addItems remplace entièrement le contenu précédent', () async {
    final repository = TaskRepository(path: path);

    await repository.addItems([
      Task(title: 'Première tâche', priority: Priority.low),
    ]);

    await repository.addItems([
      Task(title: 'Deuxième tâche', priority: Priority.high),
    ]);

    final tasks = await repository.getAll();

    expect(tasks.length, 1);
    expect(tasks.first.title, 'Deuxième tâche');
  });
}
