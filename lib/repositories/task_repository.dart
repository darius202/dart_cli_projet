import 'dart:convert';
import 'dart:io';

import 'package:dart_cli_projet/interfaces/repository_interface.dart';

import '../models/task.dart';

class TaskRepository implements RepositoryInterface<Task> {
 final String path;


  TaskRepository({
    this.path = "data/tasks.json",
  });


  File get file => File(path);

  @override
  Future<List<Task>> getAll() async {
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString("[]");
    }

    final content = await file.readAsString();

    final jsonList = jsonDecode(content) as List;

    return jsonList
        .map((e) => Task.fromJson(e))
        .toList();
  
  }

  @override
  Future<void> addItems(List<Task> items) async {
    if (!await file.exists()) {
      await file.create(recursive: true);
      await file.writeAsString("[]");
    }

    final content = await file.readAsString();
    final jsonList = jsonDecode(content) as List;

    for (final item in items) {
      jsonList.add(item.toJson());
    }

    await file.writeAsString(jsonEncode(jsonList));
  }
}