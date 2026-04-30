import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/business_opportunity/opportunities_deals_rep_entity.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/controller/opportunities_deals_rep_controller.dart';
// import 'package:sysconn_oms/app/models/opportunities&deals/opportunities_deals_rep_entity.dart';
// import 'package:sysconn_oms/app/modules/opportunitiesDeals/controller/opportunities_deals_rep_controller.dart';
// import 'package:sysconn_oms/app/repository/apicall.dart';
// import 'package:sysconn_oms/app/utilities/utility.dart';

class OpportunitiesDealsViewController extends GetxController {

  RxString selectedStatus = "".obs;
  var selectedTabIndex = 0.obs;


  Rx<OpportunitiesDealsRepEntity> selectedOpportunity =
      OpportunitiesDealsRepEntity().obs;

  String getValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "N/A";
    }
    return value;
  }

  String get rating => getValue(selectedOpportunity.value.rating);

  @override
  // void onInit() {
  //   super.onInit();
  //   final data = Get.arguments;

  //   final statusValue = data['status'];

  //   if (statusValue is int) {
  //     const reverseStatusMap = {
  //       0: "Open",
  //       1: "Declined",
  //       2: "Fulfilled",
  //     };
  //     selectedStatus.value = reverseStatusMap[statusValue] ?? "";
  //   } else {
  //     selectedStatus.value = statusValue?.toString() ?? "";
  //   }
  // }
  void onInit() {
    super.onInit();
    final data = Get.arguments;
    // selectedStatus.value = data['status'] ?? "";
    selectedStatus.value = data['status']?.toString() ?? "";
  }

  Future<void> updateStatusApi() async {
    final previousStatus = selectedStatus.value;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final repController = Get.find<OpportunitiesDealsRepController>();
      final entity = selectedOpportunity.value;

      // /// 🔹 Get latest row (SOURCE OF TRUTH)
      // final row = repController.rows.firstWhere(
      //   (r) =>
      //       r.cells['businessopportunityid']?.value.toString() ==
      //       entity.businessOpportunityId.toString(),
      //   orElse: () => throw Exception("Row not found"),
      // );

      /// ✅ Use allList (OpportunitiesDealsRepEntity) instead of rows (TrinaRow)
      final latestEntity = repController.allList.firstWhere(
        (e) =>
            e.businessOpportunityId.toString() ==
            entity.businessOpportunityId.toString(),
        orElse: () => throw Exception("Opportunity not found"),
      );

      // /// 🔹 Extract ALL latest values from row
      // final latestStage = row.cells['stage']?.value ?? 0;
      // final latestRate = row.cells['rate']?.value ?? 0;
      // final latestQty = row.cells['qty']?.value ?? 0;
      // final latestTotal = row.cells['total']?.value ?? 0.0;

      final statusMap = {
        "Open": 0,
        "Declined": 1,
        "Fulfilled": 2,
      };

      OpportunitiesDealsRepEntity opportunity =
          OpportunitiesDealsRepEntity();

      /// 🔹 Required fields
      opportunity.businessOpportunityId = entity.businessOpportunityId;
      opportunity.companyId = Utility.companyId;

      // /// 🔹 IMPORTANT → take from ROW (not entity)
      // opportunity.retailerCode = row.cells['retailer_code']?.value;
      // opportunity.retailerName = row.cells['retailer_name']?.value;
      // opportunity.title = row.cells['title']?.value;
      // opportunity.description = row.cells['description']?.value;
      // opportunity.productCode = row.cells['product_code']?.value;
      // opportunity.productDesc = row.cells['product_desc']?.value;
      // opportunity.priority = row.cells['priority']?.value;
      // opportunity.source = row.cells['source']?.value;
      // opportunity.productPriceListId =
      //     row.cells['productpricelistid']?.value;

      /// Take latest values directly from entity
      opportunity.retailerCode = latestEntity.retailerCode;
      opportunity.retailerName = latestEntity.retailerName;
      opportunity.title = latestEntity.title;
      opportunity.description = latestEntity.description;
      opportunity.productCode = latestEntity.productCode;
      opportunity.productDesc = latestEntity.productDesc;
      opportunity.priority = latestEntity.priority;
      opportunity.source = latestEntity.source;
      opportunity.productPriceListId = latestEntity.productPriceListId;
      
      // /// 🔹 Numeric fields (IMPORTANT FOR API)
      // opportunity.rate = latestRate;
      // opportunity.qty = latestQty;
      // opportunity.total = latestTotal;

      // /// 🔹 SAFE STAGE
      // opportunity.stage = latestStage;

      /// Numeric fields
      opportunity.rate = latestEntity.rate;
      opportunity.qty = latestEntity.qty;
      opportunity.total = latestEntity.total;

      /// Stage
      opportunity.stage = latestEntity.stage;

      /// 🔹 STATUS UPDATE ONLY
      opportunity.status = statusMap[selectedStatus.value] ?? 0;

      /// 🔹 Activity log
      opportunity.activity = 'Opportunity Stage/Status Updated';
      opportunity.activityDescription =
          'Status updated to ${selectedStatus.value} by ${Utility.companyName} (${Utility.email}) successfully.';

      /// 🔹 API call
      final response = await ApiCall.addOpportunitiesApi([
        opportunity.toJson(),
      ]);

      if (Get.isDialogOpen ?? false) Get.back();

      String message;
      try {
        final resJson = json.decode(response);
        message = resJson['message'] ?? response.toString();
      } catch (_) {
        message = response.toString();
      }

      if (message == 'Data Inserted Successfully') {
        repController.updateOpportunityRow(opportunity);

        final currentStage =
            int.tryParse(repController.selectStage.value);
        repController.filterByStage(currentStage);

      } else {
        selectedStatus.value = previousStatus;

        await Utility.showAlert(
          icons: Icons.close,
          iconcolor: Colors.red,
          title: 'Error',
          msg: message,
        );
      }
    } catch (e) {
      selectedStatus.value = previousStatus;

      if (Get.isDialogOpen ?? false) Get.back();

      await Utility.showAlert(
        icons: Icons.close,
        iconcolor: Colors.red,
        title: 'Error',
        msg: e.toString(),
      );
    }
  }
}
