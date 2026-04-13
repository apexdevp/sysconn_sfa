import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/product_master_report/controller/productimagecontroller.dart';
import 'package:sysconn_sfa/widgetscustome/custome_dialogbox.dart';

class ProductImageAdd extends StatelessWidget {
  final String? type;
  const ProductImageAdd({super.key, this.type});

  @override
  Widget build(BuildContext context) {
    return Container();
  }

   Future showProductImageDialog( 
   BuildContext context, {
  required String productCode,
   String? imagePath, 
}) {

    final ProductImageController controller = Get.put(ProductImageController());
   
controller.bytesData = null;
controller.fileName = null;
controller.imageUrl = null; 
controller.setExistingImage(imagePath);

    Size size = MediaQuery.of(context).size;
    //return AuthGuard(
    return Get.dialog(
      CustomeDialogbox(
        maxHeight: 600,
        maxWidth: 1000,
        minWidth: 800,
        buttontitle: 'Save',
        title: 'Add Product Image',
        function: () async {
          await controller.productImageupdateApi(productCode); 
          // Get.back();  
        },
        content:
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10, bottom: 10, left: 10),
                  child: Container(
                    width: size.width * 0.7,
                    color: Colors.white,
                    child: SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.center,
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          GetBuilder<ProductImageController>(
                            builder: (controller) {
                              return Center(
                                child: Padding(
                                  padding: const EdgeInsets.all(8.0),
                                  child: Container(
                                   // width: size.width * 0.27,
                                    height: size.height * 0.20,
                                    decoration: BoxDecoration(
                                      border: Border.all(color: Colors.grey),
                                      borderRadius: BorderRadius.circular(
                                        Utility.borderCornerRadious,
                                      ),
                                    ),
                                    child: controller.bytesData != null
                                        ? Padding(
                                            padding: const EdgeInsets.all(8.0),
                                            child: Image.memory(
                                              controller.bytesData!,
                                              fit: BoxFit.contain,
                                            ),
                                          )
                                        : controller.imageUrl != null &&
                                                controller.imageUrl!.isNotEmpty
                                            ? Padding(
                                                padding: const EdgeInsets.all(8.0),
                                                child: 
                                               Image.network(
                                              '${controller.imageUrl!}?t=${DateTime.now().millisecondsSinceEpoch}', // keep your logic
                                              height: 160,
                                              width: 160,
                                              fit: BoxFit.contain,
                                            )
                                               
                                              )
                                            : const Column(
                                                mainAxisAlignment: MainAxisAlignment.center,
                                                children: [
                                                  Icon(Icons.add_a_photo,
                                                      size: 30, color: Colors.grey),
                                                  Text(
                                                    'You have not yet picked an image.',
                                                    textAlign: TextAlign.center,
                                                  ),
                                                ],
                                              ),
                                  ),
                                ),
                              );
                            },
                          ),
                          Row(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Icon(
                                Icons.error,
                                size: 20,
                                color: Colors.grey,
                              ),
                              Text(
                                'Note: *Image size should not be more than 4MB',
                                style: kTxtStl10N,
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.02),
                          Padding(
                            // padding: const EdgeInsets.only(left: 8),
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: InkWell(
                              child: Container(
                               // width: size.width * 0.07,
                               width: size.width * 0.25, // 
                                height: size.height * 0.05,
                                decoration: const BoxDecoration(
                                  border: Border(
                                    top: BorderSide(
                                      width: 3.0,
                                      color: Colors.grey,
                                    ),
                                    right: BorderSide(
                                      width: 3.0,
                                      color: Colors.grey,
                                    ),
                                    left: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey,
                                    ),
                                    bottom: BorderSide(
                                      width: 1.0,
                                      color: Colors.grey,
                                    ),
                                  ),
                                  color: Colors.white,
                                ),
                                child: Row(
                                   mainAxisSize: MainAxisSize.min, 
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    const Icon(
                                      Icons.upload_rounded,
                                      size: 20,
                                      color: Colors.grey,
                                    ),
                                    Flexible(child: Text('Upload', style: kTxtStl14N,)),
                                  ],
                                ),
                              ),
                              onTap: () {
                                controller.startWebFilePicker();
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
       
      ),
    );
  }
}