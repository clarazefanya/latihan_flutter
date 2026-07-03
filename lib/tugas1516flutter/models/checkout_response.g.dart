// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'checkout_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

CheckoutResponse _$CheckoutResponseFromJson(Map<String, dynamic> json) =>
    CheckoutResponse(
      message: json['message'] as String,
      data: json['data'] == null
          ? null
          : AbsenModel.fromJson(json['data'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$CheckoutResponseToJson(CheckoutResponse instance) =>
    <String, dynamic>{'message': instance.message, 'data': instance.data};
