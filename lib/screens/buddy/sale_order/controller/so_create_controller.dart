import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/company/partyentity.dart';
import 'package:sysconn_sfa/api/entity/company/stock_item_entity.dart';
import 'package:sysconn_sfa/api/entity/company/voucherentity.dart';
import 'package:sysconn_sfa/api/entity/order/sales_order_cart_entity.dart';
import 'package:sysconn_sfa/api/entity/order/sales_order_header_entity.dart';
import 'package:sysconn_sfa/api/entity/order/so_inv_report_entity.dart';

class CreateSoController extends GetxController {
  final String? hedId;
  final String? partyId;
  CreateSoController({this.hedId, this.partyId});
  final isDataLoad = 0.obs;
  final dateController = TextEditingController();
  final remarkController = TextEditingController();
  final paymentTermsController = TextEditingController();
  final itemAllSearchController = TextEditingController();
  var isHeaderSaved = false.obs;

  /// ───────────────────────── Totals ─────────────────────────
  final itemTotalNetAmount = 0.0.obs;
  final totalQuantity = 0.obs;
  num totalAmount = 0;
  RxString itemName = "".obs;

  /// ───────────────────────── Data ─────────────────────────
  final salesOrderHeaderEntity = Rxn<SalesOrderHeaderEntity>();

  final partyEntityList = <PartyEntity>[].obs;
  final vchEntityList = <VoucherEntity>[].obs;
  final stockItemList = <StockItemEntity>[].obs;
  final soGetItemList = <StockItemEntity>[].obs;

  final voucherEntitySelected = Rxn<VoucherEntity>();

  /// ───────────────────────── Item Search ─────────────────────────
  Future<void> itemsListData(String itemName) async {
    stockItemList.assignAll(
      await ApiCall.itemListApi(
        itemName: itemName,
        date: DateFormat(
          'yyyy-MM-dd',
        ).format(DateTime.parse(dateController.text)),
        pricelist: priceList.value,
      ),
    );
  }

  /// ───────────────────────── Header Fields ─────────────────────────
  final vchSelectedName = ''.obs;
  final vchSelectedId = ''.obs;

  final partySelectedName = ''.obs;
  final partySelectedId = ''.obs;
  final partyMobileNo = ''.obs;
  final priceList = ''.obs;

  final selectedDate = DateTime.now().obs;
  final salesOrderID = ''.obs;

  @override
  void onInit() {
    super.onInit();
    if (hedId != '' && hedId != null) {
      isHeaderSaved.value = true; //alter mode
    } else {
      isHeaderSaved.value = false; //for create mode
    }
    dateController.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    // itemsListData()
    _initialize();
  }

  /////////for add item-------------
  /// 🔹 Inventory Object
  var inv = SOInvReportEntity().obs;
  final qtyCtrl = TextEditingController(text: "0");
  final freeQtyCtrl = TextEditingController(text: "0");
  final rateCtrl = TextEditingController(text: "0");
  final discCtrl = TextEditingController(text: "0");
  final itemRemarkCtrl = TextEditingController();
  var ispricelistrate = false.obs;

  void onItemSelected(var selectedItem) {
    itemName.value = selectedItem.itemName!;

    inv.update((i) {
      i!.itemId = selectedItem.itemId;
      i.itemName = selectedItem.itemName;
      i.gstRate = selectedItem.taxRate;
      i.cessRate = selectedItem.cess;
      i.rate = selectedItem.priceListRate;
      i.discount = selectedItem.priceListDiscount;
    });
    // set controllers
    rateCtrl.text = selectedItem.priceListRate ?? "0";
    discCtrl.text = selectedItem.priceListDiscount ?? "0";

    // FIX ✅ correct condition
    ispricelistrate.value =
        (selectedItem.priceListRate == null ||
        selectedItem.priceListRate!.isEmpty);

    calculateInventoryAmount(inv.value);
  }

  void onQtyChanged(String val) {
    inv.update((i) => i!.qty = val);
    calculateInventoryAmount(inv.value);
  }

  void onRateChanged(String val) {
    inv.update((i) => i!.rate = val);
    calculateInventoryAmount(inv.value);
  }

  void onDiscountChanged(String val) {
    inv.update((i) => i!.discount = val);
    calculateInventoryAmount(inv.value);
  }

  void onRemarkChanged(String val) {
    inv.value.remark = val;
  }

