import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/taskboard/taskboard_report_entity.dart';
import 'package:trina_grid/trina_grid.dart';

class TaskController extends GetxController {
  var isDataLoad = 0.obs;
  var rows = <TrinaRow>[].obs;
  TrinaGridStateManager? stateManager;
  var isPinnedPanelOpen = false.obs;
  String screenType = "";
  bool showAllInitially = false;
  RxString activeTab = "overview".obs;
  RxList<int> statusCounts = List.filled(6, 0).obs;
  RxString selectStatus = ''.obs;
  RxList<TrinaRow> filteredRows = <TrinaRow>[].obs;
  Rx<DateTime> fromDate = DateTime(
    DateTime.now().year,
    DateTime.now().month,
    1,
  ).obs;
  Rx<DateTime> toDate = DateTime(
    DateTime.now().year,
    DateTime.now().month + 1,
    0,
  ).obs;

  //appbar filtered button
  var isSearch = false.obs;
  TextEditingController searchController = TextEditingController();
  List<TrinaRow> _allFilteredRows = [];

  @override
  void onInit() {
    super.onInit();
    screenType = Get.arguments?['type'] ?? '';
    showAllInitially = Get.arguments?['showAll'] ?? false;
    WidgetsBinding.instance.addPostFrameCallback((_) async {
      _fetchData();
    });
  }

  @override
  void onClose() {
    rows.clear();
    filteredRows.clear();
    stateManager = null;
    super.onClose();
  }


  void onSearchTextChanged(String text) {
  if (text.isEmpty) {
    isSearch.value = false;
    // Restore rows based on current status filter
    filterByStatus(
      selectStatus.value.isEmpty ? null : int.tryParse(selectStatus.value),
    );
    return;
  }

  isSearch.value = true;

  // Search within currently filteredRows (respects active status filter)
  final results = filteredRows
      .where(
        (row) =>
            row.cells['customer_name']
                ?.value
                ?.toString()
                .toLowerCase()
                .contains(text.toLowerCase()) ??
            false,
      )
      .toList();

  filteredRows.assignAll(results);
}

void clearSearch() {
  searchController.clear();
  onSearchTextChanged('');
  isSearch.value = false;
}

  //Display ount of rows as per status
  void updateStatusCounts() {
    statusCounts.value = List.filled(6, 0);
    for (var row in rows) {
      final status = row.cells['status']?.value.toString() ?? '';
      final index = int.tryParse(status);
      if (index != null && index >= 0 && index < 6) {
        statusCounts[index]++;
      }
    }
  }

  //call methode as per screentype
  void _fetchData() {
    if (screenType == "support") {
      getSupportTaskData();
    } else if (screenType == "sales") {
      getSalesTaskData();
    } else {
      isDataLoad.value = 2;
      if (kDebugMode) print('Unknown screenType: $screenType');
    }
  }

  //before calling api clear rows and fetch data
  void _resetData() {
    isDataLoad.value = 0;
    rows.clear();
    filteredRows.clear();
    statusCounts.value = List.filled(6, 0);
  }

  //filter data as per selected status and show in gride
  // void filterByStatus(String statusIndex) {
  //   selectStatus.value = statusIndex;
  //   stateManager = null;
  //   filteredRows.clear();
  //   if (statusIndex.isEmpty) {
  //     filteredRows.value = List.from(rows);
  //   } else {
  //     filteredRows.value = rows
  //         .where((row) => row.cells['status']?.value.toString() == statusIndex)
  //         .toList();
  //   }
  // }

  // void filterByStatus(int? statusIndex) {
  //   selectStatus.value = statusIndex.toString();
  //   List<TrinaRow> tempList;

  //   if (statusIndex == null) {
  //     tempList = List.from(rows);
  //   } else {
  //     tempList = rows.where((row) {
  //       return row.cells['status']?.value == statusIndex;
  //     }).toList();
  //   }

  //   final newRows = tempList.map((row) {
  //     return TrinaRow(
  //       cells: Map.fromEntries(
  //         row.cells.entries.map(
  //           (e) => MapEntry(e.key, TrinaCell(value: e.value.value)),
  //         ),
  //       ),
  //     );
  //   }).toList();

  //   if (stateManager != null) {
  //     stateManager!.removeAllRows();
  //     stateManager!.appendRows(newRows);
  //   }

  //   /// optional (for consistency)
  //   filteredRows.assignAll(newRows);
  // }

