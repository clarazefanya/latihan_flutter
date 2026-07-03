// To parse this JSON data, do
//
//     final checkinResponse = checkinResponseFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:latihan_flutter/tugas1516flutter/models/absen_model.dart';

part 'checkin_response.g.dart';

CheckinResponse checkinResponseFromJson(String str) =>
    CheckinResponse.fromJson(json.decode(str));

String checkinResponseToJson(CheckinResponse data) =>
    json.encode(data.toJson());

@JsonSerializable()
class CheckinResponse {
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "data")
  AbsenModel? data;

  CheckinResponse({required this.message, required this.data});

  factory CheckinResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckinResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckinResponseToJson(this);
}