  void clearAll() {
    inv.value = SOInvReportEntity();

    qtyCtrl.text = "0";
    rateCtrl.text = "0";
    discCtrl.text = "0";
    itemRemarkCtrl.clear();

    itemName.value = "";
  }

  void setEditItem(SOInvReportEntity item) {
    inv.value = item;

    itemName.value = item.itemName ?? "";

    qtyCtrl.text = item.qty ?? "0";
    rateCtrl.text = item.rate ?? "0";
    discCtrl.text = item.discount ?? "0";
    itemRemarkCtrl.text = item.remark ?? "";

    ispricelistrate.value = (item.rate == null || item.rate!.isEmpty);

    calculateInventoryAmount(inv.value);
  }

  /// ───────────────────────── Party / Voucher ─────────────────────────
  void setParty(PartyEntity party) {
    partySelectedName.value = party.partyName!;
    partySelectedId.value = party.partyId!;
    partyMobileNo.value = party.partyMobNo!;
    priceList.value = party.pricelist!;
  }

  void setVoucher(VoucherEntity vch) {
    vchSelectedName.value = vch.vchTypeName!;
    vchSelectedId.value = vch.vchTypeCode!;
  }

  Future<void> _initialize() async {
    try {
      isDataLoad.value = 0; // loading

      await Future.wait([_loadParties(), _loadVoucherTypes()]);

      if (partyId != null && partyId!.isNotEmpty) {
        final party = partyEntityList.firstWhereOrNull(
          (e) => e.partyId == partyId,
        );

        if (party != null) {
          setParty(party);
        }
      }

      if (hedId != null) {
        salesOrderID.value = hedId!;
        await loadSalesOrderForEdit();
      }

      isDataLoad.value = 1; // success
    } catch (e) {
      isDataLoad.value = 2; // error
      debugPrint('Init error: $e');
    }
  }

  Future<void> _loadParties() async {
    partyEntityList.assignAll(
      await ApiCall.getPartyDetCMPApi(partyType: 'Customer'),
    );
  }

  Future<void> _loadVoucherTypes() async {
    try {
      vchEntityList.clear();

      final vList = await ApiCall.getVoucherTypeMasterAPI();
      if (vList.isEmpty) return;

      final filtered = vList.where((e) => e.parent == 'Sales Order').toList();
      if (filtered.isEmpty) return;

      vchEntityList.assignAll(filtered);
      final first = filtered.first;

      voucherEntitySelected.value = first;
      vchSelectedName.value = first.vchTypeName ?? '';
      vchSelectedId.value = first.vchTypeCode ?? '';
    } catch (e) {
      if (kDebugMode) {
        debugPrint(" Error in _loadVoucherType: $e");
      }
    }
  }

  /// ───────────────────────── Inventory Amount ─────────────────────────

  void calculateInventoryAmount(SOInvReportEntity inv) {
    final qty = double.tryParse(inv.qty ?? '0') ?? 0;
    final rate = double.tryParse(inv.rate ?? '0') ?? 0;
    final discount = double.tryParse(inv.discount ?? '0') ?? 0;

    final amount = qty * rate;
    final discAmt = amount - (amount * discount / 100);

    final gstRate = double.tryParse(inv.gstRate ?? '0') ?? 0;
    final cessRate = double.tryParse(inv.cessRate ?? '0') ?? 0;

    final gstValue = discAmt * gstRate / 100;
    final cessValue = discAmt * cessRate / 100;

    inv.value = discAmt.toStringAsFixed(2);
    inv.gstValue = gstValue.toStringAsFixed(2);
    inv.cessValue = cessValue.toStringAsFixed(2);
    inv.netValue = (discAmt + gstValue + cessValue).toStringAsFixed(2);
  }

  Future<void> loadSalesOrderForEdit() async {
    // isInvGridRefresh.value = true;
    // trinaRows.clear();
    itemTotalNetAmount.value = 0;
    totalQuantity.value = 0;

    final salesDet = await ApiCall.getSalesOrderMasterDataAPI(
      uniqueId: salesOrderID.value,
    );

    if (salesDet == null) return;

    _bindHeaderToUI(salesDet);

    for (final inv in salesDet.inventory ?? []) {
      // itemTotalNetAmount.value += double.tryParse(inv.netValue ?? '0') ?? 0;
      itemTotalNetAmount.value += double.tryParse(inv.value ?? '0') ?? 0;
      totalQuantity.value += int.tryParse(inv.qty ?? '0') ?? 0;

      // trinaRows.add(_buildRow(inv));
    }

    totalAmount = itemTotalNetAmount.value;
    // isInvGridRefresh.value = false;
  }

