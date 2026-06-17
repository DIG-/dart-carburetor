import 'package:meta/meta_meta.dart';

/// Marks a constructor or factory method to be used for dependency instantiation
/// instead of the default constructor.
///
/// By default, Carburetor uses the default constructor to create instances of
/// annotated classes. Apply [CarburetorFactoryMethod] to a named constructor,
/// factory constructor, or static factory method to override this behavior.
///
/// All parameters required by the annotated constructor or method will be
/// automatically resolved and injected by Carburetor at build time.
///
/// Only one [CarburetorFactoryMethod] annotation may be applied per class.
/// If multiple constructors or methods are annotated, the build will fail.
@Target({TargetKind.constructor, TargetKind.method})
class CarburetorFactoryMethod {
  /// Creates a [CarburetorFactoryMethod] annotation.
  const CarburetorFactoryMethod();
}
