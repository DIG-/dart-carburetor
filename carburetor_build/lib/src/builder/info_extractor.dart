import 'dart:async';
import 'dart:convert';

import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:carburetor/carburetor.dart';
import 'package:carburetor_build/src/model/json.dart';
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
    Element element,
    ConstantReader annotation,
    BuildStep buildStep,
  ) async {
    log.info('Processing element: $element with annotation: $annotation');
    return null;
  }
}
