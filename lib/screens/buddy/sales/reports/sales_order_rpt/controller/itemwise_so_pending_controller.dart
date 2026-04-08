import 'package:get/get.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/order/sales_order_report_entity.dart';
import 'package:trina_grid/trina_grid.dart';

class SOItemDetailsController extends GetxController {
  // ───────── Grid ─────────
  TrinaGridStateManager? stateManager;
  final RxList<TrinaRow> rows = <TrinaRow>[].obs;
  final RxInt loadState = 0.obs; 
  Rx<DateTime> fromDate = DateTime.now().obs;
  Rx<DateTime> toDate = DateTime.now().obs;

   @override
  void onInit() {
    super.onInit();
    fetchSalesOrders();
  }
    // ───────── API ─────────
  Future<void> fetchSalesOrders() async {
    loadState.value = 0;
    rows.clear();
    final data = await ApiCall.getSalesOrderDetailsRegisterAPI(  fromdate: fromDate.toString(),
      todate: toDate.toString(),status: '');
    if (data.isEmpty) {
      loadState.value = 2;
      return;
    }
    rows.addAll(data.map(_mapToRow));
    loadState.value = 1;
  }

  TrinaRow _mapToRow(SOReportEntity e) {
    return TrinaRow(
      cells: {
        // 'actions': TrinaCell(value: ''),
        // 'inv_id': TrinaCell(value: e.invId),
        // 'hed_unique_id': TrinaCell(value: e.hedUniqueId),
        'status': TrinaCell(
          value:
           (e.soinvapprovalstatus?.isEmpty ?? true)
              ? 'PENDING'
              : e.soinvapprovalstatus!.toUpperCase(),//renderer: (context) => StatusBadge(status: e.soinvapprovalstatus  ?? 'Draft',),
        ),
        'date': TrinaCell(
          value:e.date// DateFormat('dd-MM-yyyy').format(DateTime.parse(e.date!)),
        ),
        'order_no': TrinaCell(value: e.invoiceNo),
        'party': TrinaCell(value: e.partyName),
        'item_name': TrinaCell(value: e.itemName),
        'quantity': TrinaCell(value: e.quantity),
        'salequantity': TrinaCell(value: e.salequantity),
        'balancequantity': TrinaCell(value: e.balancequantity),
        'rate': TrinaCell(value: double.tryParse(e.rate ?? '') ?? 0),
        'disc': TrinaCell(value: double.tryParse(e.discount ?? '') ?? 0),
        'value': TrinaCell(value: double.tryParse(e.value ?? '') ?? 0),
        'user_remark': TrinaCell(value: e.userRemark),
        'approver_remark': TrinaCell(value: e.invapprovalRemark),
        'preclose': TrinaCell(value: e.preclose),
        'sales_person': TrinaCell(value: e.salesPerson),
        'due_date': TrinaCell(value: e.duedate),
      },
    );
  }

}
