import 'package:analyzer/dart/element/element.dart';
import 'package:analyzer/dart/element/type.dart';

typedef ProxyClassElement = ClassElement;
typedef ProxyConstructorElement = ConstructorElement;
typedef ProxyElement = Element;
typedef ProxyExecutableElement = ExecutableElement;
typedef ProxyInstanceElement = InstanceElement;
typedef ProxyLibraryElement = LibraryElement;
typedef ProxyMethodElement = MethodElement;

extension ProxyClassElementExtension on ProxyClassElement {
  List<ProxyConstructorElement> get constructorsProxy => constructors;
}

extension ProxyElementExtension on ProxyElement {
  String? get nameProxy => name;
  ProxyLibraryElement? get libraryProxy => library;
}

extension ProxyInstanceElementExtension on ProxyInstanceElement {
  List<ProxyMethodElement> get methodsProxy => methods;
}

extension ProxyDartTypeExtension on DartType {
  ProxyElement? get elementProxy => element;
}
