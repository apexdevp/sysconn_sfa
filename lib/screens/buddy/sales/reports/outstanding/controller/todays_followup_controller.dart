import 'package:get/get.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/outstanding/paymentfollowupentity.dart';

class TodayFollowupController extends GetxController {
  var isDataLoad = 0.obs;
  var paymentFollowupDataList = <PaymentFollowupEntity>[].obs;
  String? mobileno;
  String? fromdate;
  String? todate;
  TodayFollowupController({this.mobileno, this.fromdate, this.todate});
  
  @override
  void onInit() {
    super.onInit();
    getPaymentFollowupAllDataAPI();
  }

  Future getPaymentFollowupAllDataAPI() async {
    isDataLoad.value = 0;
    paymentFollowupDataList.clear();

    final followupvalue = await ApiCall.getPaymentFollowupDataAPI(
      mobileno: mobileno!,
      fromdate: fromdate!,
      todate: todate!,
    );
    if (followupvalue.isNotEmpty) {
      paymentFollowupDataList.assignAll(followupvalue);
      isDataLoad.value = 1;
    } else {
      isDataLoad.value = 2;
    }
  }
}
