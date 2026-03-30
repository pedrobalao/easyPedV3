import 'dart:typed_data';

import 'package:easypedv3/models/drug.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;

/// Service for generating PDF documents from drug and dose calculation data.
class PdfService {
  /// Generates a PDF document containing drug information and dose calculation
  /// results.
  static Future<Uint8List> generateDoseCalculationPdf({
    required Drug drug,
    required List<DoseCalculationResult> results,
    required Map<dynamic, dynamic> variables,
  }) async {
    final pdf = pw.Document();
    final now = DateFormat('dd/MM/yyyy HH:mm').format(DateTime.now());

    pdf.addPage(
      pw.MultiPage(
        pageFormat: PdfPageFormat.a4,
        margin: const pw.EdgeInsets.all(32),
        header: (context) => pw.Column(
          crossAxisAlignment: pw.CrossAxisAlignment.start,
          children: [
            pw.Row(
              mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
              children: [
                pw.Text(
                  'easyPed',
                  style: pw.TextStyle(
                    fontSize: 24,
                    fontWeight: pw.FontWeight.bold,
                    color: const PdfColor.fromInt(0xFF2963C8),
                  ),
                ),
                pw.Text(
                  now,
                  style: const pw.TextStyle(fontSize: 10),
                ),
              ],
            ),
            pw.Divider(),
            pw.SizedBox(height: 8),
          ],
        ),
        footer: (context) => pw.Container(
          alignment: pw.Alignment.centerRight,
          margin: const pw.EdgeInsets.only(top: 8),
          child: pw.Text(
            'Gerado pela aplicação easyPed — Confirme sempre com fontes '
            'de referência atualizadas.',
            style: const pw.TextStyle(fontSize: 8),
          ),
        ),
        build: (context) => [
          // Drug name
          pw.Text(
            drug.name ?? 'Medicamento',
            style: pw.TextStyle(
              fontSize: 20,
              fontWeight: pw.FontWeight.bold,
            ),
          ),
          pw.SizedBox(height: 8),
          // Presentation
          if (drug.presentation != null && drug.presentation!.isNotEmpty)
            _buildInfoRow('Apresentação', drug.presentation!),
          // Commercial brands
          if (drug.comercialBrands != null && drug.comercialBrands!.isNotEmpty)
            _buildInfoRow('Marcas Comerciais', drug.comercialBrands!),
          pw.SizedBox(height: 16),
          // Input variables
          pw.Text(
            'Parâmetros de Cálculo',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: const PdfColor.fromInt(0xFF2963C8),
            ),
          ),
          pw.SizedBox(height: 8),
          if (drug.variables != null)
            ...drug.variables!.map((v) {
              final value = variables[v.id];
              final label = v.description ?? v.id ?? 'Parâmetro';
              return _buildInfoRow(
                label,
                '$value ${v.idUnit ?? ""}',
              );
            }),
          pw.SizedBox(height: 16),
          // Results
          pw.Text(
            'Resultados do Cálculo',
            style: pw.TextStyle(
              fontSize: 16,
              fontWeight: pw.FontWeight.bold,
              color: const PdfColor.fromInt(0xFF2963C8),
            ),
          ),
          pw.SizedBox(height: 8),
          ...results.map(
            (result) => pw.Container(
              margin: const pw.EdgeInsets.only(bottom: 8),
              padding: const pw.EdgeInsets.all(12),
              decoration: pw.BoxDecoration(
                border: pw.Border.all(
                  color: const PdfColor.fromInt(0xFF28a745),
                ),
                borderRadius: pw.BorderRadius.circular(4),
              ),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Text(
                    result.description ?? '',
                    style: pw.TextStyle(
                      fontSize: 14,
                      fontWeight: pw.FontWeight.bold,
                    ),
                  ),
                  pw.SizedBox(height: 4),
                  pw.Text(
                    '${result.result} ${result.resultIdUnit ?? ""}',
                    style: pw.TextStyle(
                      fontSize: 18,
                      fontWeight: pw.FontWeight.bold,
                      color: const PdfColor.fromInt(0xFF28a745),
                    ),
                  ),
                  if (result.resultDescription != null &&
                      result.resultDescription!.isNotEmpty)
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 4),
                      child: pw.Text(
                        result.resultDescription!,
                        style: const pw.TextStyle(fontSize: 10),
                      ),
                    ),
                ],
              ),
            ),
          ),
          // Dose reference table
          if (drug.indications != null && drug.indications!.isNotEmpty) ...[
            pw.SizedBox(height: 16),
            pw.Text(
              'Doses por Indicação',
              style: pw.TextStyle(
                fontSize: 16,
                fontWeight: pw.FontWeight.bold,
                color: const PdfColor.fromInt(0xFF2963C8),
              ),
            ),
            pw.SizedBox(height: 8),
            ...drug.indications!.map(
              (indication) => pw.Container(
                margin: const pw.EdgeInsets.only(bottom: 8),
                child: pw.Column(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Text(
                      indication.indicationText ?? '',
                      style: pw.TextStyle(
                        fontSize: 12,
                        fontWeight: pw.FontWeight.bold,
                      ),
                    ),
                    if (indication.doses != null)
                      pw.Table(
                        border: pw.TableBorder.all(
                          color: PdfColors.grey300,
                          width: 0.5,
                        ),
                        children: [
                          pw.TableRow(
                            decoration: const pw.BoxDecoration(
                              color: PdfColors.grey100,
                            ),
                            children: [
                              _tableCell('Via', bold: true),
                              _tableCell('Dose Pediátrica', bold: true),
                              _tableCell('Dose Adulto', bold: true),
                              _tableCell('Tomas/dia', bold: true),
                              _tableCell('Max. Diária', bold: true),
                            ],
                          ),
                          ...indication.doses!.map(
                            (dose) => pw.TableRow(
                              children: [
                                _tableCell(dose.idVia ?? '-'),
                                _tableCell(
                                  '${dose.pediatricDose ?? "-"} '
                                  '${dose.idUnityPediatricDose ?? ""}',
                                ),
                                _tableCell(
                                  '${dose.adultDose ?? "-"} '
                                  '${dose.idUnityAdultDose ?? ""}',
                                ),
                                _tableCell(dose.takesPerDay ?? '-'),
                                _tableCell(
                                  '${dose.maxDosePerDay ?? "-"} '
                                  '${dose.idUnityMaxDosePerDay ?? ""}',
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                  ],
                ),
              ),
            ),
          ],
        ],
      ),
    );

    return pdf.save();
  }

  static pw.Widget _buildInfoRow(String label, String value) {
    return pw.Padding(
      padding: const pw.EdgeInsets.only(bottom: 4),
      child: pw.Row(
        crossAxisAlignment: pw.CrossAxisAlignment.start,
        children: [
          pw.SizedBox(
            width: 140,
            child: pw.Text(
              label,
              style: pw.TextStyle(
                fontSize: 12,
                fontWeight: pw.FontWeight.bold,
              ),
            ),
          ),
          pw.Expanded(
            child: pw.Text(value, style: const pw.TextStyle(fontSize: 12)),
          ),
        ],
      ),
    );
  }

  static pw.Widget _tableCell(String text, {bool bold = false}) {
    return pw.Padding(
      padding: const pw.EdgeInsets.all(4),
      child: pw.Text(
        text,
        style: pw.TextStyle(
          fontSize: 9,
          fontWeight: bold ? pw.FontWeight.bold : null,
        ),
      ),
    );
  }
}
