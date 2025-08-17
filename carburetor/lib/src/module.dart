import 'package:meta/meta_meta.dart';

@Target({TargetKind.classType})
class Module {
  const Module();
}

abstract class CarburetorModule {
  const CarburetorModule();

  T get<T>();
}
