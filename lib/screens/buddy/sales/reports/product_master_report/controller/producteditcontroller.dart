import 'dart:convert';

import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/company/product_category_entity.dart';
import 'package:sysconn_sfa/api/entity/company/product_group_entity.dart';
import 'package:sysconn_sfa/api/entity/company/product_unit_entity.dart';
import 'package:sysconn_sfa/api/entity/company/stock_group_entity.dart';
import 'package:sysconn_sfa/api/entity/company/stock_item_entity.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/product_master_report/controller/productmastercontroller.dart';
import 'package:trina_grid/trina_grid.dart';

class ProductEditController extends GetxController {
  final ProductMasterController productController =
      Get.find<ProductMasterController>();

  var selectedgroup = "".obs;
  var groupId = "".obs;
  var unitCntrl = TextEditingController();
  var groupCntrl = TextEditingController();
  var categoryCntrl = TextEditingController();
  var subCategoryCntrl = TextEditingController();
  var existingid = TextEditingController(); //shweta 09-03-26

  int isdataLoad = 0;
  List<TrinaRow> rows = [];
  TrinaGridStateManager? stateManager;
  final prdcode = TextEditingController();
  final prddesc = TextEditingController();
  final prdcatmaincode = TextEditingController();
  final prdcatname = TextEditingController();
  final prdsubcatcode = TextEditingController();
  final prdsubcatname = TextEditingController();
  final divisioncode = TextEditingController();
  final divisionname = TextEditingController();
  final uom = TextEditingController();
  final hsncd = TextEditingController();
  final hsndsc = TextEditingController();
  final gsteffdate = TextEditingController(
    text: DateFormat("yyyy-MM-dd").format(DateTime.now()),
  );
  final taxrate = TextEditingController();
  final classification = TextEditingController();
  final cessrate = TextEditingController();
  final activestatus = TextEditingController();
  final prdcreatedt = TextEditingController(
    text: DateFormat("yyyy-MM-dd").format(DateTime.now()),
  );
  final wef = TextEditingController(
    text: DateFormat("yyyy-MM-dd").format(DateTime.now()),
  );
  final dlp = TextEditingController();
  final mt = TextEditingController();
  final bag = TextEditingController();
  final kg = TextEditingController();
  final addunitsappl = TextEditingController();
  final addunits = TextEditingController();
  final conversion = TextEditingController();
  final denominator = TextEditingController();

  final descriptionController = TextEditingController();

  String groupid = '';
  // RxList<StockGroupEntity> stkgroupEntityList = <StockGroupEntity>[].obs;
  List<StockGroupEntity> stkgroupEntityList = [];

  //shweta 24-02-2026
  final isLoading = false.obs;

  final unitList = <ProductUOMEntity>[].obs;
  final selectedUnit = Rxn<ProductUOMEntity>();
  final groupList = <ProductGrpEntity>[].obs;
  final selectedGroup = Rxn<ProductGrpEntity>();
  final productCategoryList = <ProductCategoryEntity>[].obs;
  final selectedProductCategory = Rxn<ProductCategoryEntity>();
  final productSubCategoryList = <ProductSubCategoryEntity>[].obs;
  final selectedSubProductCategory = Rxn<ProductSubCategoryEntity>();
  final filteredSubCategoryList = <ProductSubCategoryEntity>[].obs;
  final classificationList = ['Product', 'Service'];
  final selectedClassification = RxnString();
  var remarkCntrl = TextEditingController();
  final isActive = false.obs;

  bool isEdit = false;
  String editingProductCode = "";

  void onToggleStatus(bool value) {
    isActive.value = value;
  }

  @override
  void onInit() {
    super.onInit();
    fetchProductMasterData();
  }

