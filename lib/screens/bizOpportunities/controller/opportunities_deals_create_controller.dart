// import 'dart:convert';

// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:get/get_core/src/get_main.dart';
// import 'package:get/get_instance/src/extension_instance.dart';
// import 'package:get/get_navigation/src/extension_navigation.dart';
// import 'package:get/get_rx/src/rx_types/rx_types.dart';
// import 'package:get/get_state_manager/src/simple/get_controllers.dart';
// import 'package:sysconn_sfa/Utility/utility.dart';
// import 'package:sysconn_sfa/api/apicall.dart';
// import 'package:sysconn_sfa/api/entity/business_opportunity/opportunities_deals_rep_entity.dart';
// import 'package:sysconn_sfa/screens/bizOpportunities/controller/opportunities_deals_rep_controller.dart';

// class OpportunitiesDealsEditController extends GetxController {

//   /// TEXT CONTROLLERS
//   final retailerName = TextEditingController();
//   final retailerCode = TextEditingController();

//   final productDesc = TextEditingController();
//   final productCode = TextEditingController();

//   final qtyController = TextEditingController();
//   final rateController = TextEditingController();
//   final totalController = TextEditingController();

//   final title = TextEditingController();
//   final description = TextEditingController();

//   /// DROPDOWNS
//   final selectedStageId = RxnInt();
//   final selectedStatusId = RxnInt();
//   final selectedPriority = RxnString();

//   final selectedSourceId = RxnInt();

//   /// FLAGS
//   final isRateEditable = true.obs;
//   final isLoading = false.obs;

//   bool isEdit = false;
//   String editingOpportunityCode = "";

//   /// STATIC DATA
//   final Map<int, String> stageList = {
//     0: "New",
//     1: "InDiscussion",
//     2: "InNegotiation",
//     3: "Hold",
//     4: "Completed"
//   };

//   final Map<int, String> statusList = {
//     0: "Open",
//     1: "Declined",
//     2: "Fulfilled",
//   };

//   final arrPriority = ["P1", "P2", "P3"];

//   @override
//   void onInit() {
//     super.onInit();

//     /// AUTO CALCULATE TOTAL
//     qtyController.addListener(calculateTotal);
//     rateController.addListener(calculateTotal);
//   }

//   // ================= CLEAR =================
//   void clearFields() {
//     isEdit = false;
//     editingOpportunityCode = "";

//     retailerName.clear();
//     retailerCode.clear();

//     productDesc.clear();
//     productCode.clear();

//     qtyController.clear();
//     rateController.clear();
//     totalController.clear();

//     title.clear();
//     description.clear();

//     selectedStageId.value = null;
//     selectedStatusId.value = 0; // default open
//     selectedPriority.value = null;
//     selectedSourceId.value = null;

//     isRateEditable.value = true;
//   }

//   // ================= VALIDATION =================
//   Future<bool> validate() async {

//     if (retailerName.text.trim().isEmpty) {
//       Utility.showErrorSnackBar("Customer required");
//       return false;
//     }

//     if (productDesc.text.trim().isEmpty) {
//       Utility.showErrorSnackBar("Product required");
//       return false;
//     }

//     if (qtyController.text.trim().isEmpty) {
//       Utility.showErrorSnackBar("Quantity required");
//       return false;
//     }

//     if (rateController.text.trim().isEmpty) {
//       Utility.showErrorSnackBar("Rate required");
//       return false;
//     }

//     if (selectedPriority.value == null) {
//       Utility.showErrorSnackBar("Priority required");
//       return false;
//     }

//     return true;
//   }

//   // ================= TOTAL =================
//   void calculateTotal() {
//     double qty = double.tryParse(qtyController.text) ?? 0;
//     double rate = double.tryParse(rateController.text) ?? 0;

//     double total = qty * rate;

//     totalController.text = total.toStringAsFixed(2);
//   }

//   // ================= SAVE API =================
//   Future<void> saveOpportunitiesApi() async {

//     bool isValid = await validate();
//     if (!isValid) return;

//     try {
//       Get.dialog(
//         const Center(child: CircularProgressIndicator()),
//         barrierDismissible: false,
//       );

//       OpportunitiesDealsRepEntity data = OpportunitiesDealsRepEntity();

//       data.businessOpportunityId = editingOpportunityCode;
//       data.companyId = Utility.companyId;

//       data.retailerName = retailerName.text;
//       data.retailerCode = retailerCode.text;

//       data.productDesc = productDesc.text;
//       data.productCode = productCode.text;

//       data.qty = int.tryParse(qtyController.text) ?? 0;
//       data.rate = double.tryParse(rateController.text) ?? 0;
//       data.total = double.tryParse(totalController.text) ?? 0;

