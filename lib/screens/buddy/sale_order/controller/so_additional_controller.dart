import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/order/sales_order_header_entity.dart';


class SOAdditionalDetailsController extends GetxController {
  // --- Reactive Fields ---
  var vehicleNo = ''.obs;
  var lrDate = ''.obs;
  var dispatchThrough = ''.obs;
  var mailingName = ''.obs;
  var partyName = ''.obs;
  var mobileNo = ''.obs;
  var consigneeName = ''.obs;
  var addressShipped = ''.obs;
  var addressShipped2 = ''.obs;
  var gstinShipped = ''.obs;
  var stateShipped = ''.obs;
  var eWBDate = ''.obs;
  var remark = ''.obs;
  var addressbilled = ''.obs;
  var address2billed = ''.obs;
  var statebilled = ''.obs;
  var gstbilled = ''.obs;

  // --- Text Controllers ---
  final vehicleNameController = TextEditingController();
  final dateController = TextEditingController();
  final dispatchController = TextEditingController();
  final mailingNameController = TextEditingController();
  final partyNameController = TextEditingController();
  final mobileNumberController = TextEditingController();
  final consigneeNameController = TextEditingController();
  final addressShippedLine1Controller = TextEditingController();
  final addressShippedLine2Controller = TextEditingController();
  final gstinShippedController = TextEditingController();
  final stateShippedController = TextEditingController();
  final eWBDateController = TextEditingController();
  final remarkController = TextEditingController();
  final addressBilledLine1Controller = TextEditingController();
  final addressBilledLine2Controller = TextEditingController();
  final stateBilledController = TextEditingController();
  final gstinBilledController = TextEditingController();

  var selectedDate = DateTime.now().obs;
  final dateFormat = DateFormat("dd/MM/yyyy");

  // Entity reference
  Rxn<SalesOrderHeaderEntity> entity = Rxn<SalesOrderHeaderEntity>();

  // ----------------------------------------------------------
  // Load entity ONLY ONCE
  // ----------------------------------------------------------
  void loadEntityOnce(SalesOrderHeaderEntity? e) {
    if (entity.value == null && e != null) {
      _loadEntity(e);
    }
  }
  

  // ----------------------------------------------------------
  // Populate reactive variables and controllers
  // ----------------------------------------------------------
  void _loadEntity(SalesOrderHeaderEntity? e) {
    entity.value = e;

    if (e == null) return;

    // debugPrint('shippedToAddress2 ${e.shippedToAddress2}');

    vehicleNo.value = e.vehicleNo ?? '';
    lrDate.value = e.lrDate ?? '';
    dispatchThrough.value = e.despatchedThrough ?? '';
    mailingName.value = e.mailingName ?? '';
    partyName.value = e.partyName ?? '';
    mobileNo.value = e.partyMobileNo ?? '';
    consigneeName.value = e.shippedToName ?? '';
    addressShipped.value = e.shippedToAddress1 ?? '';
    addressShipped2.value = e.shippedToAddress2 ?? '';
    gstinShipped.value = e.shippedToGstin ?? '';
    stateShipped.value = e.shippedToState ?? '';
    eWBDate.value = e.orderDueDate ?? '';
    remark.value = e.narration ?? '';
    addressbilled.value = e.address ?? '';
    address2billed.value = e.billaddress2 ?? '';
    gstbilled.value = e.gstin ?? '';
    statebilled.value = e.state ?? '';

    // Sync Text Fields
    vehicleNameController.text = vehicleNo.value;
    dateController.text = lrDate.value;
    dispatchController.text = dispatchThrough.value;
    mailingNameController.text = mailingName.value;
    partyNameController.text = partyName.value;
    mobileNumberController.text = mobileNo.value;
    consigneeNameController.text = consigneeName.value;
    addressShippedLine1Controller.text = addressShipped.value;
    addressShippedLine2Controller.text = addressShipped2.value;
    gstinShippedController.text = gstinShipped.value;
    stateShippedController.text = stateShipped.value;
    eWBDateController.text = eWBDate.value;
    remarkController.text = remark.value;
    addressBilledLine1Controller.text = addressbilled.value;
    addressBilledLine2Controller.text = address2billed.value;
    stateBilledController.text = statebilled.value;
    gstinBilledController.text = gstbilled.value;

    // debugPrint('addressBilledController $addressBilledController');
    // debugPrint('gstinBilledController $gstinBilledController');
    // debugPrint('stateBilledController $stateBilledController');
    // debugPrint('stateShippedController $stateShippedController');
    // debugPrint('addressShippedController $addressShippedController');
    // debugPrint('mailingNameController $mailingNameController');
  }

