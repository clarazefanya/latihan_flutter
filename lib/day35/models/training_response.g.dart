// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'training_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

TrainingResponse _$TrainingResponseFromJson(Map<String, dynamic> json) =>
    TrainingResponse(
      message: json['message'] as String?,
      data: (json['data'] as List<dynamic>?)
          ?.map((e) => TrainingModel.fromJson(e as Map<String, dynamic>))
          .toList(),
    );

Map<String, dynamic> _$TrainingResponseToJson(TrainingResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

TrainingModel _$TrainingModelFromJson(Map<String, dynamic> json) =>
    TrainingModel(
      id: (json['id'] as num?)?.toInt(),
      title: json['title'] as String?,
    );

Map<String, dynamic> _$TrainingModelToJson(TrainingModel instance) =>
    <String, dynamic>{'id': instance.id, 'title': instance.title};
