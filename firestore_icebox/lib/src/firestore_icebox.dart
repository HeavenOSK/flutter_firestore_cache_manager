const _defaultExpiration = const Duration();

class FirestoreIcebox {
  FirestoreIcebox._();

  static final FirestoreIcebox instance = FirestoreIcebox._();

  Duration _cacheExpiration = _defaultExpiration;
  Duration get cacheExpiration => _cacheExpiration;

  void setCacheExpiration(Duration expiration) {
    _cacheExpiration = expiration;
  }
}
