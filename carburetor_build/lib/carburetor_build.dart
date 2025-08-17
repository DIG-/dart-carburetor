library;

import 'package:build/build.dart';
import 'package:carburetor_build/carburetor_build.dart';

export 'src/builder.dart';

Builder carburetorBuilder(BuilderOptions options) {
  return CarburetorBuilder();
}
