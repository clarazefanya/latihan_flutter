// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'batch_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

BatchResponse _$BatchResponseFromJson(Map<String, dynamic> json) =>
    BatchResponse(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => BatchModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$BatchResponseToJson(BatchResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

BatchModel _$BatchModelFromJson(Map<String, dynamic> json) => BatchModel(
  id: (json['id'] as num?)?.toInt(),
  batchKe: json['batch_ke'] as String?,
);

Map<String, dynamic> _$BatchModelToJson(BatchModel instance) =>
    <String, dynamic>{'id': instance.id, 'batch_ke': instance.batchKe};
