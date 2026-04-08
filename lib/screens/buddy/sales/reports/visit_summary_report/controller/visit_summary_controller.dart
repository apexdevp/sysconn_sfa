import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/visitAttendanceEntity.dart';
import 'package:sysconn_sfa/api/entity/user/userentity.dart';

class VisitAttendanceSumController extends GetxController {
  RxList<VisitAttendanceEntity> visitAttendanceEntityDataList =
      <VisitAttendanceEntity>[].obs;
  RxList<VisitAttendanceEntity> visitattendanceDetailsList =
      <VisitAttendanceEntity>[].obs;
  RxList<UserEntity> salesPersonItem = <UserEntity>[].obs;

  RxInt existingVisitTotal = 0.obs;
  RxInt coldVisitTotal = 0.obs;
  RxString salesPersonMobileSelected =
      (Utility.cmpusertype.toUpperCase() == 'ADMIN' ||
                  Utility.cmpusertype.toUpperCase() == 'OWNER'
              ? 'ALL'
              : Utility.cmpmobileno)
          .obs;
  // RxString salesPersonMobileSelected = ''.obs;
  RxString salesPersonNameSelected = ''.obs;
  TextEditingController salesPersonController = TextEditingController();
  RxInt isDataLoad = 0.obs;

  Rx<DateTime> fromdate = DateTime.now().obs;
  Rx<DateTime> todate = DateTime.now().obs;
  @override
  void onInit() {
    super.onInit();
    initLoad();
  }

  // Future<void> initLoad() async {
  //   await ApiCall.getcompanyuserlistAPI().then((userDataList) {
  //     salesPersonItem.value = userDataList;
  //   });
  //   await getVisitAttendanceSummaryReportDataAPI();
  // }

  Future<void> initLoad() async {
    List<UserEntity> userDataList = await ApiCall.getcompanyuserlistAPI();
    salesPersonItem.clear();

    /// SAME LOGIC (ADD ALL)
    if (Utility.cmpusertype.toUpperCase() == 'ADMIN' ||
        Utility.cmpusertype.toUpperCase() == 'OWNER' ||
        Utility.cmpusertype.toUpperCase() == 'TEAM LEADER') {
      UserEntity userEntity = UserEntity();
      userEntity.username = 'ALL';
      userEntity.mobileno = 'ALL';

      salesPersonItem.add(userEntity);
    }

    /// ADD API DATA
    if (userDataList.isNotEmpty) {
      salesPersonItem.addAll(userDataList);
    }

    await getVisitAttendanceSummaryReportDataAPI();
  }

  Future getVisitAttendanceSummaryReportDataAPI() async {
    try {
      isDataLoad.value = 0;
      visitAttendanceEntityDataList.clear();
      // ✅ RESET TOTALS
      existingVisitTotal.value = 0;
      coldVisitTotal.value = 0;
      await ApiCall.getVisitAttendanceSumApiData(
        fromdate: fromdate.toString(),
        todate: todate.toString(),
        mobileno: salesPersonMobileSelected.value,
      ).then((visitDetailsValue) {
        if (visitDetailsValue.isNotEmpty) {
          for (int i = 0; i < visitDetailsValue.length; i++) {
            VisitAttendanceEntity visitattendanceModel =
                VisitAttendanceEntity.fromSummaryJson(visitDetailsValue[i]);
            visitAttendanceEntityDataList.add(visitattendanceModel);
            existingVisitTotal =
                existingVisitTotal +
                (visitattendanceModel.actualExisting != ''
                    ? int.parse(visitattendanceModel.actualExisting!)
                    : 0);
            coldVisitTotal =
                coldVisitTotal +
                (visitattendanceModel.actualColdVisit != ''
                    ? int.parse(visitattendanceModel.actualColdVisit!)
                    : 0);
          }
          isDataLoad.value = 1;
        } else {
          isDataLoad.value = 2;
        }
      });
    } catch (ex) {
      print(ex);
    }
  }
}
