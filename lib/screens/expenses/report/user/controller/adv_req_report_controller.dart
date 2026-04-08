import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/expense/adv_expenses_entity.dart';

class AdvanceRequisitionReportController extends GetxController
    with GetSingleTickerProviderStateMixin {
  late TabController tabController;
  var isDataLoad = 0.obs;
  var indexSelected = 0.obs;

  List<String> advApproveTabList = ['Pending', 'Approved', 'Rejected'];

  RxList<AdvExpensesEntity> expensesAdvDataList = <AdvExpensesEntity>[].obs;
  @override
  void onInit() {
    super.onInit();

    tabController = TabController(
      length: advApproveTabList.length,
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

   Future<List<AdvExpensesEntity>> getAdvExpensesDataAPI() async {
  
      expensesAdvDataList.clear();
      isDataLoad.value = 0;
     String status = indexSelected.value == 2 ? 'Reject' : advApproveTabList[indexSelected.value];
    await ApiCall.getAdvanceExpenseApiData(status).then((advExpenseItemDataList) {
      if (advExpenseItemDataList.isNotEmpty) {
        // expensesAdvDataList = advExpenseItemDataList;
         expensesAdvDataList.assignAll(advExpenseItemDataList);
        isDataLoad.value = 1;
      } else {
        isDataLoad.value = 2;
      }
    });
    // if (mounted) {
    //   setState(() {});
    // }
    return expensesAdvDataList;
  }
}
