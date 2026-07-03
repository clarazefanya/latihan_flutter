// To parse this JSON data, do
//
//     final absenModel = absenModelFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'absen_model.g.dart';

AbsenModel absenModelFromJson(String str) =>
    AbsenModel.fromJson(json.decode(str));

String absenModelToJson(AbsenModel data) => json.encode(data.toJson());

@JsonSerializable()
class AbsenModel {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "attendance_date")
  DateTime? attendanceDate;
  @JsonKey(name: "check_in_time")
  dynamic checkInTime;
  @JsonKey(name: "check_out_time")
  dynamic checkOutTime;
  @JsonKey(name: "check_in_lat")
  dynamic checkInLat;
  @JsonKey(name: "check_in_lng")
  dynamic checkInLng;
  @JsonKey(name: "check_out_lat")
  dynamic checkOutLat;
  @JsonKey(name: "check_out_lng")
  dynamic checkOutLng;
  @JsonKey(name: "check_in_address")
  dynamic checkInAddress;
  @JsonKey(name: "check_out_address")
  dynamic checkOutAddress;
  @JsonKey(name: "check_in_location")
  dynamic checkInLocation;
  @JsonKey(name: "check_out_location")
  dynamic checkOutLocation;
  @JsonKey(name: "status")
  String? status;
  @JsonKey(name: "alasan_izin")
  String? alasanIzin;

  AbsenModel({
    required this.id,
    required this.attendanceDate,
    required this.checkInTime,
    required this.checkOutTime,
    required this.checkInLat,
    required this.checkInLng,
    required this.checkOutLat,
    required this.checkOutLng,
    required this.checkInAddress,
    required this.checkOutAddress,
    required this.checkInLocation,
    required this.checkOutLocation,
    required this.status,
    required this.alasanIzin,
  });

  factory AbsenModel.fromJson(Map<String, dynamic> json) =>
      _$AbsenModelFromJson(json);

  Map<String, dynamic> toJson() => _$AbsenModelToJson(this);
}
