import 'package:shared_preferences/shared_preferences.dart';

import 'firestore_cache_manager_configuration.dart';

String _generateKey(String path) =>
    'FirestoreCacheManager-lastRefreshedAt-$path';

class FirestoreCacheManager {
  const FirestoreCacheManager(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  Future<bool> updateLastRefreshedAt(String path) async {
    return sharedPreferences.setString(
        _generateKey(path), DateTime.now().toIso8601String());
  }

  bool shouldUpdateCache(String path) {
    final lastIcedString = sharedPreferences.getString(_generateKey(path));
    if (lastIcedString == null) {
      return true;
    }
    final lastIcedDateTime = DateTime.parse(lastIcedString);
    final expiredAt = lastIcedDateTime
        .add(FirestoreCacheManagerConfiguration.instance.cacheExpiration);
    return DateTime.now().isAfter(expiredAt);
  }
}
