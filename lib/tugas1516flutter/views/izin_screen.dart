import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:latihan_flutter/tugas1516flutter/models/history_absen_response.dart';
import 'package:latihan_flutter/tugas1516flutter/services/attendance_service.dart';
import 'package:latihan_flutter/tugas1516flutter/services/dio_client.dart';

class IzinScreen extends StatefulWidget {
  const IzinScreen({super.key});

  @override
  State<IzinScreen> createState() => _IzinScreenState();
}

class _IzinScreenState extends State<IzinScreen> {
  final _formKey = GlobalKey<FormState>();
  final _dateController = TextEditingController();
  final _alasanController = TextEditingController();

  late final AttendanceService _attendanceService;

  bool _isSubmitting = false;
  Future<HistoryAbsenResponse>? _historyFuture;

  @override
  void initState() {
    super.initState();
    _attendanceService = AttendanceService(createDioClient());
    _refreshHistory(); // Load data history saat halaman pertama buka
  }

  @override
  void dispose() {
    _dateController.dispose();
    _alasanController.dispose();
    super.dispose();
  }

  // Fungsi untuk memicu reload pada FutureBuilder
  void _refreshHistory() {
    setState(() {
      _historyFuture = _attendanceService.getHistory();
    });
  }

  // Fungsi memunculkan DatePicker bawaan Flutter
  Future<void> _selectDate() async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(2020),
      lastDate: DateTime(2101),
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: const ColorScheme.light(
              primary: Color(0xFF8C52FF), // Warna Lavender Purple
            ),
          ),
          child: child!,
        );
      },
    );
    if (picked != null) {
      setState(() {
        _dateController.text = DateFormat('yyyy-MM-dd').format(picked);
      });
    }
  }

  Future<void> _handleSubmitIzin() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() => _isSubmitting = true);

    try {
      final response = await _attendanceService.izin({
        "date": _dateController.text,
        "alasan_izin": _alasanController.text.trim(),
      });

      _showSnackBar(response.message, isError: false);

      // Reset input form setelah sukses submit
      _dateController.clear();
      _alasanController.clear();

      // REFRESH DATA LIST BAWAH SECARA OTOMATIS
      _refreshHistory();
    } on DioException catch (e) {
      String errMsg = "Gagal memproses pengajuan izin";
      if (e.response?.data != null) {
        errMsg = e.response!.data['message'] ?? errMsg;
      }
      _showSnackBar(errMsg, isError: true);
    } catch (e) {
      _showSnackBar(e.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _isSubmitting = false);
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
          "Pengajuan & Riwayat Izin",
          style: TextStyle(fontWeight: FontWeight.bold, fontSize: 20),
        ),
        backgroundColor: Colors.white,
        elevation: 0.5,
        foregroundColor: const Color(0xFF2E2E3A),
      ),
      body: GestureDetector(
        onTap: () => FocusScope.of(
          context,
        ).unfocus(), // Tutup keyboard saat tap luar area form
        child: CustomScrollView(
          slivers: [
            // BAGIAN ATAS: Form Pengajuan Izin
            SliverToBoxAdapter(
              child: Padding(
                padding: const EdgeInsets.all(16.0),
                child: Container(
                  padding: const EdgeInsets.all(20.0),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(16.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withValues(alpha: 0.02),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Form(
                    key: _formKey,
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        const Text(
                          "FORM PENGAJUAN IZIN",
                          style: TextStyle(
                            fontSize: 12,
                            fontWeight: FontWeight.bold,
                            color: Color(0xFF7E7E8F),
                            letterSpacing: 1.1,
                          ),
                        ),
                        const SizedBox(height: 16),

                        // Input Tanggal Izin
                        Text(
                          "Tanggal tidak hadir",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        const SizedBox(height: 6),
                        TextFormField(
                          controller: _dateController,
                          readOnly: true,
                          onTap: _selectDate,
                          decoration: const InputDecoration(
                            hintText: "Pilih Tanggal Tidak Hadir",
                            prefixIcon: Icon(
                              Icons.calendar_today_rounded,
                              color: primaryColor,
                            ),
                            suffixIcon: Icon(
                              Icons.arrow_drop_down,
                              color: primaryColor,
                            ),
                          ),
                          validator: (v) => v == null || v.isEmpty
                              ? "Tanggal wajib dipilih"
                              : null,
                        ),
                        const SizedBox(height: 20),

                        // Input Alasan Keterangan Izin
                        Text(
                          "Alasan Keterangan Izin",
                          style: TextStyle(fontWeight: FontWeight.bold),
                        ),
                        SizedBox(height: 6),
                        TextFormField(
                          controller: _alasanController,
                          maxLines: 4,
                          textAlignVertical: TextAlignVertical.top,
                          decoration: InputDecoration(
                            hintText: "Masukkan alasan izin...",
                            border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10),
                            ),
                          ),
                          validator: (v) => v == null || v.trim().isEmpty
                              ? "Alasan tidak boleh kosong"
                              : null,
                        ),
                        const SizedBox(height: 24),

                        // Tombol Kirim Form
                        ElevatedButton.icon(
                          onPressed: _isSubmitting ? null : _handleSubmitIzin,
                          style: ElevatedButton.styleFrom(
                            backgroundColor: primaryColor,
                            foregroundColor: Colors.white,
                            minimumSize: const Size.fromHeight(50),
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(12),
                            ),
                          ),
                          icon: _isSubmitting
                              ? const SizedBox(
                                  height: 20,
                                  width: 20,
                                  child: CircularProgressIndicator(
                                    color: Colors.white,
                                    strokeWidth: 2,
                                  ),
                                )
                              : const Icon(Icons.send_rounded),
                          label: Text(
                            _isSubmitting
                                ? "Mengirim..."
                                : "Kirim Pengajuan Izin",
                            style: const TextStyle(fontWeight: FontWeight.bold),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
              ),
            ),

            // Section Divider Title
            SliverToBoxAdapter(
              child: Padding(
                padding: EdgeInsets.symmetric(horizontal: 18.0, vertical: 8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "Daftar Riwayat Izin",
                      style: TextStyle(
                        fontSize: 15,
                        fontWeight: FontWeight.bold,
                        color: Color(0xFF2E2E3A),
                      ),
                    ),
                    IconButton(
                      icon: Icon(
                        Icons.refresh_rounded,
                        color: primaryColor,
                        size: 20,
                      ),
                      tooltip: "Refresh Riwayat",
                      onPressed:
                          _refreshHistory, // Memicu update FutureBuilder di bawahnya
                    ),
                  ],
                ),
              ),
            ),
            // BAGIAN BAWAH: List Card Riwayat Khusus Izin
            SliverPadding(
              padding: const EdgeInsets.symmetric(horizontal: 16.0),
              sliver: FutureBuilder<HistoryAbsenResponse>(
                future: _historyFuture,
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Padding(
                          padding: EdgeInsets.all(24.0),
                          child: CircularProgressIndicator(color: primaryColor),
                        ),
                      ),
                    );
                  }

                  if (snapshot.hasError || snapshot.data?.data == null) {
                    return const SliverToBoxAdapter(
                      child: Center(
                        child: Text(
                          "Gagal mengambil data riwayat",
                          style: TextStyle(color: Colors.grey),
                        ),
                      ),
                    );
                  }

                  // PROSES FILTERING LOKAL DATA STATUS = "IZIN"
                  final allHistory = snapshot.data!.data!;
                  final listIzin = allHistory
                      .where((item) => item.status?.toLowerCase() == 'izin')
                      .toList();

                  if (listIzin.isEmpty) {
                    return const SliverToBoxAdapter(
                      child: Padding(
                        padding: EdgeInsets.all(32.0),
                        child: Text(
                          "Belum ada riwayat izin tercatat.",
                          textAlign: TextAlign.center,
                          style: TextStyle(color: Colors.grey, fontSize: 13),
                        ),
                      ),
                    );
                  }

                  return SliverList(
                    delegate: SliverChildBuilderDelegate((context, index) {
                      final item = listIzin[index];
                      final dateLog = item.attendanceDate != null
                          ? DateFormat(
                              'EEEE, d MMMM yyyy',
                              'id_ID',
                            ).format(item.attendanceDate!)
                          : '-';

                      return Card(
                        elevation: 0,
                        color: Colors.white,
                        margin: const EdgeInsets.only(bottom: 10),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                          side: BorderSide(color: Colors.grey.shade100),
                        ),
                        // Card tidak bisa dipencet
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                children: [
                                  Text(
                                    dateLog,
                                    style: const TextStyle(
                                      fontWeight: FontWeight.bold,
                                      fontSize: 14,
                                      color: Color(0xFF2E2E3A),
                                    ),
                                  ),
                                  Container(
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.orange.withValues(
                                        alpha: 0.1,
                                      ),
                                      borderRadius: BorderRadius.circular(6),
                                    ),
                                    child: Text(
                                      item.status == "izin" ? "Izin" : "-",
                                      style: const TextStyle(
                                        color: Colors.orange,
                                        fontWeight: FontWeight.bold,
                                        fontSize: 11,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                              const Divider(
                                height: 20,
                                color: Color(0xFFF6F5FB),
                              ),
                              const Text(
                                "Alasan:",
                                style: TextStyle(
                                  color: Color(0xFF7E7E8F),
                                  fontSize: 12,
                                  fontWeight: FontWeight.w500,
                                ),
                              ),
                              const SizedBox(height: 4),
                              Text(
                                item.alasanIzin ?? "-",
                                style: const TextStyle(
                                  fontSize: 13,
                                  color: Color(0xFF2E2E3A),
                                  height: 1.3,
                                ),
                              ),
                            ],
                          ),
                        ),
                      );
                    }, childCount: listIzin.length),
                  );
                },
              ),
            ),
            const SliverToBoxAdapter(child: SizedBox(height: 20)),
          ],
        ),
      ),
    );
  }
}
