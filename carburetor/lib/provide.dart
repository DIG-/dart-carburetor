import 'package:meta/meta_meta.dart';
import 'src/constructor.dart' show CarburetorFactoryMethod;

export 'src/constructor.dart' show CarburetorFactoryMethod;

/// Base annotation class for all Carburetor provider annotations.
///
/// Concrete subclasses such as [Provide], [ProvideAsync], [Singleton], and
/// [SingletonAsync] configure how the Carburetor build system creates and
/// manages the annotated dependency.
@Target({TargetKind.classType})
class CarburetorProvide {
  /// Whether the dependency is managed as a singleton.
  ///
  /// When `true`, Carburetor creates the instance once and reuses it for every
  /// subsequent resolution. Defaults to `false`.
  final bool singleton;

  /// Whether the singleton instance is created on first access rather than
  /// at module construction time.
  ///
  /// Only meaningful when [singleton] is `true`. Defaults to `true`.
  final bool lazy;

  /// Whether the singleton instance may be garbage-collected when no strong
  /// references to it remain.
  ///
  /// Only meaningful when [singleton] is `true` and [lazy] is `true`. Defaults to `false`.
  final bool weak;

  /// Whether the provider factory is asynchronous.
  ///
  /// When `true`, the dependency must be resolved through
  /// [CarburetorModule.getAsync]. Defaults to `false`.
  final bool async;

  /// Creates a [CarburetorProvide] annotation with the given options.
  const CarburetorProvide({this.singleton = false, this.lazy = true, this.weak = false, this.async = false});
}

/// Marks a class as a non-singleton, synchronous dependency.
///
/// A new instance is created every time the dependency is requested.
///
/// Example:
/// ```dart
/// @Provide()
/// class MyRepository { ... }
/// ```
class Provide extends CarburetorProvide {
  /// Creates a [Provide] annotation.
  const Provide() : super(singleton: false, lazy: false, weak: false, async: false);

  /// Creates an asynchronous, non-singleton provider.
  ///
  /// Equivalent to applying [ProvideAsync] directly.
  const factory Provide.async() = ProvideAsync;
}

/// Marks a class as a non-singleton, asynchronous dependency.
///
/// The dependency must be resolved through [CarburetorModule.getAsync].
class ProvideAsync extends CarburetorProvide implements Provide {
  /// Creates a [ProvideAsync] annotation.
  const ProvideAsync() : super(singleton: false, lazy: false, weak: false, async: true);
}

/// Marks a class as a singleton dependency.
///
/// By default the instance is created lazily on first access. Use
/// [Singleton.async] to declare an asynchronous singleton.
///
/// Example:
/// ```dart
/// @Singleton()
/// class MyService { ... }
///
/// @Singleton(lazy: false)
/// class EagerService { ... }
/// ```
class Singleton extends CarburetorProvide {
  /// Creates a [Singleton] annotation.
  ///
  /// - [lazy]: when `true` (the default) the instance is created on first
  ///   access; when `false` it is created at module construction time.
  /// - [weak]: when `true` the instance may be garbage-collected when no
  ///   strong references remain.
  const Singleton({super.lazy = true, super.weak = false}) : super(singleton: true, async: false);

  /// Creates an asynchronous singleton provider.
  ///
  /// Equivalent to applying [SingletonAsync] directly.
  const factory Singleton.async({bool lazy, bool weak}) = SingletonAsync;
}

/// Marks a class as an asynchronous singleton dependency.
///
/// The dependency must be resolved through [CarburetorModule.getAsync].
/// The instance is shared across all callers after the first resolution.
class SingletonAsync extends CarburetorProvide implements Singleton {
  /// Creates a [SingletonAsync] annotation.
  ///
  /// - [lazy]: when `true` (the default) the instance is created on first
  ///   access; when `false` it is created at module construction time.
  /// - [weak]: when `true` the instance may be garbage-collected when no
  ///   strong references remain.
  const SingletonAsync({super.lazy = true, super.weak = false}) : super(singleton: true, async: true);
}

typedef FactoryMethod = CarburetorFactoryMethod;
