import 'package:carburetor_build/src/provide.dart';
import 'package:source_gen/source_gen.dart';

class CarburetorBuilder extends LibraryBuilder {
  CarburetorBuilder() : super(CarburetorProvider(), generatedExtension: '.carburetor.dart');
}
