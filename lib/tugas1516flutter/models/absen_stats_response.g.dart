// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absen_stats_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbsenStatsResponse _$AbsenStatsResponseFromJson(Map<String, dynamic> json) =>
    AbsenStatsResponse(
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : AbsenStatsModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$AbsenStatsResponseToJson(AbsenStatsResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};

AbsenStatsModel _$AbsenStatsModelFromJson(Map<String, dynamic> json) =>
    AbsenStatsModel(
      totalAbsen: (json['total_absen'] as num).toInt(),
      totalMasuk: (json['total_masuk'] as num).toInt(),
      totalIzin: (json['total_izin'] as num).toInt(),
      sudahAbsenHariIni: json['sudah_absen_hari_ini'] as bool,
    );

Map<String, dynamic> _$AbsenStatsModelToJson(AbsenStatsModel instance) =>
    <String, dynamic>{
      'total_absen': instance.totalAbsen,
      'total_masuk': instance.totalMasuk,
      'total_izin': instance.totalIzin,
      'sudah_absen_hari_ini': instance.sudahAbsenHariIni,
    };
