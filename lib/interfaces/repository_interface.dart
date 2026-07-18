abstract interface class RepositoryInterface<T> {
  Future<List<T>> getAll();

  /// Ajoute [items] aux données déjà persistées.
  Future<void> addItems(List<T> items);

  /// Remplace l'intégralité des données persistées par [items].
  Future<void> saveAll(List<T> items);
}
