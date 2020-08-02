import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firestore_icebox_manager.dart';

extension FirestoreIceboxExtensions on DocumentReference {
  /// Get [DocumentSnapshot] from server with managing the cache on the icebox
  Future<DocumentSnapshot> fetch() async {
    final iceboxManager = FirestoreIceboxManager(
      await SharedPreferences.getInstance(),
    );
    return _getFromServer(iceboxManager);
  }

  /// Get [DocumentSnapshot] from cache with managing the cache on the icebox
  Future<DocumentSnapshot> unzip() async {
    final iceboxManager = FirestoreIceboxManager(
      await SharedPreferences.getInstance(),
    );

    final shouldUpdate = iceboxManager.shouldUpdateCache(path);

    if (shouldUpdate) {
      return _getFromServer(iceboxManager);
    } else {
      DocumentSnapshot snapshot;
      snapshot = await _getFromCache();
      return snapshot ?? await _getFromServer(iceboxManager);
    }
  }

  Future<DocumentSnapshot> _getFromServer(
      FirestoreIceboxManager iceboxManager) async {
    final snapshot = await get();
    if (!snapshot.metadata.isFromCache) {
      await iceboxManager.updateLastRefreshedAt(path);
    }
    return snapshot;
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
