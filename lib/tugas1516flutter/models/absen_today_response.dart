// To parse this JSON data, do
//
//     final absenTodayResponse = absenTodayResponseFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:latihan_flutter/tugas1516flutter/models/absen_model.dart';

part 'absen_today_response.g.dart';

AbsenTodayResponse absenTodayResponseFromJson(String str) =>
    AbsenTodayResponse.fromJson(json.decode(str));

String absenTodayResponseToJson(AbsenTodayResponse data) =>
    json.encode(data.toJson());

@JsonSerializable()
class AbsenTodayResponse {
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "data")
  AbsenModel? data;

  AbsenTodayResponse({required this.message, required this.data});

  factory AbsenTodayResponse.fromJson(Map<String, dynamic> json) =>
      _$AbsenTodayResponseFromJson(json);

  Map<String, dynamic> toJson() => _$AbsenTodayResponseToJson(this);
}
