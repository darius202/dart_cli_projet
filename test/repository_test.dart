import 'dart:io';

import 'package:dart_cli_projet/enums/priority.dart';
import 'package:dart_cli_projet/models/task.dart';
import 'package:dart_cli_projet/repositories/task_repository.dart';
import 'package:test/test.dart';


void main() {

  late TaskRepository repository;
  late File file;


  setUp(() {
    repository = TaskRepository();
    file = File("data/tasks.json");
  });


  tearDown(() async {
    if (await file.exists()) {
      await file.delete();
    }
  });


  test('Sauvegarde et récupération des tâches', () async {

    final tasks = [
      Task(
        title: "Apprendre Dart",
        priority: Priority.high,
      )
    ];


    await repository.addItems(tasks);


    final result = await repository.getAll();


    expect(result.length, 1);
    expect(result.first.title, "Apprendre Dart");
    expect(result.first.priority, Priority.high);

  });



  test('Retourne une liste vide si aucun fichier existe', () async {


    if(await file.exists()){
      await file.delete();
    }


    final result = await repository.getAll();


    expect(result, isEmpty);

  });



  test('Conserve plusieurs tâches', () async {


    final tasks = [

      Task(
        title: "Flutter",
        priority: Priority.medium,
      ),

      Task(
        title: "Dart",
        priority: Priority.low,
      ),

    ];


    await repository.addItems(tasks);


    final result = await repository.getAll();


    expect(result.length, 2);

  });



}