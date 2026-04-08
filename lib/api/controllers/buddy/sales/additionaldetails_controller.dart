import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/sales/sales_header_entity.dart';

class AdditionaldetailsController extends GetxController {
  SalesHeaderEntity? salesHeaderEntity;

  AdditionaldetailsController({this.salesHeaderEntity});

  TextEditingController vehicleNameController = TextEditingController();
  TextEditingController dateController = TextEditingController();
  TextEditingController dispatchcntrl = TextEditingController();
  TextEditingController mailingNamecntrl = TextEditingController();
  TextEditingController partyNameController = TextEditingController();
  TextEditingController addressBilledTextController = TextEditingController();
  TextEditingController gstinBilledTextController = TextEditingController();
  TextEditingController stateBilledTextController = TextEditingController();
  TextEditingController cosigneeNameShippedTextController = TextEditingController();
  TextEditingController address01ShippedTextController = TextEditingController();
  TextEditingController gstinShippedTextController = TextEditingController();
  TextEditingController stateShippedTextController = TextEditingController();
  TextEditingController cityShippedTextController = TextEditingController();
  TextEditingController pincodeShippedTextController = TextEditingController();

  List<SalesHeaderEntity> additinalDetList = [];
  RxInt isDataLoad = 0.obs;

  DateTime selectedDate = DateTime.now();
  final dateFormat = DateFormat("dd/MM/yyyy");

  @override
  void onInit() {
    super.onInit();
    additionalDetData();
  }

  Future<void> additionalDetData() async {
    if (salesHeaderEntity != null) {
      dateController.text = salesHeaderEntity!.date ?? '';
      vehicleNameController.text = salesHeaderEntity!.vehicleNo ?? '';
      dispatchcntrl.text = salesHeaderEntity!.despatchedthrough ?? '';
      mailingNamecntrl.text = salesHeaderEntity!.mailingName ?? '';
      partyNameController.text = salesHeaderEntity!.partyName ?? '';
      addressBilledTextController.text = salesHeaderEntity!.address ?? '';
      gstinBilledTextController.text = salesHeaderEntity!.gstin ?? '';
      stateBilledTextController.text = salesHeaderEntity!.state ?? '';
      cosigneeNameShippedTextController.text =
          salesHeaderEntity!.consigneename ?? '';
      address01ShippedTextController.text =
          salesHeaderEntity!.shippedtoaddress ?? '';
      gstinShippedTextController.text =
          salesHeaderEntity!.shippedtogstin ?? '';
      stateShippedTextController.text = salesHeaderEntity!.shippedToState ?? '';
      cityShippedTextController.text = salesHeaderEntity!.shippedTocity ?? '';
      pincodeShippedTextController.text =
          salesHeaderEntity!.shippedTopincode ?? '';
    }
    isDataLoad.value = 1;
  }

  Future additionalDetPostApi() async {
    SalesHeaderEntity salesaddentity = SalesHeaderEntity();
    salesaddentity.companyId = Utility.companyId;
    salesaddentity.uniqueId = salesHeaderEntity!.uniqueId;
    salesaddentity.address = addressBilledTextController.text;
    salesaddentity.gstin = gstinBilledTextController.text;
    salesaddentity.state = stateBilledTextController.text;
    salesaddentity.orderDueDate = '';
    salesaddentity.vehicleNo = vehicleNameController.text;
    salesaddentity.lrDate = '';
    salesaddentity.despatchedthrough = dispatchcntrl.text;
    salesaddentity.mailingName = mailingNamecntrl.text;
    salesaddentity.consigneename = cosigneeNameShippedTextController.text;
    salesaddentity.shippedtoaddress = address01ShippedTextController.text;
    salesaddentity.shippedtogstin = gstinShippedTextController.text;
    salesaddentity.shippedToState = stateShippedTextController.text;
    salesaddentity.shippedTocity = cityShippedTextController.text;
    salesaddentity.shippedTopincode = pincodeShippedTextController.text;

    ApiCall.additiondDetPostApi(salesaddentity).then((response) async {
      Get.back(); // close loader
      if (response == 'Data Updated Successfully') {
        Get.back(); // go back
      } else {
        await Utility.showAlert(
            icons: Icons.close,iconcolor:Colors.red,title: 'Error', msg: 'Oops there is an error!');
      }
    });
  }
}
