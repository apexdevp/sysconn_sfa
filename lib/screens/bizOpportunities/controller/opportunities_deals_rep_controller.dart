import 'package:intl/intl.dart';
import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/business_opportunity/opportunities_deals_rep_entity.dart';
import 'package:trina_grid/trina_grid.dart';

//Shweta 20-04-2026
class OpportunitiesDealsRepController extends GetxController {

  RxList<TrinaRow> rows = <TrinaRow>[].obs;

  /// LOADING STATE
  var isDataLoad = 0.obs; // 0 = loading, 1 = data, 2 = no data

  /// DATA LISTS
  RxList<OpportunitiesDealsRepEntity> allList = <OpportunitiesDealsRepEntity>[].obs;
  RxList<OpportunitiesDealsRepEntity> filteredList = <OpportunitiesDealsRepEntity>[].obs;

  /// FILTER STATE
  RxList<int> stageCounts = <int>[0, 0, 0, 0, 0].obs;
  RxString selectStage = ''.obs;

  bool showAllInitially = false;

  ///status
  var statusSelected = "".obs;

  // Add with other Rx variables (after stageCounts)
  Rx<DateTime> fromDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  ).obs;

  Rx<DateTime> toDate = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
    0,
  ).obs;

  // ── Search State ─────────────────────────────────────────
  var isSearch = false.obs;
  TextEditingController searchController = TextEditingController();
  RxBool searchChange = false.obs;

  // ================= INIT =================
  @override
  void onInit() {
    super.onInit();

    final args = Get.arguments ?? {};
    showAllInitially = args["showAll"] ?? false;

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      // await Utility.setdashboarddate(Get.context!, 'Current Month');
      getOpportunitiesDealsReportAPI();
    });
  }

  // ================= API =================
  Future<void> getOpportunitiesDealsReportAPI() async {
    isDataLoad.value = 0;

    allList.clear();
    filteredList.clear();
    stageCounts.assignAll([0, 0, 0, 0, 0]);

    // Set Utility dates before calling API — same as TaskController pattern
    Utility.selectedFromDateOfDateController = fromDate.value;
    Utility.selectedToDateOfDateController = toDate.value;

    final data = await ApiCall.getOpportunitiesDealsDetApi(
      showAll: showAllInitially,
    );

    print("API DATA LENGTH: ${data.length}");
    print("API DATA: $data");

    if (data.isNotEmpty) {
      allList.assignAll(data);

      _updateStageCounts();

      // if (showAllInitially) {
      //   selectStage.value = '';
      //   filteredList.assignAll(allList);
      // } else {
      //   selectStage.value = '0';
      //   filterByStage(0);
      // }

      filteredList.assignAll(allList); // show all first
      selectStage.value = '';

      isDataLoad.value = 1;
    } else {
      isDataLoad.value = 2;
    }
  }

  // ================= FILTER =================
  void filterByStage(int? stageId) {
    selectStage.value = stageId?.toString() ?? '';

    if (stageId == null) {
      filteredList.assignAll(allList);
    } else {
      filteredList.assignAll(
        allList.where((e) => e.stage == stageId).toList(),
      );
    }
  }

  // ================= STAGE COUNT =================
  void _updateStageCounts() {
    stageCounts.assignAll([0, 0, 0, 0, 0]);

    for (var item in allList) {
      switch (item.stage) {
        case 0:
          stageCounts[0]++;
          break;
        case 1:
          stageCounts[1]++;
          break;
        case 2:
          stageCounts[2]++;
          break;
        case 3:
          stageCounts[3]++;
          break;
        case 4:
          stageCounts[4]++;
          break;
      }
    }
  }

  // ================= DELETE =================
  Future<void> deleteOpportunitiesApi({
    required String businessOpportunityId,
  }) async {

    OpportunitiesDealsRepEntity deleteEntity = OpportunitiesDealsRepEntity();

    deleteEntity.companyId = Utility.companyId;
    deleteEntity.businessOpportunityId = businessOpportunityId;

    List<Map<String, dynamic>> body = [deleteEntity.toJson()];

    final response = await ApiCall.deleteOpportunitiesApi(body);

    final res = jsonDecode(response);
    String message = res['message'] ?? '';

    if (response.contains('Data Deleted Successfully')) {
      Get.back();

      await Utility.showAlert(
        icons: Icons.check,
        iconcolor: Colors.green,
        title: 'Success',
        msg: 'Data Deleted Successfully',
      );

      getOpportunitiesDealsReportAPI();

    } else if (response.contains('DEPENDENCY_EXISTS')) {

      await Utility.showAlert(
        icons: Icons.warning,
        iconcolor: Colors.orange,
        title: 'Cannot Delete',
        msg: 'Delete associated data first.',
      );

    } else if (response.contains('ONLY_TODAY_DELETE_ALLOWED')) {

      await Utility.showAlert(
        icons: Icons.warning,
        iconcolor: Colors.orange,
        title: 'Not Allowed',
        msg: 'Only today created items can be deleted.',
      );

    } else {

      await Utility.showAlert(
        icons: Icons.close,
        iconcolor: Colors.red,
        title: 'Error',
        msg: message.isNotEmpty ? message : 'Unexpected error',
      );
    }
  }

  // ================= LABEL HELPERS =================
  String getStageLabel(int? value) {
    switch (value) {
      case 0:
        return "New";
      case 1:
        return "InDiscussion";
      case 2:
        return "InNegotiation";
      case 3:
        return "Hold";
      case 4:
        return "Completed";
      default:
        return "";
    }
  }

  String getStatusLabel(int? value) {
    switch (value) {
      case 0:
        return "Open";
      case 1:
        return "Declined";
      case 2:
        return "Fulfilled";
      default:
        return "";
    }
  }

  void updateOpportunityRow(OpportunitiesDealsRepEntity opportunity) {
    final index = rows.indexWhere(
      (r) =>
          r.cells['businessopportunityid']?.value.toString() ==
          opportunity.businessOpportunityId.toString(),
    );

    if (index != -1) {
      rows[index].cells['status']?.value = opportunity.status;
      rows.refresh();
    }
  }

  // ================= UPDATE ITEM (EDIT CASE) =================
  void updateOpportunity(OpportunitiesDealsRepEntity updated) {
    int index = allList.indexWhere(
          (e) => e.businessOpportunityId == updated.businessOpportunityId,
    );

    if (index != -1) {
      allList[index] = updated;

      filterByStage(
        selectStage.value.isEmpty ? null : int.parse(selectStage.value),
      );

      _updateStageCounts();
    }
  }

  // ── Search ───────────────────────────────────────────────
  void onSearchChanged(String text) {
    if (text.isEmpty) {
      isSearch.value = false;
      // restore current stage filter
      filterByStage(
        selectStage.value.isEmpty ? null : int.tryParse(selectStage.value),
      );
      return;
    }

    isSearch.value = true;
    final query = text.toLowerCase();

    filteredList.assignAll(
      allList.where((e) {
        return (e.retailerName?.toLowerCase().contains(query) ?? false) ||
            (e.title?.toLowerCase().contains(query) ?? false) ||
            (e.productDesc?.toLowerCase().contains(query) ?? false) ||
            (e.retailerCode?.toLowerCase().contains(query) ?? false);
      }).toList(),
    );
  }

  void clearSearch() {
    searchController.clear();
    searchChange.value = false;
    isSearch.value = false;
    // restore filter
    filterByStage(
      selectStage.value.isEmpty ? null : int.tryParse(selectStage.value),
    );
  }

  @override
  void onClose() {
    searchController.dispose();
    super.onClose();
  }
}