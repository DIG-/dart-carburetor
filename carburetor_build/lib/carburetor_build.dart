library;

import 'package:build/build.dart';
import 'package:carburetor_build/src/builder/info_extractor.dart';
import 'package:carburetor_build/src/builder/info_merge.dart';
import 'package:carburetor_build/src/builder/module_creator.dart';

/// Builder for extracting information from Dart code.
Builder carburetorInfoExtractor(BuilderOptions options) {
  return InfoExtractorBuilder();
}

/// Builder for merging extracted information.
Builder carburetorInfoMerge(BuilderOptions options) {
  return InfoMergeBuilder();
}

/// Builder for creating modules.
Builder carburetorModuleCreator(BuilderOptions options) {
  return ModuleCreatorBuilder(options: options);
}
