import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:carburetor/carburetor.dart';
import 'package:source_gen/source_gen.dart';

class ModuleCreatorBuilder extends LibraryBuilder {
  ModuleCreatorBuilder({super.options}) : super(ModuleCreatorGenerator(), generatedExtension: '.carburetor.dart');
}

class ModuleCreatorGenerator extends GeneratorForAnnotation<Module> {
  const ModuleCreatorGenerator();

  @override
  Future<String?> generateForAnnotatedElement(Element2 element, ConstantReader annotation, BuildStep buildStep) async {
    return null;
  }
}
