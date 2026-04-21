import 'dart:typed_data';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pdf/pdf.dart';
import 'package:pdf/widgets.dart' as pw;
import 'package:printing/printing.dart';
// import 'package:printing/printing.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:sysconn_sfa/Utility/number_to_word.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/order/sales_order_header_entity.dart';
// import 'package:http/http.dart' as http;

class SalesOrderPdfController extends GetxController {
  final SalesOrderHeaderEntity? soHeaderEntity;
  final String vchType;

  SalesOrderPdfController({
    required this.soHeaderEntity,
    required this.vchType,
  });

  /// ================= STATE =================
  final qty = 0.obs;
  final amount = 0.0.obs;
  final gst = 0.0.obs;
  final gstSum = 0.0.obs;
  final cgst = 0.0.obs;
  final isCgstEnable = false.obs;
  final companyLogo = ''.obs;
  int autoincrement = 1;

  @override
  void onInit() {
    super.onInit();

    isCgstEnable.value =
        Utility.companyMasterEntity.companystate ==
        (soHeaderEntity?.state?.trim() ?? '');

    _calculateAll();
    _loadCompanyLogo();
  }

  double getTotalValue(String amount) {
    double creditTotal = 0;

    creditTotal += double.parse(amount);

    return creditTotal;
  }

