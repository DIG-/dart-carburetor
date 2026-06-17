import 'package:carburetor/module.dart';
import 'package:carburetor/provide.dart';
import 'package:example/src/example_base.carburetor.dart';

@Provide()
class SampleClass {
  final SampleSingletonClass child;
  final DummyClass dummy;
  const SampleClass(this.child, this.dummy);

  @FactoryMethod()
  factory SampleClass.customFactory(SampleSingletonClass child) {
    return SampleClass(child, const DummyClass());
  }
}

@Singleton()
class SampleSingletonClass {
  const SampleSingletonClass();
}

@Singleton(lazy: false)
class SampleSingletonNonLazyClass {
  const SampleSingletonNonLazyClass();
}

@Singleton(weak: true)
class SampleSingletonWeakClass {
  const SampleSingletonWeakClass();
}

@Provide.async()
class SampleAsyncClass {
  final SampleSingletonClass child;
  final SampleAsyncSingletonClass child2;
  const SampleAsyncClass(this.child, {required this.child2});
}

@Singleton.async()
class SampleAsyncSingletonClass {
  const SampleAsyncSingletonClass();
}

@Singleton.async(lazy: false)
class SampleAsyncSingletonNonLazyClass {
  const SampleAsyncSingletonNonLazyClass();
}

@Singleton.async(weak: true)
class SampleAsyncSingletonWeakClass {
  const SampleAsyncSingletonWeakClass();
}

class DummyClass {
  const DummyClass();
}

@Module()
class SampleModule extends CarburetorModule with $SampleModuleImplementation {
  static final instance = SampleModule();
}
