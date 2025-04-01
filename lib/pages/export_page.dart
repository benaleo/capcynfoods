import 'dart:io';

import 'package:excel/excel.dart';
import 'package:flutter/material.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:intl/intl.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';
import 'package:supabase_flutter/supabase_flutter.dart';

class ExportDataPage extends StatefulWidget {
  @override
  _ExportDataPageState createState() => _ExportDataPageState();
}

class _ExportDataPageState extends State<ExportDataPage> {
  bool _isLoading = false;

  Future<void> exportToExcel() async {
    setState(() {
      _isLoading = true;
    });

    try {
      final SupabaseClient supabase = Supabase.instance.client;

      // Panggil fungsi RPC
      final response = await supabase.rpc('get_presences_with_user_names');

      final data = response as List<dynamic>;

      // Buat file Excel
      var excel = Excel.createExcel();
      var sheet = excel['Presences'];

      // Header dengan format yang lebih baik
      sheet.appendRow(['Nama Pengguna', 'Waktu Mulai', 'Waktu Selesai', 'Tanggal']);

      // Format tanggal dan waktu
      final dateFormat = DateFormat('yyyy-MM-dd HH:mm:ss');
      final dateOnlyFormat = DateFormat('yyyy-MM-dd');

      // Tambahkan data
      for (var row in data) {
        // Format waktu sesuai kebutuhan
        final startTime = DateTime.parse(row['start'].toString()).toLocal();
        final endTime = row['end'] != null
            ? DateTime.parse(row['end'].toString()).toLocal()
            : null;
        final date = DateTime.parse(row['date'].toString());

        sheet.appendRow([
          row['user_name'] ?? 'Tidak Diketahui',
          dateFormat.format(startTime),
          endTime != null ? dateFormat.format(endTime) : '-',
          dateOnlyFormat.format(date),
        ]);
      }

      // Simpan file dengan nama unik
      final directory = await getApplicationDocumentsDirectory();
      final timestamp = DateFormat('yyyyMMdd_HHmmss').format(DateTime.now());
      final filePath = '${directory.path}/presensi_$timestamp.xlsx';
      final file = File(filePath);
      await file.writeAsBytes(excel.encode()!);

      // Buka file
      await OpenFile.open(filePath);

      Fluttertoast.showToast(
        msg: "Data presensi berhasil diekspor",
        toastLength: Toast.LENGTH_LONG,
      );
    } catch (e) {
      Fluttertoast.showToast(
        msg: "Gagal mengekspor: ${e.toString()}",
        toastLength: Toast.LENGTH_LONG,
        backgroundColor: Colors.red,
      );
      debugPrint('Error exporting data: $e');
    } finally {
      setState(() {
        _isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text('Export Data')),
      body: Center(
        child: _isLoading
            ? CircularProgressIndicator()
            : ElevatedButton(
          onPressed: exportToExcel,
          child: Text('Export to Excel'),
        ),
      ),
    );
  }
}