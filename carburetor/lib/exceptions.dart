class CarburetorException implements Exception {
  final String message;
  const CarburetorException(this.message);

  @override
  String toString() => 'CarburetorException: $message';
}

class CarburetorProviderIsAsyncException extends CarburetorException {
  const CarburetorProviderIsAsyncException(super.message);
}
