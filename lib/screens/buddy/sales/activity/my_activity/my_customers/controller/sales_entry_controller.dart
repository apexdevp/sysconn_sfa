import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/sales/sales_header_entity.dart';
import 'package:sysconn_sfa/api/entity/buddy/sales/sales_inventory_entity.dart';
import 'package:sysconn_sfa/api/entity/company/godown_master_entity.dart';
import 'package:sysconn_sfa/api/entity/company/ledger_entity.dart';
import 'package:sysconn_sfa/api/entity/company/partyentity.dart';
import 'package:sysconn_sfa/api/entity/company/stock_item_entity.dart';
import 'package:sysconn_sfa/api/entity/company/voucherentity.dart';
import 'package:sysconn_sfa/api/entity/sales/sales_ledger_entity.dart';
import 'package:trina_grid/trina_grid.dart';

class SalesController extends GetxController with GetTickerProviderStateMixin {
  //GetSingleTickerProviderStateMixin {
  final String? hedId;
  final String? vchType;
  final bool isEdit;
  final String? partyId;
  // final additionalController = Get.put(AdditionalDetailsController(salesHeaderEntity: s));

  SalesController({
    this.hedId,
    this.vchType,
    required this.isEdit,
    this.partyId,
  });

  final partyEntityList = <PartyEntity>[].obs;

  /// Voucher list
  final vchEntityList = <VoucherEntity>[].obs;
  final voucherEntitySelected = Rxn<VoucherEntity>();
  

  /// Items from search API
  final stockItemList = <StockItemEntity>[].obs;
  final ledgerMasterlist = <LedgerMasterEntity>[].obs;

  /// Selected voucher fields
  final vchSelectedName = ''.obs;
  final vchSelectedId = ''.obs;
  final invoiceNo = ''.obs;

  final posPaymentEnable = 'No'.obs;
  var salesLedgerList = <SalesLedgerEntity>[].obs;
  var ledgerTotalAmount = 0.0.obs;

  /// Selected party fields
  final partySelectedName = ''.obs;
  final partySelectedId = ''.obs;
  final partyMobileNo = ''.obs;
  final priceList = ''.obs;

  /// Sales Header + Totals
  // final salesHeaderEntity = Rxn<dynamic>();
  Rxn<SalesHeaderEntity> salesHeaderEntity = Rxn<SalesHeaderEntity>();
  final salesUniqueId = ''.obs;

  final itemTotalNetAmount = 0.0.obs;

  final RxDouble itemGstTotalAmount = 0.0.obs;
  final RxDouble totalAmount = 0.0.obs;


  /// Loading flags
  final isDataLoad = 0.obs;

  /// GST / Tally Flags
  final isGstAutoCalEnable = true.obs;
  final isTallyEntry = false.obs;

  /// Date
  final selectedDate = DateTime.now().obs;
  // final dateController = TextEditingController();
  DateTime dateController = DateTime.now();

  /// Ledger Lists
  // final ledgerMasterList = <dynamic>[].obs;
  final postingLedgerList = <dynamic>[].obs;

  // ---------------------- INVENTORY ENTITY (CURRENT EDIT/ADD ITEM) ----------------------
  Rx<SalesInventoryEntity> salesInvEntity = SalesInventoryEntity().obs;
  Rx<SalesLedgerEntity> salesLedgerEntity = SalesLedgerEntity().obs;

  // ---------------------- UI FIELDS ----------------------
  RxString itemName = "".obs;
  RxString postingLedgerName = "".obs;
  RxString postingLedgerId = "".obs;
  RxString godownName = "".obs;
  RxString godownId = "".obs;

  RxString ledgerName = "".obs;
  RxString ledgerID = "".obs;

  // ---------------------- DROPDOWN / FLAGS ----------------------
  RxBool isAddUnitApplicable = false.obs;
  Rx<num> conversion = 0.obs;
  Rx<num> denominator = 0.obs;
  Rx<num> billQty = 0.obs;
  // GST Ledger Amounts
  RxDouble cgstLedgerAmt = 0.0.obs;
  RxDouble sgstLedgerAmt = 0.0.obs;
  RxDouble igstLedgerAmt = 0.0.obs;

  // ---------------------- CONTROLLERS ----------------------
  TextEditingController itemRemarkController = TextEditingController();
  TextEditingController quantityController = TextEditingController();
  TextEditingController rateController = TextEditingController();
  TextEditingController discountController = TextEditingController();
  TextEditingController freeQtyController = TextEditingController();
  TextEditingController totalQtyController = TextEditingController();
  TextEditingController cashController = TextEditingController();
  TextEditingController bankInstNoController = TextEditingController();
  TextEditingController bankAmtController = TextEditingController();
  TextEditingController cardInstNoController = TextEditingController();
  TextEditingController cardAmtController = TextEditingController();
  TextEditingController giftReferenceController = TextEditingController();
  TextEditingController giftAmtController = TextEditingController();
  TextEditingController schemeDiscController = TextEditingController();

  // ---------------------- LISTS FOR AUTOCOMPLETE ----------------------
  List<PartyEntity> postingLedgerlist = [];
  List<String> unitPerList = ["%", "Amt", "Unit"];
  List<GodownMasterEntity> godownData = [];

  /// Extra fields
  final remarkController = TextEditingController();
  final paymentTermsController = TextEditingController();
  final orgInvNoController = TextEditingController();
  final orgInvDateController = TextEditingController();
  DateTime selectedOrgInvDate = DateTime.now();
  final creditNoteReasonSelected = ''.obs;
  // bool isCGSTApplicable = false;
  RxBool isCGSTApplicable = false.obs;
  // Rx<void> paymentTotal = Rx<void>(null);
  RxDouble paymentTotal = 0.0.obs;

  TrinaGridStateManager? stateManager;

  late TabController tabController;
  TabController? tabledgerController;
  List<String> osDashTabMenuList = [];

  var creditNoteReasonItem = [
    'Not Applicable',
    '01-Sales Return',
    '02-Post Sales Discount',
    '03-Deficiency in services',
    '04-Correction in Invoice',
    '05-Change in POS',
    '06-Finalization of Provisional assessment',
    '07-Others',
  ];

  // ---------------------------------------------------------------------------
  // LIFECYCLE
  // ---------------------------------------------------------------------------

