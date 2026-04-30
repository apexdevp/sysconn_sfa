import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/company/stock_item_entity.dart';
import 'package:sysconn_sfa/api/entity/taskboard/task_opportunity_create_entity.dart';

class TaskBizOpportunitiesCreateController extends GetxController {
  final opportunitiescode = TextEditingController();
  final customerRemarkController = TextEditingController();
  final userRemarkController = TextEditingController();
  final totalController = TextEditingController();
  final qtyController = TextEditingController();
  final rateController = TextEditingController();
  // final productList = <TaskOpportunitiesProductEntity>[].obs;
  // final selectedProduct = Rxn<TaskOpportunitiesProductEntity>();
  // final productPriceList = <TaskOpportunitiesPriceListEntity>[].obs;
  // final selectedproductPriceList = Rxn<TaskOpportunitiesPriceListEntity>();
  // final filteredProductPriceList = <TaskOpportunitiesPriceListEntity>[].obs;
  final customerList = <TaskOpportunitiesCustomerEntity>[].obs;
  final selectedCustomer = Rxn<TaskOpportunitiesCustomerEntity>();
  final retailerName = TextEditingController();
  final retailerCode = TextEditingController();
  final productCode = TextEditingController();
  final productDesc = TextEditingController();
  final priority = TextEditingController();
  final title = TextEditingController();
  final description = TextEditingController();
  final selectedProductName = RxString('');
  bool isEdit = false;
  String editingOpportunityCode = "";
  final isLoading = false.obs;
  var arrPriority = ["P1", "P2", "P3"];
  final selectedPriority = RxnString();
  String? taskId;
  String? screenTypeMove;
  final Map<int, String> sourceList = {1: "Test1", 2: "Test2", 3: "Test3"};
  RxnInt selectedSourceId = RxnInt(null);
  final stockItemList = <StockItemEntity>[].obs;
  String customerPriceList = ''; // Selected product info for API
  String selectedProductId = '';
  String selectedProductNameForApi = '';
  String selectedPriceListId = '';
  String selectedRate = '0';
  var isRateEditable = true.obs;
  RxnInt selectedStageId = RxnInt(null); 
  RxnInt selectedStatusId = RxnInt(null); 
final Map<int, String> stageList = {
    0: "New",
    1: "InDiscussion",
    2: "InNegotiation",
    3: "Hold",
    4: "Completed"
  };

  final Map<int, String> statusList = {
    0: "Open",
    1: "Declined",
    2: "Fulfilled",
  };

  @override
  void onInit() {
    super.onInit();
    print("Controller Initialized");
    getDropdownData();
    rateController.addListener(() {
      calculateTotal();
    });
    qtyController.addListener(calculateTotal);
  }

  void clearFields() {
    isEdit = false;
    selectedCustomer.value = null;
    selectedSourceId.value = null;
    selectedPriority.value = null;
    rateController.clear();
    qtyController.clear();
    totalController.clear();
    userRemarkController.clear();
    customerRemarkController.clear();
    // filteredProductPriceList.clear();
    title.clear();
    description.clear();
    selectedProductId = '';
    selectedProductNameForApi = '';
    selectedPriceListId = '';
    productCode.clear();
    productDesc.clear();
    selectedProductName.value = '';

    selectedStageId.value = 0;
    selectedStatusId.value = 0;

  }

  void preselectCustomer(String? retailerCode) {
    if (retailerCode == null) return;

    // If customerList is loaded, select immediately
    if (customerList.isNotEmpty) {
      final matchedCustomer = customerList.firstWhere(
        (c) => c.retailerCode == retailerCode,
        orElse: () => TaskOpportunitiesCustomerEntity(),
      );

      if (matchedCustomer.retailerCode != null &&
          matchedCustomer.retailerCode!.isNotEmpty) {
        selectedCustomer.value = matchedCustomer;
        retailerName.text = matchedCustomer.retailerName ?? '';
        this.retailerCode.text = matchedCustomer.retailerCode ?? '';
        customerPriceList = matchedCustomer.priceList ?? '';
      }
    } else {
      // Wait until customerList is populated
      ever(customerList, (_) {
        if (customerList.isNotEmpty) {
          preselectCustomer(retailerCode);
        }
      });
    }
  }

  Future<bool> validateOpportunities() async {
    /// Customer
    if (selectedCustomer.value == null) {
      // Utility.showErrorSnackBar("Customer Name required");
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Customer Name required",
      );
      return false;
    }

