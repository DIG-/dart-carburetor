import 'package:meta/meta_meta.dart';

@Target({TargetKind.classType})
class Provide {
  final bool singleton;
  final bool lazy;
  final bool weak;
  final bool async;
  const Provide({this.singleton = false, this.lazy = true, this.weak = false, this.async = false});
}
