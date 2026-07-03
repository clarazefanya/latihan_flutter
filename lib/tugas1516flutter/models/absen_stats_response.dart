// To parse this JSON data, do
//
//     final absenStatsResponse = absenStatsResponseFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'absen_stats_response.g.dart';

AbsenStatsResponse absenStatsResponseFromJson(String str) =>
    AbsenStatsResponse.fromJson(json.decode(str));

String absenStatsResponseToJson(AbsenStatsResponse data) =>
    json.encode(data.toJson());

@JsonSerializable()
class AbsenStatsResponse {
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "data")
  AbsenStatsModel? data;

  AbsenStatsResponse({required this.message, required this.data});

  factory AbsenStatsResponse.fromJson(Map<String, dynamic> json) =>
      _$AbsenStatsResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AbsenStatsResponseToJson(this);
}

@JsonSerializable()
class AbsenStatsModel {
  @JsonKey(name: "total_absen")
  int totalAbsen;
  @JsonKey(name: "total_masuk")
  int totalMasuk;
  @JsonKey(name: "total_izin")
  int totalIzin;
  @JsonKey(name: "sudah_absen_hari_ini")
  bool sudahAbsenHariIni;

  AbsenStatsModel({
    required this.totalAbsen,
    required this.totalMasuk,
    required this.totalIzin,
    required this.sudahAbsenHariIni,
  });

  factory AbsenStatsModel.fromJson(Map<String, dynamic> json) =>
      _$AbsenStatsModelFromJson(json);

  Map<String, dynamic> toJson() => _$AbsenStatsModelToJson(this);
}
