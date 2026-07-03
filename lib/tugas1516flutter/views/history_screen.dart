import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latihan_flutter/tugas1516flutter/models/history_absen_response.dart';
import 'package:latihan_flutter/tugas1516flutter/services/attendance_service.dart';
import 'package:latihan_flutter/tugas1516flutter/services/dio_client.dart';
import 'package:latihan_flutter/tugas1516flutter/views/history_detail_screen.dart';

class HistoryScreen extends StatefulWidget {
  const HistoryScreen({super.key});

  @override
  State<HistoryScreen> createState() => HistoryScreenState();
}

class HistoryScreenState extends State<HistoryScreen> {
  late final AttendanceService _attendanceService;

  bool _isDeleteMode = false;
  bool _isActionLoading = false;

  // STATE BARU UNTUK MEKANISME FILTER INLINE
  bool _showFilterContainer = false;
  final _startDateController = TextEditingController();
  final _endDateController = TextEditingController();

  Future<HistoryAbsenResponse>? _historyFuture;

  @override
  void initState() {
    super.initState();
    _attendanceService = AttendanceService(createDioClient());
    fetchFullHistory();
  }

  @override
  void dispose() {
    _startDateController.dispose();
    _endDateController.dispose();
    super.dispose();
  }

  // Fungsi refresh / ambil semua data
  Future<void> fetchFullHistory() async {
    setState(() {
      _showFilterContainer = false;
      _isDeleteMode = false;
      _startDateController.clear();
      _endDateController.clear();
      _historyFuture = _attendanceService.getHistory();
    });
  }

  Future<void> _fetchFilteredHistory() async {
    if (_startDateController.text.isEmpty || _endDateController.text.isEmpty) {
      _showSnackBar("Harap isi kedua tanggal filter", isError: true);
      return;
    }
    setState(() {
      _historyFuture = _attendanceService.getHistoryByDateRange(
        _startDateController.text,
        _endDateController.text,
      );
    });
  }