  void clearInventoryForm() {
    salesInvEntity.value = SalesInventoryEntity();

    itemName.value = "";

    quantityController.clear();
    rateController.clear();
    discountController.clear();
    freeQtyController.clear();
    totalQtyController.clear();
    itemRemarkController.clear();

    postingLedgerName.value = "";
    godownName.value = "";
  }

  void calculateInventoryTotal() {
  final qty = double.tryParse(quantityController.text) ?? 0;
  final free = double.tryParse(freeQtyController.text) ?? 0;
  final rate = double.tryParse(rateController.text) ?? 0;
  final discount = double.tryParse(discountController.text) ?? 0;

  totalQtyController.text = (qty + free).toString();

  final calc = calTotalAmountValue(
    invQty: qty.toString(),
    invRate: rate.toString(),
    invDisc: discount.toString(),
    taxRate: salesInvEntity.value.gstrate?.toString() ?? "0",
  );

  salesInvEntity.update((inv) {
    if (inv == null) return;

    inv.qty = qty.toString();
    inv.rate = rate.toString();
    inv.discount = discount.toString();
    inv.netValue = calc.netValue;
    inv.gstvalue = calc.gstvalue;
    inv.totalvalue = calc.totalvalue;
  });

  salesInvEntity.refresh(); 
}

  

  @override
  void onInit() {
    super.onInit();

    osDashTabMenuList = ['Inventory', 'Ledger'];
    tabController = TabController(length: osDashTabMenuList.length, vsync: this);

    // Initial creation
    _initTableLedgerController();

    // React to changes
    ever(posPaymentEnable, (_) {
      _initTableLedgerController();
    });

    dateController = selectedDate
        .value; //DateFormat('yyyy-MM-dd').format(selectedDate.value);

    vchType != null ? _initVoucherMode(vchType!) : dataLoadCall();

    cashController.addListener(calculatePaymentTotal);
    bankAmtController.addListener(calculatePaymentTotal);
    cardAmtController.addListener(calculatePaymentTotal);
    giftAmtController.addListener(calculatePaymentTotal);
  }
  // @override
  // void onInit() {
  //   super.onInit();

  //   tabController = TabController(
  //     length: 2,
  //     vsync: this,
  //   );

  //   dateController.text =
  //       DateFormat('yyyy-MM-dd').format(selectedDate.value);
  //   _initTableLedgerController();

  //   ever(posPaymentEnable, (_) {
  //     _initTableLedgerController();
  //   });

  //   vchType != null ? _initVoucherMode(vchType!) : dataLoadCall();

  //   cashController.addListener(calculateTotal);
  //   bankAmtController.addListener(calculateTotal);
  //   cardAmtController.addListener(calculateTotal);
  //   giftAmtController.addListener(calculateTotal);
  // }

  void _initTableLedgerController() {
    final newLength = posPaymentEnable.value == 'Yes' ? 2 : 1;

    // If already correct length, don't recreate
    if (tabledgerController != null &&
        tabledgerController!.length == newLength) {
      return;
    }

    tabledgerController?.dispose();

    tabledgerController = TabController(length: newLength, vsync: this);

    update();
  }

  void calculatePaymentTotal() {
    paymentTotal.value =
        (double.tryParse(cashController.text) ?? 0) +
        (double.tryParse(bankAmtController.text) ?? 0) +
        (double.tryParse(cardAmtController.text) ?? 0) +
        (double.tryParse(giftAmtController.text) ?? 0);
  }

  @override
  void onClose() {
    tabController.dispose();
    tabledgerController?.dispose();
    // dateController.dispose();
    remarkController.dispose();
    paymentTermsController.dispose();
    orgInvNoController.dispose();
    orgInvDateController.dispose();
    super.onClose();
  }

  // ---------------------------------------------------------------------------
  // INITIALIZERS
  // ---------------------------------------------------------------------------

  Future<void> _initVoucherMode(String vType) async {
    try {
      // Party type based on Sales / Purchase mode
      // final partyType = 'Customer';

      // debugPrint("Stepxd");
      // partyEntityList.value = await ApiCall.getPartyDetCMPApi(
      //   partyType: partyType,
      // );
      // if (partyId != null && partyId!.isNotEmpty) {
      //   final party = partyEntityList.firstWhereOrNull(
      //     (e) => e.partyId == partyId,
      //   );

      //   if (party != null) {
      //     setParty(party);
      //   }
      // }
      //  debugPrint("Step");
      await _loadVoucherType();
      // debugPrint("Step 1");
      await _loadSalesLedgerMasters();
      // debugPrint("Step 2");
      await dataLoadCall();
      // debugPrint("Step 3");
    } catch (e) {
      if (kDebugMode) {
        debugPrint(" Error in _initVoucherMode: $e");
      }
    }
  }

  // ---------------------------------------------------------------------------
  // LOAD MASTER DATA
  // ---------------------------------------------------------------------------

  //pratiksha p 13-04-2026 
  Future<void> customerListData(String customerName) async {
    partyEntityList.assignAll(
      await ApiCall.getCustomerdatalistApi(
        customerName: customerName,
      ),
    );
  }
  