  void filterByStatus(int? statusIndex) {
    selectStatus.value = statusIndex?.toString() ?? '';

    List<TrinaRow> tempList;

    if (statusIndex == null) {
      tempList = List.from(rows);
    } else {
      tempList = rows.where((row) {
        final cellValue = row.cells['status']?.value;
        // Handle both int and String stored values
        if (cellValue is int) return cellValue == statusIndex;
        return int.tryParse(cellValue?.toString() ?? '') == statusIndex;
      }).toList();
    }

    final newRows = tempList.map((row) {
      return TrinaRow(
        cells: Map.fromEntries(
          row.cells.entries.map(
            (e) => MapEntry(e.key, TrinaCell(value: e.value.value)),
          ),
        ),
      );
    }).toList();

    // Update filteredRows first (drives the Obx UI check)
    filteredRows.assignAll(newRows);

    // Update stateManager only if it's ready
    if (stateManager != null) {
      stateManager!.removeAllRows();
      if (newRows.isNotEmpty) {
        stateManager!.appendRows(newRows);
      }
    }
  }

  // after data load show data as per condition basis
  // void _afterDataLoaded() {
  //   updateStatusCounts();
  //   if (showAllInitially) {
  //     filteredRows.value = List.from(rows);
  //     selectStatus.value = '';
  //   } else {
  //     filterByStatus(0);
  //   }
  // }
  void _afterDataLoaded() {
    updateStatusCounts();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (showAllInitially) {
        selectStatus.value = '';
        filteredRows.assignAll(List.from(rows));
      } else {
        filterByStatus(0); // Show "Pending" by default
      }
    });
  }

  //call only when screentype is support
  Future<void> getSupportTaskData() async {
    _resetData();

    final supportTaskDataList = await ApiCall.getSupportTaskDetApi(
      showAll: showAllInitially,
      fromdate: DateFormat('yyyy-MM-dd').format(fromDate.value),
      todate: DateFormat('yyyy-MM-dd').format(toDate.value),
    );
    if (supportTaskDataList.isNotEmpty) {
      rows.addAll(
        supportTaskDataList.map((data) {
          return TrinaRow(
            cells: {
              'action': TrinaCell(value: ''),
              'id': TrinaCell(value: data.supportTaskId ?? ''),
              'privateid': TrinaCell(value: data.privateId ?? ''),
              'customer_name': TrinaCell(value: data.retailerName ?? ''),
              'customer_id': TrinaCell(value: data.retailerCode ?? ''),
              'event_name': TrinaCell(value: data.categoryName ?? ''),
              'event_id': TrinaCell(value: data.categoryId ?? ''),
              'assigned_to': TrinaCell(value: data.assignedUserName ?? ''),
              'assigned_to_id': TrinaCell(value: data.assignedUserTo ?? ''),
              // 'status': TrinaCell(value: data.status ?? ''),
              'status': TrinaCell(
                value: int.tryParse(data.status?.toString() ?? '') ?? 0,
              ),
              'tododate': TrinaCell(value: data.todoDate ?? ''),
              'duedate': TrinaCell(value: data.dueDate ?? ''),
              'title': TrinaCell(value: data.title ?? ''),
              'description': TrinaCell(value: data.description ?? ''),
              'query_category_id': TrinaCell(
                value: data.supportCategoryId ?? '',
              ),
              'query_category_name': TrinaCell(
                value: data.supportCategoryName ?? '',
              ),
              'subquery_category_id': TrinaCell(
                value: data.supportSubCategoryId ?? '',
              ),
              'subquery_category_name': TrinaCell(
                value: data.supportSubCategoryName ?? '',
              ),
              'ownership_category_id': TrinaCell(
                value: data.ownershipCategoryId ?? '',
              ),
              'ownership_category_name': TrinaCell(
                value: data.ownershipCategoryName ?? '',
              ),
              'rating': TrinaCell(value: data.rating ?? ''),
              'created_at': TrinaCell(value: data.createdAt ?? ''),
              'updated_at': TrinaCell(value: data.updatedAt ?? ''),
            },
          );
        }).toList(),
      );
      _afterDataLoaded();
      isDataLoad.value = 1;
    } else {
      isDataLoad.value = 2;
    }
    if (kDebugMode) {
      print('isDataLoad.value ${isDataLoad.value}');
    }
  }

  Future<void> getSalesTaskData() async {
    _resetData();

    final salesTaskDataList = await ApiCall.getSalesTaskDetApi(
      showAll: showAllInitially,
      fromdate: DateFormat('yyyy-MM-dd').format(fromDate.value),
      todate: DateFormat('yyyy-MM-dd').format(toDate.value),
    );
    if (salesTaskDataList.isNotEmpty) {
      rows.addAll(
        salesTaskDataList.map((data) {
          return TrinaRow(
            cells: {
              'action': TrinaCell(value: ''),
              'id': TrinaCell(value: data.salesTaskId ?? ''),
              'privateid': TrinaCell(value: data.privateId ?? ''),
              'customer_name': TrinaCell(value: data.retailerName ?? ''),
              'customer_id': TrinaCell(value: data.retailerCode ?? ''),
              'event_name': TrinaCell(value: data.categoryName ?? ''),
              'event_id': TrinaCell(value: data.categoryId ?? ''),
              'assigned_to': TrinaCell(value: data.assignedUserName ?? ''),
              'assigned_to_id': TrinaCell(value: data.assignedUserTo ?? ''),
              // 'status': TrinaCell(value: data.status ?? ''),
              'status': TrinaCell(
                value: int.tryParse(data.status?.toString() ?? '') ?? 0,
              ),
              'tododate': TrinaCell(value: data.todoDate ?? ''),
              'duedate': TrinaCell(value: data.dueDate ?? ''),
              'title': TrinaCell(value: data.title ?? ''),
              'description': TrinaCell(value: data.description ?? ''),
              'source': TrinaCell(value: data.bizModel ?? ''),
              'business_opportunity_id': TrinaCell(
                value: data.bizModelId ?? '',
              ),
              'business_opportunity_name': TrinaCell(
                value: data.bizModelName ?? '',
              ),
              'division_category': TrinaCell(
                value: data.divisionCategory ?? '',
              ),
              'target_category_id': TrinaCell(value: data.targetCategory ?? ''),
              'target_categoty_name': TrinaCell(
                value: data.targetCategoryName ?? '',
              ),
              'rating': TrinaCell(value: data.rating ?? ''),
              'created_at': TrinaCell(value: data.createdAt ?? ''),
              'updated_at': TrinaCell(value: data.updatedAt ?? ''),
            },
          );
        }).toList(),
      );
      _afterDataLoaded();
      isDataLoad.value = 1;
    } else {
      isDataLoad.value = 2;
    }
    if (kDebugMode) {
      print('isDataLoad.value ${isDataLoad.value}');
    }
  }

  Future<void> deleteSalesTaskApi({required String salesTaskId}) async {
    TaskBoardEntity deleteSalesTaskEntity = TaskBoardEntity();

    deleteSalesTaskEntity.companyId = Utility.companyId;
    deleteSalesTaskEntity.salesTaskId = salesTaskId;

    List<Map<String, dynamic>> body = [deleteSalesTaskEntity.toMap()];

    final response = await ApiCall.deleteSalesTaskApiCall(body);

    if (response.contains('Data Deleted Successfully')) {
      Get.back();

      await Utility.showAlert(
        icons: Icons.check,
        iconcolor: Colors.green,
        title: 'Status',
        msg: 'Data Deleted Successfully',
      );

      getSalesTaskData();
    } else {
      await Utility.showAlert(
        icons: Icons.close,
        iconcolor: Colors.red,
        title: 'Error',
        msg: 'Oops there is an error!',
      );
    }
  }

  Future<void> deleteSupportTaskApi({required String supportTaskId}) async {
    TaskBoardEntity deleteSupportTaskEntity = TaskBoardEntity();

    deleteSupportTaskEntity.companyId = Utility.companyId;
    deleteSupportTaskEntity.supportTaskId = supportTaskId;

    List<Map<String, dynamic>> body = [deleteSupportTaskEntity.toMap()];

    final response = await ApiCall.deleteSupportTaskApiCall(body);

    if (response.contains('Data Deleted Successfully')) {
      Get.back();

      await Utility.showAlert(
        icons: Icons.check,
        iconcolor: Colors.green,
        title: 'Status',
        msg: 'Data Deleted Successfully',
      );

      getSupportTaskData();
    } else {
      await Utility.showAlert(
        icons: Icons.close,
        iconcolor: Colors.red,
        title: 'Error',
        msg: 'Oops there is an error!',
      );
    }
  }
}
