import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:pluto_grid_plus/pluto_grid_plus.dart';
import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/sales/sales_header_entity.dart';
import 'package:sysconn_sfa/api/entity/company/partyentity.dart';
import 'package:sysconn_sfa/api/entity/company/voucherentity.dart';
import 'package:sysconn_sfa/api/entity/sales/sales_ledger_entity.dart';

class CreateSalesController extends GetxController {
  var dateController = TextEditingController(
    text: DateFormat("yyyy-MM-dd").format(DateTime.now())
  ).obs;

  var paymentTermsController = TextEditingController().obs;
  var remarkController = TextEditingController().obs;
  var orgInvNoController = TextEditingController().obs;
  var orgInvDateController = TextEditingController().obs;
  var cashController = TextEditingController().obs;
  var bankInstNoController = TextEditingController().obs;
  var bankAmtController = TextEditingController().obs;
  var cardInstNoController = TextEditingController().obs;
  var cardAmtController = TextEditingController().obs;
  var giftReferenceController = TextEditingController().obs;
  var giftAmtController = TextEditingController().obs;
  var ledgerDiscController = TextEditingController().obs;
  var ledgerAmtController = TextEditingController().obs;

  var selectedDate = DateTime.now().obs;

  var vchSelectedName = ''.obs;
  var vchSelectedId = ''.obs;
  var partySelectedName = ''.obs;
  var partySelectedId = ''.obs;
  var invoiceNo = ''.obs;
  var priceList = ''.obs;
  var partyMobileNo = ''.obs;

  var posPaymentEnable = 'No'.obs;
  var creditNoteReasonSelected = ''.obs;

  var isGstAutoCalEnable = true.obs;
  var isCGSTApplicable = false.obs;
  var isSaleSaved = false.obs;
  var isTallyEntry = false.obs;

  var isDataLoad = 0.obs;
  var salesUniqueId = ''.obs;

  var paymentTotal = 0.obs;
  var itemTotalNetAmount = 0.0.obs;
  var ledgerTotalAmount = 0.0.obs;
  var itemGstTotalAmount = 0.0.obs;
  var cessTotalValue = 0.0.obs;
  var totalAmount = 0.obs;

  var cgstLedgerAmt = 0.0.obs;
  var sgstLedgerAmt = 0.0.obs;
  var igstLedgerAmt = 0.0.obs;

  var mySalesId = Rxn<int>();

  var salesHeaderEntity = Rxn<SalesHeaderEntity>();

  var vchEntityList = <VoucherEntity>[].obs;
  var partyEntityList = <PartyEntity>[].obs;
  var salesLedgerList = <SalesLedgerEntity>[].obs;

  var plutoRows = <PlutoRow>[].obs;
  var isInvGridRefresh = false.obs;

  String? hedId;
  String? vchType;
  String? partyid;
  String? partyname;

  CreateSalesController({
    this.vchType,
    this.hedId,
    this.partyid,
    this.partyname
  });

  @override
  void onInit() {
    super.onInit();
    callInitFun();
  }

  Future<void> callInitFun() async {
    if (partyid != null) {
      await ApiCall.getPartyDetCMPApi(partyType: '', partyId: partyid!).then((res) async {
        partyEntityList.assignAll(res);

        await vchTypeDataAPI().then((_) async {
          if (hedId == null) {
            isDataLoad.value = 1;
          } else {
            salesUniqueId.value = hedId!;
            await getSalesDataAPI().then((_) {
              isDataLoad.value = 1;
            });
          }
        });
      });
    }
    else if (partyid == '') {
      await ApiCall.getPartyDetCMPApi(partyType: 'Customer').then((res) async {
        partyEntityList.assignAll(res);

        await vchTypeDataAPI().then((_) async {
          await getSalesDataAPI().then((_) {
            isDataLoad.value = 1;
          });
        });
      });
    }
    else {
      salesUniqueId.value = hedId!;
      isSaleSaved.value = true;

      await getSalesDataAPI().then((_) {
        isDataLoad.value = 1;
      });
    }
  }

