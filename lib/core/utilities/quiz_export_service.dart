import 'dart:io';
import 'package:pdf/widgets.dart' as pw;
import 'package:permission_handler/permission_handler.dart';
import 'package:class_app/features/tutor/quiz/data/models/quiz_model.dart';

class QuizExportService {
  static Future<String?> exportToPdf(
    Quiz quiz, {
    required String fileName,
  }) async {
    final pdf = pw.Document();

    pdf.addPage(
      pw.MultiPage(
        build:
            (context) => [
              pw.Header(
                level: 0,
                child: pw.Text(
                  "Title: ${quiz.title.toUpperCase()}",
                  style: pw.TextStyle(fontSize: 24),
                ),
              ),
              ...quiz.questions.asMap().entries.map((entry) {
                int index = entry.key;
                var question = entry.value;

                // Convert options to A, B, C, D format
                final optionLabels = ['A', 'B', 'C', 'D'];

                return pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      'Q${index + 1}: ${question.question}',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.normal,
                      ),
                    ),
                    pw.SizedBox(height: 5),
                    ...question.options.asMap().entries.map((optEntry) {
                      final label = optionLabels[optEntry.key];
                      final opt = optEntry.value;
                      return pw.Bullet(
                        text: '$label. $opt',
                        style: pw.TextStyle(fontWeight: pw.FontWeight.normal),
                      );
                    }),
                    pw.SizedBox(height: 20),
                  ],
                );
              }),
            ],
      ),
    );

    // Request permissions
    if (!await Permission.storage.request().isGranted) {
      return null;
    }

    // Get Downloads directory (Android only)
    final downloadsDir = Directory('/storage/emulated/0/Download');

    // Ensure the directory exists
    if (!downloadsDir.existsSync()) {
      downloadsDir.createSync(recursive: true);
    }

    final sanitizedFileName = fileName.trim().replaceAll(RegExp(r'\s+'), '_');
    final file = File('${downloadsDir.path}/$sanitizedFileName.pdf');
    await file.writeAsBytes(await pdf.save());

    return file.path;
  }
}
