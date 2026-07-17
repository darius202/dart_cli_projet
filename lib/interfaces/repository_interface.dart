abstract interface class RepositoryInterface<T> {
  Future<List<T>> getAll();
  Future<void> addItems(List<T> items);
}
