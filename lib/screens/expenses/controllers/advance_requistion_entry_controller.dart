import 'package:get/get.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/expense/adv_expenses_entity.dart';
import 'package:sysconn_sfa/api/entity/user/userentity.dart';
import 'package:sysconn_sfa/screens/expenses/views/entry/advance_requisition/submit_expense.dart';

class AdvanceRequisitionController extends GetxController {
  final dateController = TextEditingController(
    text: DateFormat('dd-MM-yyyy').format(DateTime.now()),
  );
  TextEditingController whatAndWhenExpnsController = TextEditingController();
  TextEditingController amountController = TextEditingController();

  List<String> categoryItem = [
    'Tour Advance',
    // 'Salary Advance',
    'IOU Advance',
    'Other Advance',
  ];
  //  var categorySelected = ''.obs;
  final RxnString categorySelected = RxnString();
  final empEntityList = <UserEntity>[].obs;

  final approvedById = ''.obs;
  final approvedByName = RxnString();
  final approvalFcmToken = RxnString();
  final approvalMobNo = RxnString();
  final expenseUniqueId = ''.obs;
  AdvExpensesEntity? expenseData;

  @override
  void onInit() {
    super.onInit();
    ApiCall.getcompanyuserlistAPI().then((userDataList) {
      empEntityList.value = userDataList;
      //  setRowEditValues();
      if (expenseData != null) {
        setRowEditValues();
      }
    });
  }

  @override
  void onClose() {
    dateController.dispose();
    whatAndWhenExpnsController.dispose();
    amountController.dispose();
    super.onClose();
  }

  void setRowEditValues() {
    if (expenseData != null) {
      print(expenseData!.expensesDetails!);
      print(expenseData!.uniqueId!);
      expenseUniqueId.value = expenseData!.uniqueId!;
      dateController.text = DateFormat(
        'dd-MM-yyyy',
      ).format(DateTime.parse(expenseData!.date!));
      whatAndWhenExpnsController.text = expenseData!.expensesDetails!;
      amountController.text = num.parse(
        expenseData!.amount!,
      ).round().toString();
      categorySelected.value = expenseData!.category!;
      approvedById.value = expenseData!.approvedbyId!;

      for (int i = 0; i < empEntityList.length; i++) {
        if (approvedById.value == empEntityList[i].emailid!) {
          print(empEntityList[i].usertype);
          approvedByName.value =
              '${empEntityList[i].username} / ${empEntityList[i].usertype}';
        }
      }
    }
  }

  Future<bool> validator() async {
    if (categorySelected.value == null) {
      scaffoldMessageBar('Please enter expenses details!');
      return false;
    } else if (approvedById.value == '') {
      scaffoldMessageBar('Please select approval name!');
      return false;
    } else if (amountController.text.trim().isEmpty) {
      scaffoldMessageBar('Please enter amount!');
      return false;
    } else if (num.parse(amountController.text.trim()) <= 0) {
      scaffoldMessageBar('Please enter valid amount!');
      return false;
    } else {
      return true;
    }
  }

  Future postAdvanceExpenses() async {
    bool isValid = false;
    await validator().then((value) {
      isValid = value;
    });
    if (isValid) {
      AdvExpensesEntity expenseadvEntity = AdvExpensesEntity();
      // expenseadvEntity.groupId = Utility.groupCode;
      expenseadvEntity.companyId = Utility.companyId;
      // expenseadvEntity.employeeid = Utility.employeeId;
      expenseadvEntity.emailId = Utility.useremailid;
      expenseadvEntity.uniqueId = expenseUniqueId.value;
      expenseadvEntity.date = dateController.text;
      expenseadvEntity.category = categorySelected.value;
      expenseadvEntity.expensesDetails = whatAndWhenExpnsController.text;
      expenseadvEntity.amount = amountController.text;
      expenseadvEntity.approvedbyId = approvedById.value;

      await ApiCall.postAdvanceExpensesAPI(expenseadvEntity).then((
        value,
      ) async {
        print('value $value');

        if (value == 'Data Inserted Successfully' ||
            value == 'Data Updated Successfully') {
          // await SendNotificationService.sendNotificationUsingAPI(approvalFcmToken,'Advance Requisition Application','Advance Requisition by ${Utility.employeeName}');
          // await postInsertNotificationData(moduleType: 'Advance Requisition',title: 'Advance Requisition Application',body: 'Advance Requisition by ${Utility.employeeName}');

          Get.to(
            () => ExpenseAdvanceSubmitScreen(
              date: dateController.text,
              totalamount: amountController.text,
              title: 'Advance Request',
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
  }
  //  Future postInsertNotificationData({required String moduleType,required String title,required String body}) async {
  //     NotificationEntity notificationEntity = NotificationEntity();
  //     notificationEntity.groupId = Utility.groupCode;
  //     notificationEntity.companyId = Utility.companyId;
  //     notificationEntity.employeeId = Utility.employeeId;
  //     notificationEntity.mobileNo = Utility.userMobileNo;
  //     notificationEntity.fcmToken = approvalFcmToken;
  //     notificationEntity.notificationMobNo = approvalMobNo;
  //     notificationEntity.notificationEmpId = approvedById;
  //     notificationEntity.moduleType = moduleType;
  //     notificationEntity.title = title;
  //     notificationEntity.body = body;

  //     List<Map<String, dynamic>> notificationListMap = [];
  //     notificationListMap.add(notificationEntity.toJson());
  //     await ApiCall.notificatioInsertPostCall(notificationListMap);
  //   }

  Future deleteAdvanceExpensApi() async {
    AdvExpensesEntity deleteSalesDetailEntity = AdvExpensesEntity();
    deleteSalesDetailEntity.companyId = Utility.companyId;
    deleteSalesDetailEntity.uniqueId = expenseUniqueId.value;
    List<Map<String, dynamic>> salesEntityListMap = [];
    salesEntityListMap.add(deleteSalesDetailEntity.toJson());

    await ApiCall.deleteAdvanceExpensePostAPI(deleteSalesDetailEntity).then((
      response,
    ) async {
      if (response == 'Data Deleted Successfully') {
        Get.back();
        await Utility.showAlert(
          icons: Icons.check,
          iconcolor: Colors.green,
          title: 'Status',
          msg: 'Advance Request Deleted Successfully',
        ).then((value) {
          Get.back();
        });
      } else {
        Utility.showAlert(
          icons: Icons.error_outline_outlined,
          iconcolor: Colors.redAccent,
          title: 'Alert',
          msg: "Oops there is an Error!.",
        );
      }
    });
  }
}
