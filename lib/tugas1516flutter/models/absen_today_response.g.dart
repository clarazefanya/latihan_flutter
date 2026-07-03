// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absen_today_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbsenTodayResponse _$AbsenTodayResponseFromJson(Map<String, dynamic> json) =>
    AbsenTodayResponse(
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : AbsenModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AbsenTodayResponseToJson(AbsenTodayResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};
