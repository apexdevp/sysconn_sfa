import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/sales/sales_header_entity.dart';

class AdditionalDetailsController extends GetxController {
  final SalesHeaderEntity salesHeaderEntity;

  AdditionalDetailsController({required this.salesHeaderEntity});

  // ================= TEXT EDITING CONTROLLERS =================

  final dateController = TextEditingController();
  final vehicleController = TextEditingController();
  final dispatchController = TextEditingController();
  final mailingController = TextEditingController();
  final partyNameController = TextEditingController();

  final addressBilledController = TextEditingController();
  final addressBilled2Controller = TextEditingController();
  final gstinBilledController = TextEditingController();

  final consigneeController = TextEditingController();
  final addressShippedController = TextEditingController();
  final addressShipped2Controller = TextEditingController();
  final gstinShippedController = TextEditingController();
  final cityController = TextEditingController();
  final pincodeController = TextEditingController();

  // ================= RX (Only Where Needed) =================

  RxString stateBilled = ''.obs;
  RxString stateShipped = ''.obs;

  // ================= DATE =================

  DateTime selectedDate = DateTime.now();
  final dateFormat = DateFormat("dd/MM/yyyy");

  @override
  void onInit() {
    super.onInit();
    loadInitialData();
  }

  // ================= LOAD INITIAL DATA =================

  void loadInitialData() {
    final sh = salesHeaderEntity;

    dateController.text = sh.date ?? '';
    vehicleController.text = sh.vehicleNo ?? '';
    dispatchController.text = sh.despatchedthrough ?? '';
    mailingController.text = sh.mailingName ?? '';
    partyNameController.text = sh.partyName ?? '';

    addressBilledController.text = sh.address ?? '';
    addressBilled2Controller.text = sh.billedaddress2 ?? '';
    gstinBilledController.text = sh.gstin ?? '';

    consigneeController.text = sh.consigneename ?? '';
    addressShippedController.text = sh.shippedtoaddress ?? '';
    addressShipped2Controller.text = sh.shippedtoaddress2 ?? '';
    gstinShippedController.text = sh.shippedtogstin ?? '';
    cityController.text = sh.shippedTocity ?? '';
    pincodeController.text = sh.shippedTopincode ?? '';

    stateBilled.value = sh.state ?? '';
    stateShipped.value = sh.shippedToState ?? '';
  }

  // ================= SAVE FUNCTION =================

  Future<void> saveAdditionalDetails() async {
    final sh = SalesHeaderEntity()
      ..companyId = Utility.companyId
      ..uniqueId = salesHeaderEntity.uniqueId
      ..date = dateController.text
      ..vehicleNo = vehicleController.text
      ..despatchedthrough = dispatchController.text
      ..mailingName = mailingController.text
      ..partyName = partyNameController.text
      ..address = addressBilledController.text
      ..gstin = gstinBilledController.text
      ..state = stateBilled.value
      ..consigneename = consigneeController.text
      ..shippedtoaddress = addressShippedController.text
      ..shippedtogstin = gstinShippedController.text
      ..shippedToState = stateShipped.value
      ..shippedTocity = cityController.text
      ..shippedTopincode = pincodeController.text;

    Utility.showCircularLoadingWid(Get.context!);

    final response = await ApiCall.additiondDetPostApi(sh);

    if (Get.isDialogOpen ?? false) Get.back(); // Close loader

    if (response == 'Data Updated Successfully') {
      print('success');
      // await Utility.showAlert(
      //   icons: Icons.check,
      //   iconcolor: Colors.green,
      //   title: 'Status',
      //   msg: 'Data Inserted Successfully',
      // );

      // Get.back(result: true); // Close dialog
    } else {
      Get.snackbar(
        'Error',
        'Oops, there is an Error!',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
    }
  }

  // ================= DISPOSE CONTROLLERS =================

  @override
  void onClose() {
    dateController.dispose();
    vehicleController.dispose();
    dispatchController.dispose();
    mailingController.dispose();
    partyNameController.dispose();
    addressBilledController.dispose();
    gstinBilledController.dispose();
    consigneeController.dispose();
    addressShippedController.dispose();
    gstinShippedController.dispose();
    cityController.dispose();
    pincodeController.dispose();
    super.onClose();
  }
}
