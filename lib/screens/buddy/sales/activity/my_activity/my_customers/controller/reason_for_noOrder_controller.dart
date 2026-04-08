import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/sales/retailer_complaint_entity.dart';

class ReasonForNoOrderController extends GetxController {
  final String? partyname;
  final String? partyid;
  final String? visitid;

  ReasonForNoOrderController({this.partyname, this.partyid, this.visitid});

  List<Map<String, dynamic>> noOrderListItem = [];

  TextEditingController feedbackController = TextEditingController();

  @override
  void onInit() {
    super.onInit();
    noOrderDataSet();
  }

  void toggleSwitch(int index, bool isOn) {
    noOrderListItem[index]['value'] = isOn;
    update();
  }

  void noOrderDataSet() {
    noOrderListItem = [
      {"reason": 'Shop Closed', "value": false},
      {"reason": 'Owner / Decision Maker Absent', "value": false},
      {"reason": 'Ask To Visit Later', "value": false},
      {"reason": 'Product Not Yet Sold', "value": false},
      {"reason": 'Payment Issue', "value": false},
      {"reason": 'Service Issue', "value": false},
      {"reason": 'Pricing Issue In Market', "value": false},
    ];
  }

  Future<bool> validator() async {
    for (var item in noOrderListItem) {
      if (item['value'] == true) {
        return true;
      }
    }
    return false;
  }

  // Future<void> sendReasonForNoOrder(BuildContext context) async {
  //   bool isValid = await validator();

  //   if (!isValid) {
  //     scaffoldMessageValidationBar(
  //       context,
  //       'Please select reason for no Order',
  //     );
  //     return;
  //   }

  //   DateTime todayDates = DateTime.now();
  //   final DateFormat timeFormatter = DateFormat('dd-MM-yyyy');
  //   String currentDate = timeFormatter.format(todayDates);

  //   RetailerComplaintData retailerComplaintRequestEntity =
  //       RetailerComplaintData();
  //   // retailerComplaintRequestEntity.retailerComplaintData = [];

  //   for (int i = 0; i < noOrderListItem.length; i++) {
  //     if (noOrderListItem[i]['value'] == true) {
  //       RetailerComplaintData noOrderData = RetailerComplaintData(
  //         cOMPANYID: Utility.companyId,
  //         // mOBILENO: Utility.cmpmobileno,
  //         dATE: currentDate,
  //         pARTYID: partyid,
  //         rEASONS: noOrderListItem[i]['reason'],
  //         rEMARK: feedbackController.text,
  //         visitId: visitid,
  //       );

  //       // retailerComplaintRequestEntity.add(noOrderData);
  //     }
  //   }

  //   retailerNoOrderPostCall(context, retailerComplaintRequestEntity);
  // }

Future<void> sendReasonForNoOrder(BuildContext context) async {

  bool isValid = await validator();

  if (!isValid) {
    scaffoldMessageValidationBar(
      context,
      'Please select reason for no Order',
    );
    return;
  }

  DateTime todayDates = DateTime.now();
  final DateFormat timeFormatter = DateFormat('dd-MM-yyyy');
  String currentDate = timeFormatter.format(todayDates);

  RetailerComplaintRequestEntity request = RetailerComplaintRequestEntity();
  request.retailerComplaintData = [];

  for (int i = 0; i < noOrderListItem.length; i++) {

    if (noOrderListItem[i]['value'] == true) {

      request.retailerComplaintData!.add(
        RetailerComplaintData(
          cOMPANYID: Utility.companyId,
          dATE: currentDate,
          pARTYID: partyid,
          rEASONS: noOrderListItem[i]['reason'],
          rEMARK: feedbackController.text,
          visitId: visitid,
        ),
      );

    }

  }

  retailerNoOrderPostCall(context, request);
}

  // void retailerNoOrderPostCall(
  //   BuildContext context,
  //   RetailerComplaintData retailerComplaintRequestEntity,
  // ) {
  //   ApiCall.retailerNoOrderPostCall(
  //     retailerComplaintRequestEntity,
  //     partyid!,
  //   ).then((response) async {
  //     if (response == "Reason For No Order Send Succesfully") {
  //       await Utility.showAlert(
  //         icons: Icons.check_circle_outline,
  //         iconcolor: Colors.lightGreen,
  //         title: 'Done',
  //         msg: 'Reason For No Order Send Succesfully!',
  //       );

  //       Get.back();
  //     } else {
  //       await Utility.showAlert(
  //         icons: Icons.cancel_outlined,
  //         iconcolor: Colors.red,
  //         title: 'Error',
  //         msg: 'Oops there is an error!',
  //       );
  //     }
  //   });
  // }
  void retailerNoOrderPostCall(
  BuildContext context,
  RetailerComplaintRequestEntity request,
) {

  ApiCall.retailerNoOrderPostCall(
    request,
    partyid!,
  ).then((response) async {

    if (response == "Reason For No Order Send Successfully") {

      await Utility.showAlert(
        icons: Icons.check_circle_outline,
        iconcolor: Colors.lightGreen,
        title: 'Done',
        msg: 'Reason For No Order Send Successfully!',
      );

      Get.back();

    } else {

      await Utility.showAlert(
        icons: Icons.cancel_outlined,
        iconcolor: Colors.red,
        title: 'Error',
        msg: 'Oops there is an error!',
      );

    }

  });

}
}
