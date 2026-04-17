import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/outstanding/controller/os_recpay_bill_controller.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/outstanding/view/os_party_group_ledger.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/outstanding/view/os_recpay_bill_details.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/outstanding/view/todays_followup_rpt.dart';
import 'package:sysconn_sfa/widgets/fl_barchart.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_dropdownlist.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/screens/drawer/drawer_view.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/outstanding/controller/outstanding_rec_pay_controller.dart';
import 'package:sysconn_sfa/widgets/trinagrid_rpt_theme.dart';
import 'package:trina_grid/trina_grid.dart';

class OsRecPayDashboard extends StatelessWidget {
  final String? dashboardtypename;
  final String? mobileno;
  // final int? salesPersonCount;

  const OsRecPayDashboard({
    super.key,
    required this.dashboardtypename,
    required this.mobileno,
    // this.salesPersonCount,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      OsRecPayDashboardController(
        dashboardtypename: dashboardtypename!,
        mobileno: mobileno,
        // salesPersonCount: salesPersonCount,
      ),
    );
    // final controller = Get.put(OsRecPayDashboardController());
    // controller.init(dashboardtypename!);
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Outstanding Receivable'),
      drawer: const DrawerForAll(),
      body: Padding(
        padding: const EdgeInsets.fromLTRB(0, 0, 0, 0),
        // padding: const EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          children: [
            Container(
              decoration: const BoxDecoration(
                gradient: LinearGradient(
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                  colors: <Color>[
                    //
                    Color(0xffF54749),

                    //  Color.fromARGB(255, 223, 98, 15),
                    Color(0xffF54749),
                  ],
                ),
              ),
              child: DefaultTabController(
                length: controller.osDashTabMenuList.length,
                child: Padding(
                  padding: EdgeInsets.all(0),
                  child: TabBar(
                    indicatorSize: TabBarIndicatorSize.tab,
                    tabAlignment: TabAlignment.start,
                    isScrollable: true,
                    controller: controller.osTabController,
                    indicator: BoxDecoration(
                      borderRadius: BorderRadius.only(
                        topLeft: Radius.circular(10),
                        topRight: Radius.circular(10),
                      ),
                      // borderRadius: BorderRadius.circular(40.0),
                      // border: Border.all(color: Colors.grey),
                      color: Colors.white,
                    ),
                    labelColor: Colors.black,
                    unselectedLabelColor: Colors.black,
                    labelPadding: EdgeInsets.all(14.0),
                    tabs: List.generate(controller.osDashTabMenuList.length, (
                      int index,
                    ) {
                      return Text(
                        controller.osDashTabMenuList[index],
                        style: kTxtStlB,
                      );
                    }),
                  ),
                ),
              ),
            ),

            /// TYPE DROPDOWN
            // if (controller.menuIndexSelected.value == 0)
            //   DropdownButton<String>(
            //     value: controller.osTypeSelected.value,
            //     items: controller.osTypeItem
            //         .map((val) => DropdownMenuItem(
            //               value: val,
            //               child: Text(val),
            //             ))
            //         .toList(),
            //     onChanged: (val) {
            //       controller.osTypeSelected.value = val!;

            //       controller.outAgeingSelected.value =
            //           val == 'Party'
            //               ? controller.outAgeingSelected.value
            //               : 'ALL';

            //       controller.callInitFun();  // SAME METHOD
            //     },
            //   ),
            // Row(
            //   children: [
            //     //  DropdownList(

            //     //           title: 'Type',
            //     //             items: controller.osTypeItem
            //     //               .map((val) => DropdownMenuItem(
            //     //                     value: val,
            //     //                     child: Text(val),
            //     //                   ))
            //     //               .toList(),
            //     //             value: controller.osTypeSelected.value,
            //     //             onChanged: (val) {
            //     //             controller.osTypeSelected.value = val;
            //     //             controller.callInitFun();
            //     //           },
            //     //           ),
            //     controller.menuIndexSelected == 0
            //         ? Obx(
            //             () => DropdownList<String>(
            //               title: 'Type',
            //               items: controller.osTypeItem.map((val) {
            //                 return DropdownMenuItem<String>(
            //                   value: val,
            //                   child: Text(val),
            //                 );
            //               }).toList(),
            //               value: controller.osTypeSelected.value,
            //               onChanged: (val) {
            //                 controller.osTypeSelected.value = val!;

            //                 if (val != 'Party') {
            //                   controller.outAgeingSelected.value = 'ALL';
            //                 }

            //                 controller.callInitFun();
            //               },
            //             ),
            //           )
            //         : Container(),
            //     controller.menuIndexSelected == 0
            //         ? SizedBox(width: size.width * 0.01)
            //         : Container(),
            //         controller.menuIndexSelected == 0
            //           ? SizedBox(width: size.width * 0.01)
            //           : Container(),
            //       DropdownList(
            //         title: 'Sub Type',
            //         items:  controller.osAgeByItem.map((val) {
            //           return DropdownMenuItem<String>(
            //             value: val,
            //             child: Text(val, style: kTxtStl13N),
            //           );
            //         }).toList(),
            //         value:  controller.osAgeBySelected,
            //         onChanged: ( val) {

            //              controller.osAgeBySelected = val;

            //            controller.callInitFun();
            //         },
            //         // )
            //       ),
            //       ( controller.menuIndexSelected == 0 ||  controller.menuIndexSelected == 2) &&
            //                controller.osTypeSelected == 'Party'
            //           ? SizedBox(width: size.width * 0.01)
            //           : Container(),
            //       ( controller.menuIndexSelected == 0 || controller. menuIndexSelected == 2) &&
            //                controller.osTypeSelected == 'Party'
            //           ? DropdownList(
            //               title: 'Ageing',

            //               items:  controller.outAgeingItem.map((String outAgeValue) {
            //                 return DropdownMenuItem<String>(
            //                   value: outAgeValue,
            //                   child: Text(outAgeValue, style: kTxtStl13N),
            //                 );
            //               }).toList(),
            //               value:  controller.outAgeingSelected,

            //               onChanged: (outageSelectedValue) {

            //                    controller.outAgeingSelected = outageSelectedValue!;

            //                  controller.callInitFun();
            //               },
            //             )
            //           // )
            //           : Container(),

            //   ],
            // ),
            Obx(
              () => Padding(
                padding: const EdgeInsets.symmetric(horizontal: 8.0),
                child: Row(
                  // mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    controller.menuIndexSelected.value == 0 &&
                            controller.menuIndexSelected.value != 1
                        ? DropdownList<String>(
                            title: 'Type',
                            items: controller.osTypeItem
                                .map(
                                  (val) => DropdownMenuItem<String>(
                                    value: val,
                                    child: Text(val),
                                  ),
                                )
                                .toList(),
                            value: controller.osTypeSelected.value,
                            onChanged: controller.changeType,
                          )
                        : Container(),
                    SizedBox(width: size.width * 0.03),

                    /// SUB TYPE
                    controller.menuIndexSelected.value == 1
                        ? Container()
                        : DropdownList<String>(
                            title: 'Sub Type',
                            items: controller.osAgeByItem
                                .map(
                                  (val) => DropdownMenuItem(
                                    value: val,
                                    child: Text(val),
                                  ),
                                )
                                .toList(),
                            value: controller.osAgeBySelected.value,
                            onChanged: controller.changeSubType,
                          ),
                    SizedBox(width: size.width * 0.03),

                    /// AGEING
                    controller.osTypeSelected.value == 'Party' &&
                            controller.menuIndexSelected.value != 1
                        ? DropdownList<String>(
                            title: 'Ageing',
                            items: controller.outAgeingItem
                                .map(
                                  (val) => DropdownMenuItem(
                                    value: val,
                                    child: Text(val),
                                  ),
                                )
                                .toList(),
                            value: controller.outAgeingSelected.value,
                            onChanged: controller.changeAgeing,
                          )
                        : Container(),
                  ],
                ),
              ),
            ),
            Expanded(
              child: TabBarView(
                controller: controller.osTabController,
                children: controller.type == 'Receivable'
                    ? [
                        recPayTab(size, controller, context),
                        todayFollowTab(size, controller, context),
                        followupTypeTab(size, controller, context),
                        // todayFollowTab(size),
                        // followupTypeTab(size),
                      ]
                    : [recPayTab(size, controller, context)],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Container osTotalCon(OsRecPayDashboardController controller) {
    return Container(
      padding: EdgeInsets.all(9.0),
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [Color(0xFFFF6A00), Color(0xFFFF0000)],
        ),
        borderRadius: BorderRadius.circular(11),
      ),
      child:
          //isDataLoad != 1
          //     ? Center(
          //         child: isDataLoad == 0
          //             ? Platform.isIOS
          //                   ? CupertinoActivityIndicator()
          //                   : CircularProgressIndicator()
          //             : Text('No Data'),
          //       )
          //     : Builder(
          //           builder: (context) {
          //           return
          Obx(
            () => Text(
              indianRupeeFormat(controller.gridDataTotal.value),
              // indianRupeeFormat(1111111),
              style: TextStyle(
                fontSize: 21.0,
                fontWeight: FontWeight.bold,
                color: Colors.white,
              ),
              textAlign: TextAlign.center,
            ),
          ),
      // ;
      //   },
      // ),
    );
  }

