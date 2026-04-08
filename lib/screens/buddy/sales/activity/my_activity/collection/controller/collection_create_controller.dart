import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/collection/receipt_header_entity.dart';
import 'package:sysconn_sfa/api/entity/buddy/collection/receipt_ledger_entity.dart';
import 'package:sysconn_sfa/api/entity/company/ledger_entity.dart';
import 'package:sysconn_sfa/api/entity/company/partyentity.dart';
import 'package:sysconn_sfa/api/entity/company/voucherentity.dart';

class CreateCollectionController extends GetxController {
  final String? hedId;
  final String? vchType;
  CreateCollectionController({this.hedId, this.vchType});
  //  var isAllapiload = false.obs;
  final detailUniqueId = ''.obs;
  var isHeaderSaved = false.obs;
  final isDataLoad = 0.obs;
  var isAddMoreClk = false.obs;
  Rxn<ReceiptHeaderEntity> receiptHeaderEntity = Rxn<ReceiptHeaderEntity>();
  final recUniqueId = ''.obs;
  final RxString amount = ''.obs;
  final TextEditingController amtController = TextEditingController();
  final selectedDate = DateTime.now().obs;
  var amntRcvdCntrl = TextEditingController();
  final dateController = TextEditingController();
  final remarkController = TextEditingController();
  final bankNameCntrl = TextEditingController();
  final partyAmountCntrl = TextEditingController();
  final instruNoCntrl = TextEditingController();
  final instruDateCntrl = TextEditingController();
  final ledgerTotalAmount = 0.0.obs;

  /// Selected party fields
  final partySelectedName = ''.obs;
  final partySelectedId = ''.obs;
  final priceList = ''.obs;
  var recLedgerEntity = <ReceiptLedgerEntity>[].obs;
  // ================= VOUCHER =================
  final vchTypeEntityList = <VoucherEntity>[].obs;
  final vchIdSelected = ''.obs;
  final vchNameSelected = ''.obs;
  final vchPrefixSelected = ''.obs;

  // ================= PARTY =================
  final partyGetEntityData = <PartyEntity>[].obs;
  final partyIdSelected = ''.obs;
  final partyNameSelected = ''.obs;
  final partyMobileNo = ''.obs;

  // ================= LEDGER =================
  final ledgerGetEntityData = <LedgerMasterEntity>[].obs;
  final ledgerIdSelected = ''.obs;
  final ledgerNameSelected = ''.obs;
  final ledgerMobileNo = ''.obs;

  // ================= BANK =================
  final bankLedgerEntityData = <LedgerMasterEntity>[].obs;
  final bankLedgerIdSelected = ''.obs;
  final bankLedgerNameSelected = ''.obs;

  // ================= LEDGER =================
  final ledgerMasterlist = <LedgerMasterEntity>[].obs;
  final modeFlag = true.obs;
  final modeSelected = ''.obs;

  final modelist = ['Card', 'Cash', 'Cheque/DD', 'e-Fund Transfer', 'Others'];

  void selectVoucher(VoucherEntity e) {
    vchNameSelected.value = e.vchTypeName!;
    vchIdSelected.value = e.vchTypeCode!;
    vchPrefixSelected.value = e.cyPfx ?? '';
  }

  void setMode(String mode) {
    modeSelected.value = mode;
    modeFlag.value = mode == 'Cash';
  }

 void amountTextEditingControllerBlank() {
    amtController.text = '';
     amtController.clear();
  amount.value = '';
  detailUniqueId.value = '';
  ledgerNameSelected.value = '';
  ledgerIdSelected.value = '';
    partyNameSelected.value = '';
    partyIdSelected.value = '';
    partyMobileNo.value = '';
  
  }

  @override
  void onInit() {
    super.onInit();
    if (hedId != '' && hedId != null) {
      isHeaderSaved.value = true;//alter mode
    }
    else{
       isHeaderSaved.value = false;//for create mode
    }

    dateController.text = DateFormat('yyyy-MM-dd').format(selectedDate.value);
    print('vchType  :$vchType');
    vchType != null ? _initVoucherMode(vchType!) : dataLoadCall();
  }

  @override
  void onClose() {
    partyNameSelected.value = '';
    ledgerNameSelected.value = '';
    super.onClose();
  }

  Future<void> dataLoadCall() async {
    try {
      isDataLoad.value = 0;

      if (hedId == null) {
        isDataLoad.value = 1;
        return;
      }

      if (hedId != '' || hedId != null) {
        recUniqueId.value = hedId!;
        print('recUniqueId.value =${recUniqueId.value}');
        // Utility.isentryopen =(hedId != '' || hedId != null); //pratiksha p 17-03-2026 add
        await getReceiptData();
      }

      isDataLoad.value = 1;
    } catch (e) {
      print(" Error in dataLoadCall: $e");
      isDataLoad.value = 1;
    }
  }

