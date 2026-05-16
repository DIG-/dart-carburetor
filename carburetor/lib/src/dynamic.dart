import 'package:carburetor/exceptions.dart';

import './module.dart';

part 'dynamic_impl.dart';

sealed class CarburetorDynamicModule<Module extends CarburetorModule> implements CarburetorModule {
  const CarburetorDynamicModule._();
  const factory CarburetorDynamicModule(Module module) = CarburetorDynamicModuleImpl;

  Module get module;

  @override
  T get<T extends Object>({String? name});

  @override
  Future<T> getAsync<T extends Object>({String? name});

  void set<T extends Object>(T value, {String? name});

  void remove<T extends Object>({String? name});
}
