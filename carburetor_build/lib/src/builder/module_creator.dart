import 'dart:convert';

import 'package:analyzer/dart/element/element2.dart';
import 'package:build/build.dart';
import 'package:carburetor/carburetor.dart';
import 'package:carburetor_build/src/model/json.dart';
import 'package:carburetor_build/src/model/provide.dart';
import 'package:source_gen/source_gen.dart';

class ModuleCreatorBuilder extends LibraryBuilder {
  ModuleCreatorBuilder({super.options}) : super(ModuleCreatorGenerator(), generatedExtension: '.carburetor.dart');
}

class ModuleCreatorGenerator extends GeneratorForAnnotation<Module> {
  const ModuleCreatorGenerator();

  static List<ProvideInfo> _providers = [];

  @override
  Future<String?> generateForAnnotatedElement(Element2 element, ConstantReader annotation, BuildStep buildStep) async {
    final output = StringBuffer();
    final providers = await _loadProviders(buildStep);
    final packageMapping = PackageImportMapping();
    {
      final imports = <Uri>{};
      output.writeln('// ignore_for_file: non_constant_identifier_names,unnecessary_constructor_name');
      output.writeln('import \'package:carburetor/carburetor.dart\';');
      for (final provider in providers) {
        if (imports.contains(provider.clazz.uri)) {
          continue;
        }
        imports.add(provider.clazz.uri);
        final mapping = packageMapping[provider.clazz];
        output
          ..write('import \'')
          ..write(provider.clazz.uri)
          ..write('\' as ')
          ..write(mapping)
          ..writeln(';');
      }
    }

    output
      ..write('mixin ')
      ..write(_generateModuleClassName(element))
      ..writeln(' on CarburetorModule {');

    for (final provider in providers) {
      _generateGetter(output: output, mapping: packageMapping, providers: providers, provider: provider);
    }

    output.writeln('@override');
    output.writeln('T get<T>() {');
    output.writeln('return switch (T) {');
    for (final provider in providers) {
      final className = _genClassName(mapping: packageMapping, clazz: provider.clazz);
      output
        ..write(className)
        ..writeln(' _ => ')
        ..write(_genClassGetterName(mapping: packageMapping, clazz: provider.clazz))
        ..writeln('() as T,');
    }
    output.writeln('_ => throw Exception(\'No provider found for type \$T\'),');
    output.writeln('};');
    output.writeln('}');

    output.writeln('}');

    return output.toString();
  }

  String _generateModuleClassName(Element2 element) {
    return '${element.displayName}Implementation';
  }

  String _genClassName({required PackageImportMapping mapping, required ProvideClass clazz}) {
    return '${mapping[clazz]}.${clazz.name}';
  }

  String _genClassGetterName({required PackageImportMapping mapping, required ProvideClass clazz}) {
    return '_get_${mapping[clazz]}_${clazz.name}';
  }

  void _generateGetter({
    required StringBuffer output,
    required PackageImportMapping mapping,
    required List<ProvideInfo> providers,
    required ProvideInfo provider,
  }) {
    if (provider.provide.singleton) {
      return _generateGetterForSingleton(output: output, mapping: mapping, providers: providers, provider: provider);
    }
    return _generateGetterForInstance(output: output, mapping: mapping, providers: providers, provider: provider);
  }

  void _generateGetterForSingleton({
    required StringBuffer output,
    required PackageImportMapping mapping,
    required List<ProvideInfo> providers,
    required ProvideInfo provider,
  }) {
    final className = _genClassName(mapping: mapping, clazz: provider.clazz);
    final instanceName = '_instance_${mapping[provider.clazz]}_${provider.clazz.name}';
    final getterName = _genClassGetterName(mapping: mapping, clazz: provider.clazz);
    output
      ..write(className)
      ..write('? ')
      ..write(instanceName)
      ..writeln(';');

    output
      ..write(className)
      ..write(' ')
      ..write(getterName)
      ..writeln('() {');

    output
      ..write(instanceName)
      ..write(' ??= ');
    _generateConstructor(output: output, mapping: mapping, providers: providers, provider: provider);
    output.writeln(';');

    output
      ..write('return ')
      ..write(instanceName)
      ..writeln('!;');

    output.writeln('}');
  }

  void _generateGetterForInstance({
    required StringBuffer output,
    required PackageImportMapping mapping,
    required List<ProvideInfo> providers,
    required ProvideInfo provider,
  }) {
    output
      ..write(_genClassName(mapping: mapping, clazz: provider.clazz))
      ..write(' ')
      ..write(_genClassGetterName(mapping: mapping, clazz: provider.clazz))
      ..writeln('() {');

    output.write('return ');
    _generateConstructor(output: output, mapping: mapping, providers: providers, provider: provider);
    output.writeln(';');

    output.writeln('}');
  }

  void _generateConstructor({
    required StringBuffer output,
    required PackageImportMapping mapping,
    required List<ProvideInfo> providers,
    required ProvideInfo provider,
  }) {
    output.write(_genClassName(mapping: mapping, clazz: provider.clazz));
    output.write('.');
    output.write(provider.constructor.name);
    output.writeln('(');
    var first = true;
    for (final parameter in provider.constructor.parameters) {
      if (first) {
        first = false;
      } else {
        output.write(',');
      }
      if (parameter.name != null) {
        output.write(parameter.name);
        output.write(': ');
      }
      output.write(_genClassGetterName(mapping: mapping, clazz: parameter.type));
      output.write('()');
    }
    output.writeln(')');
  }

  Future<List<ProvideInfo>> _loadProviders(BuildStep buildStep) async {
    if (_providers.isNotEmpty) {
      return _providers;
    }
    final mergedJsonId = AssetId(buildStep.inputId.package, 'lib/src/carburetor.merged.json');
    if (!await buildStep.canRead(mergedJsonId)) {
      throw Exception(
        'Cannot read ${mergedJsonId.path}. Make sure that the InfoMergeBuilder has run and produced the merged JSON file.',
      );
    }
    final content = await buildStep.readAsString(mergedJsonId);
    final decoded = jsonDecode(content);
    if (decoded is! List) {
      throw Exception('Expected a list in ${mergedJsonId.path}, but got ${decoded.runtimeType}.');
    }
    _providers = decoded.cast<Json>().map(ProvideInfo.fromJson).toList(growable: false);
    return _providers;
  }
}

class PackageImportMapping {
  static const _kMappingValues = 'abcdefghijklmnopqrstuvwxyz';
  final Map<String, String> _mapping = {};

  PackageImportMapping();

  String operator [](Object it) => switch (it) {
    Uri packageName => _mapping.putIfAbsent(packageName.toString(), () => _hash(_mapping.length)),
    ProvideClass clazz => this[clazz.uri],
    ProvideInfo info => this[info.clazz.uri],

    _ => throw Exception('Unsupported key type: ${it.runtimeType}'),
  };

  static String _hash(int length) {
    if (length == 0) {
      return '${_kMappingValues[0]}${_kMappingValues[0]}';
    }
    final buffer = StringBuffer();
    while (length > 0) {
      final index = length % _kMappingValues.length;
      buffer.write(_kMappingValues[index]);
      length ~/= _kMappingValues.length;
    }
    if (buffer.length == 1) {
      return '${_kMappingValues[0]}${buffer.toString()}';
    }
    return buffer.toString();
  }
}
