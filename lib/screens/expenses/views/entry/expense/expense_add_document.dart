import 'dart:io';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:image_picker/image_picker.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/expense/expense_document_entity.dart';
import 'package:sysconn_sfa/screens/expenses/controllers/expense_add_document_add_controller.dart';
import 'package:sysconn_sfa/widgets/custom_appbar.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';

class ExpenseAddDocument extends StatelessWidget {
  final String? headerUniqueId;
  final ExpensesDocumentEntity? expensesDocumentEntity;
   ExpenseAddDocument({
    super.key,
    this.headerUniqueId,

    this.expensesDocumentEntity,
  });
late final ExpenseAddDocumentController controller =
      Get.put(
        ExpenseAddDocumentController(
          headerUniqueId: headerUniqueId!,
          expensesDocumentEntity: expensesDocumentEntity,
        ),
        tag: headerUniqueId,
      );
  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(
    //   ExpenseAddDocumentController(
    //     headerUniqueId: headerUniqueId!,
    //     expensesDocumentEntity: expensesDocumentEntity,
    //   ),
    // );

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: customAppbar(context: context, title: 'Create Receipt'),
      floatingActionButton: Obx(() {
        return controller.captureImgFileList.isNotEmpty
            ? Padding(
              padding: const EdgeInsets.all(8.0),
              child: ResponsiveButton(
                  title: 'Upload',
                  function: () async {
                    Utility.showCircularLoadingWid(context);
                    await controller.imageUpload(file:controller.captureImgFileList);
                  },
                ),
            )
            : Padding(
              padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
              child: Row(
                  children: [
                    Expanded(
                      child: ResponsiveButton(
                        title: 'Camera',
                        function: () async {
                          await controller.onImageButtonPressed(
                            ImageSource.camera,
                            context: context,
                          );
                          if (controller.captureImgFileList.isNotEmpty) {
                            controller.imageEvent.value = 'Add';    
                          }
                        },
                      ),
                    ),
                    SizedBox(width: size.width*0.02,),
                    Expanded(
                      child: ResponsiveButton(
                        title: 'Gallery',
                        function: () async {
                          await controller.onImageButtonPressed(
                            ImageSource.gallery,
                            context: context,
                          );
                          if (controller.captureImgFileList.isNotEmpty) {
                            controller.imageEvent.value = 'Add';
                          }
                        },
                      ),
                    ),
                  ],
                ),
            );
      }),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Padding(
              padding: EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Icon(Icons.assignment_outlined),
                      SizedBox(width: 10.0),
                      Text(
                        '${controller.expensesDocumentEntity == null ? 'Create' : 'Update'} Document',
                        style: kTxtStlB,
                      ),
                    ],
                  ),
                  controller.expensesDocumentEntity != null
                      ? Container(
                          width: 30,
                          height: 30,
                          decoration: BoxDecoration(
                            shape: BoxShape.circle,
                            color: kGreyColor,
                          ),
                          child: IconButton(
                            padding: EdgeInsets.all(0),
                            icon: Icon(
                              Icons.delete_forever,
                              color: Colors.red,
                              size: 19,
                            ),
                            onPressed: () {
                                Utility.showAlertYesNo(iconData: Icons.help_outline_rounded,iconcolor: Colors.blueAccent,
                                title: 'Alert',msg: 'Do you want to delete this expense?',
                                yesBtnFun: () async {
                                  Utility.showCircularLoadingWid(context);

                                  controller.imageEvent.value = 'Delete';

                                  await controller.imageUpload();
                                },
                                noBtnFun: () {
                                  Navigator.of(context).pop();
                              },);
                            },
                          ),
                        )
                      : Container(),
                ],
              ),
            ),
            Row(
              children: [
                CustomTextFormFieldView(
                  controller: controller.remarkController,
                  title: 'Remark',
                ),
              ],
            ),
            SizedBox(height: size.height * 0.02),
            Expanded(
              child: Obx(() {return controller.captureImgFileList.isNotEmpty
                  ? Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: _imagePreview(controller),
                    )
                  : controller.expensesDocumentEntity == null
                  ? Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      crossAxisAlignment: CrossAxisAlignment.center,
                      children: [
                        const Icon(
                          Icons.cloud_upload_outlined,
                          size: 70,
                          color: Colors.grey,
                        ),
                        const SizedBox(height: 10.0),
                        Text(
                          'You have not yet picked a file',
                          style: kTxtStl12N,
                        ),
                      ],
                    )
                  : Container(
                      decoration: BoxDecoration(
                        border: Border.all(width: 1.0, color: Colors.grey),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: Image.network(controller.documentUrl.value),
                    );})
            ),
          ],
        ),
      ),
    );
  }

  Widget _imagePreview(ExpenseAddDocumentController controller) {
    final Text? retrieveError = _getRetrieveErrorWidget();
    if (retrieveError != null) {
      return retrieveError;
    }
    if (controller.captureImgFileList.isNotEmpty) {
      return Semantics(
        label: 'Document Image',
        child: GridView.count(
          crossAxisCount: 1,
          childAspectRatio: 0.6,
          children: List.generate(controller.captureImgFileList.length, (
            index,
          ) {
            return Semantics(
              label: 'Document Image',
              child: Image.file(
                File(controller.captureImgFileList[index].path),
              ),
            );
          }),
        ),
      );
    } else if (controller.pickImageError.value != null) {
      return Text(
        'Pick image error: ${controller.pickImageError.value}',
        style: kTxtStl12GreyN,
      );
    } else {
      return Text('You have not yet picked an image.', style: kTxtStl12GreyN);
    }
  }

  Text? _getRetrieveErrorWidget() {
    String? retrieveDataError = '';
    if (retrieveDataError != '') {
      final Text result = Text(retrieveDataError);
      retrieveDataError = null;
      return result;
    }
    return null;
  }
}