//       data.title = title.text;
//       data.description = description.text;

//       data.stage = selectedStageId.value ?? 0;
//       data.status = selectedStatusId.value ?? 0;
//       data.priority = selectedPriority.value ?? '';

//       data.entryMedium = "Manual";

//       List<Map<String, dynamic>> payload = [data.toJson()];

//       final response = await ApiCall.addOpportunitiesApi(payload);

//       if (Get.isDialogOpen ?? false) Get.back();

//       String message;

//       try {
//         final res = json.decode(response);
//         message = res['message'] ?? '';
//       } catch (e) {
//         message = response.toString();
//       }

//       if (message.contains("Success")) {

//         final repController = Get.find<OpportunitiesDealsRepController>();

//         await repController.getOpportunitiesDealsReportAPI();

//         await Utility.showAlert(
//           title: "Success",
//           msg: message,
//           icons: Icons.check,
//           iconcolor: Colors.green, 
//         );

//         Get.back(); // close dialog

//       } else {
//         Utility.showErrorSnackBar(message);
//       }

//     } catch (e) {

//       if (Get.isDialogOpen ?? false) Get.back();

//       Utility.showErrorSnackBar(e.toString());
//     }
//   }
// }





import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/business_opportunity/opportunities_customer_entity.dart';
import 'package:sysconn_sfa/api/entity/business_opportunity/opportunities_deals_rep_entity.dart';
import 'package:sysconn_sfa/api/entity/business_opportunity/opportunities_product_entity.dart';
// import 'package:sysconn_sfa/api/entity/company/party_entity.dart';
import 'package:sysconn_sfa/api/entity/company/partyentity.dart';
import 'package:sysconn_sfa/api/entity/company/stock_item_entity.dart';
// import 'package:sysconn_sfa/api/entity/business_opportunity/opportunities_product_entity.dart';
// import 'package:sysconn_sfa/api/entity/business_opportunity/opportunities_customer_entity.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/controller/opportunities_deals_rep_controller.dart';

class OpportunitiesDealsEditController extends GetxController {

  // ─── Text Controllers ───────────────────────────────────────────────────────
  final retailerName    = TextEditingController();
  final retailerCode    = TextEditingController();
  final productDesc     = TextEditingController();
  final productCode     = TextEditingController();
  final qtyController   = TextEditingController();
  final rateController  = TextEditingController();
  final totalController = TextEditingController();
  final title           = TextEditingController();   // User Remark
  final description     = TextEditingController();   // Customer Remark

  // ─── Customer ───────────────────────────────────────────────────────────────
  final customerList    = <OpportunitiesCustomerEntity>[].obs;
  final partyEntityList = <PartyEntity>[].obs;          // search results
  final selectedCustomer = Rxn<PartyEntity>();

  // ─── Product ────────────────────────────────────────────────────────────────
  final productList       = <OpportunitiesProductEntity>[].obs;
  final selectedProduct   = Rxn<OpportunitiesProductEntity>();
  final stockItemList     = <StockItemEntity>[].obs;    // search results

  // ─── Price list ─────────────────────────────────────────────────────────────
  String? customerPriceList;

  // ─── Dropdowns ──────────────────────────────────────────────────────────────
  final Map<int, String> sourceList = {
    1: "Test1",
    2: "Test2",
    3: "Test3",
  };

  final Map<int, String> stageList = {
    0: "New",
    1: "InDiscussion",
    2: "InNegotiation",
    3: "Hold",
    4: "Completed",
  };

  final Map<int, String> statusList = {
    0: "Open",
    1: "Declined",
    2: "Fulfilled",
  };

  final arrPriority = ["P1", "P2", "P3"];

  final selectedSourceId  = RxnInt();
  final selectedStageId   = RxnInt();
  final selectedStatusId  = RxnInt();
  final selectedPriority  = RxnString();

  // ─── Flags ──────────────────────────────────────────────────────────────────
  final isRateEditable = true.obs;
  final isLoading      = false.obs;
  RxBool partyMasterAdd = false.obs;   // set true when opened from PartyMaster screen

  bool   isEdit                  = false;
  String editingOpportunityCode  = "";

  OpportunitiesDealsRepEntity? editingEntity;

  // ───────────────────────────────────────────────────────────────────────────
  @override
  void onInit() {
    super.onInit();
    getDropdownData();
    qtyController.addListener(calculateTotal);
    rateController.addListener(calculateTotal);
  }