  Expanded osDashboardTrinaGrid(BuildContext context) {
    final controller = Get.find<OsRecPayDashboardController>();

    return Expanded(
      child: Container(
        decoration: BoxDecoration(border: Border.all(), color: Colors.white),
        child: Obx(() {
          if (controller.isDataLoad.value != 1) {
            return Center(
              child: controller.isDataLoad.value == 0
                  ? Utility.processLoadingWidget()
                  : NoDataFound(),
            );
          }

          return Column(
            children: [
              Expanded(
                child: trinaCustomTheme(
                  context: context,
                  columns: [
                    gridColumnRpt(field: 'name', title: 'Name'),

                    gridColumnRpt(
                      field: 'date',
                      title: 'Date',
                      hide:
                          controller.type == 'Receivable' &&
                              controller.osTypeSelected.value == 'Party' &&
                              controller.menuIndexSelected.value == 1
                          ? false
                          : true,
                    ),

                    gridColumnRpt(
                      field: 'followup_type',
                      title: 'Followup\nType',
                      hide: controller.menuIndexSelected.value == 2
                          ? false
                          : true,
                      // width: 100,
                    ),

                    gridColumnRpt(
                      field: 'amount',
                      title:
                          'Amount \n (${Utility.dashAmtUnitScaleSelected()})',
                      istext: false,
                      // width: 100,
                    ),

                    gridColumnRpt(field: 'id', title: 'Id Stock', hide: true),
                  ].obs,

                  onLoaded: (TrinaGridOnLoadedEvent event) {
                    event.stateManager.setShowColumnFilter(true);
                    controller.stateManager = event.stateManager;
                  },

                  onselected: (TrinaGridOnSelectedEvent event) {
                    if (event.row != null) {
                      final selectedRow = event.row!;
                      final selectedname = selectedRow.cells['name']!.value
                          .toString();
                      final selectedid = selectedRow.cells['id']!.value
                          .toString();

                      if (controller.osTypeSelected.value == 'Party') {
                        Get.to(
                          () => OutstandingRecPayBillDetails(
                            partyId: selectedid,
                            partyName: selectedname,
                            // type: type!,
                            ageFilter: controller.outAgeingSelected.value,
                            osAgeBySelectedFilter:
                                controller.osAgeBySelected.value,
                          ),
                        );
                      } else {
                        Get.to(
                          () => OutstandingPartyGroupLedgerDashboard(
                            dashboardtypename: dashboardtypename,
                            groupId: selectedid,
                            groupName: selectedname,
                            ageBy: controller.osAgeBySelected.value,
                            osType: controller.osTypeSelected.value,
                          ),
                        );
                      }
                    }
                  },

                  select: TrinaGridMode.select,
                  configuration: const TrinaGridConfiguration(),
                  rows: controller.rows,
                ),
              ),
            ],
          );
        }),
      ),
    );
  }
  // Column recPayTab(Size size, OsRecPayDashboardController controller,BuildContext context) {
  //   return Column(
  //     children: [
  //       SizedBox(height: size.height * 0.01),