  // ----------------------------------------------------------
  // Update reactive fields from controllers
  // ----------------------------------------------------------
  void updateFromControllers() {
    vehicleNo.value = vehicleNameController.text;
    lrDate.value = dateController.text;
    dispatchThrough.value = dispatchController.text;
    mailingName.value = mailingNameController.text;
    partyName.value = partyNameController.text;
    mobileNo.value = mobileNumberController.text;
    consigneeName.value = consigneeNameController.text;
    addressShipped.value = addressShippedLine1Controller.text;
    addressShipped2.value = addressShippedLine2Controller.text;
    gstinShipped.value = gstinShippedController.text;
    stateShipped.value = stateShippedController.text;
    eWBDate.value = eWBDateController.text;
    remark.value = remarkController.text;
    addressbilled.value = addressBilledLine1Controller.text;
    address2billed.value = addressBilledLine2Controller.text;
    gstbilled.value = gstinBilledController.text;
    statebilled.value = stateBilledController.text;
  }

  // ----------------------------------------------------------
  // Convert DD/MM/YYYY → YYYY-MM-DD safely
  // ----------------------------------------------------------
  String convertToYMD(String dateStr) {
    if (dateStr.isEmpty) return "";
    try {
      final d = DateFormat("dd/MM/yyyy").parse(dateStr);
      return DateFormat("yyyy-MM-dd").format(d);
    } catch (_) {
      return "";
    }
  }

  // ----------------------------------------------------------
  // Post API
  // ----------------------------------------------------------
  Future<void> postSOHeaderBillTo() async {
    if (entity.value == null) return;

    updateFromControllers();

    final hed = SalesOrderHeaderEntity();
    // hed.groupId = Utility.groupId;
    hed.companyId = Utility.companyId;
    hed.mobileNo = Utility.cmpmobileno;
    hed.uniqueId = entity.value!.uniqueId;

    hed.vehicleNo = vehicleNo.value;
    hed.lrDate = convertToYMD(lrDate.value);
    hed.despatchedThrough = dispatchThrough.value;
    hed.mailingName = mailingName.value;
    hed.partyMobileNo = mobileNo.value;
    hed.shippedToName = consigneeName.value;
    hed.shippedToAddress1 = addressShipped.value;
    hed.shippedToAddress2 = addressShipped2.value;
    hed.shippedToGstin = gstinShipped.value;
    hed.shippedToState = stateShipped.value;
    hed.orderDueDate = convertToYMD(eWBDate.value);
    hed.narration = remark.value;
    hed.address = addressbilled.value;
    hed.billaddress2 = address2billed.value;
    hed.gstin = gstbilled.value;
    hed.state = statebilled.value;

    var response = await ApiCall.postSOHeaderBilledToAPI(hed);

    if (response == 'Data Updated Successfully') {
      Get.back();
      scaffoldMessageValidationBar(Get.context!,
        'Sales Order Updated Successfully',
         isError: false
       
      );
    } else {
      scaffoldMessageValidationBar(Get.context!,
        response.toString(),
        isError: true
      );
    }
  }

  // ----------------------------------------------------------
  // Dispose controllers
  // ----------------------------------------------------------

  @override
  void onClose() {
    vehicleNameController.dispose();
    dateController.dispose();
    dispatchController.dispose();
    mailingNameController.dispose();
    partyNameController.dispose();
    mobileNumberController.dispose();
    consigneeNameController.dispose();
    addressShippedLine1Controller.dispose();
    addressShippedLine2Controller.dispose();
    gstinShippedController.dispose();
    stateShippedController.dispose();
    eWBDateController.dispose();
    remarkController.dispose();
    gstinBilledController.dispose();
    stateBilledController.dispose();
    addressBilledLine1Controller.dispose();
    addressBilledLine2Controller.dispose();

    super.onClose();
  }
}
