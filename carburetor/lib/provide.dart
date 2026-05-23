import 'package:meta/meta_meta.dart';

@Target({TargetKind.classType})
class CarburetorProvide {
  final bool singleton;
  final bool lazy;
  final bool weak;
  final bool async;
  const CarburetorProvide({this.singleton = false, this.lazy = true, this.weak = false, this.async = false});
}

class Provide extends CarburetorProvide {
  const Provide() : super(singleton: false, lazy: false, weak: false, async: false);
  const factory Provide.async() = ProvideAsync;
}

class ProvideAsync extends CarburetorProvide implements Provide {
  const ProvideAsync() : super(singleton: false, lazy: false, weak: false, async: true);
}

class Singleton extends CarburetorProvide {
  const Singleton({super.lazy = true, super.weak = false}) : super(singleton: true, async: false);
  const factory Singleton.async({bool lazy, bool weak}) = SingletonAsync;
}

class SingletonAsync extends CarburetorProvide implements Singleton {
  const SingletonAsync({super.lazy = true, super.weak = false}) : super(singleton: true, async: true);
}
