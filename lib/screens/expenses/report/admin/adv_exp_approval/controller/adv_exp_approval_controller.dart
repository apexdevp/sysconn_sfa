import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/expense/adv_expenses_entity.dart';

class AdvExpensesApprovalController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;

  List<String> expenseApprovalTabList = ['Pending', 'Approved', 'Rejected'];

  var indexSelected = 0.obs;
  var isDataLoad = 0.obs;
  RxList<AdvExpensesEntity> expensesApprDataList = <AdvExpensesEntity>[].obs;
  @override
  void onInit() {
    super.onInit();

    tabController = TabController(
      length: expenseApprovalTabList.length,
      vsync: this,
    );

    tabController.addListener(() {
      indexSelected.value = tabController.index;
      getAdvExpensesDataAPI();
    });

    getAdvExpensesDataAPI();
  }
    @override
  void onClose() {
    tabController.dispose();
    super.onClose();
  }

  Future getAdvExpensesDataAPI() async {
   
      expensesApprDataList.clear();
      isDataLoad.value = 0;
    await ApiCall.getAdvExpenseAprovalApi(indexSelected.value == 2? 'Reject': expenseApprovalTabList[indexSelected.value],).then((expenseItemDataList) {
      if (expenseItemDataList.isNotEmpty) {
        expensesApprDataList.value = expenseItemDataList;
      isDataLoad.value = 1;
      } else {
        isDataLoad.value = 2;
      }
    });
    
  }
}