  Future<void> _initVoucherMode(String vType) async {
    try {
      await bankLedgerMasterList();
      await voucherList();
      await getPartyData();
      await getledgerData();

      await dataLoadCall();
    } catch (e) {
      print(" Error in _initVoucherMode: $e");
    }
  }

  Future<void> bankLedgerMasterList() async {
    bankLedgerEntityData.assignAll(
      await ApiCall.getledgermasterapi(
        typedata: "('Bank Accounts','Bank OD A/c','Cash-in-Hand')",
        ledgerid: '',
      ),
      // await ApiCall.getLedgerDetCMPApi(
      //   ledgerType: "('Bank Accounts','Bank OD A/c','Cash-in-Hand')",
      // ),
    );
  }

  Future<void> voucherList() async {
    final list = await ApiCall.getVoucherTypeMasterAPI();
    vchTypeEntityList.assignAll(
      list.where((e) => e.parent?.toUpperCase() == vchType!.toUpperCase()),
    );
  }

  Future<void> getPartyData() async {
    partyGetEntityData.assignAll(
      await ApiCall.getPartyDetCMPApi(partyId: '', partyType: 'Customer'),
    );
  }

  Future<void> getledgerData() async {
    final data = await ApiCall.getledgermasterapi(typedata: '', ledgerid: '');

    ledgerGetEntityData.assignAll(
      data
          .where(
            (ledger) =>
                ledger.type != 'Cash-in-Hand' && ledger.type != 'Bank Accounts',
          )
          .toList(),
    );
  }

  Future<void> salesLedgerMasterList() async {
    ledgerMasterlist.assignAll(
      await ApiCall.getledgermasterapi(typedata: '', ledgerid: ""),
    );
  }

  Future<void> getReceiptData({bool isInvClicked = false}) async {
    try {
      ledgerTotalAmount.value = 0;

      //receiptHeaderEntity=;
      /// ---------- RESET STATE ----------

      /// ---------- API CALL ----------
      final receiptdet = await ApiCall.geteditCollectionDetAPI(
        uniqueId: recUniqueId.value,
      );

      /// ---------- HEADER ----------
      receiptHeaderEntity.value = receiptdet;
      print('receiptHeaderEntity.value ${receiptHeaderEntity.value!.uniqueId}');
      recUniqueId.value = receiptdet!.uniqueId ?? '';
      //   detailUniqueId.value

      /// ---------- VOUCHER ----------
      vchNameSelected.value = receiptdet.voucherTypeName ?? '';
      vchIdSelected.value = receiptdet.voucherType ?? '';

      /// ---------- PARTY ----------
      partySelectedName.value = receiptdet.partyName ?? '';
      partySelectedId.value = receiptdet.partyId ?? '';
      priceList.value = receiptdet.pricelist ?? '';

      modeSelected.value = receiptdet.transactionType ?? '';
      bankLedgerNameSelected.value = receiptdet.bankName ?? '';
      instruDateCntrl.text = receiptdet.instrumentDate ?? '';
      instruNoCntrl.text = receiptdet.instrumentNo ?? '';

      /// ---------- DATE ----------
      if (receiptdet.date != null && receiptdet.date!.isNotEmpty) {
        final parsedDate = DateTime.tryParse(receiptdet.date!);
        if (parsedDate != null) {
          selectedDate.value = parsedDate;
          dateController.text = DateFormat('yyyy-MM-dd').format(parsedDate);
        }
      }

      /// ---------- EXTRA HEADER FIELDS ----------
      remarkController.text = receiptdet.narration ?? '';
      amntRcvdCntrl.text = receiptdet.totalAmount ?? '';

      /// ---------- LEDGER ----------
      if (receiptdet.recLedger != null && receiptdet.recLedger!.isNotEmpty) {
        for (final l in receiptdet.recLedger!) {
          recLedgerEntity.add(l);
          ledgerTotalAmount.value +=
              double.tryParse(l.amount?.toString() ?? '0') ?? 0.0;
          // trinaRows.add(_buildRow(l));
        }
      }

      /// ---------- TOTAL ----------
      // totalAmount.value =
      //     itemTotalNetAmount.value ;
    } catch (e) {
      //, st
      debugPrint(' Error in receiptApi');
      debugPrint(e.toString());
      //  debugPrint(st.toString());
    }
  }

