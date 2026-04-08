import 'package:get/get.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/order/sales_order_report_entity.dart';

class SalesOrderRegisterController extends GetxController {
  RxInt isDataLoad = 0.obs;

  RxList<SOReportEntity> salesOrderRegisterValue = <SOReportEntity>[].obs;

  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;

  @override
  void onInit() {
    super.onInit();
    getSalesOrderRegisterAPI();
  }

  Future getSalesOrderRegisterAPI() async {
    isDataLoad.value = 0;
    salesOrderRegisterValue.clear();

    final soValue = await ApiCall.getSalesOrderRegisterAPI(
      fromdate: fromDate.toString(),
      todate: toDate.toString(),
    );
    if (soValue.isNotEmpty) {
      salesOrderRegisterValue.assignAll(soValue);
      isDataLoad.value = 1;
    } else {
      isDataLoad.value = 2;
    }
  }
}
