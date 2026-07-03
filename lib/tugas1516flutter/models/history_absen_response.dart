// To parse this JSON data, do
//
//     final historyAbsenResponse = historyAbsenResponseFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:latihan_flutter/tugas1516flutter/models/absen_model.dart';

part 'history_absen_response.g.dart';

HistoryAbsenResponse historyAbsenResponseFromJson(String str) =>
    HistoryAbsenResponse.fromJson(json.decode(str));

String historyAbsenResponseToJson(HistoryAbsenResponse data) =>
    json.encode(data.toJson());

@JsonSerializable()
class HistoryAbsenResponse {
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "data")
  List<AbsenModel>? data;

  HistoryAbsenResponse({required this.message, required this.data});

  factory HistoryAbsenResponse.fromJson(Map<String, dynamic> json) =>
      _$HistoryAbsenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$HistoryAbsenResponseToJson(this);
}
