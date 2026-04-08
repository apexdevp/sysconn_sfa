import 'package:get/get.dart';

class HomePageController extends GetxController {
  int currentIndex = 0;
  List<String> menuList = ['Sales', 'Expenses', 'POS/VAN'];

  // @override
  // void onInit() {
  //   super.onInit();
  //   callInitFun();
  // }

  // // SAME METHOD NAME
  // void callInitFun() async {
  //   Utility.unreadCount = 0;

  //   await ApiCall.allNotificationHistoryList(indexSelected: 1)
  //       .then((allNotiHistoryValue) {
  //     if (allNotiHistoryValue.isNotEmpty) {
  //       Utility.unreadCount =
  //           int.parse(allNotiHistoryValue[0].unreadNotification!);
  //     }
  //   });

  //   update(); // instead of setState

  //   if (Utility.unreadCount > 0) {
  //     Get.to(() => NotificationDetailsScreen());
  //   }
  // }

  // SAME METHOD NAME
  void bottomNavChange(int index) {

    // if (index == 1) {
    //   if (Utility.moduleCode == 'M003' ||
    //       Utility.moduleCode == 'M004' ||
    //       Utility.moduleCode == 'M004A') {
    //     currentIndex = index;
    //   } else {
    //     Get.snackbar('Error', 'Access denied!');
    //   }
    // }
    // else if (index == 2) {
    //   if (Utility.moduleCode == 'M002' ||
    //       Utility.moduleCode == 'M004' ||
    //       Utility.moduleCode == 'M004A') {
    //     currentIndex = index;
    //   } else {
    //     Get.snackbar('Error', 'Access denied!');
    //   }
    // }
    // else {

      currentIndex = index;
    // }

    update(); // instead of setState
  }

  // // SAME METHOD NAME
  // Future<void> onWillPopScopeBack(bool popval, result) async {

  //   if (popval) return;

  //   await Utility.showAlertYesNo(
  //     Get.context!,
  //     title: 'Are you sure you want to quit?',
  //     msg: 'Thank You!!',
  //     yesBtnFun: () async {
  //       await ApiCall.logoutPostApi().then((response) {
  //         Get.offAllNamed('/'); // instead of Navigator
  //       });
  //     },
  //     noBtnFun: () async {
  //       Get.back();
  //     },
  //   );
  // }
}
