import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firestore_cache_manager_configuration.dart';

String _generateKey(String path) =>
    'FirestoreCacheManager-lastRefreshedAt-$path';

class FirestoreCacheManager {
  const FirestoreCacheManager(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  Future<bool> updateLastRefreshedAt(DocumentReference ref) async {
    return sharedPreferences.setString(
        _generateKey(ref.path), DateTime.now().toIso8601String());
  }

  bool shouldRefresh(DocumentReference ref) {
    final lastRefreshedAtString =
        sharedPreferences.getString(_generateKey(ref.path));
    if (lastRefreshedAtString == null) {
      return true;
    }
    final lastRefreshedAtDateTime = DateTime.parse(lastRefreshedAtString);
    final expiredAt = lastRefreshedAtDateTime
        .add(FirestoreCacheManagerConfiguration.instance.cacheExpiration);
    return DateTime.now().isAfter(expiredAt);
  }
}
