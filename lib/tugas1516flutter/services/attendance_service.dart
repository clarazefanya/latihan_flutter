import 'package:dio/dio.dart';
import 'package:latihan_flutter/tugas1516flutter/models/absen_stats_response.dart';
import 'package:latihan_flutter/tugas1516flutter/models/absen_today_response.dart';
import 'package:latihan_flutter/tugas1516flutter/models/checkin_response.dart';
import 'package:latihan_flutter/tugas1516flutter/models/checkout_response.dart';
import 'package:latihan_flutter/tugas1516flutter/models/delete_absen_response.dart';
import 'package:latihan_flutter/tugas1516flutter/models/history_absen_response.dart';
import 'package:latihan_flutter/tugas1516flutter/models/izin_response.dart';
import 'package:retrofit/retrofit.dart';

part 'attendance_service.g.dart';

@RestApi(baseUrl: 'https://appabsensi.mobileprojp.com')
abstract class AttendanceService {
  factory AttendanceService(Dio dio, {String baseUrl}) = _AttendanceService;

  // Check In
  @POST('/api/absen/check-in')
  Future<CheckinResponse> checkIn(@Body() Map<String, dynamic> body);

  // Check Out
  @POST('/api/absen/check-out')
  Future<CheckoutResponse> checkOut(@Body() Map<String, dynamic> body);

  // Izin
  @POST('/api/izin')
  Future<IzinResponse> izin(@Body() Map<String, dynamic> body);

  // Absen Today
  @GET('/api/absen/today')
  Future<AbsenTodayResponse> getToday(
    @Query('attendance_date') String attendanceDate,
  );

  // Statistik (semua)
  @GET('/api/absen/stats')
  Future<AbsenStatsResponse> getStats();

  // Statistik per tahun
  @GET('/api/absen/stats')
  Future<AbsenStatsResponse> getStatsByYear(@Query('year') int year);

  // Statistik berdasarkan range tanggal
  @GET('/api/absen/stats')
  Future<AbsenStatsResponse> getStatsByDateRange(
    @Query('start') String start,
    @Query('end') String end,
  );

  // History (semua)
  @GET('/api/absen/history')
  Future<HistoryAbsenResponse> getHistory();

  // History berdasarkan range tanggal
  @GET('/api/absen/history')
  Future<HistoryAbsenResponse> getHistoryByDateRange(
    @Query('start') String start,
    @Query('end') String end,
  );

  // Delete absen
  @DELETE('/api/absen/{id}')
  Future<DeleteAbsenResponse> deleteAbsen(@Path('id') dynamic id);
}
