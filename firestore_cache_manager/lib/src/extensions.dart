import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firestore_cache_manager.dart';

extension FirestoreCacheManagerExtensions on DocumentReference {
  /// Read [DocumentSnapshot] from server with managing the cache on
  /// the [FirestoreCacheManager].
  Future<DocumentSnapshot> fetch() async {
    final iceboxManager = FirestoreCacheManager(
      await SharedPreferences.getInstance(),
    );
    return _getFromServer(iceboxManager);
  }

  /// Read [DocumentSnapshot] from cache first. If the cache have been expired,
  /// get document from server.
  ///
  /// And also if no documents exists on cache, get document from server.
  Future<DocumentSnapshot> unzip() async {
    final iceboxManager = FirestoreCacheManager(
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
      FirestoreCacheManager iceboxManager) async {
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
