import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/expense/expenses_report_entity.dart';

class ExpensesApprovalReportController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final expnsesReprtDataList = <ExpensesDetailsReportEntity>[].obs;
  final expensesSearchList = <ExpensesDetailsReportEntity>[];

  final expTotal = 0.0.obs;
  final isDataLoad = 0.obs;
  final indexSelected = 0.obs;

  final expApproveTabList = ['Pending', 'Approved', 'Rejected'];

  late TabController expApproveTabController;
  @override
  void onInit() {
    super.onInit();

    expApproveTabController = TabController(
      length: expApproveTabList.length,
      vsync: this,
    );

    expApproveTabController.addListener(() {
      if (!expApproveTabController.indexIsChanging) {
        indexSelected.value = expApproveTabController.index;
        checkApiDet();
      }
    });

    checkApiDet();
  }

  @override
  void onClose() {
    expApproveTabController.dispose();
    super.onClose();
  }

 void checkApiDet() async {
    await getExpensesApprovalReportAPI();
  }

  Future getExpensesApprovalReportAPI() async {
    isDataLoad.value = 0;
    expnsesReprtDataList.clear();
    expTotal.value = 0.0;

    final status = indexSelected.value == 2
        ? 'Reject'
        : expApproveTabList[indexSelected.value];

    final expenseData = await ApiCall.getexpensesapprovalApi(status: status);

    if (expenseData?.expense != null && expenseData!.expense!.isNotEmpty) {
      expnsesReprtDataList.assignAll(expenseData.expense!);
      expensesSearchList
        ..clear()
        ..addAll(expenseData.expense!);

      for (var e in expnsesReprtDataList) {
        expTotal.value += num.parse(e.amount.toString());
      }

      isDataLoad.value = 1;
    } else {
      isDataLoad.value = 2;
    }
  }
    void searchExpense(String? text) {
        final query = text?.trim() ?? '';
    if (query.isEmpty) {
      expnsesReprtDataList.assignAll(expensesSearchList);
    } else {
      // expnsesReprtDataList.assignAll(
      //   expensesSearchList.where(
      //     (e) => e.employeeName??
      //         .toLowerCase()
      //         .contains(text.toLowerCase()),
      //   ),
      // );
         expnsesReprtDataList.assignAll(
      expensesSearchList.where(
        (e) =>
            (e.employeeName ?? '')
                .toLowerCase()
                .contains(query.toLowerCase()),
      ),
    );
    }

    expTotal.value = 0;
    for (var e in expnsesReprtDataList) {
      expTotal.value += num.parse(e.amount.toString());
    }
  }
}
