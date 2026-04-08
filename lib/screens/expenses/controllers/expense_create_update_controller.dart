import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/expenses/expense_header_entity.dart';
import 'package:sysconn_sfa/api/entity/company/voucherentity.dart';
import 'package:sysconn_sfa/api/entity/expense/expense_document_entity.dart';
import 'package:sysconn_sfa/api/entity/expense/expense_header_entity.dart';
import 'package:sysconn_sfa/api/entity/expense/expense_ledger_entity.dart';
import 'package:sysconn_sfa/api/entity/user/employee_master_entity.dart';
import 'package:sysconn_sfa/api/entity/user/userentity.dart';
import 'package:sysconn_sfa/screens/expenses/views/entry/advance_requisition/submit_expense.dart';
import 'package:sysconn_sfa/screens/expenses/views/entry/expense/expense_add_document.dart';
import 'package:sysconn_sfa/screens/expenses/views/entry/expense/expense_add_ledger.dart';

class ExpenseCreateUpdateController extends GetxController {
  ExpenseCreateUpdateController({this.expRptHedId});
  final String? expRptHedId;
  final receiptledgeramttotal = 0.0.obs;
  var dateCntrl = TextEditingController(
    text: DateFormat("dd/MM/yyyy").format(DateTime.now()),
  );
  var remarkCntrl = TextEditingController();

  /// ---------------- OBSERVABLES ----------------
  var dataLoad = false.obs;
  var vchprefix = ''.obs;
  var expensesHeadId = ''.obs;
  var approvedById = ''.obs;
  var approvername = ''.obs;
  var approvalFcmToken = ''.obs;
  var approvalMobNo = ''.obs;

  var empListItem = <UserEntity>[].obs;
  var expensesHeaderEntityList = Rxn<ExpensesHeaderEntity>();
  //  final expensesHeaderEntity = Rxn<ExpensesHeaderEntity>();

  /// Voucher list
  final vchEntityList = <VoucherEntity>[].obs;
  final voucherEntitySelected = Rxn<VoucherEntity>();

  /// Selected voucher fields
  final vchSelectedName = ''.obs;
  final vchSelectedId = ''.obs;

  @override
  void onInit() {
    super.onInit();
    checkApiDet();
  }

  void checkApiDet() async {
    dataLoad.value = false;
 
    if (expRptHedId == null) {
      // await setVchPrefix();
   await loadVoucherType();
      await expenseDetailsPostAPI(); // doneButtonClicked();
    } else {
      expensesHeadId.value = expRptHedId!;
      await getExpensesAllDetApi();
    }

    await ApiCall.getcompanyuserlistAPI().then((userDataList) {
      empListItem.value = userDataList;
    });
    dataLoad.value = true;
  }

  @override
  void onClose() {
    dateCntrl.dispose();
    remarkCntrl.dispose();
    super.onClose();
  }

  // void navigateExpenseLedger(ExpensesLedgerEntity? data) async {
  //     // if (expensesHeadId.value.isEmpty) return;
  //       if (expensesHeadId.value.isEmpty) {
  //   scaffoldMessageBar('Please wait, creating expense header...');
  //   return;
  // }
  //   await Get.to(
  //     () => ExpenseAddLedgers(
  //       headerUniqueId: expensesHeadId.value,
  //       expensesLedgerEntity: data,
  //     ),
  //   );
  //   // await getExpensesAllDetApi();
  // }

  void navigateExpenseLedger(ExpensesLedgerEntity? data) async {
    if (expensesHeadId.value.isEmpty) {
      scaffoldMessageBar('Please wait, creating expense header...');
      return;
    }

    await Get.to(
      () => ExpenseAddLedgers(
        headerUniqueId: expensesHeadId.value,
        expensesLedgerEntity: data,
      ),
    );
    await getExpensesAllDetApi();
  }

  void navigateDocument(String title, ExpensesDocumentEntity? data) async {
    await Get.to(
      () => ExpenseAddDocument(
        headerUniqueId: expensesHeadId.value,
        expensesDocumentEntity: data,
      ),
    );
    await getExpensesAllDetApi();
  }

