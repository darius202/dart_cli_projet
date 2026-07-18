import 'dart:io';

import 'package:dart_cli_projet/enums/priority.dart';
import 'package:dart_cli_projet/exceptions/task_exception.dart';
import 'package:dart_cli_projet/models/base_task.dart';
import 'package:dart_cli_projet/models/task.dart';
import 'package:dart_cli_projet/models/urgent_task.dart';
import 'package:dart_cli_projet/services/task_service.dart';

class TaskCLI {
  final TaskService service;

  TaskCLI(this.service);

  Future<void> start() async {
    while (true) {
      print('\n===== TASK MANAGER =====');
      print('1. Ajouter une tâche');
      print('2. Lister les tâches');
      print('3. Lister par priorité');
      print('4. Lister par date');
      print('5. Marquer une tâche terminée');
      print('6. Supprimer une tâche');
      print('0. Quitter');

      stdout.write('Votre choix : ');
      final choice = stdin.readLineSync();

      switch (choice) {
        case '1':
          await addTask();
          break;

        case '2':
          await listTasks();
          break;

        case '3':
          await listByPriority();
          break;

        case '4':
          await listByDate();
          break;

        case '5':
          await completeTask();
          break;

        case '6':
          await deleteTask();
          break;

        case '0':
          print('Au revoir !');
          return;

        default:
          print('Choix invalide.');
      }
    }
  }

  Future<void> addTask() async {
    stdout.write('Titre : ');
    final title = stdin.readLineSync()!;

    stdout.write('Priorité (low, medium, high, urgent) : ');
    final priorityInput = stdin.readLineSync() ?? '';

    stdout.write('Date limite (yyyy-mm-dd) ou vide : ');
    final dateInput = stdin.readLineSync();

    try {
      final dueDate = _parseDueDate(dateInput);
      final task = _buildTask(title, priorityInput, dueDate);

      await service.add(task);

      print('Tâche ajoutée.');
    } on TaskException catch (e) {
      print('Erreur : $e');
    }
  }

  BaseTask _buildTask(String title, String priorityInput, DateTime? dueDate) {
    if (priorityInput.toLowerCase() == 'urgent') {
      return UrgentTask(title: title, dueDate: dueDate);
    }

    return Task(
      title: title,
      priority: _parsePriority(priorityInput),
      dueDate: dueDate,
    );
  }

  Priority _parsePriority(String input) {
    switch (input.toLowerCase()) {
      case 'low':
        return Priority.low;
      case 'medium':
        return Priority.medium;
      case 'high':
        return Priority.high;
      default:
        throw InvalidPriorityException();
    }
  }

  DateTime? _parseDueDate(String? input) {
    if (input == null || input.isEmpty) {
      return null;
    }

    final date = DateTime.tryParse(input);

    if (date == null) {
      throw InvalidDateException();
    }

    return date;
  }

  int _parseIndex(String? input) {
    final index = int.tryParse(input ?? '');

    if (index == null) {
      throw InvalidIndexException('Index invalide.');
    }

    return index;
  }

  Future<void> listTasks() async {
    final tasks = await service.repository.getAll();

    if (tasks.isEmpty) {
      print('Aucune tâche.');
      return;
    }

    for (int i = 0; i < tasks.length; i++) {
      print('$i - ${tasks[i].describe()}');
    }
  }

  Future<void> listByPriority() async {
    final tasks = await service.listByPriority();

    for (int i = 0; i < tasks.length; i++) {
      print('${tasks[i].title} - ${tasks[i].priority.name}');
    }
  }

  Future<void> listByDate() async {
    final tasks = await service.listByDate();

    for (int i = 0; i < tasks.length; i++) {
      print(
          "${tasks[i].title} - ${tasks[i].dueDate?.toIso8601String().split('T').first ?? '-'}");
    }
  }

  Future<void> completeTask() async {
    stdout.write('Index de la tâche : ');
    final input = stdin.readLineSync();

    try {
      final index = _parseIndex(input);

      await service.complete(index);

      print('Tâche terminée.');
    } on TaskException catch (e) {
      print('Erreur : $e');
    }
  }

  Future<void> deleteTask() async {
    stdout.write('Index de la tâche : ');
    final input = stdin.readLineSync();

    try {
      final index = _parseIndex(input);

      await service.delete(index);

      print('Tâche supprimée.');
    } on TaskException catch (e) {
      print('Erreur : $e');
    }
  }
}
