import 'package:get/get.dart';

class DateController extends GetxController {
  var date = ''.obs;

  void setDate(String newDate) {
    date.value = newDate;
  }
}