  void clearFields() {
    isEdit = false;
    prdcode.clear();
    prddesc.clear();
    prdcatmaincode.clear();
    prdcatname.clear();
    prdsubcatcode.clear();
    prdsubcatname.clear();
    divisioncode.clear();
    divisionname.clear();
    uom.clear();
    hsncd.clear();
    hsndsc.clear();
    gsteffdate.text = DateFormat("yyyy-MM-dd").format(DateTime.now());
    taxrate.clear();
    cessrate.clear();
    activestatus.clear();
    prdcreatedt.text = DateFormat("yyyy-MM-dd").format(DateTime.now());
    wef.text = DateFormat("yyyy-MM-dd").format(DateTime.now());
    dlp.clear();
    mt.clear();
    bag.clear();
    kg.clear();
    addunitsappl.clear();
    addunits.clear();
    conversion.clear();
    denominator.clear();
    descriptionController.clear();
    // groupid = '';
    existingid.clear(); //shweta 09-03-26

    selectedgroup.value = "";
    groupId.value = "";

    unitCntrl.clear();
    groupCntrl.clear();
    categoryCntrl.clear();
    subCategoryCntrl.clear();
    isActive.value = false;

    selectedClassification.value = '';
    selectedUnit.value = null;
    selectedGroup.value = null;
    selectedProductCategory.value = null;
    selectedSubProductCategory.value = null;

    filteredSubCategoryList.clear();
  }

  // Set when editing
  void setFromEntity(StockItemEntity entity) {
    prdcode.text = entity.itemId ?? '';
    prddesc.text = entity.itemName ?? '';
    prdcatmaincode.text = entity.productCategoryCode ?? '';
    prdcatname.text = entity.category ?? '';
    taxrate.text = entity.taxRate ?? '';
    // cessrate.text = entity.cess ?? '';
    hsncd.text = entity.hsnCode ?? '';
    uom.text = entity.unitName ?? '';
    editingProductCode = entity.itemId ?? '';
  
  }


  Future<void> loadProductForEdit(StockItemEntity entity) async {

    if (unitList.isEmpty || groupList.isEmpty || productCategoryList.isEmpty) {
      await fetchProductMasterData();
    }

    isEdit = true;
    prdcode.text = entity.itemId ?? "";
    prddesc.text = entity.itemName ?? "";
    // descCntrl.text = entity.description ?? "";
    descriptionController.text = entity.description ?? "";
    hsncd.text = entity.hsnCode ?? "";
    hsndsc.text = entity.hsndesc ?? "";
    taxrate.text = entity.taxRate ?? "";
    editingProductCode = entity.itemId ?? "";
    existingid.text = entity.existingid ?? "";          //shweta 09-03-26

    selectedClassification.value = entity.classification;

    selectedProductCategory.value = productCategoryList.firstWhereOrNull(
      (e) => e.id == (entity.productCategoryCode ?? ""),
    );

    filteredSubCategoryList.value = productSubCategoryList
        .where((e) => e.parentCategoryId == (entity.productCategoryCode ?? ""))
        .toList();

    for (var s in productSubCategoryList) {
      if (kDebugMode) {
        print("SubCat -> ${s.id}");
      }
    }


    selectedSubProductCategory.value = productSubCategoryList.firstWhereOrNull(
      (e) =>
          e.name.toString().trim().toLowerCase() ==
          entity.subcategory.toString().trim().toLowerCase(),
    );

    selectedUnit.value = unitList.firstWhereOrNull(
      (e) =>
          e.pUnitName.toString().trim().toLowerCase() ==
          entity.unitName.toString().trim().toLowerCase(),
    );

    for (var g in groupList) {
      if (kDebugMode) {
        print("Group -> ${g.pGrpId}");
      }
    }


    selectedGroup.value = groupList.firstWhereOrNull(
      (e) =>
          e.pGrpName.toString().trim().toLowerCase() ==
          entity.groupname.toString().trim().toLowerCase(),
    );

    // isActive.value = entity.activestatus.toString().toLowerCase() == "true";
    isActive.value =
        entity.activestatus.toString().toLowerCase() == "active" ||
        entity.activestatus.toString().toLowerCase() == "true";
   

    update(); // if using GetBuilder
  }

