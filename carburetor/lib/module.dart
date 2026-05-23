import 'package:meta/meta_meta.dart';

/// Annotation that marks a class as a Carburetor dependency injection module.
///
/// Apply this annotation to a class that serves as a module in the Carburetor
/// framework. The build system will generate the corresponding implementation
/// based on the providers declared inside the annotated class.
///
/// Example:
/// ```dart
/// @Module()
/// class AppModule extends CarburetorModule with $AppModuleImplementation {
/// }
/// ```
@Target({TargetKind.classType})
class Module {
  /// Creates a [Module] annotation.
  const Module();
}

/// Abstract base class for all Carburetor-generated module implementations.
///
/// Carburetor generates a concrete subclass for every class annotated with
/// [Module]. Use [get] to resolve synchronous dependencies and [getAsync] to
/// resolve asynchronous ones.
abstract class CarburetorModule {
  /// Creates a [CarburetorModule].
  const CarburetorModule();

  /// Returns the dependency of type [T] from this module.
  ///
  /// Throws a [CarburetorProviderIsAsyncException] if the provider for [T]
  /// was registered as asynchronous. Use [getAsync] in that case.
  T get<T extends Object>();

  /// Returns the dependency of type [T] from this module asynchronously.
  Future<T> getAsync<T extends Object>();
}
