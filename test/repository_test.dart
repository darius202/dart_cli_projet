import 'package:dart_cli_projet/interfaces/repository_interface.dart';
import 'package:test/test.dart';

import 'package:dart_cli_projet/enums/priority.dart';
import 'package:dart_cli_projet/models/task.dart';

  import 'package:dart_cli_projet/services/task_service.dart';



class FakeRepository implements RepositoryInterface<Task> {


  final List<Task> tasks = [];



  @override
  Future<List<Task>> getAll() async {

    return List.from(tasks);

  }




  @override
  Future<void> addItems(List<Task> items) async {

    tasks
      ..clear()
      ..addAll(items);

  }


}




void main() {


  late FakeRepository repository;

  late TaskService service;



  setUp(() {


    repository = FakeRepository();


    service = TaskService(
      repository,
    );


  });






  test('Ajoute une tâche avec le service', () async {


    await service.add(

      Task(
        title: "Tester service",
        priority: Priority.high,
      ),

    );



    final result = await repository.getAll();



    expect(result.length, 1);

    expect(
      result.first.title,
      "Tester service",
    );


  });







  test('Marque une tâche comme terminée', () async {


    await service.add(

      Task(
        title: "Terminer tâche",
        priority: Priority.low,
      ),

    );



    await service.complete(0);



    final result = await repository.getAll();



    expect(
      result.first.completed,
      true,
    );


  });








  test('Supprime une tâche avec le service', () async {


    await service.add(

      Task(
        title: "Supprimer",
        priority: Priority.medium,
      ),

    );



    await service.delete(0);



    final result = await repository.getAll();



    expect(
      result,
      isEmpty,
    );


  });



}