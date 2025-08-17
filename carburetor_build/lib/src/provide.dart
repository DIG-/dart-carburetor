import 'package:analyzer/dart/element/element.dart';
import 'package:build/build.dart';
import 'package:carburetor/carburetor.dart';
import 'package:source_gen/source_gen.dart';

class CarburetorProvider extends GeneratorForAnnotation<Provide> {
  @override
  dynamic generateForAnnotatedElement(Element2 element, ConstantReader annotation, BuildStep buildStep) {
    return super.generateForAnnotatedElement(element, annotation, buildStep);
  }
}