  Future vchTypeDataAPI() async {
    vchEntityList.clear();

    await ApiCall.getVoucherTypeMasterAPI().then((list) {
      if (list.isNotEmpty) {
        for (var v in list) {
          if (v.parent == vchType) {
            vchEntityList.add(v);

            vchSelectedName.value = vchEntityList[0].vchTypeName!;
            vchSelectedId.value = vchEntityList[0].vchTypeCode!;
            posPaymentEnable.value = vchEntityList[0].posPaymentEnable!;

            invoiceNo.value = vchEntityList[0].nyDate == ''
                ? vchEntityList[0].cyPfx!
                : DateFormat('yyyy-MM-dd')
                            .parse(dateController.value.text)
                            .isAfter(DateFormat('yyyy-MM-dd')
                            .parse(vchEntityList[0].nyDate!))
                        ? vchEntityList[0].nyPfx!
                        : vchEntityList[0].cyPfx!;
          }
        }
      }
    });
  }

  Future<void> getSalesDataAPI({bool isInvClicked = false}) async {
    itemTotalNetAmount.value = 0;
    ledgerTotalAmount.value = 0;
    itemGstTotalAmount.value = 0;
    plutoRows.clear();
    salesLedgerList.clear();

    await ApiCall.getSalesMasterDataAPI(uniqueId: salesUniqueId.value)
        .then((det) {
      if (det != null) {
        salesHeaderEntity.value = det;

        vchSelectedName.value = det.voucherTypeName!;
        vchSelectedId.value = det.voucherType!;
        posPaymentEnable.value = det.posPayment!;
        partySelectedName.value = det.partyName!;
        partySelectedId.value = det.partyId!;
        partyMobileNo.value = det.partyMobileNo!;
        priceList.value = det.pricelist!;

        dateController.value.text = det.date!;

        paymentTermsController.value.text = det.paymentTerms!;
        orgInvNoController.value.text = det.originalInvoiceNo!;
        orgInvDateController.value.text = det.originalInvoiceDate!;
        creditNoteReasonSelected.value = det.cnReason!;
        remarkController.value.text = det.narration!;
        cashController.value.text = det.cashAmount!;
        bankInstNoController.value.text = det.bankInstNo!;
        bankAmtController.value.text = det.bankAmount!;
        cardInstNoController.value.text = det.cardInstNo!;
        cardAmtController.value.text = det.cardAmount!;
        giftAmtController.value.text = det.giftAmount!;

        isGstAutoCalEnable.value =
            det.isGstAutoCal == 'Yes' ? true : false;
        isTallyEntry.value =
            det.isTalyEntry == 'Yes' ? true : false;

        isCGSTApplicable.value =
            Utility.companyMasterEntity.companystate!.toUpperCase() ==
                det.state!.toUpperCase();

        // items
        for (int i = 0; i < det.items!.length; i++) {
          itemTotalNetAmount.value +=
              num.parse(det.items![i].netValue.toString());
          itemGstTotalAmount.value +=
              num.parse(det.items![i].gstvalue.toString());

          plutoRows.add(
            PlutoRow(
              cells: {
                'config': PlutoCell(value: Container()),
                'inv_id': PlutoCell(value: det.items![i].invId),
                'item_code': PlutoCell(value: det.items![i].itemId),
                'item_name': PlutoCell(value: det.items![i].itemName),
                'unit': PlutoCell(value: det.items![i].unit),
                'tax': PlutoCell(value: det.items![i].gstrate),
                'qty': PlutoCell(value: det.items![i].qty),
                'rate': PlutoCell(value: det.items![i].rate),
                'disc': PlutoCell(value: det.items![i].discount),
                'value': PlutoCell(value: det.items![i].netValue),
              },
            ),
          );
        }

        // ledgers
        for (var lg in det.ledger!) {
          salesLedgerList.add(lg);
          ledgerTotalAmount.value += num.parse(lg.amount!);
        }
      }

      totalAmount.value =
          (itemTotalNetAmount.value + ledgerTotalAmount.value).toInt();
    });
  }

  void calGrandTotal() {
    var cash = cashController.value.text == ''
        ? 0
        : int.parse(cashController.value.text);

    var bank = bankAmtController.value.text == ''
        ? 0
        : int.parse(bankAmtController.value.text);

    var card = cardAmtController.value.text == ''
        ? 0
        : int.parse(cardAmtController.value.text);

    var gift = giftAmtController.value.text == ''
        ? 0
        : int.parse(giftAmtController.value.text);

    paymentTotal.value = (cash + bank + card + gift);
  }

  Future checkHedValidBool() async {
    if (vchSelectedId.value == '') {
      scaffoldMessageBar('Please enter voucher name');
      return false;
    }
    if (partySelectedId.value == '') {
      scaffoldMessageBar('Please enter party name');
      return false;
    }
    return true;
  }

