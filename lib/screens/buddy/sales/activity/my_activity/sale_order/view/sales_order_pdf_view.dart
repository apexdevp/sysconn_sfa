import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:printing/printing.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/sale_order/controller/salesorder_pdfcontroller.dart';
import 'package:sysconn_sfa/widgets/custom_appbar.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class SalesOrderPDFView extends GetView<SalesOrderPdfController> {
  const SalesOrderPDFView({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SfaCustomAppbar(title: '${controller.vchType} pdf'),
      body: PdfPreview(
        canChangePageFormat: false,
        canChangeOrientation: false,
        allowPrinting: true,
        allowSharing: true,
        pdfFileName: '${controller.vchType}.pdf',
        build: (format) async {
          return await controller.generateSOPdf(format);
        },
      ),
    );
  }
}
