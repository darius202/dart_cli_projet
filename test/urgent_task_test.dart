import 'package:test/test.dart';

import 'package:dart_cli_projet/models/urgent_task.dart';
import 'package:dart_cli_projet/enums/priority.dart';


void main(){

  test('Une tâche urgente a une priorité haute', () {


    final task = UrgentTask(
      title: "Bug critique",
    );


    expect(
      task.priority,
      Priority.high,
    );


  });

}