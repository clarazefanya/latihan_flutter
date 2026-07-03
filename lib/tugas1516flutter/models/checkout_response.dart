// To parse this JSON data, do
//
//     final checkoutResponse = checkoutResponseFromJson(jsonString);

import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';
import 'package:latihan_flutter/tugas1516flutter/models/absen_model.dart';

part 'checkout_response.g.dart';

CheckoutResponse checkoutResponseFromJson(String str) =>
    CheckoutResponse.fromJson(json.decode(str));

String checkoutResponseToJson(CheckoutResponse data) =>
    json.encode(data.toJson());

@JsonSerializable()
class CheckoutResponse {
  @JsonKey(name: "message")
  String message;
  @JsonKey(name: "data")
  AbsenModel? data;

  CheckoutResponse({required this.message, required this.data});

  factory CheckoutResponse.fromJson(Map<String, dynamic> json) =>
      _$CheckoutResponseFromJson(json);

  Map<String, dynamic> toJson() => _$CheckoutResponseToJson(this);
}
