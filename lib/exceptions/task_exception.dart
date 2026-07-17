class TaskException implements Exception {
  final String message;

  TaskException(this.message);

  @override
  String toString() => message;
}

class InvalidIndexException extends TaskException {
  InvalidIndexException([super.message = "L'index ne peut pas être négatif"]);
}

class TaskNotFoundException extends TaskException {
  TaskNotFoundException([super.message = "Cette tâche n'existe pas"]);
}
