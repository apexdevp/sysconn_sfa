import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/sales/dailyperformanceentity.dart';
import 'package:sysconn_sfa/api/entity/user/userentity.dart';

class DailyPerformanceController extends GetxController {
  // Loader
  RxInt isDataLoad = 0.obs;

  // Data
  var dailyPerformanceEntity = DailyPerformanceEntity().obs;
  // Sales Person
  var salesPersonItem = <UserEntity>[].obs;
  var salesPersonList = <String>[].obs;
  TextEditingController salespersonTextController = TextEditingController();
  // String? salesPersonMobileSelected = Utility.cmpmobileno;
  // String? salesPersonNameSelected;
  // String? salesPersonUserType;
  // String? salesPersonIouLedgerId;
  // String? salesPersonIouLedgerName;
  // int? salesPersonCount;
  RxString salesPersonMobileSelected = ''.obs;
  RxString salesPersonNameSelected = ''.obs;
  RxString salesPersonUserType = ''.obs;
  RxString salesPersonIouLedgerId = ''.obs;
  RxString salesPersonIouLedgerName = ''.obs;
  RxInt salesPersonCount = 0.obs;
  // Date
  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;
  bool isBottomSheetOpened = false;
  @override
  void onInit() {
    super.onInit();
    getSalesPersonDataAPI();
    // getdailyperformanceReportAPI();
  }

  void onSalesPersonSelected(String selectedName) {
    salespersonTextController.text = selectedName;
    var index = salesPersonList.indexOf(selectedName);
    salesPersonMobileSelected.value = salesPersonItem[index].mobileno!;
    salesPersonNameSelected.value = salesPersonItem[index].username!;
    salesPersonUserType.value = salesPersonItem[index].usertype!;
    // salesPersonIouLedgerId.value = salesPersonItem[index].iouledgerid!;
    // salesPersonIouLedgerName.value = salesPersonItem[index].iouledgername!;
    // salesPersonCount.value = salesPersonItem[index].salesperson == ''
    //     ? 0
    //     : int.parse(salesPersonItem[index].salesperson!);
  }

  // Future getSalesPersonDataAPI() async {
  //   await ApiCall.getcompanyuserlistAPI().then((userDataList) {
  //     salesPersonItem.value = userDataList;
  //     salesPersonList.add(userDataList[0].username!);
  //     if (Utility.cmpmobileno == userDataList[0].mobileno) {
  //       salesPersonMobileSelected.value = userDataList[0].mobileno!;
  //       salesPersonNameSelected.value = userDataList[0].username!;
  //       salesPersonUserType.value = userDataList[0].usertype!;
  //       // salesPersonIouLedgerId = userDataList[0].iouledgerid;
  //       // salesPersonIouLedgerName = userDataList[0].iouledgername;
  //       // salesPersonCount = userDataList[0].salesperson == ''
  //       //     ? 0
  //       //     : int.parse(userDataList[0].salesperson!);
  //     }
  //   });
  // }
  Future getSalesPersonDataAPI() async {
    final userDataList = await ApiCall.getcompanyuserlistAPI();

    if (userDataList.isNotEmpty) {
      salesPersonItem.value = userDataList;

      // ✅ FIX: Add full list
      salesPersonList.value = userDataList.map((e) => e.username!).toList();

      // Default selection
      salesPersonMobileSelected.value = userDataList[0].mobileno!;
      salesPersonNameSelected.value = userDataList[0].username!;
      salesPersonUserType.value = userDataList[0].usertype!;
    }
  }
  // Future getdailyperformanceReportAPI() async {
  //   isDataLoad.value = 0;

  //   final dailyPerformanceData = await ApiCall.getdailyperformanceAPIData(
  //     // partyId: partyId,
  //   );

  //   if (dailyPerformanceData.isNotEmpty) {
  //      for (int i = 0; i < dailyPerformanceData.length; i++) {
  //       dailyPerformanceEntity.value = DailyPerformanceEntity.fromJson(dailyPerformanceData);
  //     }
  //   }

  // }

  Future getdailyperformanceReportAPI() async {
    isDataLoad.value = 0;
    final data = await ApiCall.getdailyperformanceAPIData(
      mobileNo: salesPersonMobileSelected.value,
      fromDate: fromDate.toString(),
      toDate: toDate.toString(),
    );

    if (data != null) {
      dailyPerformanceEntity.value = DailyPerformanceEntity.fromJson(data);

      isDataLoad.value = 1;

      print(dailyPerformanceEntity.value.osfollowup?.overdueamt);
    } else {
      isDataLoad.value = 2;
    }
  }
}
