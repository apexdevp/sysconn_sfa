import 'package:get/get.dart';

class FloatingButtonController extends GetxController {
  var isExtended = true.obs;  // isExtended will be reactive
  var title = 'Button'.obs;   // title of the button, reactive too

  void toggleExtension() {
    isExtended.value = !isExtended.value;
  }

  void setTitle(String newTitle) {
    title.value = newTitle;
  }
}
