import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/expense/expenses_report_entity.dart';

class ExpensesReportController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  List<String> expApproveTabList = ['Pending', 'Approved', 'Rejected'];

  var indexSelected = 0.obs;
  var isLoading = false.obs;
  var expTotal = 0.0.obs;
  Rxn<ExpensesReportEntity> expenseModel = Rxn<ExpensesReportEntity>();

  @override
  void onInit() {
    super.onInit();

    tabController = TabController(
      length: expApproveTabList.length,
      vsync: this,
    );

    tabController.addListener(() {
      indexSelected.value = tabController.index;
      checkApiDet();
    });

    checkApiDet();
  }
   Future<void> checkApiDet() async {
   
    isLoading.value = true;
      final status = indexSelected.value == 2
        ? 'Reject'
        : expApproveTabList[indexSelected.value];

    final result = await ApiCall.getExpenseApiData(status);

    if (result != null) {
      expenseModel.value = result;

      expTotal.value =
          (double.tryParse(result.pending ?? '0') ?? 0) +
          (double.tryParse(result.approved ?? '0') ?? 0);
    }

    isLoading.value = false;
  }

}
