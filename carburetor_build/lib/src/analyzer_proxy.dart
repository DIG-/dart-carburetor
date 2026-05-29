import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

typedef ProxyElement = Element;
typedef ProxyClassElement = ClassElement;
typedef ProxyConstructorElement = ConstructorElement;
typedef ProxyLibraryElement = LibraryElement;

extension ProxyClassElementExtension on ProxyClassElement {
  List<ProxyConstructorElement> get constructorsProxy => constructors;
}

extension ProxyElementExtension on ProxyElement {
  String? get nameProxy => name;
  ProxyLibraryElement? get libraryProxy => library;
}

extension ProxyDartTypeExtension on DartType {
  ProxyElement? get elementProxy => element;
}
