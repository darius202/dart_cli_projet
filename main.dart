import 'package:dart_cli_projet/cli/task_cli.dart';
import 'package:dart_cli_projet/repositories/task_repository.dart';
import 'package:dart_cli_projet/services/task_service.dart';


void main() async {
  final cli = TaskCLI(TaskService(TaskRepository()));

  await cli.start();
}
