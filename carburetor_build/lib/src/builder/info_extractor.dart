import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/constant/value.dart';
import 'package:build/build.dart';
import 'package:carburetor/provide.dart';
import 'package:carburetor_build/src/analyzer_proxy.dart';
import 'package:carburetor_build/src/model/json.dart';
import 'package:carburetor_build/src/model/provide.dart';
import 'package:source_gen/source_gen.dart';

class InfoExtractorBuilder extends Builder {
  InfoExtractorBuilder({required this.options});

  static const _kProvideChecker = TypeChecker.typeNamed(CarburetorProvide);
  static const _kFactoryChecker = TypeChecker.typeNamed(CarburetorFactoryMethod);

  final BuilderOptions options;

  late final bool shouldCheckStaticMethodsForFactory = options.config['checkStaticMethodsForFactory'] ?? false;

  @override
  final Map<String, List<String>> buildExtensions = const {
    '.dart': ['.carburetor-info.json'],
  };

  @override
  Future<void> build(BuildStep buildStep) async {
    final resolver = buildStep.resolver;
    if (!await resolver.isLibrary(buildStep.inputId)) return;
    final library = await resolver.libraryFor(buildStep.inputId);
    final output = await _generateForLibrary(LibraryReader(library), buildStep).toList();
    if (output.isNotEmpty) {
      final outputId = buildStep.allowedOutputs.first;
      await buildStep.writeAsString(outputId, jsonEncode(output));
    }
  }

  Stream<Json> _generateForLibrary(LibraryReader library, BuildStep buildStep) async* {
    final generator = library
        .annotatedWith(_kProvideChecker)
        .map((e) => _generateForAnnotatedElement(library, e.element, e.annotation, buildStep))
        .toList(growable: false);
    for (final task in generator) {
      final info = await task;
      if (info != null) {
        yield info;
      }
    }
  }

  Future<Json?> _generateForAnnotatedElement(
    LibraryReader library,
    ProxyElement element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ProxyClassElement) {
      throw Exception('Annotated element is not a class ($element)');
    }
    final constructor = extractConstructor(element);
    final ann = annotation.objectValue;
    return ProvideInfo(
      provide: CarburetorProvide(
        singleton: ann.getInheritedField('singleton')?.toBoolValue() ?? false,
        lazy: ann.getInheritedField('lazy')?.toBoolValue() ?? false,
        weak: ann.getInheritedField('weak')?.toBoolValue() ?? false,
        async: ann.getInheritedField('async')?.toBoolValue() ?? false,
      ),
      clazz: ProvideClass(name: element.nameProxy!, uri: element.libraryProxy!.uri),
      constructor: ProvideConstructor(
        name: constructor.nameProxy!,
        parameters:
            constructor.formalParameters.map((p) {
              return ProvideConstructorParameter(
                name: p.isNamed ? p.nameProxy : null,
                type: ProvideClass(
                  name: p.type.elementProxy!.nameProxy!,
                  uri: p.type.elementProxy!.libraryProxy!.uri, //
                ),
              );
            }).toList(),
      ),
    ).toJson();
  }

  ProxyExecutableElement extractConstructor(ProxyClassElement clazz) {
    if (shouldCheckStaticMethodsForFactory) {
      final fromStatic = clazz.methods.where((m) => m.isStatic && _kFactoryChecker.hasAnnotationOf(m)).firstOrNull;
      if (fromStatic != null) {
        if (fromStatic.returnType != clazz.thisType) {
          throw Exception(
            'Factory method for ${clazz.nameProxy} must return the same type as the class. But ${fromStatic.returnType} was found.',
          );
        }
        return fromStatic;
      }
    }
    final fromConstructor = clazz.constructorsProxy.where((c) => _kFactoryChecker.hasAnnotationOf(c)).firstOrNull;
    if (fromConstructor != null) {
      return fromConstructor;
    }
    return clazz.constructorsProxy.where((c) => c.isDefaultConstructor).firstOrNull ?? clazz.constructorsProxy.first;
  }
}

extension on DartObject {
  DartObject? getInheritedField(String name) {
    DartObject? parent = this;
    DartObject? value = getField(name);
    while (value == null && parent != null) {
      value = parent.getField(name);
      if (value == null) {
        parent = parent.getField('(super)');
      }
    }
    return value;
  }
}
