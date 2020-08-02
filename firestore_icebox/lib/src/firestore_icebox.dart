const _defaultExpiration = Duration();

class FirestoreIcebox {
  FirestoreIcebox._();

  static final FirestoreIcebox instance = FirestoreIcebox._();

  Duration _cacheExpiration = _defaultExpiration;
  Duration get cacheExpiration => _cacheExpiration;
  set cacheExpiration(Duration expiration) {
    if (expiration == null) {
      return;
    }
    _cacheExpiration = expiration;
  }
}
