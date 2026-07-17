import 'package:test/test.dart';

import 'package:dart_cli_projet/models/task.dart';
import 'package:dart_cli_projet/models/urgent_task.dart';
import 'package:dart_cli_projet/enums/priority.dart';

void main() {
  test('Une tâche urgente a une priorité haute', () {
    final task = UrgentTask(
      title: 'Bug critique',
    );

    expect(
      task.priority,
      Priority.high,
    );
  });

  test('UrgentTask redéfinit describe() pour signaler l\'urgence', () {
    final urgentTask = UrgentTask(title: 'Bug critique');
    final task = Task(title: 'Bug critique', priority: Priority.high);

    expect(urgentTask.describe(), startsWith('🚨 URGENT'));
    expect(task.describe(), isNot(startsWith('🚨 URGENT')));
    expect(urgentTask.describe(), contains(task.describe()));
  });
}
