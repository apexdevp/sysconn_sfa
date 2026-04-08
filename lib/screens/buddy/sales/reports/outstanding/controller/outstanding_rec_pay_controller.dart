import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/outstanding/os_ageing_sum_entity.dart';
import 'package:sysconn_sfa/api/entity/buddy/outstanding/paymentfollowupentity.dart';
import 'package:trina_grid/trina_grid.dart';

class OsRecPayDashboardController extends GetxController
    with GetSingleTickerProviderStateMixin {
  final String dashboardtypename;
  final String? mobileno;
  final int? salesPersonCount;

  OsRecPayDashboardController({
    required this.dashboardtypename,
    this.mobileno,
    this.salesPersonCount,
  });

  var menuIndexSelected = 0.obs;

  late TabController osTabController;
  DateTime fromDate = DateTime.parse(
    DateFormat('yyyy-MM-dd').format(DateTime.now()),
  );
  String? type;

  var osTypeSelected = 'Party'.obs;
  var osAgeBySelected = 'Due Date'.obs;
  var outAgeingSelected = 'ALL'.obs;

  var isDataLoad = 0.obs;
  var isGraphDataLoad = 0.obs;
  RxDouble gridDataTotal = 0.0.obs;
  List<String> osDashTabMenuList = [];
  // List<String> osTypeItem = [];
  late List osTypeItem = dashboardtypename == 'Outstanding Receivable'
      ? ['Party', 'Party Group', 'Sales Person']
      : ['Party', 'Party Group'];
  List<String> osAgeByItem = ['Invoice Date', 'Due Date'];
  List<String> outAgeingItem = [
    'ALL',
    'Due',
    'Not Due',
    '<30',
    '31-60',
    '61-90',
    '91-120',
    '121-180',
    '>180',
  ];
  var osRecPayDashboardGraphItem = <Map<String, dynamic>>[
    {"Name": "< 30", "Amount": 0.0},
    {"Name": "31-60", "Amount": 0.0},
    {"Name": "61-90", "Amount": 0.0},
    {"Name": "91-120", "Amount": 0.0},
    {"Name": "121-180", "Amount": 0.0},
    {"Name": "> 180", "Amount": 0.0},
  ].obs;
  var xAxisData = <String>[].obs; // X-axis labels
  var yAxisData = <int>[].obs;

  var outstandingRecPayDashboardDataList =
      <OutstandingRecPayAgeSumEntity>[].obs;

  var rows = <TrinaRow>[].obs;

  TrinaGridStateManager? stateManager;

  var partycount = 0.obs;
  var regularcount = 0.obs;
  var disputecount = 0.obs;
  var nofollowupcount = 0.obs;
  var needAttentioncount = 0.obs;
  var escalatedcount = 0.obs;

  var followupTypeSelected = 'Total'.obs;
  RxBool isTodayFolwPendingClk = false.obs;
  // PaymentFollowupEntity? paymentFollowupEntity;
  Rxn<PaymentFollowupEntity> paymentFollowupEntity = Rxn();
  @override
  void onInit() {
    super.onInit();
    type = dashboardtypename == 'Outstanding Receivable'
        ? 'Receivable'
        : 'Payable';

    osDashTabMenuList = dashboardtypename == 'Outstanding Payable'
        ? ['Payable']
        : ['Receivable', 'Today\'s Followup', 'Followup Type'];

    osTabController = TabController(
      length: osDashTabMenuList.length,
      vsync: this,
    );

    osTabController.addListener(() async {
      if (osTabController.indexIsChanging) return;

      menuIndexSelected.value = osTabController.index;

      if (menuIndexSelected.value == 0) {
        await getOutstandingRecPayGraphDataAPI();
      }

      await getOutstandingRecPayPartyDataAPI();
    });

    callInitFun(); // SAME METHOD NAME
  }

  /// ====== Dropdown Changes ======
  void changeType(String? val) {
    if (val == null) return;

    osTypeSelected.value = val;

    if (val != 'Party') {
      outAgeingSelected.value = 'ALL';
    }

    callInitFun();
  }

  void changeSubType(String? val) {
    if (val == null) return;
    osAgeBySelected.value = val;
    callInitFun();
  }

  void changeAgeing(String? val) {
    if (val == null) return;
    outAgeingSelected.value = val;
    callInitFun();
  }

  Future<void> callInitFun() async {
    if (menuIndexSelected.value == 0) {
      await getOutstandingRecPayGraphDataAPI();
    }

    await getOutstandingRecPayPartyDataAPI();
    await getTodaysFollowupDataAPI();
  }

  Future<bool> getTodaysFollowupDataAPI() async {
    try {
      await ApiCall.getTodyfollowupapi(fromDate.toString()).then((
        paymentvalue,
      ) {
        print("API Response: $paymentvalue"); // debug
        paymentFollowupEntity.value = paymentvalue;
      });
    } catch (ex) {
      print(ex);
    }

    return true;
  }

  // Fetch graph data
  Future<void> getOutstandingRecPayGraphDataAPI() async {
    isGraphDataLoad.value = 0; // loading

    try {
      final outrecpaygraphValue = await ApiCall.getosrecPayGraphAPI(
        ageby: osAgeBySelected.value,
      );
      if (outrecpaygraphValue.isNotEmpty) {
        // for (int i = 0; i < outrecpaygraphValue.length; i++) {
        //   final outstandingRecPayAgeSumEntity =
        //       OutstandingRecPayAgeSumEntity.fromJson(outrecpaygraphValue[i]);

        //   // Update reactive list
        //   osRecPayDashboardGraphItem[0]['Amount'] =
        //       outstandingRecPayAgeSumEntity.dAYS0TO30!;
        //   osRecPayDashboardGraphItem[1]['Amount'] =
        //       outstandingRecPayAgeSumEntity.dAYS31TO60!;
        //   osRecPayDashboardGraphItem[2]['Amount'] =
        //       outstandingRecPayAgeSumEntity.dAYS61TO90!;
        //   osRecPayDashboardGraphItem[3]['Amount'] =
        //       outstandingRecPayAgeSumEntity.dAYS91TO120!;
        //   osRecPayDashboardGraphItem[4]['Amount'] =
        //       outstandingRecPayAgeSumEntity.dAYS121TO180!;
        //   osRecPayDashboardGraphItem[5]['Amount'] =
        //       outstandingRecPayAgeSumEntity.mORETHAN180DAYS!;
        // }
        //      isGraphDataLoad.value = 1; // data loaded
        final entity = OutstandingRecPayAgeSumEntity.fromJson(
          outrecpaygraphValue[0],
        );

        osRecPayDashboardGraphItem.assignAll([
          {"Name": "< 30", "Amount": entity.dAYS0TO30 ?? 0},
          {"Name": "31-60", "Amount": entity.dAYS31TO60 ?? 0},
          {"Name": "61-90", "Amount": entity.dAYS61TO90 ?? 0},
          {"Name": "91-120", "Amount": entity.dAYS91TO120 ?? 0},
          {"Name": "121-180", "Amount": entity.dAYS121TO180 ?? 0},
          {"Name": "> 180", "Amount": entity.mORETHAN180DAYS ?? 0},
        ]);

        // Update chart axes
        xAxisData.value = osRecPayDashboardGraphItem
            .map((e) => e['Name'].toString())
            .toList();
        yAxisData.value = osRecPayDashboardGraphItem
            .map((e) => double.tryParse(e['Amount'].toString())?.round() ?? 0)
            .toList();

        isGraphDataLoad.value = 1;
      } else {
        isGraphDataLoad.value = 2; // no data
      }
    } catch (e) {
      print("Error fetching graph data: $e");
      isGraphDataLoad.value = 2; // treat as no data
    }
  }
Future<int> getOutstandingRecPayPartyDataAPI() async {
  isDataLoad.value = 0;

  rows.clear();
  outstandingRecPayDashboardDataList.clear();
  gridDataTotal.value = 0.0;

  partycount.value = 0;
  regularcount.value = 0;
  disputecount.value = 0;
  nofollowupcount.value = 0;
  needAttentioncount.value = 0;
  escalatedcount.value = 0;

  /// ✅ Helper for safe compare
  String normalize(String? val) {
    return val?.trim().toLowerCase() ?? '';
  }

  final outrecpayValue = await ApiCall.getOSRecPayDashDataAPI(
    ageby: osAgeBySelected.value,
    subtype: osTypeSelected.value,
  );

  if (outrecpayValue.isNotEmpty) {
    /// =========================
    /// ✅ FIRST PASS (COUNTING)
    /// =========================
    for (var item in outrecpayValue) {
      final entity = OutstandingRecPayAgeSumEntity.fromJson(item);
      final followType = normalize(entity.followUpType);

      switch (followType) {
        case 'regular':
          regularcount.value++;
          break;

        case 'dispute':
          disputecount.value++;
          break;

        case 'escalated':
          escalatedcount.value++;
          break;

        case '':
          nofollowupcount.value++;
          break;

        default:
          nofollowupcount.value++;
      }
    }

    /// =========================
    /// ✅ SECOND PASS (FILTER + GRID)
    /// =========================
    for (var item in outrecpayValue) {
      final entity = OutstandingRecPayAgeSumEntity.fromJson(item);

      bool shouldAdd = false;
      double amount = entity.pENDINGAMOUNT ?? 0.0;

      final followType = normalize(entity.followUpType);
      final selectedType = normalize(followupTypeSelected.value);

      /// =========================
      /// TODAY FOLLOWUP TAB
      /// =========================
      if (menuIndexSelected.value == 1 && type == 'Receivable') {
        if (isTodayFolwPendingClk.value &&
            DateFormat('yyyy-MM-dd').format(fromDate) ==
                entity.nEXTFOLLOWUPDATE) {
          shouldAdd = true;
        } else if (entity.nEXTFOLLOWUPDATE?.isNotEmpty == true &&
            fromDate.compareTo(DateTime.parse(entity.nEXTFOLLOWUPDATE!)) >= 0) {
          shouldAdd = true;
        }

        if (DateFormat('yyyy-MM-dd').format(fromDate) ==
            entity.nEXTFOLLOWUPDATE) {
          partycount.value++;
        }
      }

      /// =========================
      /// RECEIVABLE TAB FILTER
      /// =========================
      else if (menuIndexSelected.value == 0 &&
          osTypeSelected.value == 'Party') {
        switch (outAgeingSelected.value) {
          case 'Due':
            if ((entity.dUE ?? 0) != 0) {
              shouldAdd = true;
              amount = entity.dUE!;
            }
            break;

          case 'Not Due':
            if ((entity.nOTDUE ?? 0) != 0) {
              shouldAdd = true;
              amount = entity.nOTDUE!;
            }
            break;

          case '<30':
            if ((entity.dAYS0TO30 ?? 0) != 0) {
              shouldAdd = true;
              amount = entity.dAYS0TO30!;
            }
            break;

          case '31-60':
            if ((entity.dAYS31TO60 ?? 0) != 0) {
              shouldAdd = true;
              amount = entity.dAYS31TO60!;
            }
            break;

          case '61-90':
            if ((entity.dAYS61TO90 ?? 0) != 0) {
              shouldAdd = true;
              amount = entity.dAYS61TO90!;
            }
            break;

          case '91-120':
            if ((entity.dAYS91TO120 ?? 0) != 0) {
              shouldAdd = true;
              amount = entity.dAYS91TO120!;
            }
            break;

          case '121-180':
            if ((entity.dAYS121TO180 ?? 0) != 0) {
              shouldAdd = true;
              amount = entity.dAYS121TO180!;
            }
            break;

          case '>180':
            if ((entity.mORETHAN180DAYS ?? 0) != 0) {
              shouldAdd = true;
              amount = entity.mORETHAN180DAYS!;
            }
            break;

          case 'ALL':
            shouldAdd = true;
            break;
        }
      }

      /// =========================
      /// FOLLOWUP TYPE TAB
      /// =========================
      else if (menuIndexSelected.value == 2) {
        if (selectedType == 'total' ||
            followType == selectedType ||
            (followType.isEmpty && selectedType == 'no followup')) {
          shouldAdd = true;
        }
      }

      /// DEFAULT
      else {
        shouldAdd = true;
      }

      /// =========================
      /// ADD TO GRID
      /// =========================
      if (shouldAdd) {
        outstandingRecPayDashboardDataList.add(entity);
        gridDataTotal.value += amount;

        rows.add(
          TrinaRow(
            cells: {
              'name': TrinaCell(value: entity.nAME),
              'date': TrinaCell(value: entity.nEXTFOLLOWUPDATE ?? ''),
              'amount': TrinaCell(
                value: Utility.dashAmtScaleSelected == 'Actuals'
                    ? amount
                    : amtFormat(value: amount.toString()),
              ),
              'id': TrinaCell(value: entity.iD),
              'followup_type': TrinaCell(value: entity.followUpType),
            },
          ),
        );
      }
    }

    isDataLoad.value = 1;
  } else {
    isDataLoad.value = 2;
  }

  return isDataLoad.value;
}
 
  // Future<int> getOutstandingRecPayPartyDataAPI() async {
  //   isDataLoad.value = 0;
  //   rows.clear();
  //   outstandingRecPayDashboardDataList.clear();
  //   gridDataTotal.value = 0.0;
  //   partycount.value = 0;
  //   regularcount.value = 0;
  //   disputecount.value = 0;
  //   nofollowupcount.value = 0;
  //   needAttentioncount.value = 0;
  //   escalatedcount.value = 0;

  //   final outrecpayValue = await ApiCall.getOSRecPayDashDataAPI(
  //     ageby: osAgeBySelected.value,
  //     subtype: osTypeSelected.value,
  //   );

  //   if (outrecpayValue.isNotEmpty) {
  //     /// FIRST PASS
  //     for (var item in outrecpayValue) {
  //       final entity = OutstandingRecPayAgeSumEntity.fromJson(item);
  //       final followType = entity.followUpType?.trim().toLowerCase();

  //       // switch (entity.followUpType) {
  //       //   case 'Dispute':
  //       //     disputecount.value++;
  //       //     break;
  //       //   case 'Regular':
  //       //     regularcount.value++;
  //       //     break;
  //       //   case 'Escalated':
  //       //     escalatedcount.value++;
  //       //     break;
  //       //   case '':
  //       //   case null:
  //       //     nofollowupcount.value++;
  //       //     break;
  //       // }
  //       switch (followType) {
  //         case 'regular':
  //           regularcount.value++;
  //           break;

  //         case 'dispute':
  //           disputecount.value++;
  //           break;

  //         case 'escalated':
  //           escalatedcount.value++;
  //           break;

  //         case '':
  //         case null:
  //           nofollowupcount.value++;
  //           break;
  //       }
  //     }

  //     /// SECOND PASS
  //     for (var item in outrecpayValue) {
  //       final entity = OutstandingRecPayAgeSumEntity.fromJson(item);

  //       bool shouldAdd = false;
  //       double amount = entity.pENDINGAMOUNT ?? 0.0;

  //       if (menuIndexSelected.value == 1 && type == 'Receivable') {
  //         if (isTodayFolwPendingClk.value &&
  //             DateFormat('yyyy-MM-dd').format(fromDate) ==
  //                 entity.nEXTFOLLOWUPDATE) {
  //           shouldAdd = true;
  //         } else if (entity.nEXTFOLLOWUPDATE?.isNotEmpty == true &&
  //             fromDate.compareTo(DateTime.parse(entity.nEXTFOLLOWUPDATE!)) >=
  //                 0) {
  //           shouldAdd = true;
  //         }

  //         if (DateFormat('yyyy-MM-dd').format(fromDate) ==
  //             entity.nEXTFOLLOWUPDATE) {
  //           partycount.value++;
  //         }
  //       } else if (menuIndexSelected.value == 0 &&
  //           osTypeSelected.value == 'Party') {
  //         switch (outAgeingSelected.value) {
  //           case 'Due':
  //             if (entity.dUE != 0.0) {
  //               shouldAdd = true;
  //               amount = entity.dUE!;
  //             }
  //             break;

  //           case 'Not Due':
  //             if (entity.nOTDUE != 0.0) {
  //               shouldAdd = true;
  //               amount = entity.nOTDUE!;
  //             }
  //             break;

  //           case '<30':
  //             if (entity.dAYS0TO30 != 0.0) {
  //               shouldAdd = true;
  //               amount = entity.dAYS0TO30!;
  //             }
  //             break;

  //           case '31-60':
  //             if (entity.dAYS31TO60 != 0.0) {
  //               shouldAdd = true;
  //               amount = entity.dAYS31TO60!;
  //             }
  //             break;

  //           case '61-90':
  //             if (entity.dAYS61TO90 != 0.0) {
  //               shouldAdd = true;
  //               amount = entity.dAYS61TO90!;
  //             }
  //             break;

  //           case '91-120':
  //             if (entity.dAYS91TO120 != 0.0) {
  //               shouldAdd = true;
  //               amount = entity.dAYS91TO120!;
  //             }
  //             break;

  //           case '121-180':
  //             if (entity.dAYS121TO180 != 0.0) {
  //               shouldAdd = true;
  //               amount = entity.dAYS121TO180!;
  //             }
  //             break;

  //           case '>180':
  //             if (entity.mORETHAN180DAYS != 0.0) {
  //               shouldAdd = true;
  //               amount = entity.mORETHAN180DAYS!;
  //             }
  //             break;

  //           case 'ALL':
  //             shouldAdd = true;
  //             break;
  //         }
  //       } else if (menuIndexSelected.value == 2) {
  //         if (followupTypeSelected.value == 'Total' ||
  //             entity.followUpType == followupTypeSelected.value ||
  //             (entity.followUpType == '' &&
  //                 followupTypeSelected.value == 'No Followup')) {
  //           shouldAdd = true;
  //         }
  //       } else {
  //         shouldAdd = true;
  //       }

  //       if (shouldAdd) {
  //         outstandingRecPayDashboardDataList.add(entity);
  //         gridDataTotal.value += amount;

  //         rows.add(
  //           TrinaRow(
  //             cells: {
  //               'name': TrinaCell(value: entity.nAME),
  //               'date': TrinaCell(value: entity.nEXTFOLLOWUPDATE ?? ''),
  //               'amount': TrinaCell(
  //                 value: Utility.dashAmtScaleSelected == 'Actuals'
  //                     ? amount
  //                     : amtFormat(value: amount.toString()),
  //               ),
  //               'id': TrinaCell(value: entity.iD),
  //               'followup_type': TrinaCell(value: entity.followUpType),
  //             },
  //           ),
  //         );
  //       }
  //     }

  //     isDataLoad.value = 1;
  //   } else {
  //     isDataLoad.value = 2;
  //   }

  //   return isDataLoad.value;
  // }

  @override
  void onClose() {
    osTabController.dispose();
    super.onClose();
  }
}

