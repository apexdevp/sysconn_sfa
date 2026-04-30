import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/sales/sales_register_entity.dart';
import 'package:trina_grid/trina_grid.dart';

class SalesReportController extends GetxController {
  final String vchType;
  final String partyid;
  var isDataLoad = 0.obs; // 0=loading,1=data,2=no data
  // var rows = <PartyEntity>[].obs;
  // Rxn<GroupMasterEntity> selectedGroup = Rxn<GroupMasterEntity>();
  RxString ledgerGroupName = ''.obs;
  RxString ledgerGroupId = ''.obs;
  RxString primaryGroup = ''.obs;
  TrinaGridStateManager? stateManager;
  // RxList<GroupMasterEntity> groupEntityList = <GroupMasterEntity>[].obs;
  var refreshId = 0.obs;
  late VoidCallback stateListener1;
  List<SalesRegisterEntity>? reportlist;

  var rows = <TrinaRow>[].obs;
  var ledgerName = ''.obs;
  var ledgerId = ''.obs;

  SalesReportController({required this.vchType, this.partyid = ''});

  @override
  void onInit() {
    super.onInit();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      //   Utility.set(Get.context!, 'Current Month');

      if (kDebugMode) {
        debugPrint('fromdate ${Utility.selectedFromDateOfDateController}');
        debugPrint('todate ${Utility.selectedToDateOfDateController}');
      }
      salesRegisterRepAPI();
    });
  }

  // void resetLedgerFields() {
  //   ledgerName.value = '';
  //   ledgerId.value = '';
  //   selectedGroup.value = null;
  // }

  Future<void> salesRegisterRepAPI() async {
    isDataLoad.value = 0;
    rows.clear();

    ApiCall.getSalesRegisterReport(vchType: vchType, partyid: partyid).then((
      salesRegisterListData,
    ) {
      if (salesRegisterListData.isNotEmpty) {
        reportlist = salesRegisterListData;
        // rows.addAll(
        //   salesRegisterListData.map((data) {
        //     return TrinaRow(
        //       cells: {
        //         'action': TrinaCell(value: ''),
        //         'unique_id': TrinaCell(value: data.uniqueid),
        //         'date': TrinaCell(value: data.date),
        //         'voucher_type': TrinaCell(value: data.vouchertype),
        //         'invoice_no': TrinaCell(value: data.invoiceno),
        //         'party': TrinaCell(value: data.partyName),
        //         'total_qty': TrinaCell(value: data.totalqty),
        //         'total_ammount': TrinaCell(
        //           value:
        //               double.tryParse(
        //                 data.totalammount.toString().replaceAll(',', ''),
        //               ) ??
        //               0.0,
        //         ),
        //         // 'total_ammount': TrinaCell(value:  double.tryParse(data.totalammount.toString()) ?? 0.0),//data.totalammount,),
        //         'tallystatus': TrinaCell(value: data.tallystatus),
        //         'tallysyncdate': TrinaCell(value: data.tallysyncdate),
        //         'deletestatus': TrinaCell(value: data.deletestatus),
        //         'approval_status': TrinaCell(
        //           value: data.approvalstatus == ''
        //               ? 'PENDING'
        //               : data.approvalstatus,
        //         ), //pratiksha p 20-10-2024 add
        //         'cashamount': TrinaCell(
        //           value: data.cashamount,
        //         ), //pooja // 17-03-2026 // add
        //         'cardamount': TrinaCell(value: data.cardamount),
        //         'bankamount': TrinaCell(value: data.bankamount),
        //         'vouchergift': TrinaCell(value: data.vouchergift),
        //         'totalamt': TrinaCell(value: data.totalamt),
        //         'balance': TrinaCell(value: data.balance),
        //       },
        //     );
        //   }).toList(),
        // );
        isDataLoad.value = 1;
      } else {
        isDataLoad.value = 2;
      }
      if (kDebugMode) {
        debugPrint('isDataLoad.value ${isDataLoad.value}');
      }
    });
  }
}
