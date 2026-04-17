import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/image_list.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/buddy/visitAttendanceEntity.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/cold_visit/controller/clod_visit_create_controller.dart';
import 'package:sysconn_sfa/widgets/customautocompletefield.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';

class CreateColdVisit extends StatelessWidget {
  final VisitAttendanceEntity? visitAttendanceList;
  const CreateColdVisit({super.key, this.visitAttendanceList});

  @override
  Widget build(BuildContext context) {
    // final controller = Get.put(CreateColdVisitController());
    final controller = Get.put(
      CreateColdVisitController(visitAttendanceList: visitAttendanceList),
    );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(
        showDefaultActions: false,
        title: visitAttendanceList == null
            ? 'Create Cold Visit'
            : 'Update Cold Visit',
        actions: [
          visitAttendanceList != null
              ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Utility.showAlertYesNo(
                      iconData: Icons.help_outline_rounded,
                      iconcolor: Colors.blueAccent,
                      title: 'Alert',
                      msg: 'Do you want to delete this ?',
                      yesBtnFun: () {
                        controller.deleteHeaderDet().then((value) {
                          Get.back();
                        });
                      },
                      noBtnFun: () {
                        Get.back();
                      },
                    );
                  },
                )
              : Container(),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                padding: EdgeInsets.all(5),
                children: [
                  AbsorbPointer(
                    absorbing: controller.isInactive.value,
                    child: Column(
                      children: [
                        Card(
                          child: Column(
                            children: [
                              Row(
                                children: [
                                  IconButton(
                                    onPressed: () {
                                      Navigator.pop(context);
                                    },
                                    icon: Icon(
                                      Icons.arrow_back_ios_new_outlined,
                                      color: Colors.grey,
                                      size: 20.0,
                                    ),
                                  ),
                                  Expanded(
                                    child: TextFormField(
                                      textInputAction: TextInputAction.search,
                                      controller:
                                          controller.searchCustController,
                                      decoration: InputDecoration(
                                        border: InputBorder.none,
                                        hintText: 'Search Customer',
                                        hintStyle: kTxtStl13B,
                                      ),
                                      keyboardType: TextInputType.text,
                                      autofocus: true,
                                      enabled: true,
                                      onFieldSubmitted: (value) {
                                        controller.getSearchCustApi(
                                          controller.searchCustController.text,
                                        );
                                      },
                                      style: kTxtStl13N,
                                      onChanged: (value) {
                                        // setState(() {
                                        controller.isCustSearch.value =
                                            value != '' ? true : false;
                                        // });
                                      },
                                    ),
                                  ),
                                  Obx(
                                    () => controller.isCustSearch.value
                                        ? Row(
                                            mainAxisSize: MainAxisSize.min,
                                            children: [
                                              IconButton(
                                                onPressed: () {
                                                  controller
                                                          .searchCustController
                                                          .text =
                                                      '';
                                                  // isDataLoad = 2;
                                                  controller
                                                          .isCustSearch
                                                          .value =
                                                      false;
                                                  // setState(() {});
                                                },
                                                icon: Icon(
                                                  Icons.close,
                                                  size: 18,
                                                  color: Color.fromARGB(
                                                    255,
                                                    8,
                                                    5,
                                                    5,
                                                  ),
                                                ),
                                              ),
                                              IconButton(
                                                onPressed: () {
                                                  controller.getSearchCustApi(
                                                    controller
                                                        .searchCustController
                                                        .text,
                                                  );
                                                },
                                                icon: Icon(Icons.search),
                                              ),
                                            ],
                                          )
                                        : Container(
                                            child: Icon(
                                              Icons.search,
                                              color: Colors.grey,
                                            ),
                                          ),
                                  ),
                                ],
                              ),
                              Obx(
                                () => controller.isCustSearch.value
                                    ? SizedBox(
                                        height: 200,
                                        child: ListView.builder(
                                          itemCount:
                                              controller.custSearchList.length,
                                          itemBuilder: (context, i) {
                                            return InkWell(
                                              child: Padding(
                                                padding: const EdgeInsets.all(
                                                  8.0,
                                                ),
                                                child: Row(
                                                  children: [
                                                    Text(
                                                      controller
                                                          .custSearchList[i]
                                                          .partyname!,
                                                      style: kTxtStl13N,
                                                    ),
                                                    SizedBox(
                                                      width: 10,
                                                      child: Text('/ '),
                                                    ),
                                                    Text(
                                                      controller
                                                          .custSearchList[i]
                                                          .partymobileno!,
                                                      style: kTxtStl13N,
                                                    ),
                                                  ],
                                                ),
                                              ),
                                              onTap: () {
                                                final customer = controller
                                                    .custSearchList[i];

                                                controller.setSearchCustRows(
                                                  customer,
                                                );

                                                controller.searchCustController
                                                    .clear();
                                                controller.isCustSearch.value =
                                                    false;
                                                print(
                                                  controller.custSearchList[i]
                                                      .toJson(),
                                                );
                                                // controller
                                                //     .setSearchCustRows(
                                                //       controller
                                                //           .custSearchList[i],
                                                //     )
                                                //     .then((value) {
                                                //       controller
                                                //               .searchCustController
                                                //               .text =
                                                //           '';
                                                //       controller
                                                //               .isCustSearch
                                                //               .value =
                                                //           false;
                                                //     });
                                              },
                                            );
                                          },
                                        ),
                                      )
                                    : Container(),
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.02),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(FontAwesomeIcons.briefcase),
                              SizedBox(width: 10.0),
                              Text('Cold Visit', style: kTxtStlB),
                            ],
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CustomTextFormFieldView(
                                      controller:
                                          controller.customerNameController,
                                      title: 'Customer Name',
                                      isCompulsory: true,
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * 0.01),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.location_city),
                              SizedBox(width: 10.0),
                              Text('Address', style: kTxtStlB),
                            ],
                          ),
                        ),

                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CustomTextFormFieldView(
                                      controller: controller.addressController,
                                      title: 'Address1',
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * 0.01),

                                Row(
                                  children: [
                                    CustomTextFormFieldView(
                                      controller: controller.addressController2,
                                      title: 'Address2',
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * 0.01),
                                Row(
                                  children: [
                                    CustomTextFormFieldView(
                                      controller: controller.addressController3,
                                      title: 'Address3',
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * 0.01),
                                Row(
                                  children: [
                                    CustomTextFormFieldView(
                                      keyboardType: TextInputType.number,
                                      controller: controller.pincodeController,
                                      title: 'Pincode',
                                    ),
                                    SizedBox(width: size.width * 0.02),
                                    CustomTextFormFieldView(
                                      controller: controller.locationController,
                                      title: 'Location',
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * 0.01),
                                Row(
                                  children: [
                                   
                                    Obx(() {
                                      // reference dummy reactive variable to trigger rebuild
                                      controller.stateRebuild.value;

                                      return CustomAutoCompleteFieldView(
                                        optionsBuilder:
                                            (TextEditingValue value) {
                                              return Utility.stateDropdownlist
                                                  .where(
                                                    (e) => e
                                                        .toLowerCase()
                                                        .contains(
                                                          value.text
                                                              .toLowerCase(),
                                                        ),
                                                  )
                                                  .toList();
                                            },
                                        title: 'State',
                                        controllerValue:
                                            controller.stateController.text,
                                        isCompulsory: true,
                                        closeControllerFun: () {
                                          controller.stateController.clear();
                                          controller.stateRebuild.value++;
                                        },
                                        onSelected: (text) {
                                          controller.stateController.text =
                                              text;
                                          controller.stateRebuild.value++;
                                        },
                                      );
                                    }),
                                  ],
                                ),
                                  SizedBox(height: size.height * 0.01),
                                Row(
                                  children: [
                                    CustomTextFormFieldView(
                                      controller: controller.gstnoController,
                                      title: 'Gst no',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: Row(
                            children: [
                              Icon(Icons.contact_phone),
                              SizedBox(width: 10.0),
                              Text('Contact Details', style: kTxtStlB),
                            ],
                          ),
                        ),
                        Card(
                          child: Padding(
                            padding: const EdgeInsets.all(8.0),
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    CustomTextFormFieldView(
                                      controller:
                                          controller.conPersonController,
                                      title: 'Contact Person',
                                    ),
                                    SizedBox(width: size.width * 0.01),
                                    CustomTextFormFieldView(
                                      controller:
                                          controller.designationController,
                                      title: 'Designation',
                                    ),
                                  ],
                                ),
                                SizedBox(height: size.height * 0.01),
                                Row(
                                  children: [
                                    CustomTextFormFieldView(
                                      keyboardType: TextInputType.number,
                                      controller: controller.mobileNoController,
                                      title: 'Mobile No',
                                      isCompulsory: true,
                                      maxLength: 10,
                                    ),
                                  ],
                                ),
                                // SizedBox(height: size.height * 0.02),
                                Row(
                                  children: [
                                    CustomTextFormFieldView(
                                      keyboardType: TextInputType.emailAddress,
                                      controller: controller.emailController,
                                      title: 'Email Id',
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),

                        Card(
                          child: Row(
                            children: [
                              CustomTextFormFieldView(
                                controller: controller.remarkController,
                                title: 'Remark',
                              ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                      ],
                    ),
                  ),
                ],
              ),
            ),
            Obx(
              () => Container(
                padding: EdgeInsets.all(9.0),
                margin: EdgeInsets.all(4.0),
                decoration: BoxDecoration(
                  borderRadius: BorderRadius.circular(14.0),
                  color: Colors.white,
                  boxShadow: [
                    BoxShadow(
                      blurRadius: 1.0,
                      color: Colors.grey,
                      spreadRadius: 3.0,
                    ),
                  ],
                ),
                child: Column(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.center,
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        attendanceDataColmn(
                          'Check In',
                          controller.checkedInTime.value == ''
                              ? ''
                              : timeFormat(controller.checkedInTime.value),

                          context,
                        ),
                        InkWell(
                          child: CircleAvatar(
                            backgroundColor: controller.isLoggedIn.value
                                ? Colors.green[50]
                                : Colors.white,
                            radius: size.height * 0.04,
                            child: controller.isLoggedIn.value
                                ? Image(
                                    image: AssetImage(
                                      ImageList.endMeetingImage,
                                    ),
                                  )
                                : Image(
                                    image: AssetImage(
                                      ImageList.startmeetingImage,
                                    ),
                                  ),
                          ),
                          onTap: () async {
                            if (controller.isLoggedIn.value) {
                              Utility.showAlertYesNo(
                                iconData: Icons.error,
                                iconcolor: Colors.orange,
                                title: 'Alert',
                                msg: 'Are you sure? \n You want to logged out!',
                                yesBtnFun: () async {
                                  Utility.showCircularLoadingWid(context);
                                  await controller.checkColdVisitOutPostCall();
                                  Get.back();
                                },
                                noBtnFun: () {
                                  Get.back();
                                },
                              );
                            } else {
                              // Utility.showCircularLoadingWid(context);
                              await controller.checkColdVisitInPostCall();
                            }
                          },
                        ),
                        attendanceDataColmn(
                          'Check Out',
                          controller.checkedOutTime.value == ''
                              ? ''
                              : timeFormat(controller.checkedOutTime.value),
                          context,
                        ),
                      ],
                    ),
                    // Container(
                    //   child: Row(
                    //     children: [
                    //       Image.asset(
                    //         'assets/images/location.png',
                    //         height: size.height * 0.05,
                    //         width: size.width * 0.06,
                    //       ),
                    //       Expanded(
                    //         child: Column(
                    //           children: [
                    //             Text(
                    //               controller.currentAddress.value,
                    //               style: kTxtStl13N,
                    //             ),
                    //           ],
                    //         ),
                    //       ),
                    //     ],
                    //   ),
                    // ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Column attendanceDataColmn(String title, String time, BuildContext context) {
    return Column(
      children: [
        Text(title, style: kTxtStl12N),
        SizedBox(height: MediaQuery.of(context).size.height * 0.01),
        Text(time, style: kTxtStl13B),
      ],
    );
  }
}
