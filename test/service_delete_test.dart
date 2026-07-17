import 'package:dart_cli_projet/interfaces/repository_interface.dart';
import 'package:test/test.dart';

import 'package:dart_cli_projet/models/task.dart';
import 'package:dart_cli_projet/enums/priority.dart';
import 'package:dart_cli_projet/services/task_service.dart';



class FakeRepository implements RepositoryInterface<Task>{


  List<Task> tasks = [];



  @override
  Future<List<Task>> getAll() async {
    return tasks;
  }



  @override
  Future<void> addItems(List<Task> items) async {
    tasks = items;
  }


}



void main(){


  test('Supprimer une tâche', () async {


    final repository = FakeRepository();

    final service = TaskService(repository);



    await service.add(

      Task(
        title: "Supprimer",
        priority: Priority.low,
      )

    );



    await service.delete(0);



    expect(
      repository.tasks.isEmpty,
      true,
    );


  });


}