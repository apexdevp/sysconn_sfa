import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/beatwisecustomerlistentity.dart';

class BeatCustomerListController extends GetxController {
  RxList<BeatCustListGetEntity> customerListData =
      <BeatCustListGetEntity>[].obs;
  var isDataLoad = 0.obs;
  TextEditingController partyNameController = TextEditingController();
  var searchPartyChange = false.obs;
  var statustag = '1'.obs;
  List<BeatCustListGetEntity> searchResultOfParty = [];
  var isSearch = false.obs;
  TextEditingController searchController = TextEditingController();

  Future<List<BeatCustListGetEntity>> getBeatListAPIDet(
    String filtertype,
    String id,
    // String status,
  ) async {
    customerListData.clear();
    isDataLoad.value = 0;

    await ApiCall.getBeatCustListData(filtertype, id, statustag.value).then((
      customerDataList,
    ) {
      if (customerDataList.isNotEmpty) {
        customerListData.assignAll(customerDataList);
        isDataLoad.value = 1;
      } else {
        isDataLoad.value = 2;
      }
    });

    return customerListData;
  }

  // Search for PARTY
  void searchParty(String filtertype) {
    final text = partyNameController.text.trim();

    if (text.isEmpty) {
      isDataLoad.value = 2;
      return;
    }

    getBeatListAPIDet(filtertype, text,);
  }

  void clearSearch() {
    partyNameController.clear();
    searchPartyChange.value = false;
    isDataLoad.value = 2;
  }
}
