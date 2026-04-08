import 'package:flutter/material.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/widgets/activitymenuview.dart';
import 'package:sysconn_sfa/widgets/reportmenuview.dart';

class BuddyMyActivityMenuView extends StatelessWidget {
  final buddySalesMyActivityList = [
    'My Customers',
    'Cold Visits',
    'Outstanding Followup',
    'Create Party',
    //'Support Ticket',
  ];
  final List salesTabList =
      Utility.cmpusertype.toUpperCase() == 'ADMIN' ||
          Utility.cmpusertype.toUpperCase() == 'OWNER'
      ? ['My \nActivity', 'Team Leader', 'Owner/Manager']
      : Utility.cmpusertype.toUpperCase() == 'TEAM LEADER'
      ? ['My \nActivity', 'Team Leader']
      : ['My \nActivity'];

  final List salesTabIconList =
      Utility.cmpusertype.toUpperCase() == 'ADMIN' ||
          Utility.cmpusertype.toUpperCase() == 'OWNER'
      ? [Icons.add_business, Icons.people, Icons.bar_chart]
      : Utility.cmpusertype.toUpperCase() == 'TEAM LEADER'
      ? [Icons.add_business, Icons.people]
      : [Icons.add_business];

  final buddySalesMyActivityPartyRemoveList = [
    'My Customers',
    'Cold Visits',
    'Outstanding Followup',
  ];

  final buddySalesMyReportList = [
    'My Sales Order Register',
    'Item Wise Sales Order Pending',
    //  'My Lead Register',
    'My Visit Register',
    'My Daily Performance Report',
    'My Sales Register',
    'My Collection Register',
    'My Customer List',
    'My Outstanding',
    'Closing Stock Report',
    'Inactive Customer Report',
    'Inactive Item Report',
    // 'Support Ticket Register',
    'Sales Monthly Report', //KOMAL D 14-10-2024 ADDED
    // 'Create Lead',
    // 'Create Contra', //komal D 22-11-2024 added
    // 'Contra List', //komal D 23-11-2024 added
    'Target Vs Actual', //komal D 13-11-2024 added
  ];

  final buddySalesMyActivityIconList = [
    Image(
      image: const AssetImage('assets/images/MyCustomer.png'),
      color: kAppIconColor,
    ),
    Image(
      image: const AssetImage('assets/images/ColdVisit.png'),
      color: kAppIconColor,
    ),
    Image(
      image: const AssetImage('assets/images/Payment.png'),
      color: kAppIconColor,
    ),
    Image(
      image: const AssetImage('assets/images/party.png'),
      color: kAppIconColor,
    ),
  ];

  BuddyMyActivityMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text('Activity', style: kTxtStl13B),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          elevation: 6.0,
          shadowColor: Theme.of(context).colorScheme.secondary,
          child: Container(
            height: size.height * 0.14,
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount:
                  (Utility.cmpusertype.toUpperCase() == 'ADMIN' ||
                      Utility.cmpusertype.toUpperCase() == 'OWNER')
                  ? buddySalesMyActivityList.length
                  : buddySalesMyActivityPartyRemoveList.length,
              itemBuilder: (context, i) {
                return ActivityMenuView(
                  title:buddySalesMyActivityList[i],
                  function: () {
                    // buddySalesMyActivityOnTap(context, i);
                  },
                  child: buddySalesMyActivityIconList[i],
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(9.0),
          child: Text('Reports', style: kTxtStl13B),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: buddySalesMyReportList.length,
            itemBuilder: (context, i) {
              return ReportMenuView(
                title: buddySalesMyReportList[i],
                function: () {
                  // buddySalesMyReportOnTap(context, i);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // void buddySalesMyActivityOnTap(BuildContext context, int i) {
  //   switch (i) {
  //     case 0:
  //       if (kDebugMode) {
  //         print('abhsajb');
  //       }
  //       Navigator.of(
  //         context,
  //       ).push(MaterialPageRoute(builder: (context) => const MyBeatList()));
  //       break;
  //     case 1:
  //       Navigator.of(context).push(
  //         MaterialPageRoute(builder: (context) => const ColdVisitReport()),
  //       );
  //       break;
  //     case 2:
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (context) => const OsReceivableDashboard(
  //             dashboardtypename: 'Outstanding Receivable',
  //           ),
  //         ),
  //       );
  //       break;
  //     case 3:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => PartyOnlineCreate(custGroup: 'Customer', isNavSales: true),
  //         ),
  //       ); 
  //       break;

  //     default:
  //   }
  // }

  // void buddySalesMyReportOnTap(BuildContext context, int i) {
  //   switch (i) {
  //     case 0:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const SalesOrderRegister()),
  //       );
  //       break;
  //     case 1:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const SOItemDetailsRegister(),
  //         ),
  //       );
  //       break;
  //     case 2:
  //       //commented
  //       //  Navigator.of(context).push(MaterialPageRoute(builder: (context) => VisitAttendanceSumRpt()));
  //       break;
  //     case 3:
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (context) => const DailyPerformanceReport(),
  //         ),
  //       );
  //       break;
  //     case 4:
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (context) => const SalesDashboard(vchType: 'Sales'),
  //         ),
  //       ); //const SalesRegister()));
  //       break;
  //     case 5:
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (context) => const CollectionReport(type: 'Receipt'),
  //         ),
  //       );
  //       break;
  //     case 6:
  //       // Navigator.of(context).push(MaterialPageRoute(builder: (context) => LedgerAttributeReport(mobilenoSelected: Utility.cmpmobileno,securityCountSelected: Utility.cmpSalesPersonCount,)));    // komal // 31-3-2023 // securitycount var added in parent class to set in api url
  //       break;
  //     case 7:
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (context) => const OsReceivableDashboard(
  //             dashboardtypename: 'Outstanding Receivable',
  //           ),
  //         ),
  //       );
  //       break;
  //     case 8:
  //       //Rupali 22-10-2024
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const ClosingStockOrderQuantityReport(),
  //         ),
  //       ); //pratiksha p 10-5-2023 changed from Closing Stock Report to Pending Closing Stock Report
  //       break;
  //     case 9:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const InactiveCustomerReport(),
  //         ),
  //       );
  //       break;
  //     case 10:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const InactiveItemReport()),
  //       );
  //       break;
  //     case 11:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const SalesAnalysis()),
  //       ); //komal d 14-10-2024 added
  //       break;
  //     case 12:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const SalesPersonAll()),
  //       ); //komal d 21-10-2024 added
  //       break;

  //     default:
  //   }
  // }
}

//====================================================================================
// sales team leader
class BuddySalesTLMenuView extends StatelessWidget {
  final buddySalesTLActivityList = [
    // 'Create Party Attribute',
    // 'Assign Party Attribute',
    'Order Approval',
    'Master',
    'Party Create',
  ];

  final buddySalesTLReportList = [
    'My Sales Order Register',
    'Item Wise Sales Order Pending',
    // 'Lead Register',
    'Visit Register',
    'Daily Performance Report',
    'Sales Register',
    'Collection Register',
    'My Customer List',
    'My product List',
    'Outstanding',
    'Closing Stock Report',
    'Inactive Customer Report',
    'Inactive Item Report',
  ];

  final buddySalesTLActivityIconList = [
    Image(
      image: const AssetImage('assets/images/Order Approval.png'),
      color: kAppIconColor,
    ),
    Image(
      image: const AssetImage('assets/images/Allocate-Customer-Attribute.png'),
      color: kAppIconColor,
    ),
    Image(
      image: const AssetImage('assets/images/Create-Customer.png'),
      color: kAppIconColor,
    ),
  ];

  BuddySalesTLMenuView({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.all(3.0),
          child: Text('Activity', style: kTxtStl13B),
        ),
        Card(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(14.0),
          ),
          elevation: 6.0,
          shadowColor: Theme.of(context).colorScheme.secondary,
          child: Container(
            height: size.height * 0.14,
            padding: const EdgeInsets.fromLTRB(4, 8, 4, 8),
            child: ListView.builder(
              scrollDirection: Axis.horizontal,
              itemCount: buddySalesTLActivityList.length,
              itemBuilder: (context, i) {
                return ActivityMenuView(
                  title: buddySalesTLActivityList[i],
                  function: () {
                    // buddySalesTLActivityOnTap(context, i);
                  },
                  child: buddySalesTLActivityIconList[i],
                );
              },
            ),
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(9.0),
          child: Text('Reports', style: kTxtStl13B),
        ),
        Expanded(
          child: ListView.builder(
            itemCount: buddySalesTLReportList.length,
            itemBuilder: (context, i) {
              return ReportMenuView(
                title: buddySalesTLReportList[i],
                function: () {
                  // buddySalesTLReportOnTap(context, i);
                },
              );
            },
          ),
        ),
      ],
    );
  }

  // void buddySalesTLActivityOnTap(BuildContext context, int i) {
  //   switch (i) {
  //     case 0:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const SalesOrderRegister()),
  //       );
  //       break;
  //     case 1:
  //       Navigator.of(
  //         context,
  //       ).push(MaterialPageRoute(builder: (context) => DataEntryTrnMenuView()));
  //       break;
  //     case 2:
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (context) =>
  //               PartyOnlineCreate(isNavSales: true, custGroup: 'Customer'),
  //         ),
  //       );
  //       break;
  //     default:
  //   }
  // }

  // void buddySalesTLReportOnTap(BuildContext context, int i) {
  //   switch (i) {
  //     case 0:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const SalesOrderRegister()),
  //       );
  //       break;
  //     case 1:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const SOItemDetailsRegister(),
  //         ),
  //       );
  //       break;
  //     case 2:
  //       Navigator.of(context).push(
  //         MaterialPageRoute(builder: (context) => ColdVisitReport()),
  //       ); //VisitAttendanceSumRpt()));
  //       break;
  //     case 3:
  //       Navigator.of(context).push(
  //         MaterialPageRoute(builder: (context) => DailyPerformanceReport()),
  //       );
  //       break;
  //     case 4:
  //       // Navigator.of(context).push(MaterialPageRoute(builder: (context) => SalesDashboard(dashboardtypename: 'Sales',salesPersonCount: Utility.cmpSalesPersonCount, mobileno: Utility.cmpmobileno)));
  //       break;
  //     case 5:
  //       //Navigator.of(context).push(MaterialPageRoute(builder: (context) => CollectionDashboard(dashboardtypename: 'Receipt',salesPersonCount: Utility.cmpSalesPersonCount,mobileno: Utility.cmpmobileno)));
  //       break;
  //     case 6:
  //       // Navigator.of(context).push(MaterialPageRoute(builder: (context) => LedgerAttributeReport(mobilenoSelected: Utility.cmpmobileno,securityCountSelected: Utility.cmpSalesPersonCount,)));    // komal // 31-3-2023 // securitycount var added in parent class to set in api url
  //       break;
  //     case 7:
  //       // Navigator.of(context).push(MaterialPageRoute(builder: (context) => ItemAtrributeReport()));
  //       break;
  //     case 8:
  //       Navigator.of(context).push(
  //         MaterialPageRoute(
  //           builder: (context) => const OsReceivableDashboard(
  //             dashboardtypename: 'Outstanding Receivable',
  //           ),
  //         ),
  //       );
  //       break;
  //     case 9:
  //       // Navigator.push(context,MaterialPageRoute(builder: (context) => ClosingStockOrderQuantityReport()),);// ClosingStockReport()),);   //pratiksha p 10-5-2023 changed from Closing Stock Report to Pending Closing Stock Report
  //       break;
  //     case 10:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(
  //           builder: (context) => const InactiveCustomerReport(),
  //         ),
  //       );
  //       break;
  //     case 11:
  //       Navigator.push(
  //         context,
  //         MaterialPageRoute(builder: (context) => const InactiveItemReport()),
  //       );
  //       break;
  //     default:
  //   }
  // }
}
