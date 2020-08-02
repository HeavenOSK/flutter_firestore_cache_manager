import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firestore_icebox.dart';

String _generateKey(String path) => 'FirestoreIcebox-$path';

extension UnzipDocument on DocumentReference {
  Future<DocumentSnapshot> unzip() async {
    final sharedPreferences = await SharedPreferences.getInstance();
    final shouldFetch = _shouldGetFromServer(sharedPreferences);

    if (shouldFetch) {
      return _getFromServer(sharedPreferences);
    } else {
      DocumentSnapshot snap;
      snap = await _getFromCache();
      return snap ?? await _getFromServer(sharedPreferences);
    }
  }

  bool _shouldGetFromServer(SharedPreferences instance) {
    final lastIcedString = instance.getString(_generateKey(path));
    if (lastIcedString == null) {
      return true;
    }
    final lastIcedDateTime = DateTime.parse(lastIcedString);
    final expiredAt =
        lastIcedDateTime.add(FirestoreIcebox.instance.cacheExpiration);
    return DateTime.now().isAfter(expiredAt);
  }

  Future<DocumentSnapshot> _getFromServer(SharedPreferences instance) async {
    final snap = await get();

    await instance.setString(
        _generateKey(path), DateTime.now().toIso8601String());
    return snap;
  }

  Future<DocumentSnapshot> _getFromCache() {
    try {
      return get(source: Source.cache);
      // ignore: avoid_catches_without_on_clauses
    } catch (_) {
      return null;
    }
  }
}
