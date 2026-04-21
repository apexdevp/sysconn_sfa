import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/business_opportunity/opportunities_deals_rep_entity.dart';
import 'package:sysconn_sfa/api/entity/order/sales_order_cart_entity.dart';
import 'package:sysconn_sfa/api/entity/order/sales_order_header_entity.dart';
import 'package:trina_grid/trina_grid.dart';

class BusinessTrackingController extends GetxController {
  final SalesOrderHeaderEntity header;

  BusinessTrackingController(this.header);

  final isLoading = false.obs;
  final isSelectAll = false.obs;

  final salesOrderValue = <OpportunitiesDealsRepEntity>[].obs;
  final selectedInvList = <SOAddToCartEntity>[].obs;
  final selectedInvIdList = <String>[].obs;

  final trinaRows = <TrinaRow>[].obs;
  TrinaGridStateManager? stateManager;

  @override
  void onInit() {
    super.onInit();
    debugPrint(" Controller INIT called");
    loadBOItems();
  }

  // ---------------------------------------------------------
  // LOAD DATA
  // ---------------------------------------------------------
  Future<void> loadBOItems() async {
    isLoading.value = true;
    debugPrint('Step 1');

    final list = await ApiCall.getOpportunitiesDealsTrackingApi(
      customerid: header.partyId ?? '',
    );

    debugPrint('Step 2');

    salesOrderValue.clear();
    selectedInvList.clear();
    selectedInvIdList.clear();
    trinaRows.clear();

    if (list.isNotEmpty) {
      for (final e in list) {
        salesOrderValue.add(e);

        trinaRows.add(
          TrinaRow(
            cells: {
              'check': TrinaCell(value: ''),
              'item_code': TrinaCell(value: e.productCode),
              'item_name': TrinaCell(value: e.productDesc),
              'qty': TrinaCell(value: e.soqty),
              'rate': TrinaCell(value: e.sorate),
              'value': TrinaCell(value: e.total),
              'business': TrinaCell(value: e.businessOpportunityId),
            },
          ),
        );
      }
      
      isSelectAll.value = true;
    }

    debugPrint('Step 3 Done');
    isLoading.value = false;
  }

  // ---------------------------------------------------------
  // SELECTION
  // ---------------------------------------------------------
  void addToSelected(OpportunitiesDealsRepEntity item) {
    if (item.businessOpportunityId == null) return;

    if (!selectedInvIdList.contains(item.businessOpportunityId)) {
      selectedInvIdList.add(item.businessOpportunityId!);

      final calc = calculate(
        invRate: item.sorate ?? "0",
        invQty: item.soqty ?? "0",
        invDisc: item.discount ?? "0",
        taxRate: item.gstRate ?? "0",
      );

      selectedInvList.add(
        SOAddToCartEntity(
          companyId: Utility.companyId,
          hedUniqueId: header.uniqueId,
          itemId: item.productCode,
          quantity: item.soqty.toString(),
          rate: item.sorate.toString(),
          value: calc.totalvalue, //item.total.toString(),
          discount: item.discount ?? '',
          gstRate: item.gstRate ?? '',
          gstValue: calc.gstValue,
          cessRate: item.cessRate ?? '',
          cessValue: item.cessValue ?? '',
          netValue: calc.netValue, //item.total.toString(),
          businessOpportunityId: item.businessOpportunityId,
          soinvno: header.uniqueId, //pratiksha p 03-04-2026 add
        ),
      );

      debugPrint('Selected IDs: $selectedInvIdList');
    }

    isSelectAll.value = selectedInvIdList.length == salesOrderValue.length;
  }

  void removeSelected(OpportunitiesDealsRepEntity item) {
    if (item.businessOpportunityId == null) return;

    final index = selectedInvIdList.indexOf(item.businessOpportunityId!);

    if (index != -1) {
      selectedInvIdList.removeAt(index);
      selectedInvList.removeAt(index);
    }

    isSelectAll.value = false;

    debugPrint('Selected IDs: $selectedInvIdList');
  }

  OpportunitiesDealsRepEntity calculate({
    required String invRate,
    required String invQty,
    required String invDisc,
    required String taxRate,
  }) {
    final rate = invRate.isEmpty ? 0 : num.parse(invRate);
    final qty = invQty.isEmpty ? 0 : num.parse(invQty);
    final disc = invDisc.isEmpty ? 0 : num.parse(invDisc);
    final gstRate = taxRate.isEmpty ? 0 : num.parse(taxRate);

    final amount = rate * qty;
    final discounted = amount - (amount * disc / 100);
    final gstValue = discounted * gstRate / 100;
    final total = discounted + gstValue;

    return OpportunitiesDealsRepEntity(
      netValue: discounted.toStringAsFixed(2),
      gstValue: gstValue.toStringAsFixed(2),
      totalvalue: total.toStringAsFixed(2),
    );
  }

  // ---------------------------------------------------------
  // SAVE
  // ---------------------------------------------------------
  Future<void> save() async {
    final data = selectedInvList.map((e) => e.toMap()).toList();
    final response = await ApiCall.postSOInventoryDetAPI(data);

    if (response.toString().toLowerCase().contains('success')) {
      Get.back(result: true);
    } else {
      Get.snackbar(
        'Error',
        'Failed to update Sales Order',
        backgroundColor: Colors.red,
        colorText: Colors.white,
      );
    }
  }
}
