import 'package:meta/meta_meta.dart';

@Target({TargetKind.classType})
class Provide {
  final bool singleton;
  final bool lazy;
  const Provide({this.singleton = false, this.lazy = true});
}
