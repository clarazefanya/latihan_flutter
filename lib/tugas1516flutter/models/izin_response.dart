// To parse this JSON data, do
//
//     final izinResponse = izinResponseFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:latihan_flutter/tugas1516flutter/models/absen_model.dart';

part 'izin_response.g.dart';

IzinResponse izinResponseFromJson(String str) =>
    IzinResponse.fromJson(json.decode(str));

String izinResponseToJson(IzinResponse data) => json.encode(data.toJson());

@JsonSerializable()
class IzinResponse {
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "data")
  AbsenModel? data;

  IzinResponse({required this.message, required this.data});

  factory IzinResponse.fromJson(Map<String, dynamic> json) =>
      _$IzinResponseFromJson(json);

  Map<String, dynamic> toJson() => _$IzinResponseToJson(this);
}
