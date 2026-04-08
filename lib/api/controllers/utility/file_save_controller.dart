import 'dart:io';
import 'package:get/get.dart';
import 'package:open_filex/open_filex.dart';
import 'package:path_provider/path_provider.dart';

class FileSaveController extends GetxController {
  var isSaving = false.obs;
  var lastSavedFilePath = ''.obs;

  Future<void> saveAndLaunchFile(List<int> bytes, String fileName) async {
    try {
      isSaving.value = true;

      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = directory.path;
      final File file = File('$path/$fileName');

      await file.writeAsBytes(bytes, flush: true);
      lastSavedFilePath.value = file.path;

      await OpenFilex.open(file.path);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save file: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }

  Future<void> saveAndLaunchFileForPDF(List<int> bytes, String fileName) async {
    try {
      isSaving.value = true;

      final Directory directory = await getApplicationDocumentsDirectory();
      final String path = directory.path;
      final File file = File('$path/$fileName');

      await file.writeAsBytes(bytes, flush: true);
      lastSavedFilePath.value = file.path;

      await OpenFilex.open(file.path);
    } catch (e) {
      Get.snackbar(
        'Error',
        'Failed to save PDF: $e',
        snackPosition: SnackPosition.BOTTOM,
      );
    } finally {
      isSaving.value = false;
    }
  }
}
