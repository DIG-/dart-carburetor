// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'provide.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

ProvideInfo _$ProvideInfoFromJson(Map<String, dynamic> json) => ProvideInfo(
  provide: const ProvideJsonConverter().fromJson(
    json['provide'] as Map<String, dynamic>,
  ),
  clazz: ProvideClass.fromJson(json['clazz'] as Map<String, dynamic>),
  constructor: ProvideConstructor.fromJson(
    json['constructor'] as Map<String, dynamic>,
  ),
);

Map<String, dynamic> _$ProvideInfoToJson(ProvideInfo instance) =>
    <String, dynamic>{
      'provide': const ProvideJsonConverter().toJson(instance.provide),
      'clazz': instance.clazz,
      'constructor': instance.constructor,
    };

ProvideClass _$ProvideClassFromJson(Map<String, dynamic> json) => ProvideClass(
  name: json['name'] as String,
  uri: Uri.parse(json['uri'] as String),
);

Map<String, dynamic> _$ProvideClassToJson(ProvideClass instance) =>
    <String, dynamic>{'name': instance.name, 'uri': instance.uri.toString()};

ProvideConstructor _$ProvideConstructorFromJson(Map<String, dynamic> json) =>
    ProvideConstructor(
      name: json['name'] as String,
      parameters:
          (json['parameters'] as List<dynamic>)
              .map(
                (e) => ProvideConstructorParameter.fromJson(
                  e as Map<String, dynamic>,
                ),
              )
              .toList(),
    );

Map<String, dynamic> _$ProvideConstructorToJson(ProvideConstructor instance) =>
    <String, dynamic>{'name': instance.name, 'parameters': instance.parameters};

ProvideConstructorParameter _$ProvideConstructorParameterFromJson(
  Map<String, dynamic> json,
) => ProvideConstructorParameter(
  name: json['name'] as String?,
  type: ProvideClass.fromJson(json['type'] as Map<String, dynamic>),
);

Map<String, dynamic> _$ProvideConstructorParameterToJson(
  ProvideConstructorParameter instance,
) => <String, dynamic>{'name': instance.name, 'type': instance.type};