  // Future setVchPrefix() async {
  //   DateTime dateCntrlValue = DateTime.parse(
  //     DateFormat(
  //       'yyyy-MM-dd',
  //     ).format(DateFormat('dd/MM/yyyy').parse(dateCntrl.text)),
  //   );
  //   vchprefix.value =
  //       'Exp'; //snehal now give hardcoded want to discuss with sir
  //   // print(dateCntrlValue);
  //   // print(DateTime.parse(Utility.companyMasterEntity.vchNyDate!).compareTo(dateCntrlValue));
  //   // if(DateTime.parse(Utility.companyMasterEntity.vchNyDate!).compareTo(dateCntrlValue) >= 0){
  //   //   vchprefix = Utility.companyMasterEntity.vchCyPrefix!;
  //   // }else{
  //   //   vchprefix = Utility.companyMasterEntity.vchNyPrefix!;
  //   // }
  // }

  void setVoucher(VoucherEntity v) {
    voucherEntitySelected.value = v;
    vchSelectedName.value = v.vchTypeName ?? '';
    vchSelectedId.value = v.vchTypeCode ?? '';
  }

  void clearVoucher() {
    voucherEntitySelected.value = null;
    vchSelectedName.value = '';
    vchSelectedId.value = '';
  }

  Future<void> loadVoucherType() async {
    try {
      vchEntityList.clear();

      final vList = await ApiCall.getVoucherTypeMasterAPI();
      if (vList.isEmpty) return;

      final filtered = vList.where((e) => e.parent == 'Journal').toList();
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

      final selectedDate = DateFormat("dd/MM/yyyy").parse(dateCntrl.text);

      vchprefix.value = (parsedNy == null || selectedDate.isBefore(parsedNy))
          ? first.cyPfx ?? ''
          : first.nyPfx ?? '';
    } catch (e) {
      print(" Error in _loadVoucherType: $e");
    }
  }

  Future expenseDetailsPostAPI() async {
    ExpensesHeaderEntity expenseHeaderEntity = ExpensesHeaderEntity();
    expenseHeaderEntity.companyId = Utility.companyId;
    // expenseHeaderEntity.groupId = Utility.groupCode;
    expenseHeaderEntity.emailid = Utility.useremailid;
    expenseHeaderEntity.uniqueId = expensesHeadId.value;
    expenseHeaderEntity.vchprefix = vchprefix.value;
     expenseHeaderEntity.vchType = vchSelectedId.value;
    expenseHeaderEntity.date = DateFormat(
      'yyyy-MM-dd',
    ).format(DateFormat('dd/MM/yyyy').parse(dateCntrl.text));
    expenseHeaderEntity.remark = remarkCntrl.text;

    expenseHeaderEntity.amount = receiptledgeramttotal.round().toString();

    expenseHeaderEntity.approver = approvedById.value;

    await ApiCall.expenseHedPostApi(expenseHeaderEntity).then((
      responseBody,
    ) async {
      if (responseBody['message'] == 'Data Inserted Successfully') {
        // expensesHeadId = responseBody['unique_id'];
        expensesHeadId.value = responseBody['unique_id'].toString();

        // await getExpensesAllDetApi();
      } else if (responseBody['message'] == 'Data Updated Successfully') {
        // await SendNotificationService.sendNotificationUsingAPI(approvalFcmToken,'Expenses Application','Expenses by ${Utility.employeeName}');
        // await postInsertNotificationData(moduleType: 'Expenses',title: 'Expenses Application',body: 'Expenses by ${Utility.employeeName}');

        Get.to(
          () => ExpenseAdvanceSubmitScreen(
            date: dateCntrl.text,
            totalamount: receiptledgeramttotal.toString(),
            title: 'Expenses',
          ),
        );
      } else {
        await Utility.showAlert(
          icons: Icons.error_outline_outlined,
          iconcolor: Colors.redAccent,
          title: 'Alert',
          msg: "Oops there is an Error!.",
        );
      }
    });
  }

