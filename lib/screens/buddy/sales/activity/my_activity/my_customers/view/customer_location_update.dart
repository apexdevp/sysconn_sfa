import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/edit_customer_location_controler.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/customer_location.dart';
import 'package:sysconn_sfa/screens/drawer/drawer_view.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class EditCustomerLocation extends StatelessWidget {
  final String? partyid;
  final String? partyname;
  final String? latitude;
  final String? longitude;
  final String? custclassfication;
  const EditCustomerLocation({
    super.key,
    this.partyid,
    this.partyname,
    this.latitude,
    this.longitude,
    this.custclassfication,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      EditCustomerController(
        partyid: partyid,
        partyname: partyname,
        latitudeOld: latitude,
        longitudeOld: longitude,
        custclassfication: custclassfication,
      ),
    );

    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Edit Customer Location'),
      drawer: const DrawerForAll(),
      body: Obx(() {
        if (!controller.isDataLoad.value) {
          return Center(child: CircularProgressIndicator());
        }
        return Padding(
          padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
          child: Column(
            children: [
              Container(
                width: size.width,
                padding: EdgeInsets.all(8.0),
                decoration: BoxDecoration(color: Colors.grey.shade300),
                child: Text(
                  partyname!,
                  style: kTxtStlB,
                  textAlign: TextAlign.center,
                ),
              ),
              SizedBox(height: size.height * 0.04),
              Card(
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(15.0),
                ),
                child: Padding(
                  padding: const EdgeInsets.all(14.0),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text(
                            "Company Address",
                            style: kTxtStl13B,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/location.png',
                            height: size.height * 0.1,
                            width: size.width * 0.1,
                          ),
                          SizedBox(width: size.width * 0.02),
                          Expanded(
                            child: Obx(
                              () => SelectableText(
                               '${controller.partyEntity.value.city!} ${controller.partyEntity.value.address1!} ${controller.partyEntity.value.address2!}',
                                style: kTxtStl13N,
                              ),
                            ),
                            //  SelectableText('${controller.partyEntity.city!}',style: kTxtStl13N),    // komal // 2025-07-19 // text should be selectable
                            // SelectableText('${controller.partyEntity.address!} ${partyEntity.address2!} ${partyEntity.address3!}',style: kTxtStl13N),    // komal // 2025-07-19 // text should be selectable
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),
                      Row(
                        children: [
                          Text(
                            "Geo Location Details",
                            style: kTxtStl13B,
                            textAlign: TextAlign.start,
                          ),
                        ],
                      ),
                      Row(
                        children: [
                          Image.asset(
                            'assets/images/location.png',
                            height: size.height * 0.1,
                            width: size.width * 0.1,
                          ),
                          SizedBox(width: size.width * 0.02),
                          Expanded(
                            child: Column(
                              children: [
                                Text(
                                  '${controller.currentAddress}',
                                  style: kTxtStl13N,
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                      Container(
                        width: size.width * 0.33,
                        height: size.height * 0.06,
                        decoration: BoxDecoration(
                          color: Colors.lightBlue[50],
                          border: Border.all(color: Colors.black),
                          borderRadius: BorderRadius.circular(18.0),
                        ),
                        child: InkWell(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [Text('See On Map', style: kTxtStl13B)],
                          ),
                          onTap: () {
                            Get.to(
                              () => GetCurrentLocation(
                                latitude: controller
                                    .currentPosition
                                    .value
                                    .latitude
                                    .toString(),
                                longitude: controller
                                    .currentPosition
                                    .value
                                    .longitude
                                    .toString(),
                                partyname: partyname,
                                custclassfication: custclassfication,
                              ),
                            );
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              SizedBox(height: size.height * 0.04),
              InkWell(
                child: Container(
                  height: size.height * 0.30,
                  width: size.width * 0.85,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14.0),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black26,
                        offset: const Offset(0.0, 0.0),
                        blurRadius: 3.0,
                        spreadRadius: 1.0,
                      ),
                      BoxShadow(
                        color: Colors.white,
                        offset: const Offset(0.0, 0.0),
                        spreadRadius: 0.0,
                      ),
                    ],
                  ),
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Image.asset(
                        'assets/images/google-maps.png',
                        width: size.width * 0.60,
                        height: size.height * 0.20,
                      ),
                      SizedBox(height: size.height * 0.03),
                      Container(
                        child: Text('Update Current Location', style: kTxtStlB),
                      ),
                    ],
                  ),
                ),
                onTap: () {
                  // if (latitude != "" &&
                  //     latitude != null &&
                  //     longitude != "" &&
                  //     longitude != null) {
                  //   showDialog(
                  //     context: context,
                  //     builder: (BuildContext context) {
                  //       return Center(child: CircularProgressIndicator());
                  //     },
                  //   );
                  //   //  if (latitude != "" && longitude != "")
                  //   if (controller.latitude.value.isNotEmpty &&
                  //       controller.longitude.value.isNotEmpty) {
                  //     Utility.showAlertYesNo(
                  //       iconData: Icons.check_circle_outline,
                  //       iconcolor: Colors.blueAccent,
                  //       title: 'Alert',
                  //       msg: 'Are you sure? \n You want to update location?',
                  //       yesBtnFun: () {
                  //         controller.editCustomerPostCall();
                  //       },
                  //       noBtnFun: () {
                  //         Navigator.of(context).pop();
                  //         Navigator.of(context).pop();
                  //       },
                  //     );
                  //   } else {
                  //     controller.editCustomerPostCall();
                  //   }
                  // } else {
                  //   scaffoldMessageValidationBar(
                  //     Get.context!,
                  //     'Kindly select location',
                  //   );
                  // }

                  if (controller.latitude.value.isNotEmpty &&
                      controller.longitude.value.isNotEmpty) {
                    Utility.showAlertYesNo(
                      iconData: Icons.check_circle_outline,
                      iconcolor: Colors.blueAccent,
                      title: 'Alert',
                      msg: 'Are you sure?\nYou want to update location?',
                      yesBtnFun: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return const Center(
                              child: CircularProgressIndicator(),
                            );
                          },
                        );

                        controller.editCustomerPostCall();
                      },
                      noBtnFun: () {
                        Get.back();
                      },
                    );
                  } else {
                    scaffoldMessageValidationBar(
                      Get.context!,
                      'Kindly select location',
                    );
                  }
                },
              ),

              SizedBox(height: size.height * 0.04),
            ],
          ),
        );
      }),
    );
  }
}
