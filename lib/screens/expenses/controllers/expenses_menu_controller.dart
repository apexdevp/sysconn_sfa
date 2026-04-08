import 'dart:async';
import 'package:get/get.dart';
import 'package:intl/intl.dart';

class ExpensesMenuController extends GetxController {
  RxString timeString = ''.obs;
  RxBool isDataLoad = false.obs;

  Timer? _timer;

  @override
  void onInit() {
    super.onInit();
    _startTimer();
  }

  void _startTimer() {
    _timer = Timer.periodic(const Duration(seconds: 1), (timer) {
      _getTime();
    });
  }

  void _getTime() {
    final DateTime now = DateTime.now();
    timeString.value = DateFormat('hh:mm:ss ').format(now);
    isDataLoad.value = true;
  }

  @override
  void onClose() {
    _timer?.cancel();
    super.onClose();
  }
}
