part of 'cache_service.dart';

class SharedPreferencesService implements CacheService {
  SharedPreferencesService(this.prefs);

  final SharedPreferences prefs;

  @override
  Future<void> save<T>(CacheKey key, T value) async {
    if (value is String) {
      await prefs.setString(key.name, value);
    } else if (value is int) {
      await prefs.setInt(key.name, value);
    } else if (value is bool) {
      await prefs.setBool(key.name, value);
    } else if (value is double) {
      await prefs.setDouble(key.name, value);
    } else if (value is List<String>) {
      await prefs.setStringList(key.name, value);
    } else if (value is List) {
      // Convert list to string list for storage
      await prefs.setStringList(key.name, value.map((e) => e.toString()).toList());
    } else {
      await prefs.setString(key.name, value.toString());
    }
  }

  @override
  T? get<T>(CacheKey key) {
    if (T == String) {
      return prefs.getString(key.name) as T?;
    } else if (T == int) {
      return prefs.getInt(key.name) as T?;
    } else if (T == bool) {
      return prefs.getBool(key.name) as T?;
    } else if (T == double) {
      return prefs.getDouble(key.name) as T?;
    } else if (T == List<String>) {
      return prefs.getStringList(key.name) as T?;
    } else if (T.toString().startsWith('List<')) {
      // For List<dynamic> or other List types, try to get as string list
      final stringList = prefs.getStringList(key.name);
      if (stringList != null) {
        return stringList as T?;
      }
      return null;
    } else {
      return prefs.get(key.name) as T?;
    }
  }

  @override
  Future<void> remove(List<CacheKey> keys) async {
    for (final key in keys) {
      await prefs.remove(key.name);
    }
  }

  @override
  Future<void> clear() async {
    await prefs.clear();
  }
}