  Future<bool> validateProduct() async {
    if (prddesc.text.trim().isEmpty) {
      Utility.showErrorSnackBar("Product Name required");
      return false;
    }

    if (selectedProductCategory.value == null) {
      Utility.showErrorSnackBar("Category required");
      return false;
    }

    if (selectedSubProductCategory.value == null) {
      Utility.showErrorSnackBar("Sub Category required");
      return false;
    }

    if (selectedGroup.value == null) {
      Utility.showErrorSnackBar("Group required");
      return false;
    }

    if (selectedUnit.value == null) {
      Utility.showErrorSnackBar("Unit required");
      return false;
    }

    if (taxrate.text.trim().isEmpty) {
      Utility.showErrorSnackBar("Tax rate required");
      return false;
    }

    return true;
  }

  Future<void> submitProduct() async {
    bool isValid = await validateProduct();
    if (!isValid) return;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );
      // isdataLoad = 0;

      StockItemEntity item = StockItemEntity();
      List<Map<String, dynamic>> stockListMap = [];
      item.companyId = Utility.companyId;
      item.itemId = editingProductCode;
      item.itemName = prddesc.text.trim();
      item.groupid = selectedGroup.value?.pGrpId ?? '';
      item.productCategoryCode = selectedProductCategory.value?.id ?? '';
      item.productSubCatCode = selectedSubProductCategory.value?.id ?? '';
      item.classification = selectedClassification.value ?? '';
      item.description = descriptionController.text.trim();
      item.unitName = selectedUnit.value?.pUnitId ?? '';
      item.hsnCode = hsncd.text.trim();
      item.hsndesc = hsndsc.text.trim();
      item.taxRate = taxrate.text.trim();
      item.activestatus = isActive.value ? "1" : "0";
      stockListMap.add(item.toMap());
      List<Map<String, dynamic>> payload = [item.toMap()];
      final response = await ApiCall.postItemMaster(payload);
      await productController.getProductMasterData();
      if (Get.isDialogOpen ?? false) Get.back();
      String message;
      try {
        // Try parsing as JSON
        final Map<String, dynamic> resJson = json.decode(response);
        message = resJson['message'] ?? response.toString();
      } catch (e) {
        // If parsing fails, assume response is plain string
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
      } else if (message == 'Data Inserted Successfully') {
        await Utility.showAlert(
          icons: Icons.check,
          iconcolor: Colors.green,
          title: 'Status',
          msg: 'Data Updated Successfully',
        );

        Get.back(result: true);
      } else if (message.contains('Already Exists')) {
        await Utility.showAlert(
          icons: Icons.close,
          iconcolor: Colors.red,
          title: 'Error',
          msg: 'Product Name Already Exists',
        );
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

  //Shweta 24-02-2026
  /// category selection
  void filterSubCatByCategory(String categoryId) {
    // Set selected category  category.id
    selectedProductCategory.value = productCategoryList.firstWhereOrNull(
      (c) => c.id == categoryId,
    );

    // Reset downstream selections
    selectedSubProductCategory.value = null;

    // Filter sub category for this category
    final filtered = productSubCategoryList
        .where((a) => a.parentCategoryId == categoryId)
        .toList();
    filteredSubCategoryList.assignAll(filtered);
  }

  void setUnitById(String id) {
    selectedUnit.value = unitList.firstWhereOrNull((e) => e.pUnitId == id);
  }

  void setGroupById(String id) {
    selectedGroup.value = groupList.firstWhereOrNull((e) => e.pGrpId == id);
  }

  void setCategoryById(String id) {
    selectedProductCategory.value = productCategoryList.firstWhereOrNull(
      (e) => e.id == id,
    );

    // Also filter subcategory list
    filterSubCatByCategory(id);
  }

  void setSubCategoryById(String id) {
    selectedSubProductCategory.value = productSubCategoryList.firstWhereOrNull(
      (e) => e.id == id,
    );
  }

  //shweta 25-02-2026
  Future<void> fetchProductMasterData() async {
    try {
      isLoading.value = true;
      final data = await ApiCall.getProdMasterData();

      unitList.assignAll(data.unit);
      // print("Unit count: ${data.unit.length}");
      // print(unitList);

      groupList.assignAll(data.group);
      productCategoryList.assignAll(data.category);
      productSubCategoryList.assignAll(data.subCategory);
    } catch (e) {
      print('Error fetching master data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
