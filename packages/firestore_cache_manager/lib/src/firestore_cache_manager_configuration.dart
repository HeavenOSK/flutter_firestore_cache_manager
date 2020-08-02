const _defaultExpiration = Duration();

class FirestoreCacheManagerConfiguration {
  FirestoreCacheManagerConfiguration._();

  static final FirestoreCacheManagerConfiguration instance =
      FirestoreCacheManagerConfiguration._();

  Duration _cacheExpiration = _defaultExpiration;
  Duration get cacheExpiration => _cacheExpiration;
  set cacheExpiration(Duration expiration) {
    if (expiration == null) {
      return;
    }
    _cacheExpiration = expiration;
  }
}
