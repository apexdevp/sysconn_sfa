import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/outstanding/view/outstanding_recpay.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/outstanding/view/todays_followup_rpt.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/daily_performance_report/controller/daily_performance_controller.dart';
import 'package:sysconn_sfa/widgets/calendarsingleview.dart';
import 'package:sysconn_sfa/widgets/customautocompletefield.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class DailyPerformanceReport extends StatelessWidget {
  const DailyPerformanceReport({super.key});

  TextStyle bold13(Color color) {
    return TextStyle(fontSize: 13.0, fontWeight: FontWeight.w600, color: color);
  }

  DataCell dataTableCell(Size size, String value, Function function) {
    return DataCell(
      Container(
        width: size.width * 0.1,
        child: Text(
          value,
          style: bold13(Colors.teal),
          textAlign: TextAlign.right,
        ),
      ),
      onTap: () {
        function();
      },
    );
  }

  Card dailyPerfDataCard(Size size, String title, String value, Color color) {
    return Card(
      child: Container(
        height: size.height * 0.08,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.spaceAround,
          children: [
            Text(title, style: kTxtStl12N),
            Text(value, style: bold13(color), textAlign: TextAlign.center),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(DailyPerformanceController());
    Size size = MediaQuery.of(context).size;

    // ✅ AUTO OPEN AFTER BUILD
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!controller.isBottomSheetOpened) {
        controller.isBottomSheetOpened = true;
        showBottomSheet(size);
      }
    });
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Daily Performance Report'),
      bottomSheet: InkWell(
        child: Container(
          width: size.width,
          padding: EdgeInsets.all(9.0),
          decoration: BoxDecoration(
            color: Colors.orange.shade100,
            shape: BoxShape.rectangle,
            borderRadius: BorderRadius.only(
              // topLeft: Radius.circular(14.0),
              // topRight: Radius.circular(14.0)
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.grey,
                blurRadius: 14.0,
                spreadRadius: 3.0,
              ),
            ],
          ),
          child: Row(
            children: [
              SizedBox(
                width: size.width * 0.3,
                child: Icon(
                  Icons.arrow_drop_down_circle_outlined,
                  size: 30.0,
                  color: Colors.white,
                ),
              ),
              Text(
                'Select Details',
                style: kTxtStlB,
                textAlign: TextAlign.center,
              ),
            ],
          ),
        ),
        onTap: () {
          showBottomSheet(size);
        },
      ),
      body: Container(
        child: Obx(() {
          if (controller.isDataLoad.value == 0) {
            return Center(
              child: Utility.processLoadingWidget()
            );
          } else if (controller.isDataLoad.value == 2) {
            return Center(child: Text('No Data'));
          }

          return Column(
            children: [
              Padding(
                padding: const EdgeInsets.fromLTRB(8, 0, 8, 8),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Flexible(
                      child: Column(
                        children: [
                          Text(
                            '${controller.salesPersonNameSelected}  ',
                            style: kTxtStlB,
                          ),
                        ],
                      ),
                    ),

                    SizedBox(width: 3.0),

                    Text(
                      '(${DateFormat('dd-MM-yyyy').format(controller.fromDate.value)}',
                      style: kTxtStl12N,
                    ),
                    Text('-', style: kTxtStl12N),
                    Text(
                      '${DateFormat('dd-MM-yyyy').format(controller.toDate.value)})',
                      style: kTxtStl12N,
                    ),
                  ],
                ),
              ),
              Divider(thickness: 1.0),
              Expanded(
                child: ListView(
                  children: [
                    Row(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.blue.shade50, Colors.white],
                                ),
                              ),
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Text(
                                        'Customer Details',
                                        style: kTxtStl13B,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: dailyPerfDataCard(
                                            size,
                                            'Total Cust.',
                                            controller
                                                .dailyPerformanceEntity
                                                .value
                                                .route!
                                                .routeName!,
                                            Colors.blue,
                                          ),
                                        ),
                                        Expanded(
                                          child: dailyPerfDataCard(
                                            size,
                                            'Active Cust.',
                                            controller
                                                .dailyPerformanceEntity
                                                .value
                                                .route!
                                                .activerouteCustomer!,
                                            Colors.blue,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                  // LedgerAttributeReport(mobilenoSelected: salesPersonMobileSelected!,securityCountSelected: salesPersonCount!,)));   // komal // 31-3-2023 // securitycount var added in parent class to set in api url
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.pink.shade50, Colors.white],
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: Text(
                                      'Visit Details',
                                      style: kTxtStl13B,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          child: dailyPerfDataCard(
                                            size,
                                            'Existing',
                                            controller
                                                .dailyPerformanceEntity
                                                .value
                                                .visit!
                                                .existingVisit!,
                                            Colors.pink,
                                          ),
                                          onTap: () {
                                            // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                            // VisitAttendanceDetRpt(name: salesPersonNameSelected!,fromdate: fromDate,todate: toDate,
                                            // mobileno: salesPersonMobileSelected,existvalue:'Existing')));
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          child: dailyPerfDataCard(
                                            size,
                                            'Cold',
                                            controller
                                                .dailyPerformanceEntity
                                                .value
                                                .visit!
                                                .coldVisit!,
                                            Colors.pink,
                                          ),
                                          onTap: () {
                                            // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                            // VisitAttendanceDetRpt(name: salesPersonNameSelected!,fromdate: fromDate,todate: toDate,
                                            // mobileno: salesPersonMobileSelected,existvalue:'Cold Visit',)));
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.brown.shade50, Colors.white],
                                ),
                              ),
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Text(
                                        'Collection Received',
                                        style: kTxtStl13B,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: dailyPerfDataCard(
                                            size,
                                            'Collection',
                                            controller
                                                .dailyPerformanceEntity
                                                .value
                                                .collection!
                                                .totalcollection!,
                                            Colors.brown,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                onTap: () async {
                                  // await Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                  // CollectionDashboard(dashboardtypename:'Receipt',dashboardNavTo:'Daily Performance',
                                  // //pooja // 11-02-2023 // change fromdate and todate
                                  // //date: date,
                                  // fromdate: DateTime.parse(DateFormat('yyyy-MM-dd').format(fromDate)),
                                  // todate: DateTime.parse(DateFormat('yyyy-MM-dd').format(toDate)),
                                  // salesPersonCount: salesPersonCount,mobileno: salesPersonMobileSelected)));
                                  // _setdashboarddate('Current Financial Year');
                                },
                              ),
                            ),
                          ),
                        ),
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.green.shade50, Colors.white],
                                ),
                              ),
                              child: InkWell(
                                child: Column(
                                  children: [
                                    Padding(
                                      padding: EdgeInsets.all(3.0),
                                      child: Text(
                                        'Expenses Incurred',
                                        style: kTxtStl13B,
                                      ),
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: dailyPerfDataCard(
                                            size,
                                            'Expenses',
                                            controller
                                                .dailyPerformanceEntity
                                                .value
                                                .expenseincured!
                                                .expensesincured!,
                                            Colors.green,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                                onTap: () {
                                  // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                  // LedgerRegisterScreen(ledgerId: salesPersonIouLedgerId,ledgername: salesPersonIouLedgerName,
                                  // fromDateSelected: fromDate,toDateSelected: toDate,)));    // komal // 3-3-2023 // from date and to date pass to ledger report
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                    Row(
                      children: [
                        Expanded(
                          child: Card(
                            shape: RoundedRectangleBorder(
                              borderRadius: BorderRadius.circular(6.0),
                            ),
                            child: Container(
                              padding: EdgeInsets.all(2.0),
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(6.0),
                                gradient: LinearGradient(
                                  begin: Alignment.topCenter,
                                  end: Alignment.bottomCenter,
                                  colors: [Colors.orange.shade50, Colors.white],
                                ),
                              ),
                              child: Column(
                                children: [
                                  Padding(
                                    padding: EdgeInsets.all(3.0),
                                    child: Text(
                                      'Today\'s Followup',
                                      style: kTxtStl13B,
                                    ),
                                  ),
                                  Row(
                                    children: [
                                      Expanded(
                                        child: InkWell(
                                          child: dailyPerfDataCard(
                                            size,
                                            'Today\'s followup',
                                            controller
                                                .dailyPerformanceEntity
                                                .value
                                                .osfollowup!
                                                .todaysfollowup!,
                                            Colors.orange,
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    TodayFollowupReport(
                                                      mobileno: controller
                                                          .salesPersonMobileSelected
                                                          .value,
                                                      fromdate: controller
                                                          .fromDate
                                                          .toString(),
                                                      todate: controller.toDate
                                                          .toString(),
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          child: dailyPerfDataCard(
                                            size,
                                            'Total Customer',
                                            controller
                                                .dailyPerformanceEntity
                                                .value
                                                .osfollowup!
                                                .totalcustomer!,
                                            Colors.orange,
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OsRecPayDashboard(
                                                      dashboardtypename:
                                                          'Outstanding Receivable',
                                                      mobileno: controller
                                                          .salesPersonMobileSelected
                                                          .value,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                      Expanded(
                                        child: InkWell(
                                          child: dailyPerfDataCard(
                                            size,
                                            'Overdue',
                                            controller
                                                .dailyPerformanceEntity
                                                .value
                                                .osfollowup!
                                                .overdueamt!,
                                            Colors.orange,
                                          ),
                                          onTap: () {
                                            Navigator.of(context).push(
                                              MaterialPageRoute(
                                                builder: (context) =>
                                                    OsRecPayDashboard(
                                                      dashboardtypename:
                                                          'Outstanding Receivable',
                                                      mobileno: controller
                                                          .salesPersonMobileSelected
                                                          .value,
                                                    ),
                                              ),
                                            );
                                          },
                                        ),
                                      ),
                                    ],
                                  ),
                                  Card(
                                    shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(6.0),
                                    ),
                                    child: Container(
                                      padding: EdgeInsets.all(2.0),
                                      decoration: BoxDecoration(
                                        borderRadius: BorderRadius.circular(
                                          6.0,
                                        ),
                                        gradient: LinearGradient(
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                          colors: [
                                            Colors.teal.shade50,
                                            Colors.white,
                                            Colors.white,
                                          ],
                                        ),
                                      ),
                                      child: Column(
                                        children: [
                                          Padding(
                                            padding: EdgeInsets.all(3.0),
                                            child: Text(
                                              'Revenue Details',
                                              style: kTxtStl13B,
                                            ),
                                          ),
                                          Container(
                                            child: DataTable(
                                              columnSpacing: size.width * 0.065,
                                              columns: <DataColumn>[
                                                DataColumn(
                                                  label: Text(
                                                    'Title',
                                                    style: kTxtStl13N,
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'No Of\nRecords',
                                                    style: kTxtStl12N,
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Unique\nSKU',
                                                    style: kTxtStl12N,
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Unique\nCustomer',
                                                    style: kTxtStl12N,
                                                  ),
                                                ),
                                                DataColumn(
                                                  label: Text(
                                                    'Total',
                                                    style: kTxtStl12N,
                                                  ),
                                                ),
                                              ],
                                              rows: <DataRow>[
                                                DataRow(
                                                  cells: <DataCell>[
                                                    DataCell(
                                                      Text(
                                                        'Lead',
                                                        style: kTxtStl12N,
                                                      ),
                                                    ),
                                                    dataTableCell(
                                                      size,
                                                      controller
                                                          .dailyPerformanceEntity
                                                          .value
                                                          .pendinglead!
                                                          .record!,
                                                      () {
                                                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                                        // LeadReport(initFromdate: fromDate,initTodate: toDate,
                                                        // initsalesPersonMobileSelected:salesPersonMobileSelected!,
                                                        // cmpUserType: salesPersonUserType!,)));
                                                      },
                                                    ),
                                                    dataTableCell(
                                                      size,
                                                      controller
                                                          .dailyPerformanceEntity
                                                          .value
                                                          .pendinglead!
                                                          .uniquesku!,
                                                      () {
                                                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                                        // LeadReport(initFromdate: fromDate,initTodate: toDate,
                                                        // initsalesPersonMobileSelected: salesPersonMobileSelected!,
                                                        // cmpUserType: salesPersonUserType!,)));
                                                      },
                                                    ),
                                                    dataTableCell(
                                                      size,
                                                      controller
                                                          .dailyPerformanceEntity
                                                          .value
                                                          .pendinglead!
                                                          .uniquecustomer!,
                                                      () {
                                                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                                        // LeadReport(initFromdate: fromDate,initTodate: toDate,
                                                        // initsalesPersonMobileSelected: salesPersonMobileSelected!,
                                                        // cmpUserType: salesPersonUserType!,)));
                                                      },
                                                    ),
                                                    dataTableCell(
                                                      size,
                                                      controller
                                                          .dailyPerformanceEntity
                                                          .value
                                                          .pendinglead!
                                                          .totalvalue!,
                                                      () {
                                                        // Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                                        // LeadReport(initFromdate: fromDate,initTodate: toDate,
                                                        // initsalesPersonMobileSelected: salesPersonMobileSelected!,
                                                        // cmpUserType: salesPersonUserType!,)));
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                DataRow(
                                                  cells: <DataCell>[
                                                    DataCell(
                                                      Text(
                                                        'SO',
                                                        style: kTxtStl12N,
                                                      ),
                                                    ),
                                                    dataTableCell(
                                                      size,
                                                      controller
                                                          .dailyPerformanceEntity
                                                          .value
                                                          .pendingso!
                                                          .record!,
                                                      () async {
                                                        // await Navigator.push(context,MaterialPageRoute(builder: (context) => SalesOrderRegister(vchtype: 'Sales Order')));
                                                        // _setdashboarddate('Current Financial Year');
                                                      },
                                                    ),
                                                    dataTableCell(
                                                      size,
                                                      controller
                                                          .dailyPerformanceEntity
                                                          .value
                                                          .pendingso!
                                                          .uniquesku!,
                                                      () async {
                                                        // await Navigator.push(context,MaterialPageRoute(builder: (context) => SalesOrderRegister(vchtype: 'Sales Order')));
                                                        //   _setdashboarddate('Current Financial Year');
                                                      },
                                                    ),
                                                    dataTableCell(
                                                      size,
                                                      controller
                                                          .dailyPerformanceEntity
                                                          .value
                                                          .pendingso!
                                                          .uniquecustomer!,
                                                      () async {
                                                        // await Navigator.push(context,MaterialPageRoute(builder: (context) => SalesOrderRegister(vchtype: 'Sales Order')));

                                                        // _setdashboarddate('Current Financial Year');
                                                      },
                                                    ),
                                                    dataTableCell(
                                                      size,
                                                      controller
                                                          .dailyPerformanceEntity
                                                          .value
                                                          .pendingso!
                                                          .totalvalue!,
                                                      () async {
                                                        // await Navigator.push(context,MaterialPageRoute(builder: (context) => SalesOrderRegister(vchtype: 'Sales Order')));
                                                        // await Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                                        // SOPODashboard(dashboardtypename: 'Sales Order',dashboardNavTo: 'Daily Performance',
                                                        // date: date,salesPersonCount: salesPersonCount,mobileno: salesPersonMobileSelected)));
                                                        // _setdashboarddate('Current Financial Year');
                                                      },
                                                    ),
                                                  ],
                                                ),
                                                DataRow(
                                                  cells: <DataCell>[
                                                    DataCell(
                                                      Text(
                                                        'Sales',
                                                        style: kTxtStl12N,
                                                      ),
                                                    ),
                                                    dataTableCell(
                                                      size,
                                                      controller
                                                          .dailyPerformanceEntity
                                                          .value
                                                          .pendingsalescn!
                                                          .record!,
                                                      () async {
                                                        // await Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                                        // SalesDashboard(dashboardtypename:'Sales',dashboardNavTo:'Daily Performance',
                                                        // // pooja // 11-02-2023 // add fromdate and todate
                                                        // //date: date,
                                                        // fromdate: DateTime.parse(DateFormat('yyyy-MM-dd').format(fromDate)),
                                                        // todate: DateTime.parse(DateFormat('yyyy-MM-dd').format(toDate)),
                                                        // salesPersonCount: salesPersonCount,mobileno:salesPersonMobileSelected,)));
                                                        // _setdashboarddate('Current Financial Year');
                                                      },
                                                    ),
                                                    dataTableCell(
                                                      size,
                                                      controller
                                                          .dailyPerformanceEntity
                                                          .value
                                                          .pendingsalescn!
                                                          .uniquesku!,
                                                      () async {
                                                        // await Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                                        // SalesDashboard(dashboardtypename:'Sales', dashboardNavTo: 'Daily Performance',
                                                        // // pooja // 11-02-2023 // add fromdate and todate
                                                        // // date: date,
                                                        // fromdate: DateTime.parse(DateFormat('yyyy-MM-dd').format(fromDate)),
                                                        // todate: DateTime.parse(DateFormat('yyyy-MM-dd').format(toDate)),
                                                        // salesPersonCount: salesPersonCount, mobileno: salesPersonMobileSelected,)));
                                                        // _setdashboarddate('Current Financial Year');
                                                      },
                                                    ),
                                                    dataTableCell(
                                                      size,
                                                      controller
                                                          .dailyPerformanceEntity
                                                          .value
                                                          .pendingsalescn!
                                                          .uniquecustomer!,
                                                      () async {
                                                        // await Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                                        // SalesDashboard(dashboardtypename:'Sales',dashboardNavTo:'Daily Performance',
                                                        //  // pooja // 11-02-2023 // add fromdate and todate
                                                        //  //date: date,
                                                        // fromdate: DateTime.parse(DateFormat('yyyy-MM-dd').format(fromDate)),
                                                        // todate: DateTime.parse(DateFormat('yyyy-MM-dd').format(toDate)),
                                                        // salesPersonCount: salesPersonCount,mobileno: salesPersonMobileSelected,)));
                                                        // _setdashboarddate('Current Financial Year');
                                                      },
                                                    ),
                                                    dataTableCell(
                                                      size,
                                                      controller
                                                          .dailyPerformanceEntity
                                                          .value
                                                          .pendingsalescn!
                                                          .totalvalue!,
                                                      () async {
                                                        // await Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                                                        // SalesDashboard(dashboardtypename: 'Sales',dashboardNavTo: 'Daily Performance',
                                                        // // pooja // 11-02-2023 // add fromdate and todate
                                                        // //,date: date,
                                                        // fromdate: DateTime.parse(DateFormat('yyyy-MM-dd').format(fromDate)),
                                                        // todate: DateTime.parse(DateFormat('yyyy-MM-dd').format(toDate)),
                                                        // salesPersonCount: salesPersonCount,mobileno: salesPersonMobileSelected,)));
                                                        // _setdashboarddate('Current Financial Year');
                                                      },
                                                    ),
                                                  ],
                                                ),
                                              ],
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ],
          );
        }),
      ),
    );
  }

  void showBottomSheet(Size size) {
    final controller = Get.find<DailyPerformanceController>();

    Get.bottomSheet(
      Container(
        height: size.height * 0.8,
        decoration: BoxDecoration(
          // borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
          color: Colors.white,
        ),
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            children: [
              Container(
                width: size.width,
                padding: EdgeInsets.all(9.0),
                decoration: BoxDecoration(
                  // borderRadius: BorderRadius.vertical(top: Radius.circular(40)),
                  color: Colors.orange[100],
                ),
                child: Text(
                  'Select Details',
                  style: kTxtStlB,
                  textAlign: TextAlign.center,
                ),
              ),

              SizedBox(height: size.height * 0.04),

              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  // Obx(
                  //   () => CalendarSingleView(
                  //     fromDate: controller.fromDate.value,
                  //     toDate: controller.toDate.value,
                  //     function: () async {
                  //       var range = await selectDateRange(
                  //         controller.fromDate.value,
                  //         controller.toDate.value,
                  //       );

                  //       controller.fromDate.value = range.start;
                  //       controller.toDate.value = range.end;
                  //     },
                  //   ),
                  // ),
                  Obx(
                    () => CustomAutoCompleteFieldView(
                      optionsBuilder: (TextEditingValue value) {
                        return controller.salesPersonList
                            .where(
                              (element) => element.toLowerCase().contains(
                                value.text.toLowerCase(),
                              ),
                            )
                            .toList();
                      },
                      title: 'Sales Person',
                      controllerValue: controller
                          .salesPersonNameSelected
                          .value, // Reactive binding
                      isCompulsory: true,
                      closeControllerFun: () {
                        controller.salesPersonNameSelected.value = '';
                        controller.salespersonTextController.clear();
                      },
                      onSelected: (String selected) {
                        controller.onSalesPersonSelected(selected);
                      },
                    ),
                  ),
                ],
              ),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Obx(
                    () => CalendarSingleView(
                      fromDate: controller.fromDate.value,
                      toDate: controller.toDate.value,
                      function: () async {
                        var range = await selectDateRange(
                          controller.fromDate.value,
                          controller.toDate.value,
                        );

                        controller.fromDate.value = range.start;
                        controller.toDate.value = range.end;
                      },
                    ),
                  ),
                ],
              ),
              SizedBox(height: size.height * 0.01),

              /// ✅ SUBMIT BUTTON
              ResponsiveButton(
                title: 'Submit',
                function: () {
                  Get.back();
                  controller.getdailyperformanceReportAPI();
                },
              ),
            ],
          ),
        ),
      ),
      isScrollControlled: true,
    );
  }
}
