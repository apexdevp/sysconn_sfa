import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/company/ledger_entity.dart';
import 'package:sysconn_sfa/api/entity/expense/expense_ledger_entity.dart';

class ExpenseAddLedgersController extends GetxController {
  ExpenseAddLedgersController({this.headerUniqueId, this.expensesLedgerEntity});
  var isAddMoreClk = false.obs;
  var ledgerId = ''.obs;
  var ledgerName = ''.obs;
  var ledgerNameList = <LedgerMasterEntity>[].obs;
  var ledgerAmount = 0.0.obs;
  var claimedAmount = 0.0.obs;
  var rejectAmount = 0.0.obs;
  var ledgerUniqueId = ''.obs;

  TextEditingController amountTextController = TextEditingController();

  ExpensesLedgerEntity? expensesLedgerEntity;
  String? headerUniqueId;
  String ledgerType = "('Direct Expenses','Indirect Expenses')";
  @override
  void onInit() {
    super.onInit();
    callInitFun();
  }

  void callInitFun() async {
    await ApiCall.getLedgerDetCMPApi(ledgerType: ledgerType).then((
      salesPersonDataList,
    ) {
      ledgerNameList.value = salesPersonDataList;
    });
    setRowsEdit();
  }

  void setRowsEdit() {
    if (expensesLedgerEntity != null) {
      ledgerUniqueId.value = expensesLedgerEntity!.ledUniqueId!;
      ledgerId.value = expensesLedgerEntity!.ledgerId!;
      ledgerName.value = expensesLedgerEntity!.ledgerName!;
      amountTextController.text = expensesLedgerEntity!.ledgerAmount!;
      // claimedAmount.value =
      //     expensesLedgerEntity!.claimedAmount?.toDouble() ?? 0.0;
      // rejectAmount.value =
      //     expensesLedgerEntity!.rejectAmount?.toDouble() ?? 0.0;
      claimedAmount.value =
          double.tryParse(expensesLedgerEntity!.claimedAmount ?? '0') ?? 0;
      rejectAmount.value =
          double.tryParse(expensesLedgerEntity!.rejectAmount ?? '0') ?? 0;
    }
  }

  void amountTextEditingControllerBlank() {
    amountTextController.clear();
    ledgerName.value = '';
    ledgerId.value = '';
  }

  Future<bool> _validFields() async {
    if (ledgerId.value == '') {
      scaffoldMessageBar('Please select ledger!');
      return false;
    } else if (amountTextController.text.trim().isEmpty) {
      scaffoldMessageBar('Please enter amount!');
      return false;
    } else if (num.parse(amountTextController.text.trim()) <= 0) {
      scaffoldMessageBar('Please enter amount. and it must be non negative.');
      return false;
    } else {
      return true;
    }
  }

  Future doneButtonClicked() async {
    bool isValidBool = await _validFields();
    if (isValidBool) {
      await expenseLedgerPostAPI();
    }
  }

  // Future expenseLedgerPostAPI() async {
  //   List<Map<String, dynamic>> ledgerListMap = [];
  //   ExpensesLedgerEntity ledgertity = ExpensesLedgerEntity();
  //   ledgertity.companyId = Utility.companyId;
  //   ledgertity.groupid = Utility.groupCode;
  //   ledgertity.headerUniqueId = headerUniqueId;
  //   ledgertity.ledUniqueId = ledgerUniqueId.value;
  //   ledgertity.ledgerId = ledgerId.value;
  //   ledgertity.ledgerAmount = amountTextController.text;
  //   ledgertity.rejectAmount = rejectAmount.value.toString();
  //   ledgertity.claimedAmount = claimedAmount.value.toString();
  //   ledgerListMap.add(ledgertity.toALLJson());

  //   await ApiCall.ledgerExpenseDetPostApi(ledgerListMap).then((response) async {
  //     // if (Get.isDialogOpen ?? false) Get.back();
  //     if (response == 'Data Inserted Successfully') {
  //       // if (!isAddMoreClk.value) Get.back();
  //       if (!isAddMoreClk.value) {
  //       Get.back(result: true); // pop page
  //     }
  //     } else {
  //       await Utility.showAlert(
  //         icons: Icons.close,
  //         iconcolor: Colors.red,
  //         title: 'Error',
  //         msg: 'Oops there is an error!',
  //       );

