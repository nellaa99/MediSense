class StorageService<T> {
  final List<T> _items = [];

 
  Future<void> add(T item) async {
    await Future.delayed(const Duration(milliseconds: 100));
    _items.add(item);
  }

  
  Future<List<T>> getAll() async {
    await Future.delayed(const Duration(milliseconds: 100));
    return List<T>.from(_items);
  }

  
  Future<T?> findWhere(bool Function(T) test) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      return _items.firstWhere(test);
    } catch (e) {
      return null;
    }
  }


  Future<List<T>> findAllWhere(bool Function(T) test) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _items.where(test).toList();
  }


  Future<bool> update(bool Function(T) test, T newItem) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final index = _items.indexWhere(test);
    if (index != -1) {
      _items[index] = newItem;
      return true;
    }
    return false;
  }

 
  Future<bool> delete(bool Function(T) test) async {
    await Future.delayed(const Duration(milliseconds: 100));
    try {
      final item = _items.firstWhere(test);
      _items.remove(item);
      return true;
    } catch (e) {
      return false;
    }
  }

 
  Future<int> deleteAllWhere(bool Function(T) test) async {
    await Future.delayed(const Duration(milliseconds: 100));
    final itemsToRemove = _items.where(test).toList();
    for (var item in itemsToRemove) {
      _items.remove(item);
    }
    return itemsToRemove.length;
  }


  Future<void> clear() async {
    await Future.delayed(const Duration(milliseconds: 100));
    _items.clear();
  }


  Future<bool> exists(bool Function(T) test) async {
    await Future.delayed(const Duration(milliseconds: 100));
    return _items.any(test);
  }

  
  int get length => _items.length;


  bool get isEmpty => _items.isEmpty;


  bool get isNotEmpty => _items.isNotEmpty;


  T? get first => _items.isEmpty ? null : _items.first;

 
  T? get last => _items.isEmpty ? null : _items.last;

  T? getAt(int index) {
    if (index < 0 || index >= _items.length) return null;
    return _items[index];
  }

 
  void sort([int Function(T, T)? compare]) {
    if (compare != null) {
      _items.sort(compare);
    }
  }

  
  void reverse() {
    _items.reversed;
  }

  Future<void> saveUsers(users) async {}

  Future getUsers() async {}

  Future<void> setCurrentUser(user) async {}

  Future<void> setAdminLogin(bool bool) async {}
}