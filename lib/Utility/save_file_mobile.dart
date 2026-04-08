import 'dart:io';

import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FileSaveHelper extends GetxController {
  static Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File file = File('$path/$fileName');

    await file.writeAsBytes(bytes, flush: true);

    Get.snackbar(
      "File Saved",
      "Saved to $path/$fileName",
      snackPosition: SnackPosition.BOTTOM,
    );

    OpenFilex.open('$path/$fileName');
  }

  static Future<void> saveAndLaunchFileForPDF(List<int> bytes, String fileName) async {
    final Directory directory = await getApplicationDocumentsDirectory();
    final String path = directory.path;
    final File file = File('$path/$fileName');

    await file.writeAsBytes(bytes, flush: true);

    Get.snackbar(
      "PDF Saved",
      "Saved to $path/$fileName",
      snackPosition: SnackPosition.BOTTOM,
    );

    await OpenFilex.open('$path/$fileName');
  }
}