    /// Product
    if (selectedProductName.value == '') {
      // Utility.showErrorSnackBar("Product Name required");
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Product Name required",
      );
      return false;
    }

    if (rateController.text.trim().isEmpty) {
      // Utility.showErrorSnackBar("Rate required");
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Rate required",
      );
      return false;
    }

    // Quantity
    if (qtyController.text.trim().isEmpty) {
      // Utility.showErrorSnackBar("Quantity required");
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Quantity required",
      );
      return false;
    }

    /// Quantity
    String qtyText = qtyController.text.trim();

    if (qtyText.isEmpty) {
      // Utility.showErrorSnackBar("Quantity required");
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Quantity required",
      );
      return false;
    }

    final int? qtyValue = int.tryParse(qtyText);
    if (qtyValue == null || qtyValue <= 0) {
      // Utility.showErrorSnackBar("Quantity must be greater than 0");
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Quantity must be greater than 0",
      );
      return false;
    }

    /// Priority
    if (selectedPriority.value == null || selectedPriority.value!.isEmpty) {
      // Utility.showErrorSnackBar("Priority required");
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Priority required",
      );
      return false;
    }

    return true;
  }

  Future<void> saveOpportunitiesApi() async {
    bool isValid = await validateOpportunities();
    if (!isValid) return;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      TaskBizOpportunitiesCreateEntity opportunity = TaskBizOpportunitiesCreateEntity();

      List<Map<String, dynamic>> opportunityListMap = [];
      opportunity.taskId = taskId;
      opportunity.taskType = screenTypeMove;
      opportunity.orderId = "";
      opportunity.businessOpportunityId = editingOpportunityCode;
      opportunity.companyId = Utility.companyId;
      opportunity.retailerCode = selectedCustomer.value?.retailerCode ?? '';
      opportunity.retailerName = selectedCustomer.value?.retailerName ?? '';
      opportunity.source = selectedSourceId.value ?? 0;
      opportunity.title = title.text.trim();
      // opportunity.productCode = selectedProduct.value?.productCode ?? '';
      // opportunity.productDesc = selectedProduct.value?.productDesc ?? '';
      opportunity.description = description.text.trim();
      // opportunity.rate = int.tryParse(rateController.text.trim()) ?? 0;
      opportunity.qty = int.tryParse(qtyController.text.trim()) ?? 0;
      opportunity.total = double.tryParse(totalController.text.trim()) ?? 0;
      opportunity.entryMedium = "Manual";
      // opportunity.productPriceListId =
      //     selectedproductPriceList.value?.priceList ?? '';

      opportunity.productCode = selectedProductId; // item_id
      opportunity.productDesc = selectedProductNameForApi; // item_name
      opportunity.productPriceListId = selectedPriceListId; // price list name
      // opportunity.rate = int.tryParse(selectedRate) ?? 0;
      // opportunity.rate = int.tryParse(rateController.text.trim()) ?? 0;
      opportunity.rate = (double.tryParse(rateController.text.trim()) ?? 0)
          .toInt();
      // print(
      //   "Selected Product Price List ID: ${selectedproductPriceList.value?.priceList}",
      // );
      opportunity.stage = selectedStageId.value ?? 0;
      opportunity.status = selectedStatusId.value ?? 0;

      opportunity.priority = selectedPriority.value ?? '';

      opportunity.activity = "Opportunity Created";
      opportunity.activityDescription = "Opportunity created by ${Utility.companyName} (${Utility.useremailid}) successfully.";


      opportunityListMap.add(opportunity.toJson());

      List<Map<String, dynamic>> payload = [opportunity.toJson()];

      final response = await ApiCall.addOpportunitiesApi(payload);

      if (Get.isDialogOpen ?? false) Get.back();
      String message;

      try {
        final Map<String, dynamic> resJson = json.decode(response);
        message = resJson['message'] ?? response.toString();
      } catch (e) {
        message = response.toString();
      }

      if (message == 'Data Inserted Successfully') {
        await Utility.showAlert(
          icons: Icons.check,
          iconcolor: Colors.green,
          title: 'Status',
          msg: 'Data Inserted Successfully',
        );

        Get.back(result: true);
      } else {
        await Utility.showAlert(
          icons: Icons.close,
          iconcolor: Colors.red,
          title: 'Error',
          msg: 'Oops there is an error!',
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();

      await Utility.showAlert(
        icons: Icons.close,
        iconcolor: Colors.red,
        title: 'Error',
        msg: e.toString(),
      );
    }
  }

  // void filterPriceListByProduct(String? productCode) {
  //   selectedproductPriceList.value = null;

  //   final filtered = productPriceList
  //       .where((p) => p.itemId == productCode)
  //       .toList();

  //   filteredProductPriceList.assignAll(filtered);
  // }

  void calculateTotal() {
    double rateValue = double.tryParse(rateController.text.trim()) ?? 0;
    double qtyValue = double.tryParse(qtyController.text.trim()) ?? 0;

    double total = rateValue * qtyValue;

    totalController.text = total.toStringAsFixed(2);
  }

  Future<void> getDropdownData() async {
    try {
      isLoading.value = true;
      final data = await ApiCall.getTaskBizOpportunityDropdown();
      customerList.assignAll(data.customerList);
      // productList.assignAll(data.productList);
      // productPriceList.assignAll(data.priceList);
    } catch (e) {
      print('Error fetching master data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchItemMaster(String searchQuery) async {
    final priceListToSend = customerPriceList; // pricelist to use

    final items = await ApiCall.itemListApi(
      itemName: searchQuery,
      date: DateTime.now().toString().split(' ')[0],
      pricelist: priceListToSend,
    );

    stockItemList.assignAll(items);
  }
}
