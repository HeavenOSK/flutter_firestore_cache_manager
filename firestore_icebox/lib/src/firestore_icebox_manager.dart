import 'package:shared_preferences/shared_preferences.dart';

import 'firestore_icebox.dart';

String _generateKey(String path) => 'firestore_icebox-lastRefreshedAt-$path';

class FirestoreIceboxManager {
  const FirestoreIceboxManager(this.sharedPreferences);

  final SharedPreferences sharedPreferences;

  Future<void> updateLastRefreshedAt(String path) async {
    await sharedPreferences.setString(
        _generateKey(path), DateTime.now().toIso8601String());
  }

  bool shouldUpdateCache(String path) {
    final lastIcedString = sharedPreferences.getString(_generateKey(path));
    if (lastIcedString == null) {
      return true;
    }
    final lastIcedDateTime = DateTime.parse(lastIcedString);
    final expiredAt =
        lastIcedDateTime.add(FirestoreIcebox.instance.cacheExpiration);
    return DateTime.now().isAfter(expiredAt);
  }
}
