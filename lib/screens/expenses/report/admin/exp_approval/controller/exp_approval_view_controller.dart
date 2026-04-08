import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/expense/expense_header_entity.dart';
import 'package:sysconn_sfa/api/entity/expense/expense_ledger_entity.dart';

class ExpensesApprovalViewController extends GetxController {
    final String? expensesHedId;
  ExpensesApprovalViewController(this.expensesHedId);
  var expensesHeaderEntityList = ExpensesHeaderEntity().obs;

  var receiptledgeramttotal = 0.obs;
  var receiptRejectledamttotal = 0.obs;

  var apiload = false.obs;

  List statusItem = ['Pending', 'Approved', 'Reject'];
  var statusSelected = RxnString();

  TextEditingController remarkController = TextEditingController();
   @override
  void onInit() {
    super.onInit();
    getExpensesAllDetApi();
  }


  @override
  void onClose() {
    remarkController.dispose();
    super.onClose();
  }

    Future updateExpensesApprovalStatusApi() async {
    ExpensesHeaderEntity expenseEntity = ExpensesHeaderEntity();
      expenseEntity.companyId = Utility.companyId;
      expenseEntity.uniqueId = expensesHedId;
      expenseEntity.approvalStatus = statusSelected.value;
      expenseEntity.approverRemark = remarkController.text;
      expenseEntity.amount = receiptledgeramttotal.value.toString();


    final value =
        await ApiCall.postExpensesUpdateStatusAPI(expenseEntity);

    if (value == 'Data Updated Successfully') {
      

      // await postnotificationInDbApi();

      await Utility.showAlert(
      icons: 
        Icons.check,
      iconcolor:   Colors.green,
      title:   'Done',
      msg:   'Status Updated Successfully!',
      );

      Get.back();
      Get.back();
    } else {
      Utility.showAlert(
       icons: 
        Icons.cancel_outlined,
       iconcolor:  Colors.red,
      title:   'Error',
      msg:   'Oops there is an error!',
      );
    }
  }

  Future getExpensesAllDetApi() async {
    apiload.value = false;
    receiptledgeramttotal.value = 0;
    receiptRejectledamttotal.value = 0;

    final data =
        await ApiCall.getExpenseAllApiData(uniqueId: expensesHedId!);

    if (data != null) {
      expensesHeaderEntityList.value = data;

      for (var ledger in data.ledger ?? []) {
        receiptledgeramttotal.value +=
            double.tryParse(ledger.ledgerAmount ?? '0')?.round() ?? 0;

        receiptRejectledamttotal.value +=
            double.tryParse(ledger.rejectAmount.toString())?.round() ?? 0;
      }

      statusSelected.value = data.approvalStatus;
      remarkController.text = data.approverRemark ?? '';
    }

    apiload.value = true;
  }

    Future expenseLedgerPostAPI({required ExpensesLedgerEntity expensesLedgerPostEntity}) async {
    List<Map<String, dynamic>> ledgerListMap = [];
    ExpensesLedgerEntity ledgertity = ExpensesLedgerEntity();
    ledgertity.companyId = Utility.companyId;
    ledgertity.groupid = Utility.groupCode;
    ledgertity.headerUniqueId = expensesHedId;
    ledgertity.ledUniqueId = expensesLedgerPostEntity.ledUniqueId;
    ledgertity.ledgerId = expensesLedgerPostEntity.ledgerId;
    // ledgertity.ledgerAmount = (double.tryParse(expensesLedgerPostEntity.ledgerAmount ?? '0') ?? 0).toStringAsFixed(2);//expensesLedgerPostEntity.ledgerAmount;
    // ledgertity.rejectAmount = (double.tryParse(expensesLedgerPostEntity.rejectAmount ?? '0') ?? 0).toStringAsFixed(2);//expensesLedgerPostEntity.rejectAmount;
    // ledgertity.claimedAmount =(double.tryParse(expensesLedgerPostEntity.claimedAmount ?? '0') ?? 0).toStringAsFixed(2);
    // // expensesLedgerPostEnt
    // ity.claimedAmount;

    ledgertity.ledgerAmount = (double.tryParse(expensesLedgerPostEntity.ledgerAmount ?? '0') ?? 0).toInt().toString();
ledgertity.rejectAmount = (double.tryParse(expensesLedgerPostEntity.rejectAmount ?? '0') ?? 0).toInt().toString();
ledgertity.claimedAmount = (double.tryParse(expensesLedgerPostEntity.claimedAmount ?? '0') ?? 0).toInt().toString();

    ledgerListMap.add(ledgertity.toALLJson());

    await ApiCall.ledgerExpenseDetPostApi(ledgerListMap).then((response) async {
   
       Get.back();
        if (response == 'Data Inserted Successfully') {
        Get.back(result: true);
        } else {
          await Utility.showAlert(icons:  Icons.close,iconcolor:  Colors.red,title:  'Error',msg:  'Oops there is an error!',);
        }
    
    });
  }

}