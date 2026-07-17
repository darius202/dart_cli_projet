import '../enums/priority.dart';
import '../interfaces/json_serializable.dart';

abstract class BaseTask implements JsonSerializable {
  String title;

  Priority priority;

  DateTime? dueDate;

  bool completed;

  BaseTask({
    required this.title,
    required this.priority,
    this.dueDate,
    this.completed = false,
  });

  void markAsCompleted() {
    completed = true;
  }
}