  //       Container(
  //         height: size.height * 0.4,
  //         // margin: EdgeInsets.symmetric(horizontal:12),
  //         child: Stack(
  //           alignment: Alignment.topCenter,
  //           children: [
  //             // Positioned(top: 0, child: osTotalCon(controller)),
  //             Positioned(
  //               top: 40, // push down to allow overlap
  //               left: 5,
  //               right: 5,
  //               child: Container(
  //                 // height: 20,
  //                 //  margin: EdgeInsets.only(top:45),
  //                 child: Card(
  //                   //  margin: EdgeInsets.only(top:10),
  //                   color: Colors.grey.shade200,
  //                   shape: RoundedRectangleBorder(
  //                     borderRadius: BorderRadius.circular(11.0),
  //                   ),
  //                   child: ExpansionTile(
  //                     title: Text(
  //                       "${dashboardtypename!} Summary as on  ",
  //                       style: kTxtStl12B,
  //                     ),
  //                     initiallyExpanded: true,
  //                     iconColor: Colors.black,
  //                     textColor: Colors.black,
  //                     collapsedTextColor: const Color.fromARGB(255, 70, 51, 51),
  //                     children: [
  //                        Obx(() {
  //                         return
  //                       Container(
  //                         // color: Colors.blue,
  //                         height: size.height * 0.22, //add for test
  //                           color: Colors.white,
  //                           child: controller.isGraphDataLoad.value != 1
  //                               ? Center(
  //                                   child: controller.isGraphDataLoad.value == 0
  //                                       ? Platform.isIOS
  //                                             ? CupertinoActivityIndicator()
  //                                             : CircularProgressIndicator()
  //                                       : Text('No Data'),
  //                                 )
  //                               : Builder(
  //                                    builder: (context) {
  //                                    controller.xAxisData.value = [];
  //                                     controller.yAxisData.value = [];