  Future<void> _loadVoucherType() async {
    try {
      vchEntityList.clear();

      final vList = await ApiCall.getVoucherTypeMasterAPI();
      if (vList.isEmpty) return;

      final filtered = vList.where((e) => e.parent == vchType).toList();
      if (filtered.isEmpty) return;

      vchEntityList.assignAll(filtered);
      final first = filtered.first;

      voucherEntitySelected.value = first;
      vchSelectedName.value = first.vchTypeName ?? '';
      vchSelectedId.value = first.vchTypeCode ?? '';

      // Invoice prefix logic
      final parsedNy = first.nyDate?.isEmpty ?? true
          ? null
          : DateFormat("yyyy-MM-dd").parse(first.nyDate!);

      invoiceNo.value = (parsedNy == null || dateController.isBefore(parsedNy))
          // DateFormat(
          //   "yyyy-MM-dd",
          // ).parse(dateController.text).isBefore(parsedNy))
          ? first.cyPfx ?? ''
          : first.nyPfx ?? '';

      posPaymentEnable.value = first.posPaymentEnable!;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(" Error in _loadVoucherType: $e");
      }
    }
  }

  Future<void> _loadSalesLedgerMasters() async {
    try {
      ledgerMasterlist.clear();

      String ledgerType = (vchType == 'Sales' || vchType == 'Credit Note')
        ? "('Sales Accounts','Direct Incomes','Indirect Incomes')"
        : "('Purchase Accounts','Direct Expenses','Indirect Expenses')";

      final list = await ApiCall.getledgermasterapi(typedata: ledgerType, ledgerid: "");
      if (list.isNotEmpty) ledgerMasterlist.assignAll(list);
      //  debugPrint('ledgerMasterlist ${ledgerMasterlist.toJson()}');
    } catch (e) {
      if (kDebugMode) {
        debugPrint(" Error in _loadSalesLedgerMasters: $e");
      }
    }
  }

  Future<void> _loadPostingLedger() async {
    try {
      postingLedgerList.clear();

      final type = (vchType == 'Sales' || vchType == 'Credit Note')
          ? "('Sales Accounts','Direct Incomes','Indirect Incomes')"
          : "('Purchase Accounts','Direct Expenses','Indirect Expenses')";

      final list = await ApiCall.getledgermasterapi(
        typedata: type,
        ledgerid: '',
      );
      if (list.isNotEmpty) postingLedgerList.assignAll(list);
    } catch (e) {
      if (kDebugMode) {
        debugPrint(" Error in _loadPostingLedger: $e");
      }
    }
  }

  Future<void> godownList() async {
    try {
      godownData = [];
      await ApiCall.getGodownmasterApi(godown: '').then((godownlistdata) {
        if (godownlistdata.isNotEmpty) {
          godownData = godownlistdata;
        }
      });
    } catch (e) {
      if (kDebugMode) {
        debugPrint(" Error in godownList: $e");
      }
    }
  }

  Future postingLedgerMasterList() async {
    postingLedgerList.clear();

    String ledgerType = (vchType == 'Sales' || vchType == 'Credit Note')
        ? "('Sales Accounts','Direct Incomes','Indirect Incomes')"
        : "('Purchase Accounts','Direct Expenses','Indirect Expenses')";

    final ledgerList = await ApiCall.getledgermasterapi(
      typedata: ledgerType,
      ledgerid: "",
    );

    if (ledgerList.isNotEmpty) {
      postingLedgerList.assignAll(ledgerList);
    }
  }

  // ---------------------------------------------------------------------------
  // LOAD SALES DATA (NEW / EDIT)
  // ---------------------------------------------------------------------------

  Future<void> dataLoadCall() async {
    try {
      isDataLoad.value = 0;

      if (hedId == null) {
        isDataLoad.value = 1;
        return;
      }

      salesUniqueId.value = hedId!;
      await _loadPostingLedger();
      await godownList();
      await getSalesDataAPI();

      isDataLoad.value = 1;
    } catch (e) {
      if (kDebugMode) {
        debugPrint(" Error in dataLoadCall: $e");
      }
      isDataLoad.value = 1;
    }
  }


