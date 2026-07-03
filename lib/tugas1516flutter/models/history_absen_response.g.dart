// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'history_absen_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

HistoryAbsenResponse _$HistoryAbsenResponseFromJson(
  Map<String, dynamic> json,
) => HistoryAbsenResponse(
  message: json['message'] as String,
  data: (json['data'] as List<dynamic>?)
      ?.map((e) => AbsenModel.fromJson(e as Map<String, dynamic>))
      .toList(),
);

Map<String, dynamic> _$HistoryAbsenResponseToJson(
  HistoryAbsenResponse instance,
) => <String, dynamic>{'message': instance.message, 'data': instance.data};
