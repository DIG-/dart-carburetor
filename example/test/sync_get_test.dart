import 'package:example/example.dart';
import 'package:carburetor/exceptions.dart';
import 'package:test/test.dart';

void main() {
  group('Sync get', () {
    test('get<SampleClass>() is SampleClass', () {
      final instance = SampleModule.instance.get<SampleClass>();
      expect(instance, isA<SampleClass>());
    });
    test('get<SampleSingletonClass>() is SampleSingletonClass', () {
      final instance = SampleModule.instance.get<SampleSingletonClass>();
      expect(instance, isA<SampleSingletonClass>());
    });
    test('get<SampleSingletonNonLazyClass>() is SampleSingletonNonLazyClass', () {
      final instance = SampleModule.instance.get<SampleSingletonNonLazyClass>();
      expect(instance, isA<SampleSingletonNonLazyClass>());
    });
    test('get<SampleSingletonWeakClass>() is SampleSingletonWeakClass', () {
      final instance = SampleModule.instance.get<SampleSingletonWeakClass>();
      expect(instance, isA<SampleSingletonWeakClass>());
    });
  });

  group('Async get from sync', () {
    test('get<SampleAsyncClass>() will throw CarburetorProviderIsAsyncException', () {
      expect(() => SampleModule.instance.get<SampleAsyncClass>(), throwsA(isA<CarburetorProviderIsAsyncException>()));
    });
    test('get<SampleAsyncSingletonClass>() will throw CarburetorProviderIsAsyncException', () {
      expect(
        () => SampleModule.instance.get<SampleAsyncSingletonClass>(),
        throwsA(isA<CarburetorProviderIsAsyncException>()),
      );
    });
    test('get<SampleAsyncSingletonNonLazyClass>() will throw CarburetorProviderIsAsyncException', () {
      expect(
        () => SampleModule.instance.get<SampleAsyncSingletonNonLazyClass>(),
        throwsA(isA<CarburetorProviderIsAsyncException>()),
      );
    });
    test('get<SampleAsyncSingletonWeakClass>() will throw CarburetorProviderIsAsyncException', () {
      expect(
        () => SampleModule.instance.get<SampleAsyncSingletonWeakClass>(),
        throwsA(isA<CarburetorProviderIsAsyncException>()),
      );
    });
  });
}
