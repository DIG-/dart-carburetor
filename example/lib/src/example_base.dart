import 'package:carburetor/carburetor.dart';
import 'package:carburetor/provide.dart';
import 'package:example/src/example_base.carburetor.dart';

@Provide()
class SampleClass {
  final SampleSingletonClass child;
  const SampleClass(this.child);
}

@Provide(singleton: true)
class SampleSingletonClass {
  const SampleSingletonClass();
}

@Provide(singleton: true, lazy: false)
class SampleSingletonNonLazyClass {
  const SampleSingletonNonLazyClass();
}

@Provide(singleton: true, weak: true)
class SampleSingletonWeakClass {
  const SampleSingletonWeakClass();
}

@Provide(async: true)
class SampleAsyncClass {
  final SampleSingletonClass child;
  final SampleAsyncSingletonClass child2;
  const SampleAsyncClass(this.child, {required this.child2});
}

@Provide(async: true, singleton: true)
class SampleAsyncSingletonClass {
  const SampleAsyncSingletonClass();
}

@Provide(async: true, singleton: true, lazy: false)
class SampleAsyncSingletonNonLazyClass {
  const SampleAsyncSingletonNonLazyClass();
}

@Provide(async: true, singleton: true, weak: true)
class SampleAsyncSingletonWeakClass {
  const SampleAsyncSingletonWeakClass();
}

@Module()
class SampleModule extends CarburetorModule with $SampleModuleImplementation {
  static final instance = SampleModule();
}
