/// Base exception class for all Carburetor-related errors.
///
/// All exceptions thrown by the Carburetor dependency injection framework
/// extend this class, allowing callers to catch them with a single handler.
class CarburetorException implements Exception {
  /// A human-readable message describing the error.
  final String message;

  /// Creates a [CarburetorException] with the given [message].
  const CarburetorException(this.message);

  @override
  String toString() => 'CarburetorException: $message';
}

/// Exception thrown when a synchronous provider accessor is called on a
/// provider that was registered as asynchronous.
///
/// Use [CarburetorModule.getAsync] instead of [CarburetorModule.get] to
/// resolve dependencies that are declared with `async: true`.
class CarburetorProviderIsAsyncException extends CarburetorException {
  /// Creates a [CarburetorProviderIsAsyncException] with the given [message].
  const CarburetorProviderIsAsyncException(super.message);
}
