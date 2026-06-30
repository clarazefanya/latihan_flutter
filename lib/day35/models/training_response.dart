import 'dart:convert';
import 'package:json_annotation/json_annotation.dart';

part 'training_response.g.dart';

TrainingResponse trainingResponseFromJson(String str) =>
    TrainingResponse.fromJson(json.decode(str));

String trainingResponseToJson(TrainingResponse data) =>
    json.encode(data.toJson());

@JsonSerializable()
class TrainingResponse {
  @JsonKey(name: "message")
  String? message;
  @JsonKey(name: "data")
  List<TrainingModel>? data;

  TrainingResponse({this.message, this.data});

  factory TrainingResponse.fromJson(Map<String, dynamic> json) =>
      _$TrainingResponseFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingResponseToJson(this);
}

@JsonSerializable()
class TrainingModel {
  @JsonKey(name: "id")
  int? id;
  @JsonKey(name: "title")
  String? title;

  TrainingModel({this.id, this.title});

  factory TrainingModel.fromJson(Map<String, dynamic> json) =>
      _$TrainingModelFromJson(json);

  Map<String, dynamic> toJson() => _$TrainingModelToJson(this);
}
