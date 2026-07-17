import 'dart:io';

import 'package:dart_cli_projet/enums/priority.dart';
import 'package:dart_cli_projet/models/task.dart';
import 'package:dart_cli_projet/services/task_service.dart';

class TaskCLI {
  final TaskService service;

  TaskCLI(this.service);

  Future<void> start() async {
    while (true) {
      print("\n===== TASK MANAGER =====");
      print("1. Ajouter une tâche");
      print("2. Lister les tâches");
      print("3. Lister par priorité");
      print("4. Lister par date");
      print("5. Marquer une tâche terminée");
      print("6. Supprimer une tâche");
      print("0. Quitter");

      stdout.write("Votre choix : ");
      final choice = stdin.readLineSync();

      switch (choice) {
        case "1":
          await addTask();
          break;

        case "2":
          await listTasks();
          break;

        case "3":
          await listByPriority();
          break;

        case "4":
          await listByDate();
          break;

        case "5":
          await completeTask();
          break;

        case "6":
          await deleteTask();
          break;

        case "0":
          print("Au revoir !");
          return;

        default:
          print("Choix invalide.");
      }
    }
  }

  Future<void> addTask() async {
    stdout.write("Titre : ");
    final title = stdin.readLineSync()!;

    stdout.write("Priorité (low, medium, high) : ");
    final priorityInput = stdin.readLineSync()!;

    Priority priority;

    switch (priorityInput.toLowerCase()) {
      case "low":
        priority = Priority.low;
        break;
      case "medium":
        priority = Priority.medium;
        break;
      case "high":
        priority = Priority.high;
        break;
      default:
        print("Priorité invalide.");
        return;
    }

    stdout.write("Date limite (yyyy-mm-dd) ou vide : ");
    final dateInput = stdin.readLineSync();

    DateTime? dueDate;

    if (dateInput != null && dateInput.isNotEmpty) {
      dueDate = DateTime.tryParse(dateInput);

      if (dueDate == null) {
        print("Date invalide.");
        return;
      }
    }

    await service.add(
      Task(
        title: title,
        priority: priority,
        dueDate: dueDate,
      ),
    );

    print("Tâche ajoutée.");
  }

  Future<void> listTasks() async {
    final tasks = await service.repository.getAll();

    if (tasks.isEmpty) {
      print("Aucune tâche.");
      return;
    }

    for (int i = 0; i < tasks.length; i++) {
      final task = tasks[i];

      print("$i - ${task.title} | ${task.priority.name} | "
          "${task.completed ? '✅' : '❌'} | "
          "${task.dueDate?.toIso8601String().split('T').first ?? '-'}");
    }
  }

  Future<void> listByPriority() async {
    final tasks = await service.listByPriority();

    for (int i = 0; i < tasks.length; i++) {
      print("${tasks[i].title} - ${tasks[i].priority.name}");
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
    stdout.write("Index de la tâche : ");

    final index = int.tryParse(stdin.readLineSync() ?? "");

    if (index == null) {
      print("Index invalide.");
      return;
    }

    await service.complete(index);

    print("Tâche terminée.");
  }

  Future<void> deleteTask() async {
    stdout.write("Index de la tâche : ");

    final index = int.tryParse(stdin.readLineSync() ?? "");

    if (index == null) {
      print("Index invalide.");
      return;
    }

    await service.delete(index);

    print("Tâche supprimée.");
  }
}
