import 'dart:convert';

import 'package:json_annotation/json_annotation.dart';

part 'batch_response.g.dart';

BatchResponse batchResponseFromJson(String str) =>
    BatchResponse.fromJson(json.decode(str));

String batchResponseToJson(BatchResponse data) => json.encode(data.toJson());

@JsonSerializable()
class BatchResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  List<BatchModel>? data;

  BatchResponse({this.message, this.data});

  factory BatchResponse.fromJson(Map<String, dynamic> json) =>
      _$BatchResponseFromJson(json);

  Map<String, dynamic> toJson() => _$BatchResponseToJson(this);
}

@JsonSerializable()
class BatchModel {
  @JsonKey(name: "id")
  int? id;

  @JsonKey(name: "batch_ke")
  String? batchKe;

  BatchModel({this.id, this.batchKe});

  factory BatchModel.fromJson(Map<String, dynamic> json) =>
      _$BatchModelFromJson(json);

  Map<String, dynamic> toJson() => _$BatchModelToJson(this);
}