// class OsRecPayDashboardController extends GetxController
//     with GetSingleTickerProviderStateMixin {

//   /// ====== Constructor Data ======
//   late String dashboardTypeName;
//   late String type;

//   /// ====== Tabs ======
//   late TabController osTabController;
//   var menuIndexSelected = 0.obs;

//   /// ====== Dropdown Data ======
//   var osTypeItem = <String>[].obs;
//   var osTypeSelected = 'Party'.obs;

//   var osAgeByItem = ['Invoice Date', 'Due Date'].obs;
//   var osAgeBySelected = 'Due Date'.obs;

//   var outAgeingItem = [
//     'ALL', 'Due', 'Not Due',
//     '<30', '31-60', '61-90',
//     '91-120', '121-180', '>180'
//   ].obs;

//   var outAgeingSelected = 'ALL'.obs;

//   /// ====== Init ======
//   void init(String dashboardtypename) {

//     dashboardTypeName = dashboardtypename;

//     type = dashboardtypename == 'Outstanding Receivable'
//         ? 'Receivable'
//         : 'Payable';

//     osTypeItem.value =
//         dashboardtypename == 'Outstanding Receivable'
//             ? ['Party', 'Party Group', 'Sales Person']
//             : ['Party', 'Party Group'];

//     osTabController = TabController(
//       length: type == 'Receivable' ? 3 : 1,
//       vsync: this,
//     );