  Future<void> collectionHedInsertPostApi() async {
    if (vchIdSelected.isEmpty || bankLedgerIdSelected.isEmpty) {
      scaffoldMessageValidationBar(Get.context!, 'Voucher / Bank required');
      return;
    }

    final entity = ReceiptHeaderEntity()
      ..companyId = Utility.companyId
      // ..groupId = Utility.groupId
      ..invoiceNo = vchPrefixSelected.value
      ..voucherType = vchIdSelected.value
      ..partyId = partyIdSelected.value
      ..date = dateController.text
      ..partyMobileNo = partyMobileNo.value
      ..narration = remarkController.text
      ..type = vchType
      ..bankName = bankLedgerIdSelected.value
      ..transactionType = modeSelected.value
      ..instrumentDate = instruDateCntrl.text
      ..instrumentNo = instruNoCntrl.text
      ..totalAmount = ledgerTotalAmount.value.toStringAsFixed(2);

    final res = await ApiCall.collectionHedPostApi(entity);

    // Get.back();

    if (res['message'] == 'Data Inserted Successfully') {
      recUniqueId.value = res['unique_id'].toString();
      isHeaderSaved.value = true;
      await getReceiptData();
      await salesLedgerMasterList();
    }
  }

  Future<void> collectionPostApi() async {
    final collHedEntity = ReceiptHeaderEntity()
      // ..groupId = Utility.groupId
      ..companyId = Utility.companyId
      ..uniqueId = recUniqueId.value
      ..totalAmount = ledgerTotalAmount.value.toStringAsFixed(2)
      ..narration = remarkController.text;

    // Show loader
    Utility.showCircularLoadingWid(Get.context!);

    try {
      final response = await ApiCall.collectionSavePostApi([
        collHedEntity.toJson(),
      ]);

      //  Close loader (only once)
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (response == 'Data Inserted Successfully') {
        //  Close existing snackbar
        if (Get.isSnackbarOpen) {
          Get.closeCurrentSnackbar();
        }
        // Utility.isentryopen = false;

        scaffoldMessageValidationBar(Get.context!,"$vchType Successfully Saved", isError: false);

        Get.back();

        //  Navigate AFTER snackbar animation
        Future.delayed(const Duration(milliseconds: 400), () {
          Get.back(); // close sales screen
          Get.back(); // go to list screen
        });
      } else {
        // if (Get.isSnackbarOpen) {
        //   Get.closeCurrentSnackbar();
        // }
        scaffoldMessageValidationBar(Get.context!,response.toString(), isError: true);
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) {
        Get.back();
      }

      if (Get.isSnackbarOpen) {
        Get.closeCurrentSnackbar();
      }

      scaffoldMessageValidationBar(Get.context!,"An error occurred: $e", isError: true);
    }
  }

  Future isLedgerValid({required String amount, required String type}) async {
    if (amount.trim().isEmpty) {
      scaffoldMessageValidationBar(Get.context!, 'Amount Required!!');
      return false;
    } else {
      return true;
    }
  }

  Future<void> postLedgerDataApi({
    required String partyId,
    required String ledgerId,
    required String amount,
    required String type,
  }) async {
    bool isValid = false;

    // ---------- VALIDATION ----------
    isValid = await isLedgerValid(type: partyId, amount: amount);

    if (!isValid) return;

    // ---------- PREPARE PAYLOAD ----------
    final List<Map<String, dynamic>> purchaseTransDetMapList = [];

    final ReceiptLedgerEntity billEntity = ReceiptLedgerEntity()
      ..companyId = Utility.companyId
      ..hedUniqueId = recUniqueId.value
      ..uniqueId = detailUniqueId.value

      
      ..partyId = partyId
      ..ledgerId = ledgerId
      ..type = type
      ..amount = amount;
    purchaseTransDetMapList.add(billEntity.toJson());
    // ---------- API CALL ----------
    final billResponse = await ApiCall.collectionLedPostApi(
      purchaseTransDetListMap: purchaseTransDetMapList,
    );

    // ---------- RESPONSE HANDLING ----------
    if (billResponse == 'Data Inserted Successfully') {
      // close loader
      // Get.back();

      // // close dialog
      // Get.back();
      // Close loader
  // if (Get.isDialogOpen ?? false) Get.back();

if (!isAddMoreClk.value) {
        Get.back();
      }      // refresh receipt data
      await getReceiptData();
    } else {
      // Get.back(); // close loader
      await Utility.showAlert(
        icons: Icons.close,
        iconcolor: Colors.red,
        title: 'Error',
        msg: 'Oops there is an error!',
      );
    }
  }
}




