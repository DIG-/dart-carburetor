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
      ..write(element.displayName)
      ..writeln('Implementation on CarburetorModule {');

    for (final provider in providers) {
      _generateGetter(output: output, mapping: packageMapping, providers: providers, provider: provider);
    }

    output.writeln('@override');
    output.writeln('T get<T>() {');
    output.writeln('return switch (T) {');
    for (final provider in providers) {
      output
        ..writeClassName(mapping: packageMapping, clazz: provider.clazz)
        ..writeln(' _ => ')
        ..writeClassGetterName(mapping: packageMapping, clazz: provider.clazz)
        ..writeln('() as T,');
    }
    output.writeln('_ => throw Exception(\'No provider found for type \$T\'),');
    output.writeln('};');
    output.writeln('}');

    output.writeln('}');

    return output.toString();
  }

  void _generateGetter({
    required StringBuffer output,
    required PackageImportMapping mapping,
    required List<ProvideInfo> providers,
    required ProvideInfo provider,
  }) {
    if (provider.provide.singleton) {
      if (provider.provide.lazy) {
        return _generateGetterForSingletonLazy(
          output: output,
          mapping: mapping,
          providers: providers,
          provider: provider,
        );
      }
      return _generateGetterForSingleton(output: output, mapping: mapping, providers: providers, provider: provider);
    }
    return _generateGetterForInstance(output: output, mapping: mapping, providers: providers, provider: provider);
  }

  void _generateGetterForSingletonLazy({
    required StringBuffer output,
    required PackageImportMapping mapping,
    required List<ProvideInfo> providers,
    required ProvideInfo provider,
  }) {
    output
      ..writeClassName(mapping: mapping, clazz: provider.clazz)
      ..write('? ')
      ..writeClassInstanceName(mapping: mapping, clazz: provider.clazz)
      ..writeln(';');

    output
      ..writeClassName(mapping: mapping, clazz: provider.clazz)
      ..write(' ')
      ..writeClassGetterName(mapping: mapping, clazz: provider.clazz)
      ..writeln('() {');

    output
      ..writeClassInstanceName(mapping: mapping, clazz: provider.clazz)
      ..write(' ??= ')
      ..writeClassConstructor(mapping: mapping, providers: providers, provider: provider)
      ..writeln(';');

    output
      ..write('return ')
      ..writeClassInstanceName(mapping: mapping, clazz: provider.clazz)
      ..writeln('!;');

    output.writeln('}');
  }

  void _generateGetterForSingleton({
    required StringBuffer output,
    required PackageImportMapping mapping,
    required List<ProvideInfo> providers,
    required ProvideInfo provider,
  }) {
    output
      ..write('late final ')
      ..writeClassName(mapping: mapping, clazz: provider.clazz)
      ..write(' ')
      ..writeClassInstanceName(mapping: mapping, clazz: provider.clazz)
      ..write(' = ')
      ..writeClassConstructor(mapping: mapping, providers: providers, provider: provider)
      ..writeln(';');

    output
      ..writeClassName(mapping: mapping, clazz: provider.clazz)
      ..write(' ')
      ..writeClassGetterName(mapping: mapping, clazz: provider.clazz)
      ..writeln('() {');

    output
      ..write('return ')
      ..writeClassInstanceName(mapping: mapping, clazz: provider.clazz)
      ..writeln(';');

    output.writeln('}');
  }

  void _generateGetterForInstance({
    required StringBuffer output,
    required PackageImportMapping mapping,
    required List<ProvideInfo> providers,
    required ProvideInfo provider,
  }) {
    output
      ..writeClassName(mapping: mapping, clazz: provider.clazz)
      ..write(' ')
      ..writeClassGetterName(mapping: mapping, clazz: provider.clazz)
      ..writeln('() {');

    output
      ..write('return ')
      ..writeClassConstructor(mapping: mapping, providers: providers, provider: provider)
      ..writeln(';');

    output.writeln('}');
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

extension on StringSink {
  void writeClassName({required PackageImportMapping mapping, required ProvideClass clazz}) {
    write(mapping[clazz]);
    write('.');
    write(clazz.name);
  }

  void writeClassGetterName({required PackageImportMapping mapping, required ProvideClass clazz}) {
    write('_get_');
    write(mapping[clazz]);
    write('_');
    write(clazz.name);
  }

  void writeClassInstanceName({required PackageImportMapping mapping, required ProvideClass clazz}) {
    write('_instance_');
    write(mapping[clazz]);
    write('_');
    write(clazz.name);
  }

  void writeClassConstructor({
    required PackageImportMapping mapping,
    required List<ProvideInfo> providers,
    required ProvideInfo provider,
  }) {
    writeClassName(mapping: mapping, clazz: provider.clazz);
    write('.');
    write(provider.constructor.name);
    writeln('(');
    var first = true;
    for (final parameter in provider.constructor.parameters) {
      if (first) {
        first = false;
      } else {
        write(',');
      }
      if (parameter.name != null) {
        write(parameter.name);
        write(': ');
      }
      writeClassGetterName(mapping: mapping, clazz: parameter.type);
      write('()');
    }
    writeln(')');
  }
}
