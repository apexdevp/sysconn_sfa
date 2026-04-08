import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/expense/adv_expenses_entity.dart';

class AdvExpenseApprController extends GetxController {
  final AdvExpensesEntity expenseDetList;

  AdvExpenseApprController(this.expenseDetList);
  TextEditingController remarkController = TextEditingController();

  List<String> statusItem = ['Pending', 'Approved', 'Reject'];

  // var statusSelected = ''.obs;
  var statusSelected = RxnString();
  String employeeFcmToken = '';

  @override
  void onInit() {
    super.onInit();
    setRowEditValues();
  }

  @override
  void onClose() {
    remarkController.dispose();
    super.onClose();
  }

  void setRowEditValues() {
    if (statusItem.contains(expenseDetList.approvalStatus)) {
      statusSelected.value = expenseDetList.approvalStatus;
    } else {
      statusSelected.value = null;
    }
    remarkController.text = expenseDetList.approverRemark ?? '';
    employeeFcmToken = expenseDetList.fcmToken ?? '';
    }

  Future postExpensesStatusApi() async {
    AdvExpensesEntity expenseadvEntity = AdvExpensesEntity();
    expenseadvEntity.companyId = Utility.companyId;
    expenseadvEntity.uniqueId = expenseDetList.uniqueId;
    expenseadvEntity.approvalStatus = statusSelected.value;

    expenseadvEntity.approverRemark = remarkController.text;

    await ApiCall.postAdvExpensesUpdateStatusAPI(expenseadvEntity).then((
      value,
    ) async {
      if (value == 'Data Updated Successfully') {
        Get.back();

        // await SendNotificationService.sendNotificationUsingAPI(employeeFcmToken, 'Advance Requisition Approval Status', statusSelected);
        // await postnotificationInDbApi();//snehal 28-07-2025 add for notification

        await Utility.showAlert(
          icons: Icons.check,
          iconcolor: Colors.green,
          title: 'Done',
          msg: 'Status Updated Successfully!',
        ).then((value) {
          Get.back();
        });

        // });
        // });
      } else {
        await Utility.showAlert(
          icons: Icons.cancel_outlined,
          iconcolor: Colors.red,
          title: 'Error',
          msg: 'Oops there is an error!',
        );
      }
    });
  }
}
