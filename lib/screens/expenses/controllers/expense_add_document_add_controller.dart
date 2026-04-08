import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_image_compress/flutter_image_compress.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/expense/expense_document_entity.dart';

class ExpenseAddDocumentController extends GetxController {
  ExpenseAddDocumentController({
    required this.headerUniqueId,
    this.expensesDocumentEntity,
  });

  final String headerUniqueId;
  final ExpensesDocumentEntity? expensesDocumentEntity;
  final remarkController = TextEditingController();
  final captureImgFileList = <XFile>[].obs;
  final pickImageError = Rxn<dynamic>();
  final documentUrl = ''.obs;
  final documentId = ''.obs;
  final maxNo = ''.obs;
  final imageEvent = ''.obs;
  final ImagePicker _picker = ImagePicker();

 @override
  void onInit() {
    super.onInit();
    _setEditData();
  }

  void _setEditData() {
    if (expensesDocumentEntity != null) {
      documentId.value = expensesDocumentEntity!.documentId ?? '';
      maxNo.value = expensesDocumentEntity!.maxNo ?? '';
      documentUrl.value = expensesDocumentEntity!.documentPath ?? '';
      remarkController.text = expensesDocumentEntity!.remark ?? '';
    }
  }
  
  @override
  void onClose() {
    remarkController.dispose();
    super.onClose();
  }

  Future<File?> compressImage(File image) async {
    var result = await FlutterImageCompress.compressWithFile(
      image.absolute.path,
      minWidth: 800, // minimum width after compression
      minHeight: 600, // minimum height after compression
      quality: 80, // Image quality (0-100, where 100 is the highest quality)
      rotate: 0, // No rotation
      format: CompressFormat.jpeg, // Output format (JPEG)
    );

    if (result != null) {
      return File(image.absolute.path)..writeAsBytesSync(result);
    } else {
      return null;
    }
  }

  //  Future<void> onImageButtonPressed(ImageSource source, {BuildContext? context,bool isMultiImage = false,}) async {
  //     if (isMultiImage) {
  //       try {
  //         final List<XFile> pickedFileList = await _picker.pickMultiImage();
  //         // Compress the images before adding them to the list
  //         List<XFile> compressedFileList = [];
  //         for (var file in pickedFileList) {
  //           File? compressedImage = await compressImage(File(file.path));
  //           if (compressedImage != null) {
  //             compressedFileList.add(XFile(compressedImage.path));
  //           }
  //         }
  //         captureImgFileList.assignAll(compressedFileList);
  //             // captureImgFileList = compressedFileList; //pickedFileList;

  //       } catch (e) {
  //         setState(() {
  //           pickImageError = e;
  //         });
  //       }
  //     } else {
  //       try {
  //         XFile? pickedFile = await ImagePicker().pickImage(source: source);
  //         if (kDebugMode) {
  //           print('pickedFile $pickedFile');
  //         }
  //         // Compress the picked image before using it
  //         if (pickedFile != null) {
  //           File? compressedImage = await compressImage(File(pickedFile.path));
  //           if (mounted && compressedImage != null) {
  //             setState(() {
  //               // _setImageFileListFromFile(XFile(compressedImage.path));
  //               captureImgFileList = [XFile(compressedImage.path)];
  //             });
  //           }
  //         }
  //       } catch (e) {
  //         if (mounted) {
  //           setState(() {
  //             pickImageError = e;
  //           });
  //         }
  //       }
  //     }
  //   }

