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
      output.writeln('import \'package:carburetor/carburetor.dart\';');
      for (final provider in providers) {
        if (imports.contains(provider.clazz.uri)) {
          continue;
        }
        imports.add(provider.clazz.uri);
        final mapping = packageMapping[provider.clazz];
        output.writeln('import \'${provider.clazz.uri}\' as $mapping;');
      }
    }
    output.writeln('mixin ${_generateModuleClassName(element)}Module on CarburetorModule {');
    for (final provider in providers) {
      final className = _genClassName(mapping: packageMapping, clazz: provider.clazz);
      final getterName = _genClassGetterName(mapping: packageMapping, clazz: provider.clazz);
      output.writeln('$className $getterName() => throw UnimplementedError(\'Not implemented yet\');');
    }
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
