import 'package:dart_cli_projet/enums/priority.dart';
import 'package:dart_cli_projet/exceptions/task_exception.dart';
import 'package:dart_cli_projet/models/task.dart';
import 'package:dart_cli_projet/repositories/repository.dart';
import 'package:dart_cli_projet/services/task_service.dart';
import 'package:test/test.dart';



class FakeRepository implements Repository<Task>{


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



void main(){
  late FakeRepository repository;

  late TaskService service;

  setUp((){

    repository = FakeRepository();

    service = TaskService(repository);

  });

  test('Ajoute une tâche', () async {


    await service.add(
      Task(
        title: "Faire les tests",
        priority: Priority.high,
      ),
    );


    final result = await repository.getAll();


    expect(result.length, 1);

    expect(
      result.first.title,
      "Faire les tests",
    );


  });





  test('Marque une tâche comme terminée', () async {
    await service.add(
      Task(
        title: "Terminer projet",
        priority: Priority.medium,
      ),
    );



    await service.complete(0);



    final result = await repository.getAll();



    expect(
      result.first.completed,
      true,
    );


  });






  test('Supprime une tâche', () async {



    await service.add(
      Task(
        title: "A supprimer",
        priority: Priority.low,
      ),
    );



    await service.delete(0);



    final result = await repository.getAll();



    expect(
      result,
      isEmpty,
    );


  });






  test('Trie les tâches par priorité', () async {


    await service.add(
      Task(
        title: "Faible",
        priority: Priority.low,
      ),
    );


    await service.add(
      Task(
        title: "Urgente",
        priority: Priority.high,
      ),
    );



    final result = await service.listByPriority();

    expect(
      result.first.priority,
      Priority.high,
    );


  });







  test('Lance une exception si la tâche existe pas', () async {


    expect(

      () => service.delete(0),

      throwsA(
        isA<TaskException>(),
      ),

    );


  });

}