  //                                     for (
  //                                       int i = 0;
  //                                       i <controller.osRecPayDashboardGraphItem.length;
  //                                       i++
  //                                     ) {
  //                                       controller.xAxisData.add(
  //                                         controller.osRecPayDashboardGraphItem[i]['Name'],
  //                                       );
  //                                       controller.yAxisData.add(
  //                                         num.parse(
  //                                           controller.osRecPayDashboardGraphItem[i]['Amount']
  //                                               .toString(),
  //                                         ).round(),
  //                                       );
  //                                     }

  //                                     List<String> xAxisList = controller.xAxisData
  //                                         .map((e) => e.toString())
  //                                         .toList();
  //                                     List<double> yAxisList = controller.yAxisData
  //                                         .map((e) => double.tryParse(e.toString()) ?? 0)
  //                                         .toList();
  //                                     return
  //                         Container(
  //                                       color: Colors.white,
  //                                       height: size.height * 0.3,
  //                                       child:
  //                                           //  ColumnChart(),
  //                                           Padding(
  //                                             padding: const EdgeInsets.all(8.0),
  //                                             child: FlBarChartWidget(
  //                                               xAxisData: xAxisList,
  //                                               yAxisData: yAxisList,
  //                                               textStyle: kTxtStl12B,
  //                                             ),
  //                                           ),
  //                                     );
  //                                   },
  //                                 ),
  //                         );} ),
  //                     ],
  //                   ),
  //                 ),
  //               ),
  //             ),
  //             Positioned(top: 15, child: osTotalCon(controller)),
  //           ],
  //         ),
  //       ),

