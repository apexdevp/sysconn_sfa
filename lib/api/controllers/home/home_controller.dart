// import 'package:get/get.dart';
// import 'package:sysconn_sfa/Utility/systemxs_global.dart';
// import 'package:sysconn_sfa/Utility/utility.dart';

// class HomeController extends GetxController {
//   RxInt currentIndex = 0.obs;

//   void changeIndex(int index) {
//     if (Utility.companyId.isEmpty) {
//       scaffoldMessageBar("Please select company first!!");
//       return;
//     }
//     currentIndex.value = index;
//   }

//   Future<bool> onBackPressed() async {
//     if (currentIndex.value == 0) {
//       bool? exit = await Utility.showAlertYesNo(
//         title: "Alert",
//         msg: "Are you sure? \n you want to quit this app!!",
//       );
//       return exit ?? false;
//     } else {
//       currentIndex.value = 0;
//       return false;
//     }
//   }
// }

import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';

class HomeController extends GetxController {
  RxString companyId = ''.obs;
  RxString companyLogo = ''.obs;

  @override
  void onInit() {
    companyId.value = Utility.companyId;
    companyLogo.value = Utility.companyLogo;
    super.onInit();
  }

  void showMessage(String message) {
    Get.snackbar(
      'Message',
      message,
      snackPosition: SnackPosition.BOTTOM,
    );
  }

  bool canProceed() {
    if (companyId.value.isEmpty) {
      showMessage('Please select company first!!');
      return false;
    }
    return true;
  }
}
