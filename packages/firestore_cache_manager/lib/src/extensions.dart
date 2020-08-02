import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:shared_preferences/shared_preferences.dart';

import 'firestore_cache_manager.dart';

extension FirestoreCacheManagerExtensions on DocumentReference {
  /// Read [DocumentSnapshot] from server with managing the cache on
  /// the [FirestoreCacheManager].
  Future<DocumentSnapshot> fetch() async {
    final cacheManager = FirestoreCacheManager(
      await SharedPreferences.getInstance(),
    );
    return _getFromServer(cacheManager);
  }

  /// Read [DocumentSnapshot] from cache first. If the cache have been expired,
  /// get document from server.
  ///
  /// And also if no documents exists on cache, get document from server.
  Future<DocumentSnapshot> unzip() async {
    final cacheManager = FirestoreCacheManager(
      await SharedPreferences.getInstance(),
    );

    final shouldRefresh = cacheManager.shouldRefresh(this);

    if (shouldRefresh) {
      return _getFromServer(cacheManager);
    } else {
      DocumentSnapshot snapshot;
      snapshot = await _getFromCache();
      return snapshot ?? await _getFromServer(cacheManager);
    }
  }

  Future<DocumentSnapshot> _getFromServer(
      FirestoreCacheManager cacheManager) async {
    final snapshot = await get();
    if (!snapshot.metadata.isFromCache) {
      await cacheManager.updateLastRefreshedAt(this);
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
