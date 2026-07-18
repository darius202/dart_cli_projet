import 'package:dart_cli_projet/interfaces/json_serializable.dart';

import '../enums/priority.dart';
import 'base_task.dart';

class UrgentTask extends BaseTask implements JsonSerializable {
  UrgentTask({
    required super.title,
    super.dueDate,
    super.completed,
  }) : super(priority: Priority.high);

  @override
  String describe() => '🚨 URGENT — ${super.describe()}';

  @override
  Map<String, dynamic> toJson() {
    return {
      'type': 'urgent',
      ...commonFields(),
    };
  }

  factory UrgentTask.fromJson(Map<String, dynamic> json) {
    return UrgentTask(
      title: json['title'],
      dueDate: json['dueDate'] != null ? DateTime.parse(json['dueDate']) : null,
      completed: json['completed'],
    );
  }
}