  //       osDashboardTrinaGrid(context),
  //     ],
  //   );
  // }
  Column recPayTab(
    Size size,
    OsRecPayDashboardController controller,
    BuildContext context,
  ) {
    return Column(
      children: [
        // SizedBox(height: size.height * 0.01),
        Stack(
          clipBehavior: Clip.none,
          alignment: Alignment.topCenter,
          children: [
            /// Card with ExpansionTile
            Padding(
              padding: const EdgeInsets.only(top: 40, left: 5, right: 5),
              child: Card(
                color: Colors.grey.shade200,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(11.0),
                ),
                child: ExpansionTile(
                  title: Text(
                    "${dashboardtypename!} Summary as on",
                    style: kTxtStl12B,
                  ),
                  initiallyExpanded: true,
                  iconColor: Colors.black,
                  textColor: Colors.black,
                  collapsedTextColor: const Color.fromARGB(255, 70, 51, 51),

                  children: [
                    Obx(() {
                      if (controller.isGraphDataLoad.value != 1) {
                        return SizedBox(
                          height: size.height * 0.22, //200,
                          child: Center(
                            child: controller.isGraphDataLoad.value == 0
                                ? (Utility.processLoadingWidget())
                                : const Text("No Data"),
                          ),
                        );
                      }

                      /// Prepare graph data (DO NOT modify Rx directly)
                      final List<String> xAxisList = controller
                          .osRecPayDashboardGraphItem
                          .map<String>((e) => e['Name'].toString())
                          .toList();

                      final List<double> yAxisList = controller
                          .osRecPayDashboardGraphItem
                          .map<double>(
                            (e) => double.tryParse(e['Amount'].toString()) ?? 0,
                          )
                          .toList();

                      return SizedBox(
                        height: size.height * 0.22,
                        child: Padding(
                          padding: const EdgeInsets.all(8.0),
                          child: FlBarChartWidget(
                            xAxisData: xAxisList,
                            yAxisData: yAxisList,
                            textStyle: kTxtStl12B,
                          ),
                        ),
                      );
                    }),
                  ],
                ),
              ),
            ),

            /// Top overlapping total container
            Positioned(top: 15, child: osTotalCon(controller)),
          ],
        ),

        osDashboardTrinaGrid(context),
      ],
    );
  }

  Widget followupCard({
    required Size size,
    // required BuildContext context,
    required String title,
    required String count,
    required Color countColor,
    required VoidCallback onTap,
  }) {
    return SizedBox(
      height: size.height * 0.11,
      width: size.width * 0.22,
      child: Card(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(11.0),
          side: const BorderSide(color: Colors.orangeAccent, width: 2.0),
        ),
        elevation: 4.0,
        color: Colors.grey.shade50,
        child: InkWell(
          onTap: onTap,
          child: Padding(
            padding: const EdgeInsets.all(4.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              children: [
                Text(title, style: kTxtStl12N, textAlign: TextAlign.center),
                Text(
                  count,
                  style: TextStyle(
                    fontSize: 16,
                    fontWeight: FontWeight.w600,
                    color: countColor,
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Column todayFollowTab(
    Size size,
    OsRecPayDashboardController controller,
    BuildContext context,
  ) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 8.0),
          child: Row(
            // mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              /// SUB TYPE
              DropdownList<String>(
                title: 'Sub Type',
                items: controller.osAgeByItem
                    .map(
                      (val) => DropdownMenuItem(value: val, child: Text(val)),
                    )
                    .toList(),
                value: controller.osAgeBySelected.value,
                onChanged: controller.changeSubType,
              ),
              SizedBox(width: size.width * 0.05),
              SizedBox(
                width: size.width * 0.4,
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Text('Date', style: kTxtStl14B),
                    ),
                    // Container(
                    //   padding: const EdgeInsets.fromLTRB(8, 0, 8, 0),
                    //   decoration: BoxDecoration(
                    //     borderRadius: BorderRadius.circular(14.0),
                    //     border: Border.all(width: 0.8, color: Colors.grey),
                    //     color: Colors.grey.shade50,
                    //   ),
                    //   child: SizedBox(
                    //        width: size.width * 0.4,
                    //     child: ListTile(
                    //         title:  Text(
                    //           DateFormat('dd-MM-yyyy').format(controller.fromDate),
                    //           style: kTxtStl12B,
                    //         ),//Icon(Icons.calendar_today),
                    //         trailing: Icon(Icons.calendar_today),
                    //         //  Icon(Icons.arrow_drop_down),
                    //         onTap: () async{
                    //       //      await selectDateRange(context, fromDate, toDate)
                    //       //     .then((selectedDateRange) {
                    //       //   fromDate = selectedDateRange.start;
                    //       //   toDate = selectedDateRange.end;
                    //       //   // setState(() { });
                    //       //   callInitFun(); // komal // 16-12-2023 // grid api call in int method bcze future builder has been removed
                    //       // });
                    //       },
                    //       ),
                    //   ),
                    // ),
                    Container(
                      padding: const EdgeInsets.fromLTRB(8, 12, 8, 12),
                      decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(14.0),
                        border: Border.all(width: 0.8, color: Colors.grey),
                        color: Colors.grey.shade50,
                      ),

                      child: InkWell(
                        child: Row(
                          children: [
                            SizedBox(width: size.width * 0.03),
                            Text(
                              DateFormat(
                                'dd-MM-yyyy',
                              ).format(controller.fromDate),
                              style: kTxtStl12B,
                            ),

                            SizedBox(width: size.width * 0.06),
                            Icon(
                              Icons.calendar_today,
                              size: 19,
                              color: Colors.grey,
                            ),
                          ],
                        ),
                        onTap: () async {
                          // await selectDateRange(context, fromDate, toDate)
                          //     .then((selectedDateRange) {
                          //   fromDate = selectedDateRange.start;
                          //   toDate = selectedDateRange.end;
                          //   // setState(() { });
                          //   callInitFun(); // komal // 16-12-2023 // grid api call in int method bcze future builder has been removed
                          // }
                          // );
                        },
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
        SizedBox(
          height: size.height * 0.3,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 40, // push down to allow overlap
                left: 5,
                right: 5,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    10,
                    10,
                    10,
                    0,
                  ), //EdgeInsets.all(6.0),
                  height: size.height * 0.18,
                  color: Colors.grey[400],
                  child: Obx(() {
                    if (controller.paymentFollowupEntity.value == null) {
                      return Center(
                        child: controller.isDataLoad.value == 0
                            ? (Utility.processLoadingWidget())
                            : const Text('No Data'),
                      );
                    }

                    return Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        followupCard(
                          size: size,
                          title: 'Monthly Count',
                          count: controller
                              .paymentFollowupEntity
                              .value!
                              .monthlyFollowup!,
                          countColor: Colors.green,
                          onTap: () {
                            // Navigator.of(context).push(
                            //   MaterialPageRoute(
                            //     builder: (context) => TodayFollowupReport(
                            //       mobileno: Utility.cmpmobileno,
                            //       fromdate: Utility.findStartOfThisMonth(
                            //         controller.fromDate,
                            //       ).toString(),
                            //       todate: Utility.findLastOfThisMonth(
                            //         controller.fromDate,
                            //       ).toString(),
                            //     ),
                            //   ),
                            // );

                            Get.to(
                              () => TodayFollowupReport(
                                mobileno: Utility.cmpmobileno,
                                fromdate: Utility.findStartOfThisMonth(
                                  controller.fromDate,
                                ).toString(),
                                todate: Utility.findLastOfThisMonth(
                                  controller.fromDate,
                                ).toString(),
                              ),
                            );
                          },
                        ),
                        followupCard(
                          size: size,
                          title: 'Daily Count',
                          count: controller
                              .paymentFollowupEntity
                              .value!
                              .todaysFollowUp!,
                          countColor: Colors.green,
                          onTap: () {
                            Navigator.of(context).push(
                              MaterialPageRoute(
                                builder: (context) => TodayFollowupReport(
                                  mobileno: Utility.cmpmobileno,
                                  fromdate: controller.fromDate.toString(),
                                  todate: controller.fromDate.toString(),
                                ),
                              ),
                            );
                          },
                        ),
                        followupCard(
                          size: size,
                          title: 'Today\'s Followup',
                          count: controller.partycount.toString(),
                          countColor: Colors.green,
                          onTap: () {},
                        ),
                      ],
                    );
                  }),
                ),
              ),
              Positioned(top: 15, child: osTotalCon(controller)),
            ],
          ),
        ),
        osDashboardTrinaGrid(context),
      ],
    );
  }

  Column followupTypeTab(
    Size size,
    OsRecPayDashboardController controller,
    BuildContext context,
  ) {
    return Column(
      children: [
        SizedBox(
          height: size.height * 0.3,
          child: Stack(
            alignment: Alignment.topCenter,
            children: [
              Positioned(
                top: 40, // push down to allow overlap
                left: 5,
                right: 5,
                child: Container(
                  padding: EdgeInsets.fromLTRB(
                    15,
                    10,
                    5,
                    0,
                  ), //EdgeInsets.all(6.0),
                  height: size.height * 0.18,
                  color: Colors.grey[400],
                  child: Row(
                    //  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      followDashCon(
                        'No Followup',
                        controller.nofollowupcount.value,
                        Colors.green,
                        size,controller
                      ),
                      followDashCon(
                        'Dispute',
                        controller.disputecount.value,
                        Colors.red,
                        size,controller
                      ),
                      Obx(
                        () => followDashCon(
                          'Escalated',
                          controller.escalatedcount.value,
                          Colors.brown,
                          size,controller
                        ),
                      ),
                      followDashCon(
                        'Regular',
                        controller.regularcount.value,
                        Colors.teal,
                        size,controller
                      ),
                      Obx(
                        () => followDashCon(
                          'Total',

                          (controller.nofollowupcount.value +
                              controller.disputecount.value +
                              controller.escalatedcount.value +
                              controller.regularcount.value),
                          Colors.blue,
                          size,controller
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Positioned(top: 15, child: osTotalCon(controller)),
            ],
          ),
        ),
        osDashboardTrinaGrid(context),
      ],
    );
  }

  Widget followDashCon(String title, int value, Color color, Size size,OsRecPayDashboardController controller) {
    return SizedBox(
      height: size.height * 0.1,
      width: size.width * 0.18,
      child: InkWell(
        child: Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(11.0),
            side: const BorderSide(color: Colors.orangeAccent, width: 2.0),
          ),
          elevation: 3, //title == followupTypeSelected ? 6 : 1,
          shadowColor: Colors.white,
          // shape: RoundedRectangleBorder(
          // borderRadius: BorderRadius.circular(5.0),
          // side: BorderSide(
          //   color:
          //       // title ==
          //       //  followupTypeSelected ? Colors.green :
          //        Colors.white,
          // )),
          margin: EdgeInsets.all(3.0),
          color:
              //  title == followupTypeSelected
              //     ? Colors.green.shade100
              //     :
              Colors.grey.shade50,
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              Text(title, style: kTxtStl12N, textAlign: TextAlign.center),
              Text(
                value.toString(),
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: color,
                ),
              ),
            ],
          ),
        ),
        onTap: () {
      
       controller.followupTypeSelected.value = title;
          
         controller.callInitFun(); // komal // 16-12-2023 // grid api call in int method bcze future builder has been removed
        },
      ),
    );
  }
}

// Container(
//   height: 45,
//   margin: const EdgeInsets.symmetric(horizontal: 12),
//   decoration: BoxDecoration(
//     color: Colors.grey.shade200,
//     borderRadius: BorderRadius.circular(25),
//   ),
//   child: TabBar(
//     controller: controller.osTabController,
//     indicator: BoxDecoration(
//       color: Colors.white,
//       borderRadius: BorderRadius.circular(25),
//     ),
//     labelColor: Colors.black,
//     unselectedLabelColor: Colors.black54,
//     tabs: const [
//       Tab(text: "Receivable"),
//       Tab(text: "Today's Followup"),
//       Tab(text: "Followup Type"),
//     ],
//   ),
// ),
