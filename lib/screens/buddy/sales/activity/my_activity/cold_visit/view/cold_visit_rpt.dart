import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/date_calendar.dart';
import 'package:sysconn_sfa/Utility/floating_point_action_button.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/cold_visit/view/cold_visit_create.dart';
import 'package:sysconn_sfa/screens/drawer/drawer_view.dart';
import 'package:sysconn_sfa/widgets/calendarsingleview.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

import '../controller/cold_visit_rpt_controller.dart';

class ColdVisitReport extends StatelessWidget {
  ColdVisitReport({super.key});
  final controller = Get.put(ColdVisitReportController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(
        title: 'Cold Visit Report',
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(
                    () => CalendarSingleView(
                      fromDate: controller.fromDate.value,
                      toDate: controller.toDate.value,
                      function: () async {
                        await selectDateRange(
                          controller.fromDate.value,
                          controller.toDate.value,
                        ).then((dateTimeRange) {
                          controller.fromDate.value = dateTimeRange.start;
                          controller.toDate.value = dateTimeRange.end;
                          controller.getVisitDataApi();
                        });
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),
            ],
          ),
        ),
      ),
      drawer: const DrawerForAll(),
      // floatingActionButton: controller.isDataLoad.value == 0
      //     ? null
      //     : FloatingButton(
      //         title: 'Create Cold Visit',
      //         icon: Icon(Icons.add_home_work),
      //         function: () async {
      //           controller.getVisitDataApi();
      //           Get.to(() => CreateColdVisit());
      //         },
      //       ),
      floatingActionButton: Obx(() {
        if (controller.isDataLoad.value == 0) {
          return SizedBox.shrink(); // ✅ instead of null
        }

        return FloatingButton(
          title: 'Create Cold Visit',
          icon: Icon(Icons.add_home_work),
          function: () async {
            await Get.to(() => CreateColdVisit());
            controller.getVisitDataApi();
          },
        );
      }),
      body: Column(
        children: [
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
                itemCount: controller.visitDetailsList.isEmpty
                    ? 0
                    : controller.visitDetailsList.length,
                itemBuilder: (context, i) {
                  final item = controller.visitDetailsList[i];
                  return InkWell(
                    child: Card(
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          children: [
                            DateCalendar(date: item.date!),
                            SizedBox(width: size.width * 0.02),
                            Expanded(
                              child: Column(
                                mainAxisAlignment: MainAxisAlignment.start,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(item.partyname!, style: kTxtStl13B),
                                  SizedBox(height: size.height * 0.01),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.25,
                                        child: Text(
                                          'Check In',
                                          style: kTxtStl13GreyN,
                                        ),
                                      ),
                                      Text(': ', style: kTxtStl13GreyN),
                                      Expanded(
                                        child: Text(
                                          item.checkintime! != ''
                                              ? item.checkintime!.substring(
                                                  0,
                                                  5,
                                                )
                                              : '',
                                          style: kTxtStl13GreyN,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      SizedBox(
                                        width: size.width * 0.25,
                                        child: Text(
                                          'Check Out',
                                          style: kTxtStl13GreyN,
                                        ),
                                      ),
                                      Text(': ', style: kTxtStl13GreyN),
                                      Expanded(
                                        child: Text(
                                          item.checkouttime! != ''
                                              ? item.checkouttime!.substring(
                                                  0,
                                                  5,
                                                )
                                              : '',
                                          style: kTxtStl13GreyN,
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                            SizedBox(width: size.width * 0.01),

                            Column(
                              children: [
                                IconButton(
                                  onPressed: () {
                                    Utility.showAlertYesNo(
                                      iconData: Icons.check_circle_outline,
                                      iconcolor: Colors.blueAccent,
                                      title: 'Alert',
                                      msg: 'Do you want to delete this Visit',
                                      yesBtnFun: () {
                                        controller.deleteVisitDet(
                                          item.visitId!,
                                        );
                                      },
                                      noBtnFun: () {
                                        Navigator.of(context).pop();
                                      },
                                    );
                                  },
                                  icon: Icon(
                                    Icons.delete_forever,
                                    color: Colors.red,
                                    size: 19,
                                  ),
                                ),
                                Container(
                                  padding: EdgeInsets.all(8.0),
                                  width: 90,
                                  decoration: BoxDecoration(
                                    borderRadius: BorderRadius.circular(30.0),
                                    color: item.status == 'Close'
                                        ? Colors.green[50]
                                        : Colors.red[50],
                                  ),
                                  child: Text(
                                    item.status.toString(),
                                    style: TextStyle(
                                      fontSize: 12,
                                      fontWeight: FontWeight.w600,
                                      color: item.status == 'Close'
                                          ? Colors.green
                                          : Colors.red,
                                    ),
                                    textAlign: TextAlign.center,
                                  ),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () async {
                      print('visitDetailsList[i] $item');
                      await Navigator.of(context).push(
                        MaterialPageRoute(
                          builder: (context) =>
                              CreateColdVisit(visitAttendanceList: item),
                        ),
                      );
                      controller.getVisitDataApi();
                    },
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
