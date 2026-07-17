import 'package:dart_cli_projet/interfaces/repository_interface.dart';

import '../exceptions/task_exception.dart';
import '../models/task.dart';

class TaskService {
  final RepositoryInterface<Task> repository;

  TaskService(this.repository);

  Future<void> add(Task task) async {
    final tasks = await repository.getAll();
    tasks.add(task);
    await repository.addItems(tasks);
  }

  Future<void> complete(int index) async {
    final tasks = await repository.getAll();

    _checkIndex(index, tasks.length);

    tasks[index].completed = true;

    await repository.addItems(tasks);
  }

  Future<void> delete(int index) async {
    final tasks = await repository.getAll();

    _checkIndex(index, tasks.length);

    tasks.removeAt(index);
    await repository.addItems(tasks);
  }

  void _checkIndex(int index, int length) {
    if (index < 0) {
      throw InvalidIndexException();
    }

    if (index >= length) {
      throw TaskNotFoundException();
    }
  }

  Future<List<Task>> listByPriority() async {
    final tasks = await repository.getAll();

    tasks.sort((a, b) => b.priority.index.compareTo(a.priority.index));

    return tasks;
  }

  Future<List<Task>> listByDate() async {
    final tasks = await repository.getAll();

    tasks.sort((a, b) {
      if (a.dueDate == null) return 1;
      if (b.dueDate == null) return -1;

      return a.dueDate!.compareTo(b.dueDate!);
    });

    return tasks;
  }
}