  //     }
  //   });
  // }

  // Future expenseLedgerPostAPI() async {
  //   try {
  //     List<Map<String, dynamic>> ledgerListMap = [];

  //     ExpensesLedgerEntity ledgertity = ExpensesLedgerEntity();
  //     ledgertity.companyId = Utility.companyId;
  //     ledgertity.groupid = Utility.groupCode;
  //     ledgertity.headerUniqueId = headerUniqueId;
  //     ledgertity.ledUniqueId = ledgerUniqueId.value;
  //     ledgertity.ledgerId = ledgerId.value;
  //     ledgertity.ledgerAmount = amountTextController.text;
  //     ledgertity.rejectAmount = rejectAmount.value.toString();
  //     ledgertity.claimedAmount = claimedAmount.value.toString();

  //     ledgerListMap.add(ledgertity.toALLJson());

  //     final response = await ApiCall.ledgerExpenseDetPostApi(ledgerListMap);

  //     // ✅ Close loader first
  //     if (Get.isDialogOpen == true) Get.back();

  //     if (response == 'Data Inserted Successfully') {
  //       if (!isAddMoreClk.value) {
  //         // ✅ Use Future.microtask to ensure pop happens after frame
  //         Future.microtask(() => Get.back(result: true));
  //       }
  //     } else {
  //       await Utility.showAlert(
  //         icons: Icons.close,
  //         iconcolor: Colors.red,
  //         title: 'Error',
  //         msg: 'Oops there is an error!',
  //       );
  //     }
  //   } catch (e) {
  //     if (Get.isDialogOpen == true) Get.back(); // Close loader on error
  //     await Utility.showAlert(
  //       icons: Icons.close,
  //       iconcolor: Colors.red,
  //       title: 'Error',
  //       msg: e.toString(),
  //     );
  //   }
  // }

  // /// ---------- POST LEDGER
  Future expenseLedgerPostAPI() async {
    ExpensesLedgerEntity ledgertity = ExpensesLedgerEntity();
    List<Map<String, dynamic>> ledgerListMap = [];
    ledgertity.companyId = Utility.companyId;
    // ledgertity.groupid = Utility.groupCode;
    ledgertity.headerUniqueId = headerUniqueId;
    ledgertity.ledUniqueId = ledgerUniqueId.value;
    ledgertity.ledgerId = ledgerId.value;
    ledgertity.ledgerAmount = amountTextController.text;
    ledgertity.rejectAmount = rejectAmount.value.toString();
    ledgertity.claimedAmount = claimedAmount.value.toString();

    ledgerListMap.add(ledgertity.toALLJson());

    final response = await ApiCall.ledgerExpenseDetPostApi(ledgerListMap);
    if (response == 'Data Inserted Successfully') {
      Get.back();
      if (!isAddMoreClk.value) {
        Get.back();
      }
    } else {
      await Utility.showAlert(
        icons: Icons.close,
        iconcolor: Colors.red,
        title: 'Error',
        msg: 'Oops there is an error!',
      );
    }
  }

  Future deleteExpenseLedger() async {
    ExpensesLedgerEntity deleteLedgerDetailEntity = ExpensesLedgerEntity();
    deleteLedgerDetailEntity.companyId = Utility.companyId;
    deleteLedgerDetailEntity.headerUniqueId =
        expensesLedgerEntity!.headerUniqueId;
    deleteLedgerDetailEntity.ledUniqueId = expensesLedgerEntity!.ledUniqueId;
    List<Map<String, dynamic>> ledgerEntityListMap = [];
    ledgerEntityListMap.add(deleteLedgerDetailEntity.toALLJson());
    await ApiCall.deleteLedgerApi(
      salesLedgerEntityListMap: ledgerEntityListMap,
    ).then((response) async {
      if (response == 'Data Deleted Successfully') {
        Get.back();
        Get.back();
      } else {
        await Utility.showAlert(
          icons: Icons.close,
          iconcolor: Colors.red,
          title: 'Error',
          msg: 'Oops there is an error!',
        );
      }
    });
  }
}