  // ─── Clear ──────────────────────────────────────────────────────────────────
  void clearFields({bool isEdit = false}) {

    if (!isEdit) {
      editingOpportunityCode = "";
      this.isEdit = false;
      editingEntity = null;
    }

    // Respect partyMasterAdd flag (same as web)
    if (partyMasterAdd.value) {
      selectedCustomer.value = PartyEntity()
        ..partyId = Utility.customerPersonaId;
    } else {
      selectedCustomer.value = null;
    }

    selectedProduct.value        = null;
    selectedSourceId.value       = null;
    selectedPriority.value       = null;
    selectedStageId.value        = null;
    selectedStatusId.value       = null;
    customerPriceList            = null;

    retailerName.clear();
    retailerCode.clear();
    productDesc.clear();
    productCode.clear();
    qtyController.clear();
    rateController.clear();
    totalController.clear();
    title.clear();
    description.clear();

    isRateEditable.value = true;
  }

  // ─── Fetch initial dropdown data ────────────────────────────────────────────
  Future<void> getDropdownData() async {
    try {
      isLoading.value = true;
      final data = await ApiCall.getBizOpportunityDropdown();
      customerList.assignAll(data.customerList);
      productList.assignAll(data.productList);
    } catch (e) {
      debugPrint('Error fetching dropdown data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  // ─── Live search: customer ───────────────────────────────────────────────────
  Future<void> customerListData(String customerName) async {
    partyEntityList.assignAll(
      await ApiCall.getCustomerdatalistApi(customerName: customerName),
    );
  }

  // ─── Live search: product ────────────────────────────────────────────────────
  Future<void> itemsListData(String itemName) async {
    stockItemList.assignAll(
      await ApiCall.itemListApi(
        itemName: itemName,
        date: DateTime.now().toString().split(' ')[0],
        pricelist: customerPriceList ?? '',
      ),
    );
  }

  // ─── Total ──────────────────────────────────────────────────────────────────
  void calculateTotal() {
    final qty  = double.tryParse(qtyController.text)  ?? 0;
    final rate = double.tryParse(rateController.text) ?? 0;
    totalController.text = (qty * rate).toStringAsFixed(2);
  }

  // ─── Load entity for edit ────────────────────────────────────────────────────
  Future<void> loadOpportunityForEdit(
      OpportunitiesDealsRepEntity entity) async {

    editingEntity = entity;

    if (customerList.isEmpty || productList.isEmpty) {
      await getDropdownData();
    }

    isEdit                = true;
    editingOpportunityCode = entity.businessOpportunityId ?? "";

    // Customer (build from entity, same as web)
    selectedCustomer.value = PartyEntity()
      ..partyId   = entity.retailerCode
      ..partyName = entity.retailerName;

    retailerName.text = entity.retailerName ?? '';
    retailerCode.text = entity.retailerCode ?? '';

    customerPriceList = entity.productPriceListId ?? '';

    // Product
    selectedProduct.value = productList.firstWhereOrNull(
      (e) =>
          (e.productCode ?? '').trim().toLowerCase() ==
          (entity.productCode ?? '').trim().toLowerCase(),
    );
    productDesc.text = entity.productDesc ?? '';
    productCode.text = entity.productCode ?? '';

    // Numbers
    rateController.text  = entity.rate?.toString()  ?? '';
    qtyController.text   = entity.qty?.toString()   ?? '';
    totalController.text = entity.total?.toString() ?? '';

    // Remarks
    title.text       = entity.title       ?? '';
    description.text = entity.description ?? '';

    // Dropdowns
    selectedSourceId.value  = entity.source;
    selectedStageId.value   = entity.stage;
    selectedStatusId.value  = entity.status;
    selectedPriority.value  = entity.priority;

    // Rate editable: editable by default in edit mode
    isRateEditable.value = true;

    update();
  }

  // ─── Validation ─────────────────────────────────────────────────────────────
  Future<bool> validate() async {

    if (selectedCustomer.value == null) {
      Utility.showErrorSnackBar("Customer required");
      return false;
    }

    if (selectedProduct.value == null) {
      Utility.showErrorSnackBar("Product required");
      return false;
    }

    if (rateController.text.trim().isEmpty) {
      Utility.showErrorSnackBar("Rate required");
      return false;
    }

    if (qtyController.text.trim().isEmpty) {
      Utility.showErrorSnackBar("Quantity required");
      return false;
    }

    if (selectedPriority.value == null || selectedPriority.value!.isEmpty) {
      Utility.showErrorSnackBar("Priority required");
      return false;
    }

    return true;
  }

  // ─── Save / Update API ──────────────────────────────────────────────────────
  Future<void> saveOpportunitiesApi() async {

    final isValid = await validate();
    if (!isValid) return;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final opportunity = OpportunitiesDealsRepEntity();

      opportunity.businessOpportunityId = editingOpportunityCode;
      opportunity.companyId   = Utility.companyId;

      opportunity.retailerCode = selectedCustomer.value?.partyId   ?? '';
      opportunity.retailerName = selectedCustomer.value?.partyName  ?? '';

      opportunity.productCode  = selectedProduct.value?.productCode ?? '';
      opportunity.productDesc  = selectedProduct.value?.productDesc ?? '';

      opportunity.rate  = double.tryParse(rateController.text.trim())  ?? 0;
      opportunity.qty   = int.tryParse(qtyController.text.trim())       ?? 0;
      opportunity.total = double.tryParse(totalController.text.trim()) ?? 0;

      opportunity.title       = title.text.trim();
      opportunity.description = description.text.trim();

      opportunity.source   = selectedSourceId.value  ?? 0;
      opportunity.stage    = selectedStageId.value   ?? 0;
      opportunity.status   = selectedStatusId.value  ?? 0;
      opportunity.priority = selectedPriority.value  ?? '';

      opportunity.entryMedium       = "Manual";
      opportunity.productPriceListId = customerPriceList ?? '';
      opportunity.taskId   = "";
      opportunity.orderId  = "";
      opportunity.taskType = "";

      // ── Activity logic (same as web) ──────────────────────────────────────
      final isEditMode     = editingOpportunityCode.isNotEmpty;
      final oldStageId     = editingEntity?.stage;
      final oldStatusId    = editingEntity?.status;
      final newStageId     = opportunity.stage;
      final newStatusId    = opportunity.status;

      final isStageChanged  = isEditMode && oldStageId  != newStageId;
      final isStatusChanged = isEditMode && oldStatusId != newStatusId;

      final oldStageName  = stageList[oldStageId];
      final newStageName  = stageList[newStageId];
      final oldStatusName = statusList[oldStatusId];
      final newStatusName = statusList[newStatusId];

      if (!isEditMode) {
        opportunity.activity            = 'Opportunity Created';
        opportunity.activityDescription =
            'Opportunity created by ${Utility.companyName}'
            ' (${Utility.email}) successfully.';
      } else if (isStageChanged || isStatusChanged) {
        opportunity.activity            = 'Opportunity Stage/Status Updated';
        opportunity.activityDescription =
            'Opportunity updated '
            '${isStageChanged  ? "(Stage: $oldStageName -> $newStageName)" : ""}'
            '${isStatusChanged ? " (Status: $oldStatusName -> $newStatusName)" : ""}'
            ' by ${Utility.companyName} (${Utility.email}) successfully.';
      } else {
        opportunity.activity            = 'Opportunity Updated';
        opportunity.activityDescription =
            'Opportunity updated by ${Utility.companyName}'
            ' (${Utility.email}) successfully.';
      }
      // ─────────────────────────────────────────────────────────────────────

      final List<Map<String, dynamic>> payload = [opportunity.toJson()];
      final response = await ApiCall.addOpportunitiesApi(payload);

      if (Get.isDialogOpen ?? false) Get.back();

      String message;
      try {
        final res = json.decode(response);
        message   = res['message'] ?? response.toString();
      } catch (_) {
        message = response.toString();
      }

      if (message == 'Data Inserted Successfully') {

        final repController = Get.find<OpportunitiesDealsRepController>();
        await repController.getOpportunitiesDealsReportAPI();
        repController.selectStage.value   = '';
        repController.statusSelected.value = '';

        await Utility.showAlert(
          title: 'Status',
          msg:   'Data Inserted Successfully',
          icons: Icons.check,
          iconcolor: Colors.green,
        );

        Get.back(result: true);

      } else if (message == 'Data Updated Successfully') {

        final repController = Get.find<OpportunitiesDealsRepController>();
        repController.selectStage.value    = '';
        repController.statusSelected.value  = '';
        repController.updateOpportunity(opportunity);

        await Utility.showAlert(
          title: 'Status',
          msg:   'Data Updated Successfully',
          icons: Icons.check,
          iconcolor: Colors.green,
        );

        Get.back(result: true);

      } else if (message.contains('Already Exists')) {

        await Utility.showAlert(
          title:     'Error',
          msg:       'Opportunity Already Exists',
          icons:     Icons.close,
          iconcolor: Colors.red,
        );

      } else {

        await Utility.showAlert(
          title:     'Error',
          msg:       'Oops there is an error!',
          icons:     Icons.close,
          iconcolor: Colors.red,
        );
      }

    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      Utility.showErrorSnackBar(e.toString());
    }
  }
}