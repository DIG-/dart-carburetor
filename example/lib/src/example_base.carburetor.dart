// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ModuleCreatorGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names,unnecessary_constructor_name,type_literal_in_constant_pattern
import 'package:carburetor/exceptions.dart';
import 'package:carburetor/module.dart';
import 'package:example/src/example_base.dart' as aa;

mixin $SampleModuleImplementation on CarburetorModule {
  aa.SampleClass _get_aa_SampleClass() {
    return aa.SampleClass.new(_get_aa_SampleSingletonClass());
  }

  aa.SampleSingletonClass? _instance_aa_SampleSingletonClass;
  aa.SampleSingletonClass _get_aa_SampleSingletonClass() {
    _instance_aa_SampleSingletonClass ??= aa.SampleSingletonClass.new();
    return _instance_aa_SampleSingletonClass!;
  }

  late final aa.SampleSingletonNonLazyClass
  _instance_aa_SampleSingletonNonLazyClass =
      aa.SampleSingletonNonLazyClass.new();
  aa.SampleSingletonNonLazyClass _get_aa_SampleSingletonNonLazyClass() {
    return _instance_aa_SampleSingletonNonLazyClass;
  }

  WeakReference<aa.SampleSingletonWeakClass>?
  _instance_aa_SampleSingletonWeakClass;
  aa.SampleSingletonWeakClass _get_aa_SampleSingletonWeakClass() {
    var instance = _instance_aa_SampleSingletonWeakClass?.target;
    if (instance != null) {
      return instance;
    }
    instance = aa.SampleSingletonWeakClass.new();
    _instance_aa_SampleSingletonWeakClass = WeakReference(instance);
    return instance;
  }

  Future<aa.SampleAsyncClass> _get_aa_SampleAsyncClass() async {
    return aa.SampleAsyncClass.new(
      _get_aa_SampleSingletonClass(),
      child2: await _get_aa_SampleAsyncSingletonClass(),
    );
  }

  aa.SampleAsyncSingletonClass? _instance_aa_SampleAsyncSingletonClass;
  Future<aa.SampleAsyncSingletonClass>?
  _instance_aa_SampleAsyncSingletonClass_creator;
  Future<aa.SampleAsyncSingletonClass>
  _get_aa_SampleAsyncSingletonClass() async {
    if (_instance_aa_SampleAsyncSingletonClass != null) {
      return _instance_aa_SampleAsyncSingletonClass!;
    }
    _instance_aa_SampleAsyncSingletonClass_creator ??= Future(
      () async => aa.SampleAsyncSingletonClass.new(),
    ).then((value) {
      _instance_aa_SampleAsyncSingletonClass = value;
      _instance_aa_SampleAsyncSingletonClass_creator = null;
      return value;
    });
    return _instance_aa_SampleAsyncSingletonClass_creator!;
  }

  late final Future<aa.SampleAsyncSingletonNonLazyClass>
  _instance_aa_SampleAsyncSingletonNonLazyClass_creator = Future(
    () async => aa.SampleAsyncSingletonNonLazyClass.new(),
  ).then((value) {
    _instance_aa_SampleAsyncSingletonNonLazyClass = value;
    return value;
  });
  aa.SampleAsyncSingletonNonLazyClass?
  _instance_aa_SampleAsyncSingletonNonLazyClass;
  Future<aa.SampleAsyncSingletonNonLazyClass>
  _get_aa_SampleAsyncSingletonNonLazyClass() async {
    if (_instance_aa_SampleAsyncSingletonNonLazyClass != null) {
      return _instance_aa_SampleAsyncSingletonNonLazyClass!;
    }
    return _instance_aa_SampleAsyncSingletonNonLazyClass_creator;
  }

  WeakReference<aa.SampleAsyncSingletonWeakClass>?
  _instance_aa_SampleAsyncSingletonWeakClass;
  Future<aa.SampleAsyncSingletonWeakClass>?
  _instance_aa_SampleAsyncSingletonWeakClass_creator;
  Future<aa.SampleAsyncSingletonWeakClass>
  _get_aa_SampleAsyncSingletonWeakClass() async {
    final instance = _instance_aa_SampleAsyncSingletonWeakClass?.target;
    if (instance != null) {
      return instance;
    }
    _instance_aa_SampleAsyncSingletonWeakClass_creator ??= Future(
      () async => aa.SampleAsyncSingletonWeakClass.new(),
    ).then((value) {
      _instance_aa_SampleAsyncSingletonWeakClass = WeakReference(value);
      _instance_aa_SampleAsyncSingletonWeakClass_creator = null;
      return value;
    });
    return _instance_aa_SampleAsyncSingletonWeakClass_creator!;
  }

  @override
  T get<T extends Object>() {
    return switch (T) {
      aa.SampleClass => _get_aa_SampleClass() as T,
      aa.SampleSingletonClass => _get_aa_SampleSingletonClass() as T,
      aa.SampleSingletonNonLazyClass =>
        _get_aa_SampleSingletonNonLazyClass() as T,
      aa.SampleSingletonWeakClass => _get_aa_SampleSingletonWeakClass() as T,
      aa.SampleAsyncClass =>
        throw CarburetorProviderIsAsyncException(
          'SampleAsyncClass is async. Should use getAsync()',
        ),
      aa.SampleAsyncSingletonClass =>
        throw CarburetorProviderIsAsyncException(
          'SampleAsyncSingletonClass is async. Should use getAsync()',
        ),
      aa.SampleAsyncSingletonNonLazyClass =>
        throw CarburetorProviderIsAsyncException(
          'SampleAsyncSingletonNonLazyClass is async. Should use getAsync()',
        ),
      aa.SampleAsyncSingletonWeakClass =>
        throw CarburetorProviderIsAsyncException(
          'SampleAsyncSingletonWeakClass is async. Should use getAsync()',
        ),
      _ => throw CarburetorException('No provider found for type $T'),
    };
  }

  @override
  Future<T> getAsync<T extends Object>() async {
    return switch (T) {
      aa.SampleAsyncClass => (await _get_aa_SampleAsyncClass()) as T,
      aa.SampleAsyncSingletonClass =>
        (await _get_aa_SampleAsyncSingletonClass()) as T,
      aa.SampleAsyncSingletonNonLazyClass =>
        (await _get_aa_SampleAsyncSingletonNonLazyClass()) as T,
      aa.SampleAsyncSingletonWeakClass =>
        (await _get_aa_SampleAsyncSingletonWeakClass()) as T,
      _ => get<T>(),
    };
  }
}
