import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/screens/expenses/report/admin/exp_approval/controller/exp_approval_document_controller.dart';
import 'package:sysconn_sfa/widgets/custom_appbar.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';


// class ExpApproveDocument extends StatelessWidget {
class ExpApproveDocument
    extends GetView<ExpApproveDocumentController> {
  // final String documentPath;
  const ExpApproveDocument({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: SfaCustomAppbar( title: 'Display Document'),
      body: Center(child: Image.network(controller.documentPath)),
    );
  }
}
