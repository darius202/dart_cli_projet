import 'package:test/test.dart';

import 'package:dart_cli_projet/models/task.dart';
import 'package:dart_cli_projet/enums/priority.dart';


void main(){

  test('Création d une tâche', () {

    final task = Task(
      title: "Apprendre Dart",
      priority: Priority.high,
    );


    expect(task.title, "Apprendre Dart");
    expect(task.priority, Priority.high);

  });

}