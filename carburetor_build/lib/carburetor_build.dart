library;

import 'package:build/build.dart';
import 'package:carburetor_build/src/builder/info_extractor.dart';
import 'package:carburetor_build/src/builder/info_merge.dart';
import 'package:carburetor_build/src/builder/module_creator.dart';

Builder carburetorInfoExtractor(BuilderOptions options) {
  return InfoExtractorBuilder();
}

Builder carburetorInfoMerge(BuilderOptions options) {
  return InfoMergeBuilder();
}

Builder carburetorModuleCreator(BuilderOptions options) {
  return ModuleCreatorBuilder(options: options);
}