  Future<bool> salesHeaderPostApi() async {
    bool ok = await checkHedValidBool();
    if (!ok) return false;

    SalesHeaderEntity hed = SalesHeaderEntity();
    hed.companyId = Utility.companyId;
    hed.mobileno = Utility.cmpmobileno;
    hed.invoiceNo = invoiceNo.value;
    hed.voucherType = vchSelectedId.value;
    hed.partyId = partySelectedId.value;
    hed.date = dateController.value.text;
    hed.paymentTerms = paymentTermsController.value.text;
    hed.partyMobileNo = partyMobileNo.value;
    hed.narration = remarkController.value.text;
    hed.type = vchType;
    hed.originalInvoiceNo = orgInvNoController.value.text;
    hed.originalInvoiceDate = orgInvDateController.value.text;
    hed.cnReason = creditNoteReasonSelected.value;
    hed.isGstAutoCal = isGstAutoCalEnable.value ? 'Yes' : 'No';

    var response = await ApiCall.salesHedPostApi(hed);

    if (response['message'] == 'Data Inserted Successfully') {
      salesUniqueId.value = response['unique_id'];
      isSaleSaved.value = true;
      await getSalesDataAPI();
    } else {
      await Utility.showAlert(
       icons:  Icons.error_outline_outlined,
       iconcolor:  Colors.redAccent,
        title: 'Alert',
        msg: "Oops there is an error.",
      );
    }

    return true;
  }

  Future taxLedgerPostApi() async {
    List<Map<String, dynamic>> ledgerListMap = [];

    List taxLedgerNameList = ['CGST', 'SGST', 'IGST'];
    List<num> taxLedgerAmountList = [
      cgstLedgerAmt.value,
      sgstLedgerAmt.value,
      igstLedgerAmt.value
    ];

    for (int i = 0; i < 3; i++) {
      SalesLedgerEntity lg = SalesLedgerEntity();
      lg.companyid = Utility.companyId;
      lg.mobileno = Utility.cmpmobileno;
      lg.hedUniqueId = salesUniqueId.value;
      lg.ledgerId = taxLedgerNameList[i];
      lg.amount = taxLedgerAmountList[i].toStringAsFixed(2);
      ledgerListMap.add(lg.toMap());
    }

    await ApiCall.taxLedgerDetPostApi(ledgerListMap);
  }

  Future salesSavePostApi() async {
    if (isGstAutoCalEnable.value) await taxLedgerPostApi();
    await salesPostApi();
    Get.back();
  }

  Future salesPostApi() async {
    SalesHeaderEntity hed = SalesHeaderEntity();
    hed.companyId = Utility.companyId;
    hed.uniqueId = salesUniqueId.value;
    hed.totalAmount = totalAmount.value.toString();
    hed.cashAmount = cashController.value.text;
    hed.bankInstNo = bankInstNoController.value.text;
    hed.bankAmount = bankAmtController.value.text;
    hed.cardInstNo = cardInstNoController.value.text;
    hed.cardAmount = cardAmtController.value.text;
    hed.giftAmount = giftAmtController.value.text;
    hed.paymentTerms = paymentTermsController.value.text;
    hed.narration = remarkController.value.text;

    var res = await ApiCall.salesSavePostApi([hed.toMap()]);

    if (res == 'Data Inserted Successfully') {
      await Utility.showAlert(
       icons: Icons.check,
       iconcolor: Colors.green,
       title: 'Status',
       msg: 'Data Inserted Successfully'
      );
      Get.back(result: true);
    } else {
      await Utility.showAlert(
       icons: Icons.close,
       iconcolor: Colors.red,
       title: 'Error',
       msg: 'Oops there is an error!'
      );
    }
  }

  // ------------------------------
  // Navigation wrappers
  // ------------------------------

  void navigateItemScreen(String title, int index) async {
    await Get.toNamed("/inventory_details", arguments: {
      'uniqueId': salesUniqueId.value,
      'title': title,
      'vchType': vchType,
      'itemlist': title == 'Add Inventory Details'
          ? null
          : salesHeaderEntity.value!.items![index],
    });

    await getSalesDataAPI();
  }

  void navigateLedgerScreen(String title, int index) async {
    await Get.toNamed("/add_ledger", arguments: {
      'salesId': salesUniqueId.value,
      'title': title,
      'vchType': vchType,
      'ledgerlist': title == 'Add Ledgers'
          ? null
          : salesHeaderEntity.value!.ledger![index],
    });

    await getSalesDataAPI();
  }
}
