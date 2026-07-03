// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkin_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckinResponse _$CheckinResponseFromJson(Map<String, dynamic> json) =>
    CheckinResponse(
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : AbsenModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CheckinResponseToJson(CheckinResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};
