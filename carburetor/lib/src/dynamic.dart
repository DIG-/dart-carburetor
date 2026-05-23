import 'package:carburetor/exceptions.dart';
import 'package:carburetor/module.dart';

part 'dynamic_impl.dart';

/// A [CarburetorModule] wrapper that facilitates incremental migration from a
/// runtime dependency injection system to Carburetor's build-time approach.
///
/// During migration, some dependencies may not yet be registered in a
/// Carburetor-generated module. [CarburetorDynamicModule] allows those
/// dependencies to be provided at runtime by calling [set], while all
/// already-migrated dependencies are resolved normally through the underlying
/// [module]. Once all dependencies have been migrated, this wrapper can be
/// removed and the generated module used directly.
///
/// This class is also useful in tests to override specific dependencies
/// without replacing the entire module.
///
/// Example:
/// ```dart
/// // During migration: override a dependency not yet handled by the module.
/// final dynamic = CarburetorDynamicModule(appModule);
/// dynamic.set<LegacyService>(legacyServiceInstance);
///
/// final service = dynamic.get<LegacyService>(); // returns legacyServiceInstance
/// final other   = dynamic.get<MigratedService>(); // resolved by appModule
/// ```
sealed class CarburetorDynamicModule<Module extends CarburetorModule> implements CarburetorModule {
  const CarburetorDynamicModule._();

  /// Wraps [module] in a [CarburetorDynamicModule] that delegates all
  /// non-overridden resolutions to [module].
  const factory CarburetorDynamicModule(Module module) = CarburetorDynamicModuleImpl;

  /// The underlying module that handles non-overridden dependency resolutions.
  Module get module;

  /// Returns the dependency of type [T], using the registered override when
  /// one exists, or falling back to [module].
  ///
  /// If [name] is provided and no override is registered for that name, a
  /// [CarburetorException] is thrown.
  @override
  T get<T extends Object>({String? name});

  /// Returns the dependency of type [T] asynchronously, using the registered
  /// override when one exists, or falling back to [module].
  ///
  /// If [name] is provided and no override is registered for that name, a
  /// [CarburetorException] is thrown.
  @override
  Future<T> getAsync<T extends Object>({String? name});

  /// Registers [value] as the override for type [T].
  ///
  /// Subsequent calls to [get] or [getAsync] for [T] (and the optional [name])
  /// will return [value] instead of delegating to [module].
  void set<T extends Object>(T value, {String? name});

  /// Removes the override for type [T] (and the optional [name]).
  ///
  /// After removal, calls to [get] or [getAsync] for [T] delegate to [module]
  /// again, or throw a [CarburetorException] if [module] cannot resolve it.
  void remove<T extends Object>({String? name});
}
