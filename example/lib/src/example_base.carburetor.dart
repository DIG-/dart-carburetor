// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ModuleCreatorGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names,unnecessary_constructor_name
import 'package:carburetor/carburetor.dart';
import 'package:carburetor/exception.dart';
import 'package:example/src/example_base.dart' as aa;

mixin $SampleModuleImplementation on CarburetorModule {
  aa.SampleClass _get_aa_SampleClass() {
    return aa.SampleClass.new(_get_aa_SampleChildClass());
  }

  aa.SampleChildClass? _instance_aa_SampleChildClass;
  aa.SampleChildClass _get_aa_SampleChildClass() {
    _instance_aa_SampleChildClass ??= aa.SampleChildClass.new();
    return _instance_aa_SampleChildClass!;
  }

  Future<aa.SampleAsyncClass> _get_aa_SampleAsyncClass() async {
    return aa.SampleAsyncClass.new();
  }

  @override
  T get<T extends Object>() {
    return switch (T) {
      aa.SampleClass _ => _get_aa_SampleClass() as T,
      aa.SampleChildClass _ => _get_aa_SampleChildClass() as T,
      aa.SampleAsyncClass _ =>
        throw CarburetorProviderIsAsyncException(
          'SampleAsyncClass is async. Should use getAsync()',
        ),
      _ => throw CarburetorException('No provider found for type $T'),
    };
  }

  @override
  Future<T> getAsync<T extends Object>() async {
    return switch (T) {
      aa.SampleAsyncClass _ => (await _get_aa_SampleAsyncClass()) as T,
      _ => get<T>(),
    };
  }
}
