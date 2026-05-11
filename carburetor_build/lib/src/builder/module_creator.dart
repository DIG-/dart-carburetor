import 'dart:convert';

import 'package:analyzer/dart/element/element2.dart';
import 'package:build/build.dart';
import 'package:carburetor/carburetor.dart';
import 'package:carburetor_build/src/model/creator_context.dart';
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
    final context = CreatorContext.fromProviders(await _loadProviders(buildStep));
    output.writeln('// ignore_for_file: non_constant_identifier_names,unnecessary_constructor_name');
    output.writeln('import \'package:carburetor/carburetor.dart\';');
    for (final MapEntry(key: import, value: alias) in context.getPackageImportMapping().entries) {
      output
        ..write('import \'')
        ..write(import)
        ..write('\' as ')
        ..write(alias)
        ..writeln(';');
    }

    output
      ..write('mixin \$')
      ..write(element.displayName)
      ..writeln('Implementation on CarburetorModule {');

    for (final provider in context.getProviders()) {
      _generateGetter(output: output, context: context, provider: provider);
    }

    output.writeln('@override');
    output.writeln('T get<T extends Object>() {');
    output.writeln('return switch (T) {');
    for (final provider in context.getProviders()) {
      output
        ..writeClassName(context: context, clazz: provider.clazz)
        ..writeln(' _ => ')
        ..writeClassGetterName(context: context, clazz: provider.clazz)
        ..writeln('() as T,');
    }
    output.writeln('_ => throw Exception(\'No provider found for type \$T\'),');
    output.writeln('};');
    output.writeln('}');

    output.writeln('}');

    return output.toString();
  }

  void _generateGetter({required StringBuffer output, required CreatorContext context, required ProvideInfo provider}) {
    if (provider.provide.singleton) {
      if (provider.provide.weak) {
        return _generateGetterForSingletonWeak(output: output, context: context, provider: provider);
      }
      if (provider.provide.lazy) {
        return _generateGetterForSingletonLazy(output: output, context: context, provider: provider);
      }
      return _generateGetterForSingleton(output: output, context: context, provider: provider);
    }
    return _generateGetterForInstance(output: output, context: context, provider: provider);
  }

  void _generateGetterForSingletonWeak({
    required StringBuffer output,
    required CreatorContext context,
    required ProvideInfo provider,
  }) {
    output
      ..write('WeakReference<')
      ..writeClassName(context: context, clazz: provider.clazz)
      ..write('>? ')
      ..writeClassInstanceName(context: context, clazz: provider.clazz)
      ..writeln(';');

    output
      ..writeClassName(context: context, clazz: provider.clazz)
      ..write(' ')
      ..writeClassGetterName(context: context, clazz: provider.clazz)
      ..writeln('() {');

    output
      ..write('var instance = ')
      ..writeClassInstanceName(context: context, clazz: provider.clazz)
      ..writeln('?.target;');

    output.writeln('if (instance != null) {');
    output.writeln('return instance!;');
    output.writeln('}');

    output
      ..write('instance = ')
      ..writeClassConstructor(context: context, provider: provider)
      ..writeln(';');

    output
      ..writeClassInstanceName(context: context, clazz: provider.clazz)
      ..writeln(' = WeakReference(instance);');

    output.writeln('return instance!;');

    output.writeln('}');
  }

  void _generateGetterForSingletonLazy({
    required StringBuffer output,
    required CreatorContext context,
    required ProvideInfo provider,
  }) {
    output
      ..writeClassName(context: context, clazz: provider.clazz)
      ..write('? ')
      ..writeClassInstanceName(context: context, clazz: provider.clazz)
      ..writeln(';');

    output
      ..writeClassName(context: context, clazz: provider.clazz)
      ..write(' ')
      ..writeClassGetterName(context: context, clazz: provider.clazz)
      ..writeln('() {');

    output
      ..writeClassInstanceName(context: context, clazz: provider.clazz)
      ..write(' ??= ')
      ..writeClassConstructor(context: context, provider: provider)
      ..writeln(';');

    output
      ..write('return ')
      ..writeClassInstanceName(context: context, clazz: provider.clazz)
      ..writeln('!;');

    output.writeln('}');
  }

  void _generateGetterForSingleton({
    required StringBuffer output,
    required CreatorContext context,
    required ProvideInfo provider,
  }) {
    output
      ..write('late final ')
      ..writeClassName(context: context, clazz: provider.clazz)
      ..write(' ')
      ..writeClassInstanceName(context: context, clazz: provider.clazz)
      ..write(' = ')
      ..writeClassConstructor(context: context, provider: provider)
      ..writeln(';');

    output
      ..writeClassName(context: context, clazz: provider.clazz)
      ..write(' ')
      ..writeClassGetterName(context: context, clazz: provider.clazz)
      ..writeln('() {');

    output
      ..write('return ')
      ..writeClassInstanceName(context: context, clazz: provider.clazz)
      ..writeln(';');

    output.writeln('}');
  }

  void _generateGetterForInstance({
    required StringBuffer output,
    required CreatorContext context,
    required ProvideInfo provider,
  }) {
    output
      ..writeClassName(context: context, clazz: provider.clazz)
      ..write(' ')
      ..writeClassGetterName(context: context, clazz: provider.clazz)
      ..writeln('() {');

    output
      ..write('return ')
      ..writeClassConstructor(context: context, provider: provider)
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

extension on StringSink {
  void writeClassName({required CreatorContext context, required ProvideClass clazz}) {
    write(context.getPackageAlias(clazz: clazz));
    write('.');
    write(clazz.name);
  }

  void writeClassGetterName({required CreatorContext context, required ProvideClass clazz}) {
    write('_get_');
    write(context.getPackageAlias(clazz: clazz));
    write('_');
    write(clazz.name);
  }

  void writeClassInstanceName({required CreatorContext context, required ProvideClass clazz}) {
    write('_instance_');
    write(context.getPackageAlias(clazz: clazz));
    write('_');
    write(clazz.name);
  }

  void writeClassConstructor({required CreatorContext context, required ProvideInfo provider}) {
    writeClassName(context: context, clazz: provider.clazz);
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
      writeClassGetterName(context: context, clazz: parameter.type);
      write('()');
    }
    writeln(')');
  }
}
