import 'package:analyzer/dart/element/element2.dart';
import 'package:analyzer/dart/element/type.dart';

typedef ProxyElement = Element2;
typedef ProxyClassElement = ClassElement2;
typedef ProxyConstructorElement = ConstructorElement2;
typedef ProxyLibraryElement = LibraryElement2;

extension ProxyClassElementExtension on ProxyClassElement {
  List<ProxyConstructorElement> get constructorsProxy => constructors2;
}

extension ProxyElementExtension on ProxyElement {
  String? get nameProxy => name3;
  ProxyLibraryElement? get libraryProxy => library2;
}

extension ProxyDartTypeExtension on DartType {
  ProxyElement? get elementProxy => element3;
}
