// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'absen_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

AbsenModel _$AbsenModelFromJson(Map<String, dynamic> json) => AbsenModel(
  id: (json['id'] as num?)?.toInt(),
  attendanceDate: json['attendance_date'] == null
      ? null
      : DateTime.parse(json['attendance_date'] as String),
  checkInTime: json['check_in_time'],
  checkOutTime: json['check_out_time'],
  checkInLat: json['check_in_lat'],
  checkInLng: json['check_in_lng'],
  checkOutLat: json['check_out_lat'],
  checkOutLng: json['check_out_lng'],
  checkInAddress: json['check_in_address'],
  checkOutAddress: json['check_out_address'],
  checkInLocation: json['check_in_location'],
  checkOutLocation: json['check_out_location'],
  status: json['status'] as String?,
  alasanIzin: json['alasan_izin'] as String?,
);

Map<String, dynamic> _$AbsenModelToJson(AbsenModel instance) =>
    <String, dynamic>{
      'id': instance.id,
      'attendance_date': instance.attendanceDate?.toIso8601String(),
      'check_in_time': instance.checkInTime,
      'check_out_time': instance.checkOutTime,
      'check_in_lat': instance.checkInLat,
      'check_in_lng': instance.checkInLng,
      'check_out_lat': instance.checkOutLat,
      'check_out_lng': instance.checkOutLng,
      'check_in_address': instance.checkInAddress,
      'check_out_address': instance.checkOutAddress,
      'check_in_location': instance.checkInLocation,
      'check_out_location': instance.checkOutLocation,
      'status': instance.status,
      'alasan_izin': instance.alasanIzin,
    };
