import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/order/sales_order_report_entity.dart';

class SalesOrderReportController extends GetxController {
  RxDouble totalAmount = 0.0.obs;
  RxInt isDataLoad = 0.obs;
  RxList<SOReportEntity> sODetailsList = <SOReportEntity>[].obs;
  DateTime? fromDate = Utility.selectedFromDateOfDateController;
  DateTime? toDate = Utility.selectedToDateOfDateController;

  @override
  void onInit() {
    super.onInit();
    getSoDataApi();
  }

  Future getSoDataApi() async {
    isDataLoad.value = 0;
    sODetailsList.clear();
    totalAmount.value = 0.0;
    await ApiCall.getSalesOrderRegisterAPI(
      fromdate: fromDate.toString(),
      todate: toDate.toString(),
    ).then((sovalue) {
      if (sovalue.isNotEmpty) {
        sODetailsList.value = sovalue;
         for (var item in sovalue) {
          totalAmount.value +=
              double.tryParse(item.totalAmount.toString()) ?? 0.0;
        }

        isDataLoad.value = 1;
      } else {
        isDataLoad.value = 2;
      }
    });
  }
//   Future getSoDataApi() async {
//   isDataLoad.value = 0;
//   totalAmount.value = 0.0;

//   final sovalue = await ApiCall.getSalesOrderRegisterAPI(
//     fromdate: fromDate.toString(),
//     todate: toDate.toString(),
//   );

//   if (sovalue.isNotEmpty) {
//     sODetailsList.assignAll(sovalue); 

//     totalAmount.value = sovalue.fold(
//       0.0,
//       (sum, item) =>
//           sum + (double.tryParse(item.totalAmount.toString()) ?? 0.0),
//     );

//     isDataLoad.value = 1;
//   } else {
//     sODetailsList.clear();
//     isDataLoad.value = 2;
//   }
// }
}
