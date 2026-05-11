import 'package:carburetor_build/src/model/provide.dart';

class CreatorContext {
  static const _kMappingValues = 'abcdefghijklmnopqrstuvwxyz';

  final Map<Uri, String> _mapping;
  final Map<ProvideClass, ProvideInfo> _classes;

  const CreatorContext._(this._mapping, this._classes);

  factory CreatorContext.fromProviders(List<ProvideInfo> providers) {
    final mapping = <Uri, String>{};
    final classes = <ProvideClass, ProvideInfo>{};
    for (final provider in providers) {
      if (!mapping.containsKey(provider.clazz.uri)) {
        mapping[provider.clazz.uri] = _generatePackageAlias(mapping.length);
      }
      classes[provider.clazz] = provider;
    }
    return CreatorContext._(mapping, classes);
  }

  static String _generatePackageAlias(int length) {
    if (length == 0) {
      return '${_kMappingValues[0]}${_kMappingValues[0]}';
    }
    final buffer = StringBuffer();
    while (length > 0) {
      final index = length % _kMappingValues.length;
      buffer.write(_kMappingValues[index]);
      length ~/= _kMappingValues.length;
    }
    if (buffer.length == 1) {
      return '${_kMappingValues[0]}${buffer.toString()}';
    }
    return buffer.toString();
  }

  Map<Uri, String> getPackageImportMapping() => _mapping;

  String getPackageAlias({Uri? uri, final ProvideClass? clazz, final ProvideInfo? info}) {
    uri ??=
        clazz?.uri ??
        info?.clazz.uri ?? //
        (throw ArgumentError('At least one of uri, clazz or info must be provided'));
    return _mapping[uri] ?? (throw PackageNotFoundException(uri));
  }

  Iterable<ProvideInfo> getProviders() => _classes.values;

  ProvideInfo getProvider({required ProvideClass clazz}) => _classes[clazz] ?? (throw ProviderNotFoundException(clazz));
}

class PackageNotFoundException implements Exception {
  final Uri uri;

  const PackageNotFoundException(this.uri);

  @override
  String toString() => 'Package not found: $uri';
}

class ProviderNotFoundException implements Exception {
  final ProvideClass clazz;

  const ProviderNotFoundException(this.clazz);

  @override
  String toString() => 'Provider not found: $clazz';
}
