import 'package:carburetor/carburetor.dart';
import 'package:example/src/example_base.carburetor.dart';

@Provide()
class SampleClass {
  final SampleChildClass child;

  const SampleClass(this.child);

  /// A method that does something.
  void doSomething() {
    // Implementation goes here.
  }
}

@Provide(singleton: true)
class SampleChildClass {
  const SampleChildClass();
}

@Module()
class SampleModule extends CarburetorModule with $SampleModuleImplementation {
  static final instance = SampleModule();
}
