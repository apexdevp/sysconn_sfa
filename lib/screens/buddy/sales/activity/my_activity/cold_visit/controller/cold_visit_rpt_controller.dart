import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/visitAttendanceEntity.dart';

class ColdVisitReportController extends GetxController {
  RxList<VisitAttendanceEntity> visitDetailsList =
      <VisitAttendanceEntity>[].obs;
  RxInt isDataLoad = 0.obs;
  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;

@override
  void onInit() {
    super.onInit();
    getVisitDataApi();
  }
  Future getVisitDataApi() async {
    isDataLoad.value = 0;
    visitDetailsList.clear();
    await ApiCall.getVisitDetailsDataAPI(
      fromdate: fromDate.toString(),
      todate: toDate.toString(),
    ).then((visitvalue) {
      if (visitvalue.isNotEmpty) {
        visitDetailsList.value = visitvalue;
        isDataLoad.value = 1;
      } else {
        isDataLoad.value = 2;
      }
    });
  }

    Future deleteVisitDet(String visitId) async {  
   await ApiCall.visitDeletePostData(visitid:visitId ).then((response) async {
     
        if (response == 'Data Deleted Successfully') {  
        //  Get.back();     
            getVisitDataApi();
          
        } else {
            scaffoldMessageValidationBar(Get.context!, 'Opps there is an error!');
        }
      
    });
  }
}
