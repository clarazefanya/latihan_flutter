import 'package:json_annotation/json_annotation.dart';

part 'user_model.g.dart';

// Fungsi helper untuk handle konversi String ke int secara aman
int? _intFromString(Map json, String key) {
  final value = json[key];
  if (value is int) return value;
  if (value is String) return int.tryParse(value);

  // JIKA API PROFILE MENGEMBALIKAN OBJEK MAP ("batch" atau "training")
  if (value is Map) {
    final idValue = value['id'];
    if (idValue is int) return idValue;
    if (idValue is String) return int.tryParse(idValue);
  }

  // JIKA KEY DI JSON ADALAH "batch_id" TAPI DI PROFILE ADALAH "batch"
  if (key == 'batch_id' && json['batch'] is Map) {
    final idValue = json['batch']['id'];
    if (idValue is int) return idValue;
    if (idValue is String) return int.tryParse(idValue);
  }
  if (key == 'training_id' && json['training'] is Map) {
    final idValue = json['training']['id'];
    if (idValue is int) return idValue;
    if (idValue is String) return int.tryParse(idValue);
  }

  return null;
}

@JsonSerializable()
class UserModel {
  // Tambahkan readValue: _intFromString di field int Anda
  @JsonKey(name: "id", readValue: _intFromString)
  int? id;

  @JsonKey(name: "name")
  String? name;

  @JsonKey(name: "email")
  String? email;

  @JsonKey(name: "email_verified_at")
  dynamic emailVerifiedAt;

  @JsonKey(name: "created_at")
  DateTime? createdAt;

  @JsonKey(name: "updated_at")
  DateTime? updatedAt;

  @JsonKey(name: "jenis_kelamin")
  String? jenisKelamin;

  @JsonKey(name: "profile_photo")
  String? profilePhoto;

  // Tambahkan readValue di sini juga
  @JsonKey(name: "batch_id", readValue: _intFromString)
  int? batchId;

  // Tambahkan readValue di sini juga
  @JsonKey(name: "training_id", readValue: _intFromString)
  int? trainingId;

  UserModel({
    this.id,
    this.name,
    this.email,
    this.emailVerifiedAt,
    this.createdAt,
    this.updatedAt,
    this.jenisKelamin,
    this.profilePhoto,
    this.batchId,
    this.trainingId,
  });

  factory UserModel.fromJson(Map<String, dynamic> json) =>
      _$UserModelFromJson(json);

  Map<String, dynamic> toJson() => _$UserModelToJson(this);
}
