import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/sales/unbilled_item_entity.dart';

class InactiveCustomerController extends GetxController {
  RxInt isDataLoad = 0.obs;

  RxList<UnbilledItemEntity> unbillItemDataList = <UnbilledItemEntity>[].obs;

  TextEditingController inactivecustomerController = TextEditingController(
    text: '90',
  );

  @override
  void onInit() {
    super.onInit();
    getUnbillItemReportAPI();
  }

  Future getUnbillItemReportAPI() async {
    isDataLoad.value = 0;
    unbillItemDataList.clear();

    final itemValue = await ApiCall.getInactiveCustomerDataAPI(
      type: 'Ledger',
      inactivesince: inactivecustomerController.text,
    );
    if (itemValue.isNotEmpty) {
      unbillItemDataList.assignAll(itemValue);
      isDataLoad.value = 1;
    } else {
      isDataLoad.value = 2;
    }
  }
}