//     osTabController.addListener(() {
//       if (osTabController.indexIsChanging) return;

//       menuIndexSelected.value = osTabController.index;
//       callInitFun();
//     });

//     callInitFun();
//   }

//   /// ====== Dropdown Changes ======
//   void changeType(String? val) {
//     if (val == null) return;

//     osTypeSelected.value = val;

//     if (val != 'Party') {
//       outAgeingSelected.value = 'ALL';
//     }

//     callInitFun();
//   }

//   void changeSubType(String? val) {
//     if (val == null) return;
//     osAgeBySelected.value = val;
//     callInitFun();
//   }

//   void changeAgeing(String? val) {
//     if (val == null) return;
//     outAgeingSelected.value = val;
//     callInitFun();
//   }

//   /// ====== API Caller ======
//   Future<void> callInitFun() async {

//     if (menuIndexSelected.value == 0) {
//       await getOutstandingRecPayGraphDataAPI();
//     }

//     await getOutstandingRecPayPartyDataAPI();
//   }

//   /// ====== Dummy APIs ======
//   Future<void> getOutstandingRecPayGraphDataAPI() async {
//     print("Graph API Called");
//   }

//   Future<void> getOutstandingRecPayPartyDataAPI() async {
//     print("Party API Called");
//   }

//   @override
//   void onClose() {
//     osTabController.dispose();
//     super.onClose();
//   }
// }
