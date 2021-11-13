library typed_event_notifier;

/// Class [TypedEventNotifier].
///
/// Allows notifying listeners with an object.
class TypedEventNotifier<T extends Object> {
  final List<dynamic> _listeners = <dynamic>[];

  /// Number of listeners.
  int get numberOfListeners => _listeners.length;

  /// Create [TypedEventNotifier] instance.
  TypedEventNotifier();

  /// Add listener.
  void addListener<L extends T>(void Function(L object) listener) {
    final bool isContains = _listeners.contains(listener);
    if (isContains == false) {
      _listeners.add(listener);
    }
    assert(isContains == false, 'try add already registered listener.');
  }

  /// Remove listener.
  void removeListener<L extends T>(void Function(L object) listener) {
    final bool isRemoved = _listeners.remove(listener);
    assert(isRemoved == true, 'try removing unregistered listener.');
  }

  /// Notify listeners.
  void notifyListeners<L extends T>(L object) {
    _listeners.forEach((dynamic listener) {
      if (listener is void Function(L object)) {
        listener(object);
      }
    });
  }
}