  pw.Widget _headerValueRow(
    String label,
    String value,
    pw.Font font,
    pw.Font titlefont,
  ) {
    return pw.Column(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.Text(label, style: pw.TextStyle(font: titlefont, fontSize: 9)),
        pw.Expanded(
          child: pw.Text(value, style: pw.TextStyle(font: font, fontSize: 9)),
        ),
      ],
    );
  }

  pw.Widget _keyValueRow(
    String label,
    String value,
    pw.Font font,
    pw.Font titlefont,
  ) {
    return pw.Row(
      crossAxisAlignment: pw.CrossAxisAlignment.start,
      children: [
        pw.SizedBox(
          width: 65,
          child: pw.Text(
            label,
            style: pw.TextStyle(font: titlefont, fontSize: 9),
          ),
        ),
        pw.SizedBox(
          width: 5,
          child: pw.Text(':', style: pw.TextStyle(font: font, fontSize: 9)),
        ),
        pw.Expanded(
          child: pw.Text(value, style: pw.TextStyle(font: font, fontSize: 9)),
        ),
      ],
    );
  }

  // pw.Widget _th(String text, pw.Font font) => pw.Padding(
  //       padding: const pw.EdgeInsets.all(6),
  //       child: pw.Text(text,
  //           style: pw.TextStyle(font: font, fontSize: 8)),
  //     );

  // pw.Widget _th(String text, pw.Font font) => pw.Column( mainAxisAlignment: pw.MainAxisAlignment.end,
  //     children:[ pw.Padding(
  //   padding: const pw.EdgeInsets.all(3),
  //   child:pw.Text(text,
  //       style: pw.TextStyle(font: font, fontSize: 8)))]
  // );

  pw.Widget _th(String text, pw.Font font) {
    return pw.Container(
      alignment: pw.Alignment.center,
      padding: const pw.EdgeInsets.all(3),
      decoration: const pw.BoxDecoration(
        border: pw.Border(bottom: pw.BorderSide(width: 0.5)),
      ),
      child: pw.Text(text, style: pw.TextStyle(font: font, fontSize: 8)),
    );
  }

  pw.Widget _td(
    String text,
    pw.Font font, {
    bool alignRight = false,
    String? description,
  }) {
    return pw.Padding(
      padding: const pw.EdgeInsets.symmetric(vertical: 2, horizontal: 3),
      child: pw.Column(
        crossAxisAlignment: alignRight
            ? pw.CrossAxisAlignment.end
            : pw.CrossAxisAlignment.start,
        children: [
          pw.Text(text, style: pw.TextStyle(font: font, fontSize: 9)),
          if (description != null && description.isNotEmpty)
            pw.Align(
              alignment: pw.Alignment.bottomRight,
              child: pw.Padding(
                padding: const pw.EdgeInsets.only(left: 20, top: 5),
                child: pw.Text(
                  description,
                  style: pw.TextStyle(font: font, fontSize: 6),
                ),
              ),
            ),
        ],
      ),
    );
  }
  // pw.Widget _td(
  //   String text,
  //   pw.Font font, {
  //   bool alignRight = false,
  //   String? description,
  // }) {
  //   return pw.Padding(
  //     padding: const pw.EdgeInsets.all(5),
  //     child: pw.Column(
  //       children: [
  //         pw.Align(
  //           alignment: alignRight
  //               ? pw.Alignment.centerRight
  //               : pw.Alignment.centerLeft,
  //           child: pw.Text(text, style: pw.TextStyle(font: font, fontSize: 8)),
  //         ),
  //         if (description != null)
  //           pw.Align(
  //             alignment: pw.Alignment.bottomRight,
  //             child: pw.Padding(
  //               padding: const pw.EdgeInsets.only(left: 20, top: 5),
  //               child: pw.Text(
  //                 description,
  //                 style: pw.TextStyle(font: font, fontSize: 6),
  //               ),
  //             ),
  //           ),
  //       ],
  //     ),
  //   );
  // }

  String formatDateSafe(String? rawDate) {
    if (rawDate == null) return '';
    if (rawDate.trim().isEmpty) return '';

    try {
      // ISO format (yyyy-MM-dd or full ISO)
      final dt = DateTime.parse(rawDate);
      return DateFormat('dd-MM-yyyy').format(dt);
    } catch (_) {
      try {
        // dd-MM-yyyy fallback
        final dt = DateFormat('dd-MM-yyyy').parse(rawDate);
        return DateFormat('dd-MM-yyyy').format(dt);
      } catch (_) {
        return '';
      }
    }
  }

  //   pw.Widget _totalRow(
  //   String label,
  //   double value,
  //   pw.Font font,
  //   pw.Font boldFont,
  // ) {
  //   return pw.Padding(
  //     padding: const pw.EdgeInsets.symmetric(vertical: 2),
  //     child: pw.Row(
  //       mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
  //       children: [
  //         pw.Text(label, style: pw.TextStyle(font: font, fontSize: 9)),
  //         pw.Text(
  //           value.toStringAsFixed(2),
  //           style: pw.TextStyle(font: font, fontSize: 9),
  //         ),
  //       ],
  //     ),
  //   );
  // }

  /// ================= PDF =================
  Future<Uint8List> generateSOPdf(PdfPageFormat format) async {
    try {
      final pdf = pw.Document();

      final boldFont = pw.Font.helveticaBold();
      final regularFont = pw.Font.helvetica();

      final headerData = soHeaderEntity;
      final inventory = headerData?.inventory ?? [];
      bool? isCgstEnable;
      isCgstEnable =
          Utility.companyMasterEntity.companystate == headerData!.state!.trim();
      // debugPrint('companystate${Utility.companyMasterEntity.companystate.value}');
      // debugPrint('headerData${ headerData.state!.trim()}');
      // debugPrint('headerData${ soHeaderEntity!.toMap()}');
      pw.Widget logoWidget;
      // int totalColumns = isCgstEnable ? 11 : 10;

      if (Utility.companyMasterEntity.companylogo != '') {
        try {
          final logoImage = await networkImage(
            '${Utility.companyMasterEntity.companylogo}',
          );
          logoWidget = pw.Image(logoImage, fit: pw.BoxFit.contain);
        } catch (e) {
          // debugPrint('Failed to load logo: $e');
          logoWidget = pw.Container(width: 100, height: 70);
        }
      } else {
        logoWidget = pw.Container(width: 100, height: 70);
      }
      int totalColumns = 9;
      int beforeAmountCells = totalColumns - 3;
      int srNo = 1;
      double subTotal = 0;
      double cgstTotal = 0;
      double sgstTotal = 0;
      double igstTotal = 0;

      for (var item in inventory) {
        double value = double.tryParse(item.value ?? '0') ?? 0;
        double gstValue = double.tryParse(item.gstValue ?? '0') ?? 0;

        subTotal += value;

        if (isCgstEnable) {
          cgstTotal += gstValue / 2;
          sgstTotal += gstValue / 2;
        } else {
          igstTotal += gstValue;
        }
      }

      double grandTotal = subTotal + cgstTotal + sgstTotal + igstTotal;

      pdf.addPage(
        pw.MultiPage(
          pageFormat: format,
          margin: const pw.EdgeInsets.all(30),

          // ================= HEADER =================
          header: (_) => pw.Column(
            crossAxisAlignment: pw.CrossAxisAlignment.start,
            children: [
              /// TITLE
              pw.Align(
                alignment: pw.Alignment.center,
                child: pw.Text(
                  (vchType == 'Sales Order' || vchType == 'Quotation')
                      ? vchType
                      : 'Tax Invoice',
                  style: pw.TextStyle(font: boldFont, fontSize: 13),
                ),
              ),
              pw.SizedBox(height: 10),

              /// COMPANY + ORDER INFO
              pw.Container(
                decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Padding(
                      padding: const pw.EdgeInsets.only(top: 6),
                      child: pw.Container(
                        width: 100, //150,
                        height: 70,
                        child: logoWidget,
                      ),
                    ),
                    //                 if (logoImage != null)
                    // // pw.Image(
                    // //   logoImage,
                    // //   width: 80,
                    // //   height: 80,
                    // //   fit: pw.BoxFit.contain,
                    // // ),
                    //                  pw.Image(networkimage,width: 80,height: 80,),
                    /// LEFT BLOCK (Company)
                    pw.Container(
                      width: 180,
                      padding: const pw.EdgeInsets.all(8),
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(right: pw.BorderSide(width: 0.5)),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            Utility.companyName,
                            style: pw.TextStyle(font: boldFont, fontSize: 9),
                          ),
                          pw.Text(
                            Utility.companyMasterEntity.companyaddress01 ?? '',
                            style: pw.TextStyle(font: regularFont, fontSize: 9),
                          ),
                          pw.Text(
                            Utility.companyMasterEntity.companyaddress02 ?? '',
                            style: pw.TextStyle(font: regularFont, fontSize: 9),
                          ),
                          pw.Text(
                            Utility.companyMasterEntity.companycountry ?? '',
                            style: pw.TextStyle(font: regularFont, fontSize: 9),
                          ),
                          pw.Row(
                            children: [
                              pw.Text(
                                Utility.companyMasterEntity.companystate ?? '',
                                style: pw.TextStyle(
                                  font: regularFont,
                                  fontSize: 9,
                                ),
                              ),
                              pw.SizedBox(width: 10),
                              pw.Text(
                                Utility.companyMasterEntity.companypincode ??
                                    '',
                                style: pw.TextStyle(
                                  font: regularFont,
                                  fontSize: 9,
                                ),
                              ),
                            ],
                          ),
                          pw.SizedBox(height: 4),
                          _keyValueRow(
                            'GSTIN',
                            Utility.companyMasterEntity.companygstin ?? '',
                            regularFont,
                            boldFont,
                          ),
                        ],
                      ),
                    ),

                    /// RIGHT BLOCK (Order Details with Borders)
                    pw.Expanded(
                      child: pw.Container(
                        decoration: const pw.BoxDecoration(
                          border: pw.Border(left: pw.BorderSide(width: 0.5)),
                        ),
                        child: pw.Container(
                          height: 90, // total height of both rows
                          child: pw.Column(
                            children: [
                              /// ROW 1
                              pw.Expanded(
                                child: pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.stretch,
                                  children: [
                                    pw.Expanded(
                                      child: pw.Container(
                                        alignment: pw.Alignment.centerLeft,
                                        padding: const pw.EdgeInsets.all(8),
                                        decoration: const pw.BoxDecoration(
                                          border: pw.Border(
                                            right: pw.BorderSide(width: 0.5),
                                            bottom: pw.BorderSide(width: 0.5),
                                          ),
                                        ),
                                        child: _headerValueRow(
                                          (vchType == 'Sales Order')
                                              ? 'Order No'
                                              : 'Invoice No',
                                          headerData.invoiceNo ?? '',
                                          regularFont,
                                          boldFont,
                                        ),
                                      ),
                                    ),
                                    pw.Expanded(
                                      child: pw.Container(
                                        alignment: pw.Alignment.centerLeft,
                                        padding: const pw.EdgeInsets.all(8),
                                        decoration: const pw.BoxDecoration(
                                          border: pw.Border(
                                            bottom: pw.BorderSide(width: 0.5),
                                          ),
                                        ),
                                        child: _headerValueRow(
                                          'Date',
                                          formatDateSafe(headerData.date),
                                          regularFont,
                                          boldFont,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),

                              /// ROW 2
                              pw.Expanded(
                                child: pw.Row(
                                  crossAxisAlignment:
                                      pw.CrossAxisAlignment.stretch,
                                  children: [
                                    pw.Expanded(
                                      child: pw.Container(
                                        alignment: pw.Alignment.centerLeft,
                                        padding: const pw.EdgeInsets.all(8),
                                        decoration: const pw.BoxDecoration(
                                          border: pw.Border(
                                            right: pw.BorderSide(width: 0.5),
                                          ),
                                        ),
                                        child: _headerValueRow(
                                          'Due Date',
                                          formatDateSafe(
                                            headerData.orderDueDate,
                                          ),
                                          regularFont,
                                          boldFont,
                                        ),
                                      ),
                                    ),
                                    pw.Expanded(
                                      child: pw.Container(
                                        alignment: pw.Alignment.centerLeft,
                                        padding: const pw.EdgeInsets.all(8),
                                        child: _headerValueRow(
                                          'Sales Person',
                                          headerData.salesPersonName ?? '',
                                          regularFont,
                                          boldFont,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),

              /// BILLED TO
              pw.Container(
                decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
                child: pw.Row(
                  crossAxisAlignment: pw.CrossAxisAlignment.start,
                  children: [
                    pw.Container(
                      width: 280,
                      padding: const pw.EdgeInsets.all(8),
                      decoration: const pw.BoxDecoration(
                        border: pw.Border(right: pw.BorderSide(width: 0.5)),
                      ),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Billed To ,',
                            style: pw.TextStyle(font: boldFont, fontSize: 9),
                          ),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            headerData.partyName ?? '',
                            style: pw.TextStyle(font: boldFont, fontSize: 9),
                          ),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            headerData.address ?? '',
                            style: pw.TextStyle(font: regularFont, fontSize: 9),
                          ),
                          pw.SizedBox(height: 6),
                          _keyValueRow(
                            'Mobile Numer',
                            headerData.mobileNo ?? '',
                            regularFont,
                            boldFont,
                          ),
                          _keyValueRow(
                            'State',
                            headerData.state ?? '',
                            regularFont,
                            boldFont,
                          ),
                          _keyValueRow(
                            'GSTIN',
                            headerData.gstin ?? '',
                            regularFont,
                            boldFont,
                          ),
                        ],
                      ),
                    ),

                    /// RIGHT BLOCK (Order Details with Borders)
                    pw.Container(
                      width: 280,
                      padding: const pw.EdgeInsets.all(8),
                      // decoration: const pw.BoxDecoration(
                      //   border:pw.Border(right: pw.BorderSide(width: 0.5)),),
                      child: pw.Column(
                        crossAxisAlignment: pw.CrossAxisAlignment.start,
                        children: [
                          pw.Text(
                            'Shipped To ,',
                            style: pw.TextStyle(font: boldFont, fontSize: 9),
                          ),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            headerData.shippedToName ?? '',
                            style: pw.TextStyle(font: boldFont, fontSize: 9),
                          ),
                          pw.SizedBox(height: 3),
                          pw.Text(
                            headerData.shippedToAddress1 ?? '',
                            style: pw.TextStyle(font: regularFont, fontSize: 9),
                          ),
                          pw.Text(
                            headerData.shippedToAddress2 ?? '',
                            style: pw.TextStyle(font: regularFont, fontSize: 9),
                          ),

                          pw.SizedBox(height: 6),
                          // _keyValueRow(
                          //     'Mobile Numer', headerData?.mobileNo ?? '', regularFont,boldFont),
                          _keyValueRow(
                            'State',
                            headerData.shippedToState ?? '',
                            regularFont,
                            boldFont,
                          ),
                          _keyValueRow(
                            'GSTIN',
                            headerData.shippedToGstin ?? '',
                            regularFont,
                            boldFont,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),

          // ================= BODY =================
          build: (_) => [
            /// ITEM TABLE
            // pw.Table(
            //   //border: pw.TableBorder.all(width: 0.5),

            //   columnWidths: const {
            //     0: pw.FractionColumnWidth(0.05),
            //     1: pw.FractionColumnWidth(0.40),
            //     2: pw.FractionColumnWidth(0.10),
            //     3: pw.FractionColumnWidth(0.10),
            //     4: pw.FractionColumnWidth(0.10),
            //     5: pw.FractionColumnWidth(0.10),
            //     6: pw.FractionColumnWidth(0.10),
            //     7: pw.FractionColumnWidth(0.15),
            //     8: pw.FractionColumnWidth(0.20),
            //   },
            pw.Table(
              border: pw.TableBorder(
                left: const pw.BorderSide(width: 0.5),
                right: const pw.BorderSide(width: 0.5),
                top: const pw.BorderSide(width: 0.5),
                bottom: const pw.BorderSide(width: 0.5),
                verticalInside: const pw.BorderSide(width: 0.3),
              ),
              columnWidths:
                  // isCgstEnable!
                  //     ? const {
                  //         0: pw.FractionColumnWidth(0.05),
                  //         1: pw.FractionColumnWidth(0.40),
                  //         2: pw.FractionColumnWidth(0.10),
                  //         3: pw.FractionColumnWidth(0.08),
                  //         4: pw.FractionColumnWidth(0.09),
                  //         5: pw.FractionColumnWidth(0.11),
                  //         6: pw.FractionColumnWidth(0.12),
                  //         7: pw.FractionColumnWidth(0.09),
                  //         8: pw.FractionColumnWidth(0.09),
                  //         9: pw.FractionColumnWidth(0.09),
                  //         10: pw.FractionColumnWidth(0.18),
                  //       }
                  const {
                    0: pw.FractionColumnWidth(0.05),
                    1: pw.FractionColumnWidth(0.45),
                    2: pw.FractionColumnWidth(0.10),
                    3: pw.FractionColumnWidth(0.08),
                    4: pw.FractionColumnWidth(0.09),
                    5: pw.FractionColumnWidth(0.11),
                    6: pw.FractionColumnWidth(0.12),
                    7: pw.FractionColumnWidth(0.12),
                    8: pw.FractionColumnWidth(0.18),
                    9: pw.FractionColumnWidth(0.18),
                  },
              children: [
                /// HEADER
                pw.TableRow(
                  children: [
                    _th('Sr', boldFont),
                    _th('Item Name', boldFont),
                    _th('HSN', boldFont),
                    _th('Qty', boldFont),
                    _th('Rate', boldFont),
                    _th('Unit', boldFont),
                    _th('Discount', boldFont),
                    _th('GST %', boldFont),
                    _th('Amount', boldFont),
                  ],
                ),

                /// ITEMS
                ...inventory.map((item) {
                  // double gstValue = double.tryParse(item.gstValue ?? '0') ?? 0;

                  return pw.TableRow(
                    children: [
                      _td('${srNo++}', regularFont),
                      _td(
                        item.itemName ?? '',
                        regularFont,
                        description: item.remark,
                      ),
                      _td(item.hsncode ?? '', regularFont, alignRight: true),
                      _td('${item.qty ?? 0}', regularFont, alignRight: true),
                      _td(
                        (double.tryParse(item.rate ?? '0') ?? 0)
                            .toStringAsFixed(2),
                        regularFont,
                        alignRight: true,
                      ),
                      _td(item.unitname ?? '', regularFont),
                      _td(
                        '${item.discount ?? 0}',
                        regularFont,
                        alignRight: true,
                      ),
                      _td(
                        '${item.gstRate ?? 0}',
                        regularFont,
                        alignRight: true,
                      ),
                      _td(
                        (double.tryParse(item.value ?? '0') ?? 0)
                            .toStringAsFixed(2),
                        regularFont,
                        alignRight: true,
                      ),
                    ],
                  );
                }),

                /// SUB TOTAL
                pw.TableRow(
                  children: [
                    pw.Container(),
                    _td('Sub Total', boldFont, alignRight: true),
                    ...List.generate(beforeAmountCells, (_) => pw.Container()),
                    _td(
                      subTotal.toStringAsFixed(2),
                      boldFont,
                      alignRight: true,
                    ),
                  ],
                ),

                /// CGST + SGST (INTRA STATE)
                if (isCgstEnable!) ...[
                  pw.TableRow(
                    children: [
                      pw.Container(),
                      _td('CGST', boldFont, alignRight: true),
                      ...List.generate(
                        beforeAmountCells,
                        (_) => pw.Container(),
                      ),
                      _td(
                        cgstTotal.toStringAsFixed(2),
                        boldFont,
                        alignRight: true,
                      ),
                    ],
                  ),

                  pw.TableRow(
                    children: [
                      pw.Container(),
                      _td('SGST', boldFont, alignRight: true),
                      ...List.generate(
                        beforeAmountCells,
                        (_) => pw.Container(),
                      ),
                      _td(
                        sgstTotal.toStringAsFixed(2),
                        boldFont,
                        alignRight: true,
                      ),
                    ],
                  ),
                ] else ...[
                  /// IGST (INTER STATE)
                  pw.TableRow(
                    children: [
                      pw.Container(),
                      _td('IGST', boldFont, alignRight: true),
                      ...List.generate(
                        beforeAmountCells,
                        (_) => pw.Container(),
                      ),
                      _td(
                        igstTotal.toStringAsFixed(2),
                        boldFont,
                        alignRight: true,
                      ),
                    ],
                  ),
                ],

                /// GRAND TOTAL
                pw.TableRow(
                  decoration: pw.BoxDecoration(
                    color: PdfColors.grey200,
                    border: pw.TableBorder(
                      top: const pw.BorderSide(width: 0.5),
                    ),
                  ),
                  children: [
                    pw.Container(),
                    _td('Grand Total', boldFont, alignRight: true),
                    ...List.generate(beforeAmountCells, (_) => pw.Container()),
                    _td(
                      grandTotal.toStringAsFixed(2),
                      boldFont,
                      alignRight: true,
                    ),
                  ],
                ),
              ],
            ),

            /// REMARK + SIGNATURE
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(
                        width: 100,
                        child: pw.Text(
                          'Amount (in words) :',
                          style: pw.TextStyle(font: boldFont, fontSize: 9),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          NumberToWord().convertToWords(
                            getTotalValue(amount.toString()).round(),
                          ),
                          style: pw.TextStyle(font: regularFont, fontSize: 9),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            pw.Container(
              padding: const pw.EdgeInsets.all(8),
              decoration: pw.BoxDecoration(border: pw.Border.all(width: 0.5)),
              child: pw.Column(
                crossAxisAlignment: pw.CrossAxisAlignment.start,
                children: [
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(
                        width: 100,
                        child: pw.Text(
                          'Company\'s  PAN :',
                          style: pw.TextStyle(font: boldFont, fontSize: 9),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          Utility.companyMasterEntity.panno!,
                          style: pw.TextStyle(font: regularFont, fontSize: 9),
                        ),
                      ),
                    ],
                  ),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.SizedBox(
                        width: 100,
                        child: pw.Text(
                          'Remark :',
                          style: pw.TextStyle(font: boldFont, fontSize: 9),
                        ),
                      ),
                      pw.Expanded(
                        child: pw.Text(
                          headerData.narration ?? '',
                          style: pw.TextStyle(font: regularFont, fontSize: 9),
                        ),
                      ),
                    ],
                  ),
                  if (headerData.termncondition != '') pw.SizedBox(height: 20),
                  if (headerData.termncondition != '')
                    pw.Row(
                      children: [
                        pw.Text(
                          'Terms & Condition',
                          style: pw.TextStyle(
                            font: boldFont,
                            fontSize: 9.0,
                            decoration: pw.TextDecoration.underline,
                          ),
                        ),
                      ],
                    ),
                  // pw.Row(
                  //   children: [
                  //     pw.Text(
                  //       headerData.termncondition!,
                  //       style: pw.TextStyle(font: regularFont, fontSize: 8.0),
                  //     ),
                  //   ],
                  // ),
                  pw.Row(
                    crossAxisAlignment: pw.CrossAxisAlignment.start,
                    children: [
                      pw.Expanded(
                        child: pw.Text(
                          headerData.termncondition ?? '',
                          style: pw.TextStyle(font: regularFont, fontSize: 8.0),
                        ),
                      ),
                    ],
                  ),
                  pw.SizedBox(height: 40),
                  pw.Row(
                    mainAxisAlignment: pw.MainAxisAlignment.spaceBetween,
                    children: [
                      pw.Text(
                        'Customer Signature',
                        style: pw.TextStyle(font: regularFont, fontSize: 9),
                      ),
                      pw.Text(
                        'Authorised Signatory',
                        style: pw.TextStyle(font: regularFont, fontSize: 9),
                      ),
                    ],
                  ),
                  // pw.Column(
                  //   crossAxisAlignment: pw.CrossAxisAlignment.start,
                  //   children: [
                  //     pw.Text('Company Bank Details',style: pw.TextStyle(fontWeight: pw.FontWeight.bold)),
                  //     _keyValueRow(
                  //       'Bank Name',
                  //       Utility.companyMasterEntity.panno.value!,
                  //       regularFont,
                  //       boldFont,
                  //     ),
                  //     if ((headerData.narration ?? '').isNotEmpty)
                  //       _keyValueRow(
                  //         'Remark',
                  //         headerData.narration ?? '',
                  //         regularFont,
                  //         boldFont,
                  //       )
                  //       ],
                  // )
                ],
              ),
            ),
          ],
        ),
      );

      return pdf.save();
    } catch (e, stack) {
      debugPrint('PDF GENERATION ERROR: $e');
      debugPrintStack(stackTrace: stack);
      rethrow;
    }
  }

  Future<void> _loadCompanyLogo() async {
    final prefs = await SharedPreferences.getInstance();
    companyLogo.value = prefs.getString('cmp_logo_image') ?? '';
  }

  void _calculateAll() {
    _getQty();
    _getAmount();
    _getGST();
    _getCGST();
    _getSumGST();
  }

  void _getQty() {
    qty.value = 0;
    for (final item in soHeaderEntity?.inventory ?? []) {
      qty.value += int.tryParse(item.qty ?? '0') ?? 0;
    }
  }

  void _getAmount() {
    amount.value = 0.0;
    for (final item in soHeaderEntity?.inventory ?? []) {
      amount.value += double.tryParse(item.value ?? '0') ?? 0;
    }
  }

  void _getGST() {
    gst.value = 0.0;
    for (final item in soHeaderEntity?.inventory ?? []) {
      gst.value = double.tryParse(item.gstValue ?? '0') ?? 0;
    }
  }

  void _getCGST() {
    cgst.value = 0.0;
    for (final item in soHeaderEntity?.inventory ?? []) {
      cgst.value += (double.tryParse(item.gstValue ?? '0') ?? 0) / 2;
    }
  }

  void _getSumGST() {
    gstSum.value = 0.0;
    for (final item in soHeaderEntity?.inventory ?? []) {
      // debugPrint('object${item.gstValue}');
      gstSum.value += double.tryParse(item.gstValue ?? '0') ?? 0;
    }
  }
}