  Future<bool> validator() async {
    if (expensesHeadId.value.isNotEmpty) {
      if (approvedById.value == '') {
        scaffoldMessageBar('Please enter approved by name!');
        return false;
      } else {
        return true;
      }
    } else {
      return true;
    }
  }

  Future<void> doneButtonClicked() async {
    await validator().then((isValid) async {
      if (isValid) {
        await expenseDetailsPostAPI();
      }
    });
  }

  Future<void> getExpensesAllDetApi() async {
    expensesHeaderEntityList.value = null;

    final expensesHedList = await ApiCall.getExpenseAllApiData(
      uniqueId: expensesHeadId.value,
    );

    expensesHeaderEntityList.value = expensesHedList;

    receiptledgeramttotal.value = 0;
    final ledgers = expensesHedList!.ledger ?? [];
    // if (expensesHedList.ledger != null) {
    for (var l in ledgers) {
      receiptledgeramttotal.value += num.parse(l.ledgerAmount.toString());
    }
    // }
    dateCntrl.text = DateFormat(
      "dd/MM/yyyy",
    ).format(DateTime.parse(expensesHedList.date!));
    remarkCntrl.text = expensesHedList.remark ?? '';
    approvername.value = expensesHedList.approverName ?? '';
    approvedById.value = expensesHedList.approver ?? '';
    expensesHeadId.value = expensesHedList.uniqueId!;
    vchprefix.value = expensesHedList.vchprefix!;
    vchSelectedName.value=expensesHedList.vchprefixname!;
  }

  Future deleteExpenseButtonClicked() async {
    try {
      // Utility.showCircularLoadingWid(Get.context!);

      ExpensesHeaderEntity deleteexpenseDetailEntity = ExpensesHeaderEntity();
      // deleteexpenseDetailEntity.groupId = Utility.groupCode;
      deleteexpenseDetailEntity.companyId = Utility.companyId;
      deleteexpenseDetailEntity.uniqueId = expensesHeadId.value;

      List<Map<String, dynamic>> expenseEntityListMap = [];
      expenseEntityListMap.add(deleteexpenseDetailEntity.toALLJson());

      final response = await ApiCall.deleteExpenseApi(
        salesEntityListMap: expenseEntityListMap,
      );

      if (Get.isDialogOpen == true) Get.back(); // close loader

      if (response == 'Data Deleted Successfully') {
        // ✅ pop dialog + page safely
        Future.microtask(() {
          Get.back(); // close confirmation
          Get.back(result: true); // return to list
        });
      } else {
        scaffoldMessageBar('Oops there is an error!');
      }
    } catch (e) {
      if (Get.isDialogOpen == true) Get.back();
      scaffoldMessageBar(e.toString());
    }
  }

  // Future<bool> onWillPop() async {
  //     // Existing expense → allow back
  //     if (expRptHedId != null) {
  //       return true;
  //     }

  //     // New expense → ask confirmation
  //     Utility.showAlertYesNo(

  //       iconData: Icons.help_outline_rounded,
  //       iconcolor: Colors.blueAccent,
  //       title: 'Alert',
  //        msg: 'Do you want to discard expense data?',
  //       yesBtnFun: () async {
  //         await deleteExpenseButtonClicked();
  //         Get.back(); // close dialog
  //         Get.back(); // close screen
  //       },
  //       noBtnFun: () {
  //         Get.back(); // close dialog only
  //       },
  //     );

  //     // prevent auto pop
  //     return false;
  //   }

  void onWillPop(bool didPop, Object? result) async {
    // If already popped, do nothing
    if (didPop) return;

    // Existing expense → allow pop
    if (expRptHedId != null) {
      Get.back();
      return;
    }

    // New expense → confirmation dialog
    Utility.showAlertYesNo(
      iconData: Icons.help_outline_rounded,
      iconcolor: Colors.blueAccent,
      title: 'Alert',
      msg: 'Do you want to discard expense data?',
      yesBtnFun: () async {
        await deleteExpenseButtonClicked();
        Get.back(); // close dialog
        Get.back(); // close screen
      },
      noBtnFun: () {
        Get.back(); // close dialog only
      },
    );
  }
}
