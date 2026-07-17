import '../enums/priority.dart';
import 'task.dart';

class UrgentTask extends Task {
  UrgentTask({
    required super.title,
    super.dueDate,
  }) : super(priority: Priority.high);
}
