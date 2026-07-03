// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'izin_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

IzinResponse _$IzinResponseFromJson(Map<String, dynamic> json) => IzinResponse(
  message: json['message'] as String,
  data: json['data'] == null
      ? null
      : AbsenModel.fromJson(json['data'] as Map<String, dynamic>),
);

Map<String, dynamic> _$IzinResponseToJson(IzinResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};
