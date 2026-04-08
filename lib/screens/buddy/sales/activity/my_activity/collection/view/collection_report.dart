import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/floating_point_action_button.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/collection/controller/collection_report_controller.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/collection/view/collection_create.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class CollectionReport extends StatelessWidget {
  final String type;
  CollectionReport({super.key, required this.type});


  @override
  Widget build(BuildContext context) {
    final CollectionReportController controller = Get.put(
      CollectionReportController(type),
    );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Collection Register'),
      floatingActionButton: FloatingButton(
        isExtended: false,

        icon: Icon(Icons.add),
        function: () async {
          await Get.to(() => CollectionCreate(vchType: type));
        },
      ),
      body: Column(
        children: [
         ],
      ),
    );
  }
}
