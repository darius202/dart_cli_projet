import 'package:dart_cli_projet/enums/priority.dart';

import 'base_task.dart';

class Task extends BaseTask {
  Task({
    required super.title,
    required super.priority,
    super.dueDate,
    super.completed,
  });

  @override
  Map<String, dynamic> toJson() {
    return {
      'title': title,
      'priority': priority.name,
      'dueDate': dueDate?.toIso8601String(),
      'completed': completed
    };
  }

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json['title'],
      priority: Priority.values.firstWhere(
        (e) => e.name == json['priority'],
      ),
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      completed: json['completed'],
    );
  }
}
