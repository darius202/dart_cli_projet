import '../enums/priority.dart';

class Task {
  String title;
  Priority priority;
  DateTime? dueDate;
  bool completed;

  Task({
    required this.title,
    required this.priority,
    this.dueDate,
    this.completed = false,
  });

  Map<String, dynamic> toJson() => {
        "title": title,
        "priority": priority.name,
        "dueDate": dueDate?.toIso8601String(),
        "completed": completed,
      };

  factory Task.fromJson(Map<String, dynamic> json) {
    return Task(
      title: json["title"],
      priority: Priority.values.firstWhere(
        (e) => e.name == json["priority"],
      ),
      dueDate: json["dueDate"] != null
          ? DateTime.parse(json["dueDate"])
          : null,
      completed: json["completed"],
    );
  }
}