  /// ───────────────────────── Header Binding (IMPORTANT) ─────────────────────────
  void _bindHeaderToUI(SalesOrderHeaderEntity h) {
    salesOrderHeaderEntity.value = h;
    // debugPrint('h.pricelist ${h.pricelist}');

    vchSelectedName.value = h.voucherTypeName ?? '';
    vchSelectedId.value = h.voucherType ?? '';

    partySelectedName.value = h.partyName ?? '';
    partySelectedId.value = h.partyId ?? '';
    partyMobileNo.value = h.partyMobileNo ?? '';

    priceList.value = h.pricelist ?? '';

    if ((h.date ?? '').isNotEmpty) {
      selectedDate.value = DateTime.parse(h.date!);
      dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate.value);
    }

    remarkController.text = h.narration ?? '';
  }

  String _generateInvoiceNo() {
    final vch = voucherEntitySelected.value;

    if (vch == null) return '';

    final now = DateTime.now();

    if ((vch.nyDate ?? '').isEmpty) {
      return vch.cyPfx ?? '';
    }

    final nyDate = DateFormat('yyyy-MM-dd').parse(vch.nyDate!);

    return now.isAfter(nyDate) ? vch.nyPfx! : vch.cyPfx!;
  }

  Future<bool> _isHeaderValid() async {
    if (vchSelectedId.value.isEmpty) {
      scaffoldMessageValidationBar(Get.context!, 'Please select voucher type');
      return false;
    }

    if (partySelectedId.value.isEmpty) {
      scaffoldMessageValidationBar(Get.context!, 'Please select party');
      return false;
    }

    return true;
  }

  Future<void> postSOExtHeaderAPI() async {
    final isValid = await _isHeaderValid();
    if (!isValid) return;

    final header = SalesOrderHeaderEntity()
      ..companyId = Utility.companyId
      ..mobileNo = Utility.cmpmobileno
      ..voucherType = vchSelectedId.value
      ..partyId = partySelectedId.value
      ..date = DateFormat('yyyy-MM-dd').format(selectedDate.value)
      ..rateType = Utility.rateType
      ..invoiceNo = _generateInvoiceNo();

    // try {
    // Utility.showCircularLoadingWid(context);

    final response = await ApiCall.postSalesOrderHeaderAPI(header);

    // if (Get.isDialogOpen ?? false) Get.back();

    if (response['message'] == 'Data Inserted Successfully' &&
        (response['unique_id']?.isNotEmpty ?? false)) {
      salesOrderID.value = response['unique_id'];
      isHeaderSaved.value = true;
    }
  }

  /// Add / Update Inventory Item
  /// ─────────────────────────
  Future<bool> soInventoryDetailsPost({
    required SOInvReportEntity salesOrderEntity,
  }) async {
    if (salesOrderID.value.isEmpty) {
      scaffoldMessageValidationBar(
        Get.context!,
        'Please save Sales Order header first',
        isError: true,
      );
      return false;
    }

    try {
      // isLoading.value = true;
      // debugPrint('salesOrderEntity ${salesOrderEntity.toMap()}');

      final cart = SOAddToCartEntity()
        ..companyId = Utility.companyId
        ..hedUniqueId = salesOrderID.value
        ..itemId = salesOrderEntity.itemId
        ..quantity = salesOrderEntity.qty
        ..rate = salesOrderEntity.rate
        ..discount = salesOrderEntity.discount
        // ..value = salesOrderEntity.value
        ..value = double.parse(salesOrderEntity.value!).toStringAsFixed(2)
        ..gstRate = salesOrderEntity.gstRate
        ..cessRate = salesOrderEntity.cessRate
        // ..gstValue = salesOrderEntity.gstValue
        ..gstValue = double.parse(salesOrderEntity.gstValue!).toStringAsFixed(2)
        // ..cessValue = salesOrderEntity.cessValue
        ..cessValue = double.parse(
          salesOrderEntity.cessValue!,
        ).toStringAsFixed(2)
        // ..netValue = salesOrderEntity.netValue
        ..netValue = double.parse(salesOrderEntity.netValue!).toStringAsFixed(2)
        ..remark = salesOrderEntity.remark
        ..invid = salesOrderEntity.invId;

      final response = await ApiCall.postSOInventoryDetAPI([cart.toMap()]);

      if (response == 'Data Inserted Successfully') {
        itemName.value = "";
        await loadSalesOrderForEdit();
        Get.back();
        if (Get.isDialogOpen ?? false) Get.back();
        scaffoldMessageValidationBar(
          Get.context!,
          'Item added successfully',
          isError: false,
        );

        return true;
      }

      scaffoldMessageValidationBar(
        Get.context!,
        response.toString(),
        isError: true,
      );
      return false;
    } catch (e) {
      scaffoldMessageValidationBar(
        Get.context!,
        'Failed to add item: $e',
        isError: true,
      );
      return false;
    } finally {
      // isLoading.value = false;
    }
  }

  /// Save / Finalize Sales Order
  /// ─────────────────────────
  Future<void> sOSavePostApi() async {
    if (salesOrderID.value.isEmpty) {
      Get.snackbar(
        'Alert',
        'Please create Sales Order header first',
        backgroundColor: Colors.redAccent,
        colorText: Colors.white,
      );
      return;
    }

    final header = SalesOrderHeaderEntity()
      ..companyId = Utility.companyId
      ..uniqueId = salesOrderID.value
      ..amount = itemTotalNetAmount.value.toStringAsFixed(2)
      ..paymentTerms = paymentTermsController.text
      ..narration = remarkController.text
      ..giftReferenceNo = '';

    try {
      final response = await ApiCall.salesOrderSavePostApi([header.toMap()]);

      if (Get.isDialogOpen ?? false) Get.back();
      //Get.back();

      if (response == 'Data Inserted Successfully') {
        // snackbarMessageBar('Sales Order saved successfully', isError: false);
        await Utility.showAlert(
          icons: Icons.check,
          iconcolor: Colors.green,
          title: 'Status',
          msg: 'Sales Order Successfully Saved',
        );

        Get.back();
        // Get.back(result: true);

        // Close screen safely after snackbar
        // Future.delayed(const Duration(milliseconds: 700), () {
        //   if (!(Get.isDialogOpen ?? false)) {
        //     Get.back(result: true);
        //   }
        //   Get.back();
        //   Get.back();
        // });
      } else {
        scaffoldMessageValidationBar(
          Get.context!,
          response.toString(),
          isError: true,
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();

      scaffoldMessageValidationBar(
        Get.context!,
        'Failed to save Sales Order: $e',
        isError: true,
      );
    }
  }

  //  Future<bool> deleteOrder() async {
  //   final so = SalesOrderHeaderEntity()
  //     ..companyId = Utility.companyId
  //     ..mobileNo = Utility.cmpmobileno
  //     ..uniqueId = salesOrderID.value;

  //   return await ApiCall.deleteSODetAPI(so) == 'Data Deleted Successfully';
  // }

  Future<void> deleteOrder() async {
    final so = SalesOrderHeaderEntity()
      ..companyId = Utility.companyId
      ..mobileNo = Utility.cmpmobileno
      ..uniqueId = salesOrderID.value;

    try {
      final response = await ApiCall.deleteSODetAPI(so);

      if (response == 'Data Deleted Successfully') {
        Get.back();
        scaffoldMessageValidationBar(
          Get.context!,
          'Sales Order deleted successfully',
          isError: false,
        );
      } else {
        scaffoldMessageValidationBar(
          Get.context!,
          response.toString(),
          isError: true,
        );
      }
    } catch (e) {
      scaffoldMessageValidationBar(
        Get.context!,
        'Failed to delete Sale Order: $e',
        isError: true,
      );
    }
  }

  /// ─────────────────────────
  /// Delete Sales Order Inventory Item
  /// ─────────────────────────
  Future<void> deleteInventoryItem(String invId) async {
    if (invId.isEmpty) return;

    final payload = SOAddToCartEntity()
      ..companyId = Utility.companyId
      ..hedUniqueId = salesOrderID.value
      ..invid = invId;

    try {
      final response = await ApiCall.deleteSOInventoryDetAPI(payload);

      // Utility.hideCircularLoadingWid();

      if (response == 'Data Deleted Successfully') {
        Get.back();
        await loadSalesOrderForEdit();

        scaffoldMessageValidationBar(
          Get.context!,
          'Item deleted successfully',
          isError: false,
        );
      } else {
        scaffoldMessageValidationBar(
          Get.context!,
          response.toString(),
          isError: true,
        );
      }
    } catch (e) {
      scaffoldMessageValidationBar(
        Get.context!,
        'Failed to delete item: $e',
        isError: true,
      );
    }
  }
}
