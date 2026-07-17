abstract class Repository<T> {
  Future<List<T>> getAll();
  Future<void> addItems(List<T> items);
}