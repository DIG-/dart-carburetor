import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element2.dart';
import 'package:build/build.dart';
import 'package:carburetor/provide.dart';
import 'package:carburetor_build/src/model/json.dart';
import 'package:carburetor_build/src/model/provide.dart';
import 'package:source_gen/source_gen.dart';

class InfoExtractorBuilder extends Builder {
  InfoExtractorBuilder();

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
        .annotatedWith(TypeChecker.typeNamed(Provide))
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
    Element2 element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    if (element is! ClassElement2) {
      throw Exception('Annotated element is not a class ($element)');
    }
    final constructor =
        element.constructors2.where((c) => c.isDefaultConstructor).firstOrNull ?? element.constructors2.first;

    final ann = annotation.objectValue;
    return ProvideInfo(
      provide: Provide(
        singleton: ann.getField('singleton')?.toBoolValue() ?? false,
        lazy: ann.getField('lazy')?.toBoolValue() ?? false,
        weak: ann.getField('weak')?.toBoolValue() ?? false,
        async: ann.getField('async')?.toBoolValue() ?? false,
      ),
      clazz: ProvideClass(name: element.name3!, uri: element.library2.uri),
      constructor: ProvideConstructor(
        name: constructor.name3!,
        parameters:
            constructor.formalParameters.map((p) {
              return ProvideConstructorParameter(
                name: p.isNamed ? p.name3 : null,
                type: ProvideClass(
                  name: p.type.element3!.name3!,
                  uri: p.type.element3!.library2!.uri, //
                ),
              );
            }).toList(),
      ),
    ).toJson();
  }
}