  // Fungsi pembantu untuk memunculkan kalender pada field input inline
  Future<void> _selectInlineDate(
    BuildContext context,
    TextEditingController controller,
  ) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
    );
    if (picked != null) {
      setState(() {
        controller.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _showDeleteConfirmation(dynamic id, String dateLabel) async {
    return showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Konfirmasi Hapus",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: Text(
            "Apakah Anda yakin ingin menghapus data absensi pada tanggal $dateLabel?",
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Batal", style: TextStyle(color: Colors.grey)),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(
                backgroundColor: const Color(0xFFFF5252),
              ),
              onPressed: () {
                Navigator.pop(context);
                _executeDeleteAbsen(id);
              },
              child: const Text(
                "Ya, Hapus",
                style: TextStyle(color: Colors.white),
              ),
            ),
          ],
        );
      },
    );
  }

  Future<void> _executeDeleteAbsen(dynamic id) async {
    setState(() => _isActionLoading = true);
    try {
      final response = await _attendanceService.deleteAbsen(id);
      _showSnackBar(response.message, isError: false);

      // Jika sedang memfilter, refresh data berdasarkan filter tersebut, jika tidak ambil semua
      if (_startDateController.text.isNotEmpty &&
          _endDateController.text.isNotEmpty) {
        _fetchFilteredHistory();
      } else {
        fetchFullHistory();
      }
    } on DioException catch (e) {
      String errMsg = "Gagal menghapus data";
      if (e.response?.data != null)
        errMsg = e.response!.data['message'] ?? errMsg;
      _showSnackBar(errMsg, isError: true);
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isActionLoading = false);
    }
  }

  void _showSnackBar(String msg, {required bool isError}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(msg),
        backgroundColor: isError
            ? const Color(0xFFFF5252)
            : const Color(0xFF00BFA5),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    const primaryColor = Color(0xFF8C52FF);
    const backgroundColor = Color(0xFFF9F8FD);

    return Scaffold(
      backgroundColor: backgroundColor,
      appBar: AppBar(
        title: const Text(
          "Riwayat Absensi",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: const Color(0xFF2E2E3A),
        actions: [
          // Icon Filter: Berubah outlined/filled dan menyalakan/mematikan container inline
          IconButton(
            icon: Icon(
              _showFilterContainer
                  ? Icons.filter_alt_rounded
                  : Icons.filter_alt_outlined,
              color: _showFilterContainer
                  ? primaryColor
                  : const Color(0xFF2E2E3A),
            ),
            onPressed: () {
              setState(() => _showFilterContainer = !_showFilterContainer);
            },
          ),
          IconButton(
            icon: Icon(
              _isDeleteMode
                  ? Icons.close_rounded
                  : Icons.delete_outline_rounded,
              color: _isDeleteMode
                  ? const Color(0xFFFF5252)
                  : const Color(0xFF2E2E3A),
            ),
            onPressed: () {
              setState(() => _isDeleteMode = !_isDeleteMode);
            },
          ),
        ],
      ),
      body: Stack(
        children: [
          Column(
            children: [
              // 1. INLINE CONTAINER FILTER (Hanya muncul jika _showFilterContainer bernilai true)
              if (_showFilterContainer)
                Container(
                  padding: const EdgeInsets.all(16.0),
                  color: Colors.white,
                  child: Column(
                    children: [
                      Row(
                        children: [
                          Expanded(
                            child: TextFormField(
                              controller: _startDateController,
                              readOnly: true,
                              onTap: () => _selectInlineDate(
                                context,
                                _startDateController,
                              ),
                              decoration: const InputDecoration(
                                labelText: "Tanggal Awal",
                                labelStyle: TextStyle(fontSize: 12),
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Text("-", style: TextStyle(fontSize: 16)),
                          const SizedBox(width: 12),
                          Expanded(
                            child: TextFormField(
                              controller: _endDateController,
                              readOnly: true,
                              onTap: () => _selectInlineDate(
                                context,
                                _endDateController,
                              ),
                              decoration: const InputDecoration(
                                labelText: "Tanggal Akhir",
                                labelStyle: TextStyle(fontSize: 12),
                                prefixIcon: Icon(
                                  Icons.calendar_today,
                                  size: 16,
                                  color: primaryColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 12),
                      ElevatedButton.icon(
                        style: ElevatedButton.styleFrom(
                          backgroundColor: primaryColor,
                          foregroundColor: Colors.white,
                          minimumSize: const Size.fromHeight(40),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(8),
                          ),
                        ),
                        onPressed: _fetchFilteredHistory,
                        icon: const Icon(Icons.search, size: 18),
                        label: const Text(
                          "Terapkan Filter",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                      ),
                    ],
                  ),
                ),

              // 2. REFRESH INDICATOR & LIST CARDS RIWAYAT
              Expanded(
                child: RefreshIndicator(
                  color: primaryColor,
                  onRefresh:
                      fetchFullHistory, // Memicu reset filter & sembunyikan container
                  child: FutureBuilder<HistoryAbsenResponse>(
                    future: _historyFuture,
                    builder: (context, snapshot) {
                      if (snapshot.connectionState == ConnectionState.waiting) {
                        return const Center(
                          child: CircularProgressIndicator(color: primaryColor),
                        );
                      }

                      if (snapshot.hasError ||
                          snapshot.data?.data == null ||
                          snapshot.data!.data!.isEmpty) {
                        return ListView(
                          children: [
                            SizedBox(
                              height: MediaQuery.of(context).size.height * 0.25,
                            ),
                            const Center(
                              child: Text(
                                "Belum ada riwayat absensi",
                                style: TextStyle(color: Colors.grey),
                              ),
                            ),
                          ],
                        );
                      }

                      final listAbsen = snapshot.data!.data!;

                      return ListView.builder(
                        padding: const EdgeInsets.all(16.0),
                        itemCount: listAbsen.length,
                        itemBuilder: (context, index) {
                          final item = listAbsen[index];

                          final dateStr = item.attendanceDate != null
                              ? DateFormat(
                                  'EEEE, d MMMM yyyy',
                                  'id_ID',
                                ).format(item.attendanceDate!)
                              : '-';

                          final isMasuk = item.status?.toLowerCase() == 'masuk';
                          final isIzin = item.status?.toLowerCase() == 'izin';

                          return Card(
                            elevation: 0,
                            color: Colors.white,
                            margin: const EdgeInsets.only(bottom: 12.0),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(14.0),
                              side: BorderSide(color: Colors.grey.shade100),
                            ),
                            child: InkWell(
                              borderRadius: BorderRadius.circular(14.0),
                              onTap: () {
                                // MENGIRIM SELURUH OBJEK DATA TANPA ENDPOINT PARAMS ID
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        HistoryDetailScreen(absenData: item),
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.all(20.0),
                                child: Row(
                                  children: [
                                    Expanded(
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Text(
                                                dateStr,
                                                style: const TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF2E2E3A),
                                                ),
                                              ),
                                              Container(
                                                padding:
                                                    const EdgeInsets.symmetric(
                                                      horizontal: 10,
                                                      vertical: 4,
                                                    ),
                                                decoration: BoxDecoration(
                                                  color: isMasuk
                                                      ? const Color(
                                                          0xFF00BFA5,
                                                        ).withValues(alpha: 0.1)
                                                      : isIzin
                                                      ? Colors.orange
                                                            .withValues(
                                                              alpha: 0.1,
                                                            )
                                                      : Colors.grey.withValues(
                                                          alpha: 0.1,
                                                        ),
                                                  borderRadius:
                                                      BorderRadius.circular(8),
                                                ),
                                                child: Text(
                                                  isMasuk
                                                      ? "Hadir"
                                                      : (isIzin ? "Izin" : "-"),
                                                  style: TextStyle(
                                                    color: isMasuk
                                                        ? const Color(
                                                            0xFF00BFA5,
                                                          )
                                                        : (isIzin
                                                              ? Colors.orange
                                                              : Colors.black),
                                                    fontWeight: FontWeight.bold,
                                                    fontSize: 12,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          ),
                                          const Divider(
                                            height: 24,
                                            color: Color(0xFFF6F5FB),
                                          ),
                                          Row(
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              _buildTimeInfo(
                                                "Jam Masuk",
                                                item.checkInTime ?? "--:--",
                                              ),
                                              _buildTimeInfo(
                                                "Jam Pulang",
                                                item.checkOutTime ?? "--:--",
                                              ),
                                            ],
                                          ),
                                        ],
                                      ),
                                    ),
                                    if (_isDeleteMode) ...[
                                      const SizedBox(width: 16),
                                      IconButton(
                                        icon: const Icon(
                                          Icons.delete_forever_rounded,
                                          color: Color(0xFFFF5252),
                                          size: 26,
                                        ),
                                        onPressed: () {
                                          _showDeleteConfirmation(
                                            item.id,
                                            DateFormat(
                                              'd MMMM yyyy',
                                              'id_ID',
                                            ).format(
                                              item.attendanceDate ??
                                                  DateTime.now(),
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  ],
                                ),
                              ),
                            ),
                          );
                        },
                      );
                    },
                  ),
                ),
              ),
            ],
          ),
          if (_isActionLoading)
            Container(
              color: Colors.black26,
              child: const Center(
                child: CircularProgressIndicator(color: primaryColor),
              ),
            ),
        ],
      ),
    );
  }

  Widget _buildTimeInfo(String title, String time) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          title,
          style: const TextStyle(color: Color(0xFF7E7E8F), fontSize: 11),
        ),
        const SizedBox(height: 2),
        Text(
          time,
          style: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 15,
            color: Color(0xFF2E2E3A),
          ),
        ),
      ],
    );
  }
}
