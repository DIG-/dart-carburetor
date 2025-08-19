library;

import 'package:build/build.dart';
import 'package:carburetor_build/src/builder/info_extractor.dart';
import 'package:carburetor_build/src/builder/module_creator.dart';

export 'src/builder.dart';

Builder carburetorInfoExtractor(BuilderOptions options) {
  return InfoExtractorBuilder();
}

Builder carburetorModuleCreator(BuilderOptions options) {
  return ModuleCreatorBuilder(options: options);
}
