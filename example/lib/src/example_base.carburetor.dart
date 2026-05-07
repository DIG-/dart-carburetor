// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// ModuleCreatorGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names,unnecessary_constructor_name
import 'package:carburetor/carburetor.dart';
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

  @override
  T get<T extends Object>() {
    return switch (T) {
      aa.SampleClass _ => _get_aa_SampleClass() as T,
      aa.SampleChildClass _ => _get_aa_SampleChildClass() as T,
      _ => throw Exception('No provider found for type $T'),
    };
  }
}
