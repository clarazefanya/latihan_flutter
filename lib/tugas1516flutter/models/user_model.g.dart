// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'user_model.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

UserModel _$UserModelFromJson(Map<String, dynamic> json) => UserModel(
  id: (_intFromString(json, 'id') as num?)?.toInt(),
  name: json['name'] as String?,
  email: json['email'] as String?,
  emailVerifiedAt: json['email_verified_at'],
  createdAt: json['created_at'] == null
      ? null
      : DateTime.parse(json['created_at'] as String),
  updatedAt: json['updated_at'] == null
      ? null
      : DateTime.parse(json['updated_at'] as String),
  jenisKelamin: json['jenis_kelamin'] as String?,
  profilePhoto: json['profile_photo'] as String?,
  batchId: (_intFromString(json, 'batch_id') as num?)?.toInt(),
  trainingId: (_intFromString(json, 'training_id') as num?)?.toInt(),
);

Map<String, dynamic> _$UserModelToJson(UserModel instance) => <String, dynamic>{
  'id': instance.id,
  'name': instance.name,
  'email': instance.email,
  'email_verified_at': instance.emailVerifiedAt,
  'created_at': instance.createdAt?.toIso8601String(),
  'updated_at': instance.updatedAt?.toIso8601String(),
  'jenis_kelamin': instance.jenisKelamin,
  'profile_photo': instance.profilePhoto,
  'batch_id': instance.batchId,
  'training_id': instance.trainingId,
};
