import 'package:dio/dio.dart';
import 'package:latihan_flutter/day35/models/auth_response.dart';
import 'package:latihan_flutter/day35/models/profile_response.dart';
import 'package:latihan_flutter/day35/models/training_response.dart';
import 'package:latihan_flutter/day35/models/batch_response.dart';
import 'package:retrofit/retrofit.dart';

part 'auth_service.g.dart';

@RestApi(baseUrl: 'https://appabsensi.mobileprojp.com')
abstract class AuthService {
  factory AuthService(Dio dio, {String baseUrl}) = _AuthService;

  @POST('/api/register')
  Future<AuthResponse> register(@Body() Map<String, dynamic> body);

  @POST('/api/login')
  Future<AuthResponse> login(@Body() Map<String, dynamic> body);

  @GET('/api/profile')
  Future<ProfileResponse> getProfile();

  @PUT('/api/profile')
  Future<ProfileResponse> updateProfile(@Body() Map<String, dynamic> body);

  @PUT('/api/profile/photo')
  Future<ProfileResponse> updateProfilePhoto(@Body() Map<String, dynamic> body);

  @GET('/api/trainings')
  Future<TrainingResponse> getTrainings();

  @GET('/api/batches')
  Future<BatchResponse> getBatches();
}
