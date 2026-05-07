import 'package:build/build.dart';
import 'package:carburetor/carburetor.dart';
import 'package:carburetor_build/src/model/json.dart';
import 'package:json_annotation/json_annotation.dart';

part 'provide.g.dart';

class ProvideJsonConverter extends JsonConverter<Provide, Json> {
  static const _kSingleton = 'singleton';
  static const _kLazy = 'lazy';
  static const _kWeak = 'weak';

  const ProvideJsonConverter();

  @override
  Json toJson(Provide provide) {
    return {
      _kSingleton: provide.singleton,
      _kLazy: provide.lazy, //
      _kWeak: provide.weak, //
    };
  }

  @override
  Provide fromJson(Json json) {
    return Provide(
      singleton: json[_kSingleton] as bool? ?? false,
      lazy: json[_kLazy] as bool? ?? false, //
      weak: json[_kWeak] as bool? ?? false, //
    );
  }
}

class AssetIdJsonConverter extends JsonConverter<AssetId, String> {
  const AssetIdJsonConverter();

  @override
  String toJson(AssetId assetId) => assetId.toString();

  @override
  AssetId fromJson(String json) => AssetId.parse(json);
}

@JsonSerializable(converters: [ProvideJsonConverter(), AssetIdJsonConverter()])
class ProvideInfo {
  final Provide provide;
  final ProvideClass clazz;
  final ProvideConstructor constructor;

  const ProvideInfo({required this.provide, required this.clazz, required this.constructor});
  factory ProvideInfo.fromJson(Json json) => _$ProvideInfoFromJson(json);

  Json toJson() => _$ProvideInfoToJson(this);
}

@JsonSerializable()
class ProvideClass {
  final String name;
  final Uri uri;
  const ProvideClass({required this.name, required this.uri});
  factory ProvideClass.fromJson(Json json) => _$ProvideClassFromJson(json);

  Json toJson() => _$ProvideClassToJson(this);
}

@JsonSerializable()
class ProvideConstructor {
  final String name;
  final List<ProvideConstructorParameter> parameters;

  const ProvideConstructor({required this.name, required this.parameters});
  factory ProvideConstructor.fromJson(Json json) => _$ProvideConstructorFromJson(json);

  Json toJson() => _$ProvideConstructorToJson(this);
}

@JsonSerializable()
class ProvideConstructorParameter {
  final String? name;
  final ProvideClass type;

  const ProvideConstructorParameter({required this.name, required this.type});
  factory ProvideConstructorParameter.fromJson(Json json) => _$ProvideConstructorParameterFromJson(json);

  Json toJson() => _$ProvideConstructorParameterToJson(this);
}
