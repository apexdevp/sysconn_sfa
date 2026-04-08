import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/date_calendar.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/visit_summary_report/view/visit_details_rpt.dart';
import 'package:sysconn_sfa/widgets/calendarsingleview.dart';
import 'package:sysconn_sfa/widgets/customautocompletefield.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

import '../controller/visit_summary_controller.dart';

class VisitAttendanceSumRpt extends StatelessWidget {
  const VisitAttendanceSumRpt({super.key});
  Expanded visitSummaryView(
    Size size,
    String title1,
    String title2,
    int value1,
    String title3,
    int value2,
  ) {
    return Expanded(
      child: Row(
        children: [
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title1, style: kTxtStl12GreyB),
                Container(
                  alignment: Alignment.center,
                  height: size.height * 0.04,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    border: Border.all(width: 1),
                    color: Colors.blue[50],
                  ),
                  child: Text((value1 + value2).toString(), style: kTxtStl12N),
                ),
              ],
            ),
          ),
          SizedBox(width: size.width * 0.02),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title2, style: kTxtStl13GreyB),
                Container(
                  alignment: Alignment.center,
                  height: size.height * 0.04,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.amber[50],
                  ),
                  child: Text(
                    value1.toString(),
                    style: kTxtStl12N,
                    textAlign: TextAlign.center,
                  ),
                ),
              ],
            ),
          ),
          SizedBox(width: size.width * 0.02),
          Expanded(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Text(title3, style: kTxtStl12GreyB),
                Container(
                  alignment: Alignment.center,
                  height: size.height * 0.04,
                  decoration: BoxDecoration(
                    border: Border.all(),
                    borderRadius: BorderRadius.circular(8.0),
                    color: Colors.green[50],
                  ),
                  child: Text(
                    value2.toString(),
                    style: kTxtStl13N,
                    textAlign: TextAlign.center,
                  ),
                ),
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
    final controller = Get.put(VisitAttendanceSumController());
    return Scaffold(
      appBar: SfaCustomAppbar(
        title: 'Visit Attendance Summary Report',
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Obx(
                    () => CalendarSingleView(
                      fromDate: controller.fromdate.value,
                      toDate: controller.todate.value,
                      function: () async {
                        await selectDateRange(
                          controller.fromdate.value,
                          controller.todate.value,
                        ).then((dateTimeRange) {
                          controller.fromdate.value = dateTimeRange.start;
                          controller.todate.value = dateTimeRange.end;
                        });
                        controller.getVisitAttendanceSummaryReportDataAPI();
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
      bottomNavigationBar: Obx(() {
        return Container(
          padding: EdgeInsets.all(size.width * 0.02),
          margin: EdgeInsets.only(left: 3, right: 3),
          decoration: BoxDecoration(
            color: Theme.of(context).colorScheme.secondary,
            borderRadius: BorderRadius.only(
              topLeft: Radius.circular(14.0),
              topRight: Radius.circular(14.0),
            ),
            border: Border.all(color: Theme.of(context).colorScheme.secondary),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: size.width * 0.2,
                child: Text(
                  'Total',
                  style: kTxtStl13B,
                  textAlign: TextAlign.center,
                ),
              ),

              controller.salesPersonNameSelected.value != ''
                  ? IconButton(
                      onPressed: () {
                        // Navigator.of(context).push(
                        //   MaterialPageRoute(
                        //     builder: (context) => VisitAttendanceDetRpt(
                        //       name: controller.salesPersonNameSelected.value,
                        //       fromdate: controller.fromdate.value,
                        //       todate: controller.todate.value,
                        //       mobileno:
                        //           controller.salesPersonMobileSelected.value,
                        //       existvalue: 'ALL',
                        //     ),
                        //   ),
                        // );

                             Get.to(() => VisitAttendanceDetRpt(
                    name: controller.salesPersonNameSelected.value,
                    fromdate: controller.fromdate.value,
                    todate: controller.todate.value,
                    mobileno:  controller.salesPersonMobileSelected.value,
                    existvalue: 'ALL',
                  ));
                       
                      },
                      icon: Icon(Icons.arrow_forward_ios, color: Colors.white),
                    )
                  : SizedBox(width: size.width * 0.01),
              visitSummaryView(
                size,
                '',
                '',
                controller.existingVisitTotal.value,
                '',
                controller.coldVisitTotal.value,
              ),
            ],
          ),
        );
      }),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(6.0),
            child: Row(
              children: [
                Obx(
                  () => CustomAutoCompleteFieldView(
                    optionsBuilder: (TextEditingValue value) {
                      return controller.salesPersonItem
                          .where(
                            (element) => element.username!
                                .toLowerCase()
                                .contains(value.text.toLowerCase()),
                          )
                          .toList();
                    },
                    displayStringForOption: (displayString) {
                      return displayString.username!;
                    },
                    title: 'Sales Person',
                    controllerValue: controller.salesPersonNameSelected.value,
                    closeControllerFun: () {
                      controller.salesPersonNameSelected.value = '';
                      controller.salesPersonMobileSelected.value =
                          Utility.cmpusertype.toUpperCase() == 'ADMIN' ||
                              Utility.cmpusertype.toUpperCase() == 'OWNER'
                          ? 'ALL'
                          : Utility.cmpmobileno;
                      controller.getVisitAttendanceSummaryReportDataAPI();
                    },

                    // onSelected: (spselected) {

                    //   controller.salesPersonNameSelected.value =
                    //       spselected.username!;
                    //   controller.salesPersonMobileSelected.value =
                    //       spselected.mobileno!;
                    //   controller.getVisitAttendanceSummaryReportDataAPI();
                    // },
                    onSelected: (spselected) {
                      // ✅ STEP 1: CLOSE DROPDOWN FIRST
                      FocusScope.of(context).unfocus();

                      // ✅ STEP 2: DELAY UPDATE (VERY IMPORTANT)
                      Future.delayed(const Duration(milliseconds: 100), () {
                        controller.salesPersonNameSelected.value =
                            spselected.username!;
                        controller.salesPersonMobileSelected.value =
                            spselected.mobileno!;

                        controller.getVisitAttendanceSummaryReportDataAPI();
                      });
                    },
                  ),
                ),
              ],
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
                itemCount: controller.visitAttendanceEntityDataList.isEmpty
                    ? 0
                    : controller.visitAttendanceEntityDataList.length,
                itemBuilder: (context, i) {
                  final item = controller.visitAttendanceEntityDataList[i];
                  return InkWell(
                    child: Card(
                      elevation: 2,
                      child: Container(
                        padding: EdgeInsets.all(size.width * 0.02),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(item.mobUserName!, style: kTxtStl13B),
                            SizedBox(height: size.height * 0.01),
                            Row(
                              children: [
                                DateCalendar(date: item.date!),
                                SizedBox(width: size.width * 0.02),
                                visitSummaryView(
                                  size,
                                  'Total Customer',
                                  'Existing',
                                  int.parse(item.actualExisting!),
                                  'Cold',
                                  int.parse(item.actualColdVisit!),
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () {
                      // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                      // VisitAttendanceDetRpt(name: visitAttendanceEntityDataList[i].mobUserName!,// komal // 18-8-2022 // name added
                      // fromdate: DateTime.parse(visitAttendanceEntityDataList[i].date!),
                      // todate: DateTime.parse(visitAttendanceEntityDataList[i].date!,),
                      // mobileno: visitAttendanceEntityDataList[i].mobileNo, existvalue: 'ALL',)));//pooja // 10-5-2023 // add existvalue
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
