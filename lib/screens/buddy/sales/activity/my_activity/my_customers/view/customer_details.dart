import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/image_list.dart';
import 'package:sysconn_sfa/Utility/textFormField.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/customer_edit.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/customer_location_update.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/customer_overview.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/party_master_address.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/party_master_contact.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/price_list_rpt.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/reason_for_noOrder.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/sale_order/view/sale_order_report.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/outstanding/view/os_recpay_bill_details.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/screens/drawer/drawer_view.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/customer_details_controller.dart';
import 'package:url_launcher/url_launcher.dart';

class RetailerDetails extends StatelessWidget {
  final String? pARTYID,
      pARTYNAME,
      latitude,
      longitude,
      mobileNo,
      priceLevel,
      custclassfication;
  const RetailerDetails({
    super.key,
    this.pARTYID,
    this.custclassfication,
    this.latitude,
    this.longitude,
    this.mobileNo,
    this.pARTYNAME,
    this.priceLevel,
  });

  Widget editButton({
    required String title,
    required VoidCallback onPressed,
    Color backgroundColor = Colors.white,
    Color titleColor = Colors.black,
    Color borderColor = Colors.grey,
  }) {
    return Padding(
      padding: const EdgeInsets.all(4.0),
      child: ElevatedButton(
        style: ElevatedButton.styleFrom(
          backgroundColor: backgroundColor,
          foregroundColor: titleColor,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(20),
          ),
          side: BorderSide(color: borderColor, width: 2),
          elevation: 2,
        ),
        onPressed: onPressed,
        child: Text(
          title,
          style: TextStyle(
            fontSize: 13,
            fontWeight: FontWeight.bold,
            color: titleColor,
          ),
        ),
      ),
    );
  }

  Expanded retailerListTitleRow(String title, String value, {double? size}) {
    return Expanded(
      child: Row(
        children: [
          SizedBox(
            width: size,
            child: Text(title, style: kTxtStl11N),
          ),
          Text(': ', style: kTxtStl10N),
          Expanded(child: Text(value, style: kTxtStl10N)),
        ],
      ),
    );
  }

  Widget dashboardCardWidget({
    required BuildContext context,
    required String title,
    required String imagePath,
    required String firstLabel,
    required String firstValue,
    required String secondLabel,
    required String secondValue,
    VoidCallback? onTap,
  }) {
    final size = MediaQuery.of(context).size;

    return Expanded(
      child: InkWell(
        onTap: onTap,
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(9.0),
            side: const BorderSide(color: Colors.grey, width: 1.0),
          ),
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(title, style: kTxtStl15B),
                    Image.asset(
                      imagePath,
                      height: size.height * 0.05,
                      width: size.width * 0.15,
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  children: [
                    retailerListTitleRow(
                      firstLabel,
                      firstValue,
                      size: size.width * 0.23,
                    ),
                  ],
                ),
                Row(
                  children: [
                    retailerListTitleRow(
                      secondLabel,
                      secondValue,
                      size: size.width * 0.23,
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column attendanceDataColmn(String title, String time, BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      children: [
        Text(title, style: kTxtStl12N),
        SizedBox(height: size.height * 0.01),
        Text(time, style: kTxtStl13B),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // controller.getCustomerDetailsAPIDet(pARTYID!);
    final controller = Get.put(
      CustomerDetailsController(
        pARTYID: pARTYID,
        pARTYNAME: pARTYNAME,
        latitude: latitude,
        longitude: longitude,
        mobileNo: mobileNo,
        priceLevel: priceLevel,
        custclassfication: custclassfication,
      ),
    );
    return Scaffold(
      appBar: SfaCustomAppbar(
        title: 'Customer Details',
        showDefaultActions: false,
        actions: [
          IconButton(
            icon: Icon(Icons.call),
            onPressed: () async {
              if (await canLaunchUrl(Uri.parse('tel:+91$mobileNo'))) {
                await launchUrl(Uri.parse('tel:+91$mobileNo'));
              } else {
                throw 'Could not launch ${'tel:+91 $mobileNo'}';
              }
            },
          ),
        ],
      ),
      drawer: const DrawerForAll(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Obx(
          () => controller.isLoading.value
              ? const Center(child: CircularProgressIndicator())
              : Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.start,
                      children: [Text(pARTYNAME!, style: kTxtStlB)],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        editButton(
                          title: "Overview",
                          // // backgroundColor: kAppIconColor,
                          // titleColor: Colors.white,
                          // borderColor: kAppIconColor,
                          onPressed: () {
                            Get.to(
                              () => OverviewView(),
                              arguments:pARTYID,// controller.partyMasterEntityData,
                            ); //CustomerEdit(partyId: pARTYID));
                          },
                        ),
                        editButton(
                          title: 'Address',

                          titleColor: Colors.black,

                          onPressed: () async {
                            Get.to(
                              () => PartyMasterAddresses(),
                              // arguments: controller.partyMasterEntityData,
                            );
                          },
                        ),
                        editButton(
                          title: 'Contact',

                          titleColor: Colors.black,

                          onPressed: () async {
                            Get.to(() => PartyMasterContacts());
                          },
                        ),
                      ],
                    ),
                    SizedBox(height: size.height * 0.02),
                    Expanded(
                      //  height: size.height * 0.20,
                      child: Card(
                        elevation: 4.0,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12.0),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.all(12.0),
                          child: Column(
                            children: [
                              Row(
                                mainAxisAlignment: MainAxisAlignment.end,
                                children: [
                                  InkWell(
                                    child: Image.asset(
                                      ImageList.googleMapImage,
                                      height: size.height * 0.03,
                                      width: size.width * 0.1,
                                    ),
                                    onTap: () {
                                      Get.to(
                                        () => EditCustomerLocation(
                                          partyid: pARTYID,
                                          partyname: pARTYNAME,
                                          latitude: latitude,
                                          longitude: longitude,
                                          custclassfication: custclassfication,
                                        ),
                                      );
                                    },
                                  ),
                                ],
                              ),
                              Row(
                                crossAxisAlignment: CrossAxisAlignment.center,
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceEvenly,
                                children: [
                                  attendanceDataColmn(
                                    'Check In',
                                    controller.checkedInTime.value == ''
                                        ? ''
                                        : timeFormat(
                                            controller.checkedInTime.value,
                                          ),
                                    context,
                                  ),
                                  InkWell(
                                    child: CircleAvatar(
                                      radius: size.height * 0.06,
                                      // backgroundColor: isLoggedIn? Colors.green[50]: Colors.white,
                                      child: Image(
                                        image: controller.isLoggedIn.value
                                            ? AssetImage(
                                                ImageList.endMeetingImage,
                                              )
                                            : AssetImage(
                                                ImageList.startmeetingImage,
                                              ),
                                      ),
                                    ),
                                    onTap: () async {
                                      if (controller.isLoggedIn.value) {
                                        showBottomSheetVisit(size, controller);
                                      } else {
                                        // Utility.showCircularLoadingWid(context);
                                        await controller.checkInPostCall();
                                      }
                                    },
                                  ),
                                  attendanceDataColmn(
                                    'Check Out',
                                    controller.checkedOutTime.value == ''
                                        ? ''
                                        : timeFormat(
                                            controller.checkedOutTime.value,
                                          ),
                                    context,
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                    SizedBox(height: size.height * 0.02),
                    SizedBox(
                      height: size.height * 0.50,
                      child: Column(
                        children: [
                          Expanded(
                            child: Row(
                              children: [
                                // ✅ Lead Card
                                Expanded(
                                  child: InkWell(
                                    onTap: () {},
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          9.0,
                                        ),
                                        side: const BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text('Lead', style: kTxtStl15B),
                                                Image.asset(
                                                  ImageList.leadImage,
                                                  height: size.height * 0.05,
                                                  width: size.width * 0.15,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            size.width * 0.24,
                                                        child: Text(
                                                          'Pending Lead',
                                                          style: kTxtStl11N,
                                                        ),
                                                      ),
                                                      Text(
                                                        ': ',
                                                        style: kTxtStl10N,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          controller
                                                              .customerDetailsData[0]
                                                              .pENDINGLEAD!,
                                                          style: kTxtStl10N,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      SizedBox(
                                                        width:
                                                            size.width * 0.26,
                                                        child: Text(
                                                          'Pending Lead Amt',
                                                          style: kTxtStl11N,
                                                        ),
                                                      ),
                                                      Text(
                                                        ': ',
                                                        style: kTxtStl10N,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          controller
                                                              .customerDetailsData[0]
                                                              .pENDINGLEAD!
                                                              .toString(),
                                                          style: kTxtStl10N,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),
                                // dashboardCardWidget(
                                //   context: context,
                                //   title: 'Lead',
                                //   imagePath: ImageList.leadImage,
                                //   firstLabel: 'Pending Lead',
                                //   firstValue: controller
                                //       .customerDetailsData[0]
                                //       .pENDINGLEAD!, //'01',
                                //   secondLabel: 'Pending Lead Amt',
                                //   secondValue: controller
                                //       .customerDetailsData[0]
                                //       .pENDINGLEAD!.toString(),
                                //   onTap: () {},
                                // ),

                                // ✅ Order Card
                                dashboardCardWidget(
                                  context: context,
                                  title: 'Orders',
                                  imagePath: ImageList.orderImage,
                                  firstLabel: 'Last Order Amt',
                                  firstValue: controller
                                      .customerDetailsData[0]
                                      .pENDINGSOAMOUNT!
                                      .toString(),
                                  secondLabel: 'Last Order Date',
                                  secondValue: DateFormat('dd-MM-yyyy').format(
                                    DateTime.parse(
                                      controller
                                          .customerDetailsData[0]
                                          .lASTSODATE!
                                          .toString(),
                                    ),
                                  ),
                                  // controller.customerDetailsData[0].lASTSODATE!,
                                  onTap: () {
                                     Get.to(() => SalesOrderReport(partyId: pARTYID!,));//snehal 17-04-2025 add for party id 
                                  },
                                ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Expanded(
                            child: Row(
                              children: [
                                // ✅ Sales Card
                                dashboardCardWidget(
                                  context: context,
                                  title: 'Sales',
                                  imagePath: ImageList.salesAppclrImage,
                                  firstLabel: 'Last Sales Amt',
                                  firstValue:
                                      controller.customerDetailsData.isNotEmpty
                                      ? (controller
                                                    .customerDetailsData[0]
                                                    .lASTSALESAMT ??
                                                '0')
                                            .toString()
                                      : '0',
                                  // controller
                                  //     .customerDetailsData[0]
                                  //     .lASTSALESAMT!
                                  //     .toString(),
                                  secondLabel: 'Last Sales Date',
                                  secondValue:
                                      controller
                                              .customerDetailsData
                                              .isNotEmpty &&
                                          controller
                                                  .customerDetailsData[0]
                                                  .lASTSALESDATE !=
                                              null &&
                                          controller
                                                  .customerDetailsData[0]
                                                  .lASTSALESDATE !=
                                              ''
                                      ? DateFormat('dd-MM-yyyy').format(
                                          DateTime.parse(
                                            controller
                                                .customerDetailsData[0]
                                                .lASTSALESDATE!,
                                          ),
                                        )
                                      : '',
                                  //  DateFormat('dd-MM-yyyy').format(
                                  //   DateTime.parse(
                                  //     controller.customerDetailsData[0].lASTSALESDATE!
                                  //         .toString(),
                                  //   ),
                                  // ),
                                  // controller.customerDetailsData[0].lASTSALESDATE!,
                                  onTap: () {},
                                ),

                                // ✅ Collection Card
                                Expanded(
                                  child: InkWell(
                                    onTap: () {},
                                    child: Card(
                                      shape: RoundedRectangleBorder(
                                        borderRadius: BorderRadius.circular(
                                          9.0,
                                        ),
                                        side: const BorderSide(
                                          color: Colors.grey,
                                          width: 1.0,
                                        ),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Column(
                                          children: [
                                            Row(
                                              mainAxisAlignment:
                                                  MainAxisAlignment
                                                      .spaceBetween,
                                              children: [
                                                Text(
                                                  'Collection',
                                                  style: kTxtStl15B,
                                                ),
                                                Image.asset(
                                                  ImageList.collectionImage,
                                                  height: size.height * 0.05,
                                                  width: size.width * 0.15,
                                                ),
                                              ],
                                            ),
                                            SizedBox(
                                              height: size.height * 0.02,
                                            ),
                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        // width:  size.width * 0.25,
                                                        child: Text(
                                                          'Last Collection Amt',
                                                          style: kTxtStl11N,
                                                        ),
                                                      ),
                                                      Text(
                                                        ': ',
                                                        style: kTxtStl10N,
                                                      ),
                                                      Expanded(
                                                        child: Text(
                                                          controller
                                                              .customerDetailsData[0]
                                                              .lASTCOLLECTIONAMT!
                                                              .toString(),
                                                          style: kTxtStl10N,
                                                        ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),

                                            Row(
                                              children: [
                                                Expanded(
                                                  child: Row(
                                                    children: [
                                                      Container(
                                                        // width:  size.width * 0.24,
                                                        child: Text(
                                                          'Last Collection Date',
                                                          style: kTxtStl11N,
                                                        ),
                                                      ),
                                                      Text(
                                                        ': ',
                                                        style: kTxtStl10N,
                                                      ),
                                                      Expanded(
                                                        child:
                                                            controller
                                                                    .customerDetailsData[0]
                                                                    .lASTCOLLECTIONDATE ==
                                                                ''
                                                            ? Container()
                                                            : Text(
                                                                DateFormat(
                                                                  'dd-MM-yyyy',
                                                                ).format(
                                                                  DateTime.parse(
                                                                    controller
                                                                        .customerDetailsData[0]
                                                                        .lASTCOLLECTIONDATE
                                                                        .toString(),
                                                                  ),
                                                                ),
                                                                style:
                                                                    kTxtStl10N,
                                                              ),
                                                        //  Text(
                                                        //   controller
                                                        //       .customerDetailsData[0]
                                                        //       .lASTCOLLECTIONDATE!
                                                        //       ,
                                                        //   style: kTxtStl10N,
                                                        // ),
                                                      ),
                                                    ],
                                                  ),
                                                ),
                                              ],
                                            ),
                                          ],
                                        ),
                                      ),
                                    ),
                                  ),
                                ),

                                //     dashboardCardWidget(
                                //       context: context,
                                //       title: 'Collection',
                                //       imagePath: ImageList.orderImage,
                                //       firstLabel: 'Last Collection Amt',
                                //       firstValue: controller
                                //           .customerDetailsData[0]
                                //           .lASTCOLLECTIONAMT!
                                //           .toString(),
                                //       secondLabel: 'Last Collection Date',
                                //       secondValue: controller
                                //           .customerDetailsData[0]
                                //           .lASTCOLLECTIONDATE!,
                                //       onTap: () {},
                                //     ),
                              ],
                            ),
                          ),
                          SizedBox(height: size.height * 0.01),
                          Expanded(
                            child: Row(
                              children: [
                                // ✅ Outstanding Card
                                dashboardCardWidget(
                                  context: context,
                                  title: 'Outstanding',
                                  imagePath: ImageList.osFollowupImage,
                                  firstLabel: 'Total O/S Amt',
                                  firstValue: controller
                                      .customerDetailsData[0]
                                      .tOTALOSAMOUNT!
                                      .toString(),
                                  secondLabel: 'Due Bills Amt',
                                  secondValue: controller
                                      .customerDetailsData[0]
                                      .tOTALOSDUEAMOUNT!
                                      .toString(),
                                  onTap: () {
                                    if (controller.visitid.value == '') {
                                      scaffoldMessageValidationBar(
                                        context,
                                        'Start visit first.',
                                      );
                                    } else {
                                      Get.to(
                                        () => OutstandingRecPayBillDetails(
                                          partyId: pARTYID,
                                          partyName: pARTYNAME,
                                          osAgeBySelectedFilter: 'Due Date',
                                        ),
                                      );
                                    }
                                  },
                                ),

                                // ✅ Task Card
                                dashboardCardWidget(
                                  context: context,
                                  title: 'Task',
                                  imagePath: ImageList.taskImage,
                                  firstLabel: 'No of Task',
                                  firstValue: '0',
                                  secondLabel: 'Last Task Date',
                                  secondValue: '1111',
                                  onTap: () {},
                                ),
                              ],
                            ),
                          ),
                        ],
                      ),
                    ),
                    SizedBox(height: size.height * 0.01),
                  ],
                ),
        ),
      ),
    );
  }

  void showBottomSheetVisit(Size size, CustomerDetailsController controller) {
    Get.bottomSheet(
      Container(
        color: Colors.white,
        child: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(8.0),
            child: Column(
              children: <Widget>[
                SizedBox(height: size.height * 0.01),
                Container(
                  padding: EdgeInsets.all(size.height * 0.01),
                  width: size.width,
                  decoration: BoxDecoration(color: Colors.orangeAccent),
                  child: Text(
                    'Customer Details',
                    style: kTxtStlB,
                    textAlign: TextAlign.center,
                  ),
                ),
                SizedBox(height: size.height * 0.02),
                Row(
                  children: [
                    CustomTextFormFieldView(
                      controller: controller.designationController,
                      title: 'Designation',
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),
                Row(
                  children: [
                    CustomTextFormFieldView(
                      controller: controller.conpersonController,
                      title: 'Contact Person',
                      keyboardType: TextInputType.text,
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.01),
                Row(
                  children: [
                    CustomTextFormFieldView(
                      controller: controller.mobileNoController,
                      title: 'Mobile No.',
                      keyboardType: TextInputType.number,
                    ),
                  ],
                ),
                SizedBox(height: size.height * 0.01),

                Row(
                  children: [
                    CustomTextFormFieldView(
                      controller: controller.remarkController,
                      title: 'Remark',
                      keyboardType: TextInputType.text,
                      maxLength: 500,
                    ),
                  ],
                ),

                SizedBox(height: size.height * 0.01),
                ResponsiveButton(
                  title: 'Check Out',
                  function: () async {
                    Get.back();
                    Utility.showAlertYesNo(
                      iconData: Icons.error,
                      iconcolor: Colors.orange,
                      title: 'Alert',
                      msg: 'Are you sure? \n You want to logged out!',
                      yesBtnFun: () async {
                        // Utility.showCircularLoadingWid(context);
                        await controller.checkOutPostCall().then((value) {
                          // Navigator.of(context).pop();
                          Get.back(
                            result: true,
                          ); // set value as true to refresh prev page only if this page is saved
                        });
                      },
                      noBtnFun: () {
                        Get.back();
                      },
                    );
                  },
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
