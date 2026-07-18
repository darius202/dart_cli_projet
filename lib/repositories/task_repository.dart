import 'dart:convert';
import 'dart:io';

import 'package:dart_cli_projet/interfaces/repository_interface.dart';

import '../models/base_task.dart';
import '../models/task.dart';
import '../models/urgent_task.dart';

class TaskRepository implements RepositoryInterface<BaseTask> {
  final String path;

  TaskRepository({
    this.path = 'data/tasks.json',
  });

  File get file => File(path);

  @override
  Future<List<BaseTask>> getAll() async {
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString('[]');
    }

    final content = await file.readAsString();

    final jsonList = jsonDecode(content) as List;

    return jsonList.map(_decode).toList();
  }

  @override
  Future<void> addItems(List<BaseTask> items) async {
    final existing = await getAll();

    await saveAll([...existing, ...items]);
  }

  @override
  Future<void> saveAll(List<BaseTask> items) async {
    if (!await file.exists()) {
      await file.create(recursive: true);
    }

    final jsonList = items.map((item) => item.toJson()).toList();

    await file.writeAsString(jsonEncode(jsonList));
  }

  BaseTask _decode(dynamic json) {
    final map = json as Map<String, dynamic>;

    return map['type'] == 'urgent'
        ? UrgentTask.fromJson(map)
        : Task.fromJson(map);
  }
}
