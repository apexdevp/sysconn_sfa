import 'package:file_picker/file_picker.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/product_master_report/controller/productmastercontroller.dart';

class ProductImageController extends GetxController {

  Uint8List? bytesData;
 String? fileName;

   Future<void> startWebFilePicker() async {
  FilePickerResult? result = await FilePicker.platform.pickFiles(
    type: FileType.image,
    withData: true,
  );

  if (result != null) {
    bytesData = result.files.first.bytes;
    fileName = result.files.first.name;

    print("File: $fileName");

    update(); 
  }
}

  Future<void> productImageupdateApi(String productCode) async {
  if (bytesData == null || fileName == null) {
    await Utility.showAlert(
      icons: Icons.error,
      iconcolor: Colors.red,
      title: 'Error',
      msg: 'Please select an image first',
    );
    return;
  }
  try {
    Get.dialog(
      const Center(child: CircularProgressIndicator()),
      barrierDismissible: false,
    );
    final response = await ApiCall.postProductImage(
      Utility.companyId,
      productCode,
      bytesData!,
      fileName!,
    );

    if (Get.isDialogOpen ?? false) Get.back();
   // print("API RESPONSE: $response");
    if (response.contains('Successfully')) {
      await Utility.showAlert(
        icons: Icons.check,
        iconcolor: Colors.green,
        title: 'Status',
        msg: 'Image Uploaded Successfully',
      );
   final productController = Get.find<ProductMasterController>();
  await productController.getProductMasterData();

  Get.back(result: true); 
    } else {
      await Utility.showAlert(
        icons: Icons.close,
        iconcolor: Colors.red,
        title: 'Error',
        msg: 'Oops there is an error!',
      );
    }
  } catch (e) {
    if (Get.isDialogOpen ?? false) Get.back();

    await Utility.showAlert(
      icons: Icons.close,
      iconcolor: Colors.red,
      title: 'Error',
      msg: e.toString(),
    );
  }
}

String? imageUrl;

void setExistingImage(String? path) {
  if (path == null || path.isEmpty) return;
  imageUrl = path;
 print("FINAL IMAGE URL: $imageUrl");
  update();
}
  }


