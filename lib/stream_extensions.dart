import 'dart:async';

// Global map to hold subscriptions keyed by Stream and key
final Map<Stream<dynamic>, Map<String, StreamSubscription<dynamic>>> _subscriptions = {};

/// Extension to add key-based listeners to streams
extension StreamWithKeyExtension<T> on Stream<T> {
  /// Method to listen to a stream with a key
  ///
  /// This method allows you to listen to a stream and associate the listener with a key.
  /// If a listener with the same key already exists, it will be canceled and replaced.
  ///
  /// Parameters:
  ///   [key] - A unique key to identify the listener.
  ///   [onData] - A function to handle data events from the stream.
  ///   [onError] - An optional function to handle error events from the stream.
  ///   [onDone] - An optional function to handle the done event from the stream.
  ///   [cancelOnError] - An optional boolean to cancel the subscription on error.
  ///
  /// Returns:
  ///   A [StreamSubscription] object representing the subscription.
  StreamSubscription<T> listenWithKey({
    required String key,
    required void Function(T event) onData,
    Function? onError,
    void Function()? onDone,
    bool? cancelOnError,
  }) {
    // Ensure the stream has an entry in the global subscription map
    if (!_subscriptions.containsKey(this)) {
      _subscriptions[this] = {};
    }

    // If a subscription with the same key already exists, cancel it
    if (_subscriptions[this]!.containsKey(key)) {
      _subscriptions[this]![key]!.cancel();
      _subscriptions[this]!.remove(key);
    }

    // Create a new subscription
    final subscription = listen(
      onData,
      onError: onError,
      onDone: onDone,
      cancelOnError: cancelOnError,
    );

    // Store the subscription with the provided key
    _subscriptions[this]![key] = subscription;

    return subscription;
  }

  /// Method to cancel a specific listener by key
  ///
  /// This method cancels the listener associated with the given key.
  ///
  /// Parameters:
  ///   [key] - The unique key identifying the listener to cancel.
  void cancelListener({required String key}) {
    if (_subscriptions.containsKey(this) && _subscriptions[this]!.containsKey(key)) {
      _subscriptions[this]![key]!.cancel();
      _subscriptions[this]!.remove(key);
    }
  }

  /// Method to cancel all listeners for this stream
  ///
  /// This method cancels all listeners with keys associated with this stream.
  void cancelAllListenersWithKeys() {
    if (_subscriptions.containsKey(this)) {
      _subscriptions[this]!.forEach((key, subscription) {
        subscription.cancel();
      });
      _subscriptions[this]!.clear();
    }
  }
}
