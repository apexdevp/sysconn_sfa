import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/image_list.dart';
import 'package:sysconn_sfa/Utility/report_menu.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/collection/view/collection_report.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/my_customer_list/view/my_customer_list.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/outstanding/view/outstanding_recpay.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/cold_visit/view/cold_visit_rpt.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/beat_list.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/reason_for_noOrder.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/daily_performance_report/view/daily_performance_rpt.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/inactive_customer_report/view/inactive_customer_rpt.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/inactive_item_report/view/inactive_item_rpt.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/sales_order_rpt/view/itemwise_so_pending_rpt.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/sales_order_rpt/view/sales_order_register.dart';
import 'package:sysconn_sfa/screens/expenses/controllers/expenses_menu_controller.dart';
import 'package:sysconn_sfa/widgets/menuCard.dart';

import '../reports/visit_summary_report/view/visit attendance_summary_rpt.dart';

class SalesMenuView extends StatelessWidget {
  SalesMenuView({super.key});

  final ExpensesMenuController controller = Get.put(ExpensesMenuController());

  Widget activityButtonRow(BuildContext context, Size size) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Column(
        children: [
          Row(
            children: [
              MenuCardView(
                image: Image.asset(ImageList.myCustomerImage),
                title: 'My Customer',
                function: () {
                  Get.to(() => MyBeatList());
                },
              ),

              SizedBox(width: size.width * 0.02),
              MenuCardView(
                image: Image.asset(ImageList.visitImage),
                title: ' Cold Visit',
                function: () {
                  Get.to(() => ColdVisitReport());
                },
              ),
              SizedBox(width: size.width * 0.02),
              MenuCardView(
                image: Image.asset(ImageList.orderImage),
                title: 'Order',
                function: () {},
              ),
              SizedBox(width: size.width * 0.02),
              MenuCardView(
                image: Image.asset(ImageList.leadImage),
                title: 'Lead',
                function: () {},
              ),
            ],
          ),
          SizedBox(height: size.height * 0.02),
          Row(
            children: [
              MenuCardView(
                image: Image.asset(ImageList.collectionImage),
                title: 'Collection',
                function: () {
                  Get.to(() => CollectionReport(type: 'Receipt'));
                },
              ),

              SizedBox(width: size.width * 0.02),
              MenuCardView(
                image: Image.asset(ImageList.osFollowupImage),
                title: 'OS Followup',
                function: () {
                  Get.to(
                    () => OsRecPayDashboard(
                      dashboardtypename: 'Outstanding Receivable',
                      mobileno: Utility.cmpmobileno,
                      // salesPersonCount: 0,
                    ),
                  );
                },
              ),
              SizedBox(width: size.width * 0.02),
              MenuCardView(
                image: Image.asset(ImageList.taskImage),
                title: 'Task',
                function: () {},
              ),
              SizedBox(width: size.width * 0.02),
              MenuCardView(
                image: Image.asset(ImageList.supportImage),
                title: 'Support Ticket',
                function: () {},
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget reportsTile(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ReportMenu(
            title: 'My Sales Order Register',
            function: () {
              Get.to(() => SalesOrderRegister());
            },
          ),
          ReportMenu(
            title: 'Item Wise Sales Order Pending',
            function: () {
              Get.to(() => ItemWiseSOPendingReport());
            },
          ),
          ReportMenu(
            title: 'My Visit Register',
            function: () {
              Get.to(() => VisitAttendanceSumRpt());
            },
          ),
          ReportMenu(
            title: 'My Daily Performance Register',
            function: () {
              // Get.to(() => DailyPerformanceReport());
            },
          ),
          ReportMenu(title: 'My Sales Register', function: () {}),
          ReportMenu(title: 'My Collection Register', function: () {}),
          ReportMenu(
            title: 'My Customer List',
            function: () {
              Get.to(() => MyCustomerList(partyGroup: 'Customer'));
            },
          ),
          ReportMenu(
            title: 'My Outstanding',
            function: () {
              Get.to(
                () => OsRecPayDashboard(
                  dashboardtypename: 'Outstanding Receivable',
                  mobileno: Utility.cmpmobileno,
                  // salesPersonCount: 0,
                ),
              );
            },
          ),
          ReportMenu(title: 'Closing Stock Report', function: () {}),
          ReportMenu(
            title: 'Inactive Customer Report',
            function: () {
              Get.to(() => InactiveCustomerReport());
            },
          ),
          ReportMenu(
            title: 'Inactive Item Report',
            function: () {
              Get.to(() => InactiveItemReport());
            },
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: customAppbar(context: context, title: 'Expenses'),
      //AppBar(title: Text('Expenses'),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Obx(
            () => controller.isDataLoad.value == false
                ? Center(child: Utility.processLoadingWidget())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Hello, ', style: kTxtStl17N),
                          Text(' ${Utility.companyName} !', style: kTxtStl17B),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),

                      //  Text(
                      //   '${DateFormat('d MMM yyyy,').format(DateTime.now())}  ${controller.timeString.value}',
                      //   style: kTxtStl14GreyN,
                      // ),
                      Row(
                        children: [
                          Text('Have a nice day !', style: kTxtStl14B),
                          SizedBox(width: size.width * 0.12),
                          Text(
                            '${DateFormat('d MMM yyyy').format(DateTime.now())} | ${controller.timeString.value}',
                            style: kTxtStl14GreyN,
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.03),
                      activityButtonRow(context, size),
                      SizedBox(height: size.height * 0.03),
                      reportsTile(context),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
