import 'dart:io';
import 'package:flutter/services.dart' show rootBundle;
import 'package:permission_handler/permission_handler.dart';
import 'package:intl/intl.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:pdf/pdf.dart';

class QuizResultExportService {
  static Future<String?> exportToPdf({
    required String quizTitle,
    required List<Map<String, dynamic>> responses,
    required String fileName,
  }) async {
    final status = await Permission.storage.request();
    if (!status.isGranted) return null;

    final pdf = pw.Document();

    // Load custom font
    final fontData = await rootBundle.load("assets/fonts/Poppins-Regular.ttf");
    final ttf = pw.Font.ttf(fontData);

    // Load logo
    final logoBytes = await rootBundle.load("assets/images/logo.png");
    final logoImage = pw.MemoryImage(logoBytes.buffer.asUint8List());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        build:
            (context) => [
              pw.Row(
                mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                children: [
                  pw.Image(logoImage, width: 80, height: 80),
                  pw.Text(
                    quizTitle,
                    style: pw.TextStyle(
                      font: ttf,
                      fontSize: 24,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                ],
              ),
              pw.SizedBox(height: 20),
              pw.Table.fromTextArray(
                headers: ['ID', 'Score', 'Submitted At'],
                data:
                    responses.map((res) {
                      return [
                        res['id'],
                        res['score'].toString(),
                        DateFormat.yMd().add_jm().format(
                          DateTime.parse(res['submittedAt']),
                        ),
                      ];
                    }).toList(),
                headerStyle: pw.TextStyle(
                  font: ttf,
                  fontWeight: pw.FontWeight.bold,
                ),
                cellStyle: pw.TextStyle(font: ttf),
                cellAlignment: pw.Alignment.centerLeft,
              ),
            ],
      ),
    );

    final outputDir = Directory('/storage/emulated/0/Download');
    if (!outputDir.existsSync()) {
      outputDir.createSync(recursive: true);
    }

    final filePath = '${outputDir.path}/$fileName.pdf';
    final file = File(filePath);
    await file.writeAsBytes(await pdf.save());

    return filePath;
  }
}
