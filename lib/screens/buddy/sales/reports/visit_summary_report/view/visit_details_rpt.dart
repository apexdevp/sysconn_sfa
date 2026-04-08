import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/buddy/visitAttendanceEntity.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/visit_summary_report/controller/visit_attendance_det_controller.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class VisitAttendanceDetRpt extends StatelessWidget {
  final String name;
  final DateTime fromdate;
  final DateTime todate;
  final String? mobileno;
  final String existvalue;
  VisitAttendanceDetRpt({
    super.key,
    required this.name,
    required this.existvalue,
    required this.fromdate,
    this.mobileno,
    required this.todate,
  });
  // final controller = Get.put(VisitAttendanceDetRptController());
  Row attendanceDetailsTitleRow(
    String title1,
    String value1,
    Size size,
    String title2,
    String value2,
  ) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Flexible(
          child: Row(
            children: [
              Container(
                width: size.width * 0.1,
                child: Text(title1, style: kTxtStl13GreyN),
              ),
              Text(': ', style: kTxtStl13GreyN),
              Flexible(
                child: Column(children: [Text(value1, style: kTxtStl13GreyN)]),
              ),
            ],
          ),
        ),
        title2 != ''
            ? Flexible(
                child: Row(
                  children: [
                    Container(
                      width: size.width * 0.1,
                      child: Text(title2, style: kTxtStl13GreyN),
                    ),
                    Text(': ', style: kTxtStl13GreyN),
                    Flexible(child: Text(value2, style: kTxtStl13GreyN)),
                  ],
                ),
              )
            : Container(),
      ],
    );
  }

  Card visitCard(VisitAttendanceEntity visitAttendanceEntity) {
    Size size = MediaQuery.of(Get.context!).size;
    TextStyle textStyle14B = TextStyle(
      fontSize: 14.0,
      fontWeight: FontWeight.w600,
      color: Colors.cyan,
    );
    return Card(
      child: Padding(
        padding: EdgeInsets.all(size.height * 0.01),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(
                  Icons.circle,
                  color: visitAttendanceEntity.customertype! == 'Existing'
                      ? Colors.amber[100]
                      : Colors.green[100],
                  size: size.width * 0.04,
                ),
                SizedBox(width: 2.0),
                Flexible(
                  fit: FlexFit.tight,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(visitAttendanceEntity.partyname!, style: kTxtStl13B),
                    ],
                  ),
                ),
                visitAttendanceEntity.date ==
                        DateFormat('yyyy-MM-dd').format(DateTime.now())
                    ? SizedBox(
                        height: 20,
                        width: 40,
                        child: IconButton(
                          onPressed: () {
                            Utility.showAlertYesNo(
                              iconData: Icons.check_circle_outline,
                              iconcolor: Colors.blueAccent,
                              title: 'Alert',
                              msg: 'Do you want to delete this Visit',
                              yesBtnFun: () {
                                // deleteVisitDetails(visitAttendanceEntity.visitId!);
                              },
                              noBtnFun: () {
                                Get.back();
                              },
                            );
                          },
                          icon: Icon(
                            Icons.delete_forever,
                            color: Colors.red,
                            size: 24,
                          ),
                        ),
                      )
                    : Container(),
              ],
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: visitAttendanceEntity.customertype == 'Existing'
                  ? Row(
                      children: [
                        Icon(
                          visitAttendanceEntity.locationUpdate == 'Yes'
                              ? Icons.location_on_rounded
                              : Icons.location_off_rounded,
                          color: visitAttendanceEntity.locationUpdate == 'Yes'
                              ? Colors.red
                              : Colors.red[100],
                          size: size.width * 0.05,
                        ),

                        Icon(
                          visitAttendanceEntity.verifiedMobNo == 'Yes'
                              ? Icons.verified_rounded
                              : null,
                          color: Colors.green[300],
                          size: size.width * 0.05,
                        ),
                      ],
                    )
                  : Container(),
            ),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: size.width * 0.2,
                  child: Column(
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.watch_later_outlined,
                            size: size.height * 0.02,
                            color: Theme.of(Get.context!).colorScheme.secondary,
                          ),
                          SizedBox(width: 2.0),
                          // Text(
                          //   visitAttendanceEntity.totalhrs! == '' ||
                          //           visitAttendanceEntity.totalhrs!.contains(
                          //             '*',
                          //           )
                          //       ? ''
                          //       : DateFormat.Hm().format(
                          //           DateFormat(
                          //             "hh:mm",
                          //           ).parse(visitAttendanceEntity.totalhrs!),
                          //         ),
                          //   style: textStyle14B,
                          // ),
                        ],
                      ),
                      Text(
                        visitAttendanceEntity.checkintime! == ''
                            ? ''
                            : timeFormat(visitAttendanceEntity.checkintime!),
                        style: textStyle14B,
                      ),
                      Text(
                        visitAttendanceEntity.checkouttime! == ''
                            ? ''
                            : timeFormat(visitAttendanceEntity.checkouttime!),
                        style: textStyle14B,
                      ),
                    ],
                  ),
                ),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      visitAttendanceEntity.customertype == 'Existing'
                          ? attendanceDetailsTitleRow(
                              'Route',
                              visitAttendanceEntity.route?? '',
                              size,
                              'Area',
                              visitAttendanceEntity.area!,
                            )
                          : attendanceDetailsTitleRow(
                              'Mob',
                              visitAttendanceEntity.partymobileno!,
                              size,
                              '',
                              '',
                            ),
                      Text(
                        visitAttendanceEntity.checkinlocation!,
                        style: kTxtStl12GreyN,
                      ),
                      Text(
                        visitAttendanceEntity.checkoutlocation!,
                        style: kTxtStl12GreyN,
                      ),
                      SizedBox(height: 2.0),
                    ],
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),

            visitDetailsTable(visitAttendanceEntity),
            SizedBox(height: size.height * 0.01),
            visitAttendanceEntity.customertype == 'Existing' &&
                    visitAttendanceEntity.reason != ''
                ? Row(
                    children: [
                      Text('Reason (No order) :', style: kTxtStl12GreyN),
                      Flexible(
                        child: Column(
                          children: [
                            Text(
                              visitAttendanceEntity.reason!,
                              style: kTxtStl12GreyN,
                            ),
                          ],
                        ),
                      ),
                    ],
                  )
                : Container(),
            SizedBox(height: size.height * 0.01),
            Row(
              children: [
                Text('Remark :', style: kTxtStl12GreyN),
                Flexible(
                  child: Column(
                    children: [
                      Text(
                        visitAttendanceEntity.remark!,
                        style: kTxtStl12GreyN,
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Container visitDetailsTable(VisitAttendanceEntity visitAttendanceEntity) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.grey[50],
        border: Border.all(width: 0.5),
      ),
      child: Column(
        children: [
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(child: Text('')),
                VerticalDivider(width: 1.0, color: Colors.grey),
                Expanded(
                  child: Text(
                    'Lead',
                    style: kTxtStl13GreyN,
                    textAlign: TextAlign.center,
                  ),
                ),
                visitAttendanceEntity.customertype == 'Existing'
                    ? VerticalDivider(width: 1.0, color: Colors.grey)
                    : Container(),
                visitAttendanceEntity.customertype == 'Existing'
                    ? Expanded(
                        child: Text(
                          'SO',
                          style: kTxtStl13GreyN,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(),
                visitAttendanceEntity.customertype == 'Existing'
                    ? VerticalDivider(width: 1.0, color: Colors.grey)
                    : Container(),
                visitAttendanceEntity.customertype == 'Existing'
                    ? Expanded(
                        child: Text(
                          'DC',
                          style: kTxtStl13GreyN,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(),
                visitAttendanceEntity.customertype == 'Existing'
                    ? VerticalDivider(width: 1.0, color: Colors.grey)
                    : Container(),
                visitAttendanceEntity.customertype == 'Existing'
                    ? Expanded(
                        child: Text(
                          'Sales',
                          style: kTxtStl13GreyN,
                          textAlign: TextAlign.center,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Divider(height: 1.0),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Qty',
                    style: kTxtStl13GreyN,
                    textAlign: TextAlign.center,
                  ),
                ),
                VerticalDivider(width: 1.0, color: Colors.grey),
                Expanded(
                  child: Text(
                    visitAttendanceEntity.leadQty!,
                    style: kTxtStl13GreyN,
                    textAlign: TextAlign.right,
                  ),
                ),
                visitAttendanceEntity.customertype == 'Existing'
                    ? VerticalDivider(width: 1.0, color: Colors.grey)
                    : Container(),
                visitAttendanceEntity.customertype == 'Existing'
                    ? Expanded(
                        child: Text(
                          visitAttendanceEntity.soQty!,
                          style: kTxtStl13GreyN,
                          textAlign: TextAlign.right,
                        ),
                      )
                    : Container(),
                visitAttendanceEntity.customertype == 'Existing'
                    ? VerticalDivider(width: 1.0, color: Colors.grey)
                    : Container(),
                visitAttendanceEntity.customertype == 'Existing'
                    ? Expanded(
                        child: Text(
                          visitAttendanceEntity.dcQty!,
                          style: kTxtStl13GreyN,
                          textAlign: TextAlign.right,
                        ),
                      )
                    : Container(),
                visitAttendanceEntity.customertype == 'Existing'
                    ? VerticalDivider(width: 1.0, color: Colors.grey)
                    : Container(),
                visitAttendanceEntity.customertype == 'Existing'
                    ? Expanded(
                        child: Text(
                          visitAttendanceEntity.salesQty!,
                          style: kTxtStl13GreyN,
                          textAlign: TextAlign.right,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
          Divider(height: 1.0),
          IntrinsicHeight(
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Expanded(
                  child: Text(
                    'Value (₹)',
                    style: kTxtStl13GreyN,
                    textAlign: TextAlign.center,
                  ),
                ),
                VerticalDivider(width: 1.0, color: Colors.grey),
                Expanded(
                  child: Text(
                    visitAttendanceEntity.leadValue!,
                    style: kTxtStl13GreyN,
                    textAlign: TextAlign.right,
                  ),
                ),
                visitAttendanceEntity.customertype == 'Existing'
                    ? VerticalDivider(width: 1.0, color: Colors.grey)
                    : Container(),
                visitAttendanceEntity.customertype == 'Existing'
                    ? Expanded(
                        child: Text(
                          visitAttendanceEntity.soValue!,
                          style: kTxtStl13GreyN,
                          textAlign: TextAlign.right,
                        ),
                      )
                    : Container(),
                visitAttendanceEntity.customertype == 'Existing'
                    ? VerticalDivider(width: 1.0, color: Colors.grey)
                    : Container(),
                visitAttendanceEntity.customertype == 'Existing'
                    ? Expanded(
                        child: Text(
                          visitAttendanceEntity.dcValue!,
                          style: kTxtStl13GreyN,
                          textAlign: TextAlign.right,
                        ),
                      )
                    : Container(),
                visitAttendanceEntity.customertype == 'Existing'
                    ? VerticalDivider(width: 1.0, color: Colors.grey)
                    : Container(),
                visitAttendanceEntity.customertype == 'Existing'
                    ? Expanded(
                        child: Text(
                          visitAttendanceEntity.salesValue!,
                          style: kTxtStl13GreyN,
                          textAlign: TextAlign.right,
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final controller = Get.put(VisitAttendanceDetRptController());

if (controller.attendanceDetailsList.isEmpty) {
  controller.initData(
    from: fromdate,
    to: todate,
    mobile: mobileno,
    filter: existvalue,
  );
}
    return Scaffold(
      appBar: SfaCustomAppbar(
        title: 'Visit Attendance Details',
        showDefaultActions: false,
        actions: [
          PopupMenuButton<String>(
            itemBuilder: (context) {
              return controller.popupMenuItem.map((String popupMenuValue) {
                return PopupMenuItem(
                  padding: EdgeInsets.all(3.0),
                  value: popupMenuValue,
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      Icon(
                        Icons.circle,
                        color:
                            controller.popupMenuSelected.value == popupMenuValue
                            ? Colors.green
                            : Colors.white,
                      ),
                      Text(popupMenuValue),
                    ],
                  ),
                );
              }).toList();
            },
            onSelected: (String popupMenuValueSelected) {
              controller.popupMenuSelected.value = popupMenuValueSelected;

              controller.attendanceDetailsDataAPI();
            },
          ),
        ],
      ),
      body: Column(
        children: [
          Container(
            padding: EdgeInsets.all(14.0),
            width: size.width,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(40.0),
              //   topRight: Radius.circular(40.0),
              // ),
              color: Colors.orange.shade50,
            ),
            child: Text(
              '${name} ' +
                  '(${DateFormat('dd-MM-yyyy').format(DateTime.parse(fromdate.toString())).toString()})',
              textAlign: TextAlign.center,
              style: kTxtStlB,
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isDataLoad.value == 0) {
                return Center(
                  child: Platform.isIOS
                      ? CupertinoActivityIndicator()
                      : CircularProgressIndicator(),
                );
              }

              if (controller.isDataLoad.value == 2) {
                return Center(child: NoDataFound());
              }
              return ListView.builder(
                itemCount: controller.attendanceDetailsList.isEmpty
                    ? 0
                    : controller.attendanceDetailsList.length,
                itemBuilder: (context, i) {
                  return visitCard(controller.attendanceDetailsList[i]);
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