  Future<void> onImageButtonPressed(
    ImageSource source, {
    BuildContext? context,
    bool isMultiImage = false,
  }) async {
    try {
      if (isMultiImage) {
        final pickedList = await _picker.pickMultiImage();
        List<XFile> compressed = [];

        for (var file in pickedList) {
          File? img = await compressImage(File(file.path));
          if (img != null) {
            compressed.add(XFile(img.path));
          }
        }
        captureImgFileList.assignAll(compressed);
      } else {
        final pickedFile = await _picker.pickImage(source: source);
        if (pickedFile != null) {
          File? img = await compressImage(File(pickedFile.path));
          if (img != null) {
            captureImgFileList.assignAll([XFile(img.path)]);
          }
        }
      }
      imageEvent.value = 'Add';
    } catch (e) {
      pickImageError.value = e;
    }
  }

//   Future imageUpload({List<XFile>? file}) async {
//     ExpensesDocumentEntity expensesDocumentEntity = ExpensesDocumentEntity();
//     expensesDocumentEntity.headerUniqueId = headerUniqueId;
//     expensesDocumentEntity.documentId = documentId.value;
//     expensesDocumentEntity.maxNo = maxNo.value;
//     expensesDocumentEntity.remark = remarkController.text;
//     expensesDocumentEntity.imageEvent = imageEvent.value;
//     expensesDocumentEntity.imageSelectedFilepath = captureImgFileList[0].path;
// print("Header Unique ID Sent: $headerUniqueId");
// print("Image Path Sent: ${captureImgFileList.first.path}");
//     await ApiCall.expDocImageUpload(
//       expensesDocumentEntity: expensesDocumentEntity,
//     ).then((response) async {
//       Get.back();
//       if (response == 'Data Inserted Successfully') {
//         // if (response == 'Success') {
//         await Utility.showAlert(
//           icons: Icons.check_circle_outline,
//           iconcolor: Colors.green,
//           title: 'Done',
//           msg: 'Document Uploaded Successfully!',
//         );
//         Get.back();
//       } else if (response == 'Data Deleted Successfully') {
//         await Utility.showAlert(
//           icons: Icons.check_circle_outline,
//           iconcolor: Colors.green,
//           title: 'Done',
//           msg: 'Document Deleted Successfully!',
//         );
//         Get.back();
//       } else {
//         await Utility.showAlert(
//           icons: Icons.cancel_outlined,
//           iconcolor: Colors.red,
//           title: 'Error',
//           msg: 'Oops there is an error!',
//         );
//       }
//     });
//   }

Future imageUpload({List<XFile>? file}) async {
  ExpensesDocumentEntity entity = ExpensesDocumentEntity();
  entity.headerUniqueId = headerUniqueId;
  entity.documentId = documentId.value;
  entity.maxNo = maxNo.value;
  entity.remark = remarkController.text;
  entity.imageEvent = imageEvent.value;

  print('ImageEvent: ${imageEvent.value}');
  print('ImageList length: ${captureImgFileList.length}');

  // ✅ DELETE FLOW → DO NOT TOUCH IMAGE LIST
  if (imageEvent.value == 'Delete') {
    await ApiCall.expDocImageUpload(
      expensesDocumentEntity: entity,
    ).then((response) async {
      Get.back();
      if (response == 'Data Deleted Successfully') {
        await Utility.showAlert(
          icons: Icons.check_circle_outline,
          iconcolor: Colors.green,
          title: 'Done',
          msg: 'Document Deleted Successfully!',
        );
        Get.back();
      } else {
        await Utility.showAlert(
          icons: Icons.cancel_outlined,
          iconcolor: Colors.red,
          title: 'Error',
          msg: 'Oops there is an error!',
        );
      }
    });
    return;
  }

  // ✅ ADD / INSERT FLOW → IMAGE REQUIRED
  final List<XFile> files = file ?? captureImgFileList;

  if (files.isEmpty) {
    Get.back();
    Get.snackbar(
      'Error',
      'Please select at least one image',
      snackPosition: SnackPosition.BOTTOM,
    );
    return;
  }

  // ✅ SAFE ACCESS
  entity.imageSelectedFilepath = files.first.path;

  print("Header Unique ID Sent: $headerUniqueId");
  print("Image Path Sent: ${files.first.path}");

  await ApiCall.expDocImageUpload(
    expensesDocumentEntity: entity,
  ).then((response) async {
    Get.back();
    if (response == 'Data Inserted Successfully') {
      await Utility.showAlert(
        icons: Icons.check_circle_outline,
        iconcolor: Colors.green,
        title: 'Done',
        msg: 'Document Uploaded Successfully!',
      );
      Get.back();
    } else {
      await Utility.showAlert(
        icons: Icons.cancel_outlined,
        iconcolor: Colors.red,
        title: 'Error',
        msg: 'Oops there is an error!',
      );
    }
  });
}

}
