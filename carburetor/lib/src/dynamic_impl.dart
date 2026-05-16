part of 'dynamic.dart';

final class CarburetorDynamicModuleImpl<Module extends CarburetorModule> extends CarburetorDynamicModule<Module> {
  @override
  final Module module;

  final Map<Type, Map<String?, Object>> _overrides;

  const CarburetorDynamicModuleImpl(this.module, [this._overrides = const {}]) : super._();

  @override
  T get<T extends Object>({String? name}) {
    final override = _getOverride<T>(name: name);
    if (name != null && override == null) {
      throw CarburetorException('No override found for type $T with name "$name".');
    }
    if (override != null) {
      return override;
    }
    return module.get<T>();
  }

  @override
  Future<T> getAsync<T extends Object>({String? name}) async {
    final override = _getOverride<T>(name: name);
    if (name != null && override == null) {
      throw CarburetorException('No override found for type $T with name "$name".');
    }
    if (override != null) {
      return override;
    }
    return module.getAsync<T>();
  }

  @override
  void set<T extends Object>(T value, {String? name}) {
    final typeOverrides = _overrides[T];
    if (typeOverrides == null) {
      _overrides[T] = {name: value};
    } else {
      typeOverrides[name] = value;
    }
  }

  @override
  void remove<T extends Object>({String? name}) {
    final typeOverrides = _overrides[T];
    if (typeOverrides != null) {
      typeOverrides.remove(name);
      if (typeOverrides.isEmpty) {
        _overrides.remove(T);
      }
    }
  }

  T? _getOverride<T extends Object>({String? name}) {
    final typeOverrides = _overrides[T];
    if (typeOverrides == null) return null;
    return typeOverrides[name] as T?;
  }
}
