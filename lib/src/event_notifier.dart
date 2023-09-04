import 'dart:async';

import 'package:meta/meta.dart';

/// Adds the [events] stream to the class so that other objects can
/// observe and react to changes in its instances. Use the protected [notify]
/// method to post an event to the [events] stream.
///
/// The notifier should be disposed of via the [dispose] method
/// once it is no longer needed.
mixin EventNotifier<E> {
  final _controller = StreamController<E>.broadcast();

  /// Stream of events that happen inside this instance. Can be listened to
  /// multiple times. The listeners are called asynchronously,
  /// so the notifier's state might be different when read inside the listener
  /// callback than at the time of posting the event.
  Stream<E> get events => _controller.stream;

  /// Use this method to notify listeners of an event. The posted event will
  /// appear asynchronously in the [events] stream.
  @protected
  @nonVirtual
  void notify(E event) {
    assert(
      !_controller.isClosed,
      'The EventNotifier has already been disposed. '
      'You cannot call `notify` on this instance anymore.',
    );
    _controller.add(event);
  }

  /// Disposes of the notifier and frees its resources. This ends
  /// the [events] stream. [notify] cannot be called anymore once this method
  /// is called.
  @mustCallSuper
  Future<void> dispose() {
    return _controller.close();
  }
}
