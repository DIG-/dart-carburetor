import 'package:example/example.dart';
import 'package:test/test.dart';

void main() {
  group('Sync Check', () {
    test('SampleClass must be different each call', () {
      final a = SampleModule.instance.get<SampleClass>();
      final b = SampleModule.instance.get<SampleClass>();
      expect(a, isNot(same(b)));
    });
    test('SampleSingletonClass must be the same each call', () {
      final a = SampleModule.instance.get<SampleSingletonClass>();
      final b = SampleModule.instance.get<SampleSingletonClass>();
      expect(a, same(b));
    });
    test('SampleSingletonNonLazyClass must be the same each call', () {
      final a = SampleModule.instance.get<SampleSingletonNonLazyClass>();
      final b = SampleModule.instance.get<SampleSingletonNonLazyClass>();
      expect(a, same(b));
    });
    test('SampleSingletonWeakClass must be the same each call', () {
      final a = SampleModule.instance.get<SampleSingletonWeakClass>();
      final b = SampleModule.instance.get<SampleSingletonWeakClass>();
      expect(a, same(b));
    });
  });

  group('Async Check', () {
    test('SampleClass must be different each call', () async {
      final a = SampleModule.instance.get<SampleClass>();
      final b = await SampleModule.instance.getAsync<SampleClass>();
      expect(a, isNot(same(b)));
    });
    test('SampleAsyncClass must be different each call', () async {
      final a = await SampleModule.instance.getAsync<SampleAsyncClass>();
      final b = await SampleModule.instance.getAsync<SampleAsyncClass>();
      expect(a, isNot(same(b)));
    });
    test('SampleSingletonClass must be the same each call', () async {
      final a = SampleModule.instance.get<SampleSingletonClass>();
      final b = await SampleModule.instance.getAsync<SampleSingletonClass>();
      expect(a, same(b));
    });
    test('SampleAsyncSingletonClass must be the same each call', () async {
      final a = await SampleModule.instance.getAsync<SampleAsyncSingletonClass>();
      final b = await SampleModule.instance.getAsync<SampleAsyncSingletonClass>();
      expect(a, same(b));
    });
    test('SampleSingletonNonLazyClass must be the same each call', () async {
      final a = SampleModule.instance.get<SampleSingletonNonLazyClass>();
      final b = await SampleModule.instance.getAsync<SampleSingletonNonLazyClass>();
      expect(a, same(b));
    });
    test('SampleAsyncSingletonNonLazyClass must be the same each call', () async {
      final a = await SampleModule.instance.getAsync<SampleAsyncSingletonNonLazyClass>();
      final b = await SampleModule.instance.getAsync<SampleAsyncSingletonNonLazyClass>();
      expect(a, same(b));
    });
    test('SampleSingletonWeakClass must be the same each call', () async {
      final a = SampleModule.instance.get<SampleSingletonWeakClass>();
      final b = await SampleModule.instance.getAsync<SampleSingletonWeakClass>();
      expect(a, same(b));
    });
    test('SampleAsyncSingletonWeakClass must be the same each call', () async {
      final a = await SampleModule.instance.getAsync<SampleAsyncSingletonWeakClass>();
      final b = await SampleModule.instance.getAsync<SampleAsyncSingletonWeakClass>();
      expect(a, same(b));
    });
  });
}
