import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'delete_absen_response.g.dart';

DeleteAbsenResponse deleteAbsenResponseFromJson(String str) =>
    DeleteAbsenResponse.fromJson(json.decode(str));

String deleteAbsenResponseToJson(DeleteAbsenResponse data) =>
    json.encode(data.toJson());

@JsonSerializable()
class DeleteAbsenResponse {
  @JsonKey(name: "message")
  String message;

  @JsonKey(name: "data")
  dynamic data;

  DeleteAbsenResponse({required this.message, this.data});

  factory DeleteAbsenResponse.fromJson(Map<String, dynamic> json) =>
      _$DeleteAbsenResponseFromJson(json);

  Map<String, dynamic> toJson() => _$DeleteAbsenResponseToJson(this);
}
