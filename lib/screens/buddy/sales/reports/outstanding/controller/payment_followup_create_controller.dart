import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/outstanding/paymentfollowupentity.dart';
import 'package:sysconn_sfa/api/entity/company/partyentity.dart';

class PaymentFollowUpCreateController extends GetxController {
  final String? partyId;
  final PartyEntity? partyEntity;
  PaymentFollowUpCreateController(this.partyId, this.partyEntity);

  RxInt isDataLoad = 0.obs;

  TextEditingController outstandingController = TextEditingController();
  TextEditingController overdueAmountController = TextEditingController();
  TextEditingController followUpAmountController = TextEditingController();
  TextEditingController nextDateController = TextEditingController();
  TextEditingController nextTimeController = TextEditingController();
  TextEditingController followdoneWithController = TextEditingController();
  TextEditingController remarkController = TextEditingController();
  RxString lastFollowupDate = ''.obs;
  RxString lastPayDoneWith = ''.obs;
  RxString lastRemark = ''.obs;

  ValueNotifier<DateTime> dateTimeNotifier = ValueNotifier<DateTime>(
    DateTime.now(),
  );

  List<String> followuptypeForItem = ['Regular', 'Dispute', 'Escalated'];

  RxString followupForSelected = 'Regular'.obs;

  @override
  void onInit() {
    super.onInit();
    getLastFollowupDetails();
  }

  Future getLastFollowupDetails() async {
    isDataLoad.value = 0;

    await ApiCall.getlastfollowupAPI(partyid: partyId!).then((
      lastfollowupSyncValue,
    ) {
      if (lastfollowupSyncValue.isNotEmpty) {
        PaymentFollowupEntity lastPaymentfollowupEntity =
            PaymentFollowupEntity.fromJson(lastfollowupSyncValue[0]);
        lastFollowupDate.value =
            lastPaymentfollowupEntity.lastFollowupDate! != ''
            ? DateFormat('dd-MM-yyyy').format(
                DateTime.parse(lastPaymentfollowupEntity.lastFollowupDate!),
              )
            : '';
        lastPayDoneWith.value = lastPaymentfollowupEntity.lsFollowUpDoneWith!;
        lastRemark.value = lastPaymentfollowupEntity.lsRemark!;
        outstandingController.text =
            lastPaymentfollowupEntity.outstandingAmount! != ''
            ? num.parse(
                lastPaymentfollowupEntity.outstandingAmount!,
              ).toStringAsFixed(1)
            : '';
        overdueAmountController.text =
            lastPaymentfollowupEntity.overDueAmount != ''
            ? num.parse(
                lastPaymentfollowupEntity.overDueAmount!,
              ).toStringAsFixed(1)
            : '';
      } else {
        isDataLoad.value = 2;
      }
    });
  }

  Future postPaymentFollowupAPi() async {
    PaymentFollowupEntity paymentFollowupEntity = PaymentFollowupEntity();
    paymentFollowupEntity.companyId = Utility.companyId;
    paymentFollowupEntity.emailid = Utility.useremailid;
    paymentFollowupEntity.mobileNo = Utility.cmpmobileno;
    paymentFollowupEntity.partyId = partyId;
    paymentFollowupEntity.followUpAmount = followUpAmountController.text;

    paymentFollowupEntity.contact = partyEntity!.contactNo!;
    paymentFollowupEntity.nextFollowUpTime = nextTimeController.text;
    paymentFollowupEntity.remarks = remarkController.text;
    paymentFollowupEntity.nextFollowUpDate = nextDateController.text == ''
        ? ''
        : DateFormat(
            'yyyy-MM-dd',
          ).format(DateFormat('dd/MM/yyyy').parse(nextDateController.text));
    paymentFollowupEntity.todayFollowupDoneWith = followdoneWithController.text;
    paymentFollowupEntity.followuptype = followupForSelected.value;

    List<Map<String, dynamic>> paymentfollowupList = [];
    paymentfollowupList.add(paymentFollowupEntity.toJson());

    await ApiCall.postPaymentFollowupDataApi(
      partyId!,
      paymentfollowupList,
    ).then((response) async {
      Get.back();
      if (response == 'Entry Added Successfully') {
        await Utility.showAlert(
          icons: Icons.check,
          iconcolor: Colors.green,
          title: 'Done',
          msg: 'Data Inserted Successfully',
        );
        Get.back();
      } else {
        Utility.showAlert(
          icons: Icons.close,
          iconcolor: Colors.red,
          title: 'Error',
          msg: 'Oops there is an error!',
        );
      }
    });
  }
}
