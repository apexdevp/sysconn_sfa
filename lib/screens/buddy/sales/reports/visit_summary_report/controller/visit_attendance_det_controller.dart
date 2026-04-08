import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/visitAttendanceEntity.dart';

class VisitAttendanceDetRptController extends GetxController {
  RxInt isDataLoad = 0.obs;
  RxList<VisitAttendanceEntity> attendanceDetailsList =
      <VisitAttendanceEntity>[].obs;

  DateTime fromdate = Utility.findStartOfThisYear(DateTime.now());
  DateTime todate = Utility.findLastOfThisYear(DateTime.now());
  String? mobileno;
  RxString popupMenuSelected = 'ALL'.obs;
  List<String> popupMenuItem = ['ALL', 'Existing', 'Cold Visit'];

  // @override
  // void onInit() {
  //   super.onInit();
  //   attendanceDetailsDataAPI();
  // }

void initData({
  required DateTime from,
  required DateTime to,
  String? mobile,
  required String filter,
}) {
  fromdate = from;
  todate = to;
  mobileno = mobile;
  popupMenuSelected.value = filter;

  attendanceDetailsDataAPI(); // ✅ CALL AFTER SETTING DATA
}

  Future<void> attendanceDetailsDataAPI() async {
    isDataLoad.value = 0;

    try {
      attendanceDetailsList.value = await ApiCall.getVisitDetailsDataAPI(
        fromdate: fromdate.toString(),
        todate: todate.toString(),
        // mobileno: mobileno, // ✅ ADD THIS
        filterType: popupMenuSelected.value,
      );

      isDataLoad.value = attendanceDetailsList.isNotEmpty ? 1 : 2;
    } catch (e) {
      isDataLoad.value = 2;
      print('Error fetching visit details: $e');
    }
  }
}
