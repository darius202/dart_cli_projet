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

class InvalidPriorityException extends TaskException {
  InvalidPriorityException([super.message = 'Priorité invalide.']);
}

class InvalidDateException extends TaskException {
  InvalidDateException([super.message = 'Date invalide.']);
}