Future<void> getSalesDataAPI({bool isInvClicked = false}) async {
  try {
    /// ---------- RESET TOTALS ONLY (not the lists) ----------
    itemTotalNetAmount.value = 0.0;
    ledgerTotalAmount.value = 0.0;
    itemGstTotalAmount.value = 0.0;

    // ✅ DO NOT null salesHeaderEntity or clear salesLedgerList here.
    // Clearing them before the API returns causes the blank flash.
    // They are replaced atomically below once data arrives.

    /// ---------- API CALL ----------
    final salesDet = await ApiCall.getSalesMasterDataAPI(
      uniqueId: salesUniqueId.value,
    );

    if (salesDet == null) {
      debugPrint('getSalesDataAPI: salesDet is NULL');
      return;
    }

    // ✅ NOW replace — both assignments happen in the same frame,
    //    so Obx only rebuilds once with complete data.
    salesHeaderEntity.value = salesDet;
    salesLedgerList.clear(); // clear only after new data is ready

    salesUniqueId.value = salesDet.uniqueId ?? '';
//     /// ---------- VOUCHER ----------
      vchSelectedName.value = salesDet.voucherTypeName ?? '';
      vchSelectedId.value = salesDet.voucherType ?? '';
      posPaymentEnable.value = salesDet.posPayment ?? '';
      if (kDebugMode) {
        debugPrint('posPaymentEnable $posPaymentEnable');
      }

      /// ---------- PARTY ----------
      partySelectedName.value = salesDet.partyName ?? '';
      partySelectedId.value = salesDet.partyId ?? '';
      partyMobileNo.value = salesDet.partyMobileNo ?? '';
      priceList.value = salesDet.pricelist ?? '';

      /// ---------- DATE ----------
      if (salesDet.date != null && salesDet.date!.isNotEmpty) {
        final parsedDate = DateTime.tryParse(salesDet.date!);
        if (parsedDate != null) {
          selectedDate.value = parsedDate;
          dateController =
              parsedDate; //DateFormat('yyyy-MM-dd').format(parsedDate);
        }
      }

      /// ---------- EXTRA HEADER FIELDS ----------
      remarkController.text = salesDet.narration ?? '';
      paymentTermsController.text = salesDet.paymentTerms ?? '';
      orgInvNoController.text = salesDet.originalInvoiceNo ?? '';
      orgInvDateController.text = salesDet.originalInvoiceDate ?? '';
      creditNoteReasonSelected.value = salesDet.cnReason ?? '';

      isGstAutoCalEnable.value = salesDet.isGstAutoCal == 'Yes';
      isTallyEntry.value = salesDet.isTalyEntry == 'Yes';

      cashController.text = salesDet.cashAmount ?? '';
      bankAmtController.text = salesDet.bankAmount ?? '';
      bankInstNoController.text = salesDet.bankInstNo ?? '';
      cardInstNoController.text = salesDet.cardInstNo ?? '';
      cardAmtController.text = salesDet.cardAmount ?? '';
      giftReferenceController.text = salesDet.giftReferenceNo ?? '';
      giftAmtController.text = salesDet.giftAmount ?? '';

      /// ---------- ITEMS ----------
      if (salesDet.items != null && salesDet.items!.isNotEmpty) {
        for (final item in salesDet.items!) {
          final net = double.tryParse(item.netValue?.toString() ?? '0') ?? 0.0;
          final gst = double.tryParse(item.gstvalue?.toString() ?? '0') ?? 0.0;

          itemTotalNetAmount.value += net;

          if (isGstAutoCalEnable.value) {
            itemGstTotalAmount.value += gst;
            cgstLedgerAmt.value = isCGSTApplicable.value
                ? itemGstTotalAmount.value / 2
                : 0.0;
            sgstLedgerAmt.value = isCGSTApplicable.value
                ? itemGstTotalAmount.value / 2
                : 0.0;
            igstLedgerAmt.value = isCGSTApplicable.value
                ? 0.0
                : itemGstTotalAmount.value;
          }
        }
      }

      /// ---------- LEDGER ----------
      // if (salesDet.ledger != null && salesDet.ledger!.isNotEmpty) {
      //   for (final l in salesDet.ledger!) {
      //     salesLedgerList.add(l);
      //     ledgerTotalAmount.value +=
      //         double.tryParse(l.amount?.toString() ?? '0') ?? 0.0;
      //   }
      // }

      const excludedLedgers = ['igst', 'cgst', 'sgst'];

      if (salesDet.ledger != null && salesDet.ledger!.isNotEmpty) {
        for (final l in salesDet.ledger!) {
          salesLedgerList.add(l);

          if (!excludedLedgers.contains((l.ledgerName ?? '').toLowerCase())) {
            ledgerTotalAmount.value +=
                double.tryParse(l.amount?.toString() ?? '0') ?? 0.0;
          }
        }
      }

      /// ---------- TOTAL ----------
      totalAmount.value =
          itemTotalNetAmount.value +
          ledgerTotalAmount.value +
          (isGstAutoCalEnable.value ? itemGstTotalAmount.value : 0.0);

      // debugPrint(
      //   'Sales Loaded | Items: ${salee.length}, Ledgers: ${salesLedgerList.length}',
      // );
  
  } catch (e, st) {
    debugPrint('Error in getSalesDataAPI: $e');
    debugPrint(st.toString());
  }
}

  // Future<void> getSalesDataAPI({bool isInvClicked = false}) async {
  //   try {
  //     /// ---------- RESET STATE ----------
  //     itemTotalNetAmount.value = 0.0;
  //     ledgerTotalAmount.value = 0.0;
  //     itemGstTotalAmount.value = 0.0;

  //     trinaRows.clear();
  //     salesLedgerList.clear();
  //     if (!isInvClicked) {
  //       //test

  //       salesHeaderEntity.value = null;
  //     }

  //     /// ---------- API CALL ----------
  //     final salesDet = await ApiCall.getSalesMasterDataAPI(
  //       uniqueId: salesUniqueId.value,
  //     );

  //     if (salesDet == null) {
  //       debugPrint('getSalesDataAPI: salesDet is NULL');
  //       return;
  //     }

  //     /// ---------- HEADER ----------
  //     salesHeaderEntity.value = salesDet;
  //     debugPrint(
  //       'salesHeaderEntity.value ${salesHeaderEntity.value!.uniqueId}',
  //     );
  //     salesUniqueId.value = salesDet.uniqueId ?? '';

  //     /// ---------- VOUCHER ----------
  //     vchSelectedName.value = salesDet.voucherTypeName ?? '';
  //     vchSelectedId.value = salesDet.voucherType ?? '';
  //     posPaymentEnable.value = salesDet.posPayment ?? '';
  //     if (kDebugMode) {
  //       debugPrint('posPaymentEnable $posPaymentEnable');
  //     }

  //     /// ---------- PARTY ----------
  //     partySelectedName.value = salesDet.partyName ?? '';
  //     partySelectedId.value = salesDet.partyId ?? '';
  //     partyMobileNo.value = salesDet.partyMobileNo ?? '';
  //     priceList.value = salesDet.pricelist ?? '';

  //     /// ---------- DATE ----------
  //     if (salesDet.date != null && salesDet.date!.isNotEmpty) {
  //       final parsedDate = DateTime.tryParse(salesDet.date!);
  //       if (parsedDate != null) {
  //         selectedDate.value = parsedDate;
  //         dateController =
  //             parsedDate; //DateFormat('yyyy-MM-dd').format(parsedDate);
  //       }
  //     }

  //     /// ---------- EXTRA HEADER FIELDS ----------
  //     remarkController.text = salesDet.narration ?? '';
  //     paymentTermsController.text = salesDet.paymentTerms ?? '';
  //     orgInvNoController.text = salesDet.originalInvoiceNo ?? '';
  //     orgInvDateController.text = salesDet.originalInvoiceDate ?? '';
  //     creditNoteReasonSelected.value = salesDet.cnReason ?? '';

  //     isGstAutoCalEnable.value = salesDet.isGstAutoCal == 'Yes';
  //     isTallyEntry.value = salesDet.isTalyEntry == 'Yes';

  //     cashController.text = salesDet.cashAmount ?? '';
  //     bankAmtController.text = salesDet.bankAmount ?? '';
  //     bankInstNoController.text = salesDet.bankInstNo ?? '';
  //     cardInstNoController.text = salesDet.cardInstNo ?? '';
  //     cardAmtController.text = salesDet.cardAmount ?? '';
  //     giftReferenceController.text = salesDet.giftReferenceNo ?? '';
  //     giftAmtController.text = salesDet.giftAmount ?? '';

  //     /// ---------- ITEMS ----------
  //     if (salesDet.items != null && salesDet.items!.isNotEmpty) {
  //       for (final item in salesDet.items!) {
  //         final net = double.tryParse(item.netValue?.toString() ?? '0') ?? 0.0;
  //         final gst = double.tryParse(item.gstvalue?.toString() ?? '0') ?? 0.0;

  //         itemTotalNetAmount.value += net;

  //         if (isGstAutoCalEnable.value) {
  //           itemGstTotalAmount.value += gst;
  //           cgstLedgerAmt.value = isCGSTApplicable.value
  //               ? itemGstTotalAmount.value / 2
  //               : 0.0;
  //           sgstLedgerAmt.value = isCGSTApplicable.value
  //               ? itemGstTotalAmount.value / 2
  //               : 0.0;
  //           igstLedgerAmt.value = isCGSTApplicable.value
  //               ? 0.0
  //               : itemGstTotalAmount.value;
  //         }
  //         trinaRows.add(
  //           TrinaRow(
  //             cells: {
  //               'config': TrinaCell(value: ''),
  //               'inv_id': TrinaCell(value: item.invId ?? ''),
  //               'item_code': TrinaCell(value: item.itemId ?? ''),
  //               'item_name': TrinaCell(value: item.itemName ?? ''),
  //               'unit': TrinaCell(value: item.unit ?? ''),
  //               'tax': TrinaCell(value: item.gstrate ?? ''),
  //               'qty': TrinaCell(
  //                 value: num.tryParse(item.qty ?? "0") ?? 0,
  //               ), //item.qty ?? ''),
  //               'rate': TrinaCell(
  //                 value: num.tryParse(item.rate ?? "0") ?? 0,
  //               ), // item.rate ?? ''),
  //               'disc': TrinaCell(
  //                 value: num.tryParse(item.discount ?? "0") ?? 0,
  //               ), //item.discount ?? ''),
  //               'value': TrinaCell(
  //                 value: num.tryParse(item.netValue ?? "0") ?? 0,
  //               ), //item.netValue ?? ''),
  //             },
  //           ),
  //         );
  //       }
  //     }

  //     /// ---------- LEDGER ----------
  //     // if (salesDet.ledger != null && salesDet.ledger!.isNotEmpty) {
  //     //   for (final l in salesDet.ledger!) {
  //     //     salesLedgerList.add(l);
  //     //     ledgerTotalAmount.value +=
  //     //         double.tryParse(l.amount?.toString() ?? '0') ?? 0.0;
  //     //   }
  //     // }

  //     const excludedLedgers = ['igst', 'cgst', 'sgst'];

  //     if (salesDet.ledger != null && salesDet.ledger!.isNotEmpty) {
  //       for (final l in salesDet.ledger!) {
  //         salesLedgerList.add(l);

  //         if (!excludedLedgers.contains((l.ledgerName ?? '').toLowerCase())) {
  //           ledgerTotalAmount.value +=
  //               double.tryParse(l.amount?.toString() ?? '0') ?? 0.0;
  //         }
  //       }
  //     }

  //     /// ---------- TOTAL ----------
  //     totalAmount.value =
  //         itemTotalNetAmount.value +
  //         ledgerTotalAmount.value +
  //         (isGstAutoCalEnable.value ? itemGstTotalAmount.value : 0.0);

  //     debugPrint(
  //       'Sales Loaded | Items: ${trinaRows.length}, Ledgers: ${salesLedgerList.length}',
  //     );
  //   } catch (e, st) {
  //     debugPrint('Error in getSalesDataAPI');
  //     debugPrint(e.toString());
  //     debugPrint(st.toString());
  //   }
  // }

  // ---------------------------------------------------------------------------
  // ITEM SEARCH
  // ---------------------------------------------------------------------------

  Future<void> itemsListData(String itemName) async {
    stockItemList.clear();

    final dateStr = dateController;
    //  DateFormat(
    //   'yyyy-MM-dd',
    // ).format(DateTime.parse(dateController.text));

    final list = await ApiCall.itemListApi(
      itemName: itemName,
      date: dateStr.toString(),
      pricelist: priceList.value,
    );

    if (list.isNotEmpty) stockItemList.assignAll(list);
  }

  // ---------------------------------------------------------------------------
  // SETTERS
  // ---------------------------------------------------------------------------

  void setVoucher(VoucherEntity v) {
    voucherEntitySelected.value = v;
    vchSelectedName.value = v.vchTypeName ?? '';
    vchSelectedId.value = v.vchTypeCode ?? '';
    if (kDebugMode) {
      debugPrint('working11');
    }
  }

  void clearVoucher() {
    voucherEntitySelected.value = null;
    vchSelectedName.value = '';
    vchSelectedId.value = '';
  }

  void setParty(PartyEntity p) {
    partySelectedName.value = p.partyName ?? '';
    partySelectedId.value = p.partyId ?? '';
    partyMobileNo.value = p.partyMobNo ?? '';
    priceList.value = p.pricelist ?? '';
    if (kDebugMode) {
      debugPrint('working');
    }
  }

  Future<void> deleteLedgerPostApi(
    SalesLedgerEntity salesLedgerSelectedEntity,
  ) async {
    try {
      SalesLedgerEntity deleteLedgerDetailEntity = SalesLedgerEntity();
      deleteLedgerDetailEntity.companyid = Utility.companyId;
      deleteLedgerDetailEntity.mobileno = Utility.cmpmobileno;
      deleteLedgerDetailEntity.ledgerUniqueId =
          salesLedgerSelectedEntity.ledgerUniqueId;

      List<Map<String, dynamic>> ledgerEntityListMap = [];
      ledgerEntityListMap.add(deleteLedgerDetailEntity.toMap());

      await ApiCall.deleteLedgerSalesApi(
        salesLedgerEntityListMap: ledgerEntityListMap,
      );

      // Close dialog or previous screen
      Get.back();
      getSalesDataAPI();
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        icon: const Icon(Icons.error, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  //////////////////////////////// Sales Header /////////////////////////////////////////
  Future checkHedValidBool() async {
    if (vchSelectedId.value == '') {
      scaffoldMessageBar('Please enter voucher name');
      return false;
    } else if (partySelectedId.value == '') {
      scaffoldMessageBar('Please enter party name');
      return false;
    } else {
      return true;
    }
  }

  Future<bool> salesHeaderPostApi() async {
    bool isValid = await checkHedValidBool();

    if (!isValid) return false;

    SalesHeaderEntity salesHedEntity = SalesHeaderEntity();
    salesHedEntity.companyId = Utility.companyId;
    // salesHedEntity.mobileno = Utility.cmpmobileno;
    salesHedEntity.invoiceNo = invoiceNo.value;
    salesHedEntity.voucherType = vchSelectedId.value;
    salesHedEntity.partyId = partySelectedId.value;
    salesHedEntity.date = salesHedEntity.date = DateFormat("yyyy-MM-dd").format(dateController);
    // DateFormat(
    //   'yyyy-MM-dd',
    // ).format(DateFormat('dd/MM/yyyy').parse(selectedDate.toString()));// dateController.toString();
    salesHedEntity.paymentTerms = paymentTermsController.text;
    salesHedEntity.partyMobileNo = partyMobileNo.value;
    salesHedEntity.narration = remarkController.text;
    salesHedEntity.type = vchType; // since in GetX we don't use widget.vchType
    salesHedEntity.originalInvoiceNo = orgInvNoController.text;
    salesHedEntity.originalInvoiceDate = orgInvDateController.text.isEmpty
        ? ''
        : orgInvDateController.text;
    salesHedEntity.cnReason = creditNoteReasonSelected.value;
    salesHedEntity.isGstAutoCal = isGstAutoCalEnable.value ? 'Yes' : 'No';
    salesHedEntity.salespersonid = Utility.useremailid;
   
    final response = await ApiCall.salesHedPostApi(salesHedEntity);
    Get.back();
    if (response['message'] == 'Data Inserted Successfully') {
      salesUniqueId.value = response['unique_id'];
      await getSalesDataAPI();
      await godownList();
      await postingLedgerMasterList();
      // Open inventory dialog
      return true;
    } else {
      Get.snackbar(
        "Error",
        'Oops! There is an error.',
        icon: const Icon(Icons.error, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,
      );
      return false;
    }
  }

  Future<void> deleteAllSalesApi() async {
    try {
      SalesHeaderEntity deleteSalesDetailEntity = SalesHeaderEntity();
      deleteSalesDetailEntity.companyId = Utility.companyId;
      deleteSalesDetailEntity.uniqueId = salesUniqueId.value;
      deleteSalesDetailEntity.type = vchType;

      List<Map<String, dynamic>> salesEntityListMap = [];
      salesEntityListMap.add(deleteSalesDetailEntity.toMap());

      final response = await ApiCall.deleteSalesApi(
        salesEntityListMap: salesEntityListMap,
      );

      if (response == "Data Deleted Successfully") {
        // Close screens
        Get.back();
        Get.back();

        await Utility.showAlert(
          icons: Icons.check,
          iconcolor: Colors.green,
          title: 'Status',
          msg: 'Data Deleted Successfully',
        );
      } else {
        Get.snackbar(
          "Error",
          "Oops there is an error!",
          icon: const Icon(Icons.close, color: Colors.red),
          snackPosition: SnackPosition.BOTTOM,
        );
      }
    } catch (e) {
      Get.snackbar(
        "Error",
        e.toString(),
        icon: const Icon(Icons.error, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future<bool> isLedValid(String ledgerId, String amount) async {
    if (ledgerId == '') {
      scaffoldMessageBar('Please enter ledger name');
      return false;
    } else if (amount.trim().isEmpty) {
      scaffoldMessageBar('Please enter amount');
      return false;
    } else {
      return true;
    }
  }

  Future<void> taxLedgerPostApi() async {
    try {
      // Prepare ledger map
      List<Map<String, dynamic>> ledgerListMap = [];
      List<String> taxLedgerNameList = ['CGST', 'SGST', 'IGST'];
      List<num> taxLedgerAmountList = [
        cgstLedgerAmt.value,
        sgstLedgerAmt.value,
        igstLedgerAmt.value,
      ];

      for (int i = 0; i < taxLedgerNameList.length; i++) {
        SalesLedgerEntity ledgerEntity = SalesLedgerEntity();
        ledgerEntity.companyid = Utility.companyId;
        ledgerEntity.mobileno = Utility.cmpmobileno;
        ledgerEntity.hedUniqueId = salesUniqueId.value;
        ledgerEntity.ledgerId = taxLedgerNameList[i];
        ledgerEntity.amount = taxLedgerAmountList[i].toStringAsFixed(2);
        ledgerListMap.add(ledgerEntity.toMap());
      }

      // Post ledger
      final response = await ApiCall.taxLedgerDetPostApi(ledgerListMap);

      if (response == 'Data Inserted Successfully') {}
    } catch (e) {
      Get.snackbar(
        'Error',
        e.toString(),
        icon: const Icon(Icons.error, color: Colors.red),
        snackPosition: SnackPosition.BOTTOM,
      );
    }
  }

  Future salesSavePostApi() async {
    if (isGstAutoCalEnable.value) {
      await taxLedgerPostApi();
    }
    await salesPostApi().then((value) {
      Get.back();
      Get.back();
      Get.back();
    });
  }

  Future<void> salesPostApi() async {
    final salesHedEntity = SalesHeaderEntity()
      ..companyId = Utility.companyId
      ..uniqueId = salesUniqueId.value
      ..totalAmount = totalAmount.value.toStringAsFixed(2)
      ..cashAmount = cashController.text
      ..bankInstNo = bankInstNoController.text
      ..bankAmount = bankAmtController.text
      ..cardInstNo = cardInstNoController.text
      ..cardAmount = cardAmtController.text
      ..giftReferenceNo = giftReferenceController.text
      ..giftAmount = giftAmtController.text
      ..paymentTerms = paymentTermsController.text
      ..narration = remarkController.text;

    // Show loader
    Utility.showCircularLoadingWid(Get.context!);

    try {
      final response = await ApiCall.salesSavePostApi([salesHedEntity.toMap()]);

      //  Close loader (only once)
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (response == 'Data Inserted Successfully') {
        await Utility.showAlert(
          icons: Icons.check,
          iconcolor: Colors.green,
          title: 'Status',
          msg: '$vchType Successfully Saved',
        );

        //snackbarMessageBar("$vchType Successfully Saved", isError: false);

        Get.back();

        //  Navigate AFTER snackbar animation
        // Future.delayed(const Duration(milliseconds: 400), () {
        //   Get.back(); // close sales screen
        //   Get.back(); // go to list screen
        // });
      } else {
        // if (Get.isSnackbarOpen) {
        //   Get.closeCurrentSnackbar();
        // }
        await Utility.showAlert(
          icons: Icons.close,
          iconcolor: Colors.red,
          title: 'Error',
          msg: 'Oops there is an error!',
        );
        // snackbarMessageBar(response.toString(), isError: true);
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }
      await Utility.showAlert(
        icons: Icons.close,
        iconcolor: Colors.red,
        title: 'Error',
        msg: 'An error occurred: $e',
      );

      // snackbarMessageBar("An error occurred: $e", isError: true);
    }
  }

  // Future<void> salesPostApi() async {
  //   final salesHedEntity = SalesHeaderEntity();
  //   salesHedEntity.groupId = Utility.groupId;
  //   salesHedEntity.companyId = Utility.companyId;
  //   salesHedEntity.uniqueId = salesUniqueId.value;
  //   salesHedEntity.totalAmount = totalAmount.value.toStringAsFixed(2);
  //   salesHedEntity.cashAmount = cashController.text;
  //   salesHedEntity.bankInstNo = bankInstNoController.text;
  //   salesHedEntity.bankAmount = bankAmtController.text;
  //   salesHedEntity.cardInstNo = cardInstNoController.text;
  //   salesHedEntity.cardAmount = cardAmtController.text;
  //   salesHedEntity.giftReferenceNo = ''; // optional
  //   salesHedEntity.giftAmount = giftAmtController.text;
  //   salesHedEntity.paymentTerms = paymentTermsController.text;
  //   salesHedEntity.narration = remarkController.text;

  //   // Show loader
  //   Utility.showCircularLoadingWid(msg: "Processing...");

  //   try {
  //     final response = await ApiCall.salesSavePostApi([salesHedEntity.toMap()]);

  //     // Close loader safely
  //     if (Get.isDialogOpen ?? false) Get.back();
  //     Get.back();
  //     if (response == 'Data Inserted Successfully') {
  //       snackbarMessageBar("$vchType Successfully Saved", isError: false);

  //       Get.back();
  //       Get.back();
  //     } else {
  //       snackbarMessageBar(response.toString(), isError: true);
  //     }

  //     //   // Delay closing the screen slightly to avoid disposing snackbar too early
  //     //   // Future.delayed(const Duration(milliseconds: 500), () {
  //     //   //   if (!(Get.isDialogOpen ?? false)) {
  //     //   //     Get.back();

  //     //   //   }
  //     //   // });
  //     //   Get.back();
  //     //   // Get.back();
  //   } catch (e) {
  //     // Handle exceptions
  //     if (Get.isDialogOpen ?? false) Get.back();
  //     snackbarMessageBar("An error occurred: $e", isError: true);
  //   }
  // }

  // Future<void> salesPostApi() async {
  //   try {
  //     // --- Prepare Sales Header Entity ---
  //     SalesHeaderEntity salesHedEntity = SalesHeaderEntity();
  //     salesHedEntity.companyId = Utility.companyId;
  //     salesHedEntity.uniqueId = salesUniqueId.value;
  //     salesHedEntity.totalAmount = totalAmount.value.toStringAsFixed(2);
  //     salesHedEntity.cashAmount = cashController.text;
  //     salesHedEntity.bankInstNo = bankInstNoController.text;
  //     salesHedEntity.bankAmount = bankAmtController.text;
  //     salesHedEntity.cardInstNo = cardInstNoController.text;
  //     salesHedEntity.cardAmount = cardAmtController.text;
  //     salesHedEntity.giftReferenceNo = ''; // optional
  //     salesHedEntity.giftAmount = giftAmtController.text;
  //     salesHedEntity.paymentTerms = paymentTermsController.text;
  //     salesHedEntity.narration = remarkController.text;

  //     // --- Show loading dialog ---
  //     // Utility.showCircularLoadingWid(Get.context!);
  //     Utility.showCircularLoadingWid(msg: 'Processing..');

  //     // --- API Call ---
  //     final response = await ApiCall.salesSavePostApi([salesHedEntity.toMap()]);

  //     // --- Close loading dialog ---
  //     Get.back();

  //     // --- Show response alert ---
  //     if (response == 'Data Inserted Successfully') {
  //       Get.snackbar(
  //         'Status',
  //         'Data Inserted Successfully',
  //         icon: const Icon(Icons.check, color: Colors.green),
  //         snackPosition: SnackPosition.BOTTOM,
  //         backgroundColor: Colors.green,
  //       );
  //       // Close the screen after successful save
  //       Get.back(result: true);
  //     } else {
  //       Get.snackbar(
  //         'Error',
  //         'Oops there is an error!',
  //         icon: const Icon(Icons.error, color: Colors.red),
  //         snackPosition: SnackPosition.BOTTOM,
  //       );
  //     }
  //   } catch (e) {
  //     // Handle errors
  //     Get.back(); // close loading if open
  //     Get.snackbar(
  //       'Error',
  //       e.toString(),
  //       icon: const Icon(Icons.error, color: Colors.red),
  //       snackPosition: SnackPosition.BOTTOM,
  //     );
  //   }
  // }

  Future<void> ledgerPostApi({
    required SalesLedgerEntity salesledgerApiEntity,
  }) async {
    try {
      // --- Validate Ledger ---
      bool isValid = await isLedValid(
        salesledgerApiEntity.ledgerId!,
        salesledgerApiEntity.amount!,
      );

      if (!isValid) return;

      List<Map<String, dynamic>> ledgerListMap = [];
      SalesLedgerEntity ledgertity = SalesLedgerEntity();
      ledgertity.companyid = Utility.companyId;
      // ledgertity.mobileno = Utility.cmpmobileno;
      ledgertity.hedUniqueId = salesUniqueId.value;
      ledgertity.ledgerUniqueId = salesledgerApiEntity.ledgerUniqueId ?? '';
      ledgertity.ledgerId = salesledgerApiEntity.ledgerId;
      ledgertity.amount = salesledgerApiEntity.amount;

      ledgerListMap.add(ledgertity.toMap());

      final response = await ApiCall.ledgerDetPostApi(ledgerListMap);
      Get.back();

      if (response == "Data Inserted Successfully") {
        //Get.back();
        // Refresh list
        getSalesDataAPI();
        await Utility.showAlert(
          icons: Icons.check,
          iconcolor: Colors.green,
          title: 'Status',
          msg: 'Ledger created successfully',
        );
        // snackbarMessageBar('Ledger created successfully', isError: false);
      } else {
        await Utility.showAlert(
          icons: Icons.close,
          iconcolor: Colors.red,
          title: 'Error',
          msg: 'Oops there is an error!',
        );
        // snackbarMessageBar('Oops there is an error!', isError: true);
      }
    } catch (e) {
      await Utility.showAlert(
        icons: Icons.close,
        iconcolor: Colors.red,
        title: 'Error',
        msg: e.toString(),
      );
      // snackbarMessageBar(e.toString(), isError: true);
    }
  }

  Future checkValidIssueItemBool(
    String? itemId,
    String? qtyText,
    String? rateText,
  ) async {
    if (itemId == '') {
      scaffoldMessageBar('Please enter item name');
      return false;
    } else if (qtyText == null) {
      scaffoldMessageBar('Please enter quantity');
      return false;
    } else if (rateText == null) {
      scaffoldMessageBar('Please enter rate');
      return false;
    }
    //commented
    // else if (postingLedgerId.trim().isEmpty) {
    //   scaffoldMessageBar(Get.context!, 'Please select posting ledger');
    //   return false;
    // } else if (godownId.trim().isEmpty) {
    //   scaffoldMessageBar(Get.context!, 'Please select godown');
    //   return false;
    // }
    else {
      return true;
    }
  }

  Future<void> salesItemPost({
    required SalesInventoryEntity itemSelectedEntity,
  }) async {
    try {
      final isValid = await checkValidIssueItemBool(
        itemSelectedEntity.itemId,
        itemSelectedEntity.qty,
        itemSelectedEntity.rate,
      );

      if (!isValid) return;

      SalesInventoryEntity itementity = SalesInventoryEntity();
      itementity.companyid = Utility.companyId;
      itementity.invId = itemSelectedEntity.invId ?? '';
      itementity.hedUniqueId = salesUniqueId.value;
      itementity.itemId = itemSelectedEntity.itemId;
      itementity.qty = itemSelectedEntity.qty;
      itementity.rate = itemSelectedEntity.rate;
      itementity.discount = itemSelectedEntity.discount ?? '';
      itementity.totalvalue = itemSelectedEntity.totalvalue;
      itementity.gstrate = itemSelectedEntity.gstrate ?? '';
      itementity.cessrate = itemSelectedEntity.cessrate ?? '';
      itementity.gstvalue = itemSelectedEntity.gstvalue ?? '';
      itementity.cessvalue = itemSelectedEntity.cessvalue ?? '';
      itementity.netValue = itemSelectedEntity.netValue ?? '';
      itementity.remark = itemSelectedEntity.remark ?? '';
      itementity.altQtyPer = itemSelectedEntity.altQtyPer ?? '';
      itementity.altQty = itemSelectedEntity.altQty ?? '';
      itementity.postingledgerid = postingLedgerId.value;
      itementity.godownid = godownId.value;

      List<Map<String, dynamic>> itemList = [itementity.toMap()];
      final response = await ApiCall.salesInvDetPostApi(itemList);

      // Close ONLY loading dialog
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (response == 'Data Inserted Successfully') {
        clearInventoryForm();
        // if (Get.isDialogOpen ?? false) {
        //   Get.back();
        //   }

        // Close inventory dialog and return result
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
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      await Utility.showAlert(
        icons: Icons.close,
        iconcolor: Colors.red,
        title: 'Error',
        msg: 'Oops there is an error!',
      );
    }
  }

  Future<void> deleteItemPostApi({required String invId}) async {
    SalesInventoryEntity deleteEntity = SalesInventoryEntity();

    deleteEntity.companyid = Utility.companyId;
    deleteEntity.mobileno = Utility.cmpmobileno;
    deleteEntity.invId = invId;
    deleteEntity.hedUniqueId = salesUniqueId.value;

    List<Map<String, dynamic>> body = [deleteEntity.toMap()];

    // Show loading
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );

    final response = await ApiCall.deleteItemSalesApi(
      salesInvEntityListMap: body,
    );

    // Close loading
    Get.back();

    if (response == 'Data Deleted Successfully') {
      // Success msg
      await Utility.showAlert(
        icons: Icons.check,
        iconcolor: Colors.green,
        title: 'Status',
        msg: 'Item Deleted Successfully',
      );

      // Get.snackbar(
      //   "Success",
      //   "Item deleted successfully",
      //   backgroundColor: Colors.green.withOpacity(0.2),
      //   colorText: Colors.green[800],
      // );

      // Refresh your data
      await getSalesDataAPI(isInvClicked: true);
    } else {
      // Error
      scaffoldMessageBar('Oops! there is an error!', isError: true);
    }
  }

  SalesInventoryEntity calTotalAmountValue({
    required String invRate,
    required String invQty,
    required String invDisc,
    required String taxRate,
  }) {
    SalesInventoryEntity e = SalesInventoryEntity();

    // ------ Parse Safe Values ------
    num rate = invRate.isEmpty ? 0 : num.parse(invRate);
    num qty = invQty.isEmpty ? 0 : num.parse(invQty);
    num disc = invDisc.isEmpty ? 0 : num.parse(invDisc);
    num gstRate = taxRate.isEmpty ? 0 : num.parse(taxRate);

    // ------ Base Amount ------
    num amount = rate * qty;

    // ------ Discount ------
    num discountedValue = amount - (amount * disc / 100);

    // ------ GST ------
    //  num gstValue =
    //           (discountedValue * ((gstRate / 2) / 100)).round() +
    //           (discountedValue * ((gstRate / 2) / 100)).round();
    num gstValue = discountedValue * gstRate / 100;

    // ------ Total ------
    num totalValue = discountedValue + gstValue;

    // ------ Assign ------
    e.netValue = discountedValue.toStringAsFixed(2);
    e.gstvalue = gstValue.toStringAsFixed(2);
    e.totalvalue = totalValue.toStringAsFixed(2);

    return e;
  }

  //delete

  Future<bool> onWillPop() async {
    // if (hedId == null && salesHeaderEntity.value != null) {
    if (!isEdit && salesHeaderEntity.value != null) {
      final result = await Get.dialog<bool>(
        AlertDialog(
          title: const Text("Alert"),
          content: const Text("Do you want to discard sales data?"),
          actions: [
            TextButton(
              onPressed: () => Get.back(result: false),
              child: const Text("No"),
            ),
            ElevatedButton(
              style: ElevatedButton.styleFrom(backgroundColor: Colors.black),
              onPressed: () async {
                Get.back(); // close dialog

                Get.dialog(
                  const Center(child: CircularProgressIndicator()),
                  barrierDismissible: false,
                );

                SalesHeaderEntity salesHeaderEntity = SalesHeaderEntity()
                  ..companyId = Utility.companyId
                  ..uniqueId = salesUniqueId.value
                  ..type = vchType;
                List<Map<String, dynamic>> salesEntityListMap = [];
                salesEntityListMap.add(salesHeaderEntity.toMap());

                final response = await ApiCall.deleteSalesApi(
                  salesEntityListMap: salesEntityListMap,
                );

                Get.back(); // close loader

                if (response == 'Data Deleted Successfully') {
                  Get.back(result: true);
                } else {
                  Get.snackbar(
                    "Error",
                    "Oops there is an Error!",
                    backgroundColor: Colors.redAccent,
                    colorText: Colors.white,
                  );
                }
              },
              child: const Text("Yes"),
            ),
          ],
        ),
      );

      return result ?? false;
    }

    return true;
  }
}
