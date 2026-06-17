import 'package:example/example.dart';
import 'package:test/test.dart';

void main() {
  group('Async get sync instances', () {
    test('getAsync<SampleClass>() is SampleClass', () async {
      final instance = await SampleModule.instance.getAsync<SampleClass>();
      expect(instance, isA<SampleClass>());
    });
    test('getAsync<SampleSingletonClass>() is SampleSingletonClass', () async {
      final instance = await SampleModule.instance.getAsync<SampleSingletonClass>();
      expect(instance, isA<SampleSingletonClass>());
    });
    test('getAsync<SampleSingletonNonLazyClass>() is SampleSingletonNonLazyClass', () async {
      final instance = await SampleModule.instance.getAsync<SampleSingletonNonLazyClass>();
      expect(instance, isA<SampleSingletonNonLazyClass>());
    });
    test('getAsync<SampleSingletonWeakClass>() is SampleSingletonWeakClass', () async {
      final instance = await SampleModule.instance.getAsync<SampleSingletonWeakClass>();
      expect(instance, isA<SampleSingletonWeakClass>());
    });
  });

  group('Async get', () {
    test('getAsync<SampleAsyncClass>() is SampleAsyncClass', () async {
      final instance = await SampleModule.instance.getAsync<SampleAsyncClass>();
      expect(instance, isA<SampleAsyncClass>());
    });
    test('getAsync<SampleAsyncSingletonClass>() is SampleAsyncSingletonClass', () async {
      final instance = await SampleModule.instance.getAsync<SampleAsyncSingletonClass>();
      expect(instance, isA<SampleAsyncSingletonClass>());
    });
    test('getAsync<SampleAsyncSingletonNonLazyClass>() is SampleAsyncSingletonNonLazyClass', () async {
      final instance = await SampleModule.instance.getAsync<SampleAsyncSingletonNonLazyClass>();
      expect(instance, isA<SampleAsyncSingletonNonLazyClass>());
    });
    test('getAsync<SampleAsyncSingletonWeakClass>() is SampleAsyncSingletonWeakClass', () async {
      final instance = await SampleModule.instance.getAsync<SampleAsyncSingletonWeakClass>();
      expect(instance, isA<SampleAsyncSingletonWeakClass>());
    });
  });
}
