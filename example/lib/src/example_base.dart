import 'package:carburetor/carburetor.dart';

@Provide()
class SampleClass {
  /// A method that does something.
  void doSomething() {
    // Implementation goes here.
  }
}

@Module()
class SampleModule implements CarburetorModule {}
