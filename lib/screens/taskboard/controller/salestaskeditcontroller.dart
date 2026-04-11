import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_navigation/src/extension_navigation.dart';
import 'package:get/get_rx/src/rx_types/rx_types.dart';
import 'package:get/get_rx/src/rx_workers/rx_workers.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:get/get_utils/src/extensions/internacionalization.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/taskboard/audit_log_model.dart';
import 'package:sysconn_sfa/api/entity/taskboard/sales_task_dropdown_model.dart';
import 'package:sysconn_sfa/api/entity/taskboard/task_bizopportunity_get_model.dart';
import 'package:sysconn_sfa/api/entity/taskboard/taskboard_report_entity.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/taskrptcontroller.dart';

class SalesTaskEditController extends GetxController {
  
  // TaskController get productController => Get.find<TaskController>();
  // int isdataLoad = 0;
  // List<TrinaRow> rows = [];
  // TrinaGridStateManager? stateManager;

  //Dropdown fwtch api
  final isLoading = false.obs;

  //Manual type field controller
  final title = TextEditingController();
  final tododate = TextEditingController();
  final duedate = TextEditingController();
  final description = TextEditingController();


  //This is for Dropdown List fetch
  final customerList = <CustomerList>[].obs;
  final eventList = <EventList>[].obs;
  final assignedToList = <AssignedTo>[].obs;
  final bizCategoryList = <BizCategory>[].obs;
  final targetCategoryList = <TargetCategory>[].obs;
  RxList<String> sourceList = ["Business Opportunities"].obs;
  RxList<String> divisioncategoryList = [
    "Division 1",
    "Division 2",
    "Division 3",
  ].obs;
  //status list show in form
  RxList<String> statuslist = [
    "Pending",
    "In Progress",
    "Completed",
    "On Hold",
    "Cancelled",
    "FTC",
  ].obs;

  //This is to store selected data row and this is use to sent data to post api
  final selectedCustomer = Rxn<CustomerList>();
  final selectedEvent = Rxn<EventList>();
  final selectedAssignedTo = Rxn<AssignedTo>();
  final selectedBizCategory = Rxn<BizCategory>();
  final selectedTargetCategory = Rxn<TargetCategory>();
  final selectedSource = Rxn<String>();
  final selectedDivision = Rxn<String>();
  final selectedstatus = Rxn<String>();
  //send no to post api as per selected status name
  final Map<String, String> statusNameToId = {
    "Pending": "0",
    "In Progress": "1",
    "Completed": "2",
    "On Hold": "3",
    "Cancelled": "4",
    "FTC": "5",
  };

  //Get data of row on onclick from trinagrid report
  final editingRowData = Rxn<Map<String, dynamic>>();
  final isEdit = false.obs;

  final bizOpList = <BizOpportunityListModel>[].obs;
  final isBizOpLoading = false.obs;

  RxList<Log> indexData = <Log>[].obs;

  // Rx<String?> selectedSource = "Business Opportunities".obs;

  @override
  void onInit() {
    super.onInit();
    if (kDebugMode) {
      print("Controller Initialized");
    }
    fetchSalesDropdownData();

    ever(editingRowData, (row) {
      if (row != null) {
        getSalesTaskBizOpList();
      }
    });
  }

  Future<void> getAuditLogs({
    required String model,
    required String modelId,
  }) async {
    try {
      isLoading.value = true;
      final logs = await ApiCall.getAuditLogs(model: model, modelId: modelId);
      indexData.value = logs;
    } catch (e) {
      print("Controller Error fetching audit logs: $e");
      indexData.clear();
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> getSalesTaskBizOpList() async {
    try {
      isBizOpLoading.value = true;

      final taskId = editingRowData.value?['id']?.toString() ?? '';
      final screenType = 'sales';

      final response = await ApiCall.getBizOpportunityList();
      final decoded = json.decode(response);

      if (decoded['data'] != null) {
        final List list = decoded['data'];

        final filtered = list.where((item) {
          final apiTaskId = item['taskid']?.toString();
          final apiTaskType = item['tasktype']?.toString();

          return apiTaskId == taskId && apiTaskType == screenType;
        }).toList();

        bizOpList.value = filtered
            .map((e) => BizOpportunityListModel.fromJson(e))
            .toList();
      } else {
        print("❌ 'data' key not found in API response");
      }
    } catch (e) {
      print("❌ BizOp API Error: $e");
    } finally {
      isBizOpLoading.value = false;
    }
  }

  void clearFields({bool followUpTask = false}) {
    isEdit.value = false;
    title.clear();
    description.clear();
    final today = DateTime.now();
    final dueDate = DateTime.now();
    tododate.text = DateFormat('yyyy-MM-dd').format(today);
    duedate.text = DateFormat('yyyy-MM-dd').format(dueDate);
    selectedEvent.value = null;
    selectedAssignedTo.value = null;
    selectedBizCategory.value = null;
    selectedTargetCategory.value = null;
    selectedSource.value = sourceList.first;
    selectedDivision.value = null;
    selectedstatus.value = statuslist.first;

    if (editingRowData.value != null && followUpTask) {
      final row = editingRowData.value!;

      if (customerList.isNotEmpty) {
        selectedCustomer.value = customerList.firstWhereOrNull(
          (c) => c.tallyRetailerCode == row['customer_id'],
        );
      }

      if (bizCategoryList.isNotEmpty) {
        selectedBizCategory.value = bizCategoryList.firstWhereOrNull(
          (b) => b.businessopportunityid == row['business_opportunity_id'],
        );
      }
    } else {
      selectedCustomer.value = null;
      selectedBizCategory.value = null;
    }
  }

  Future<void> loadTaskForEdit(Map<String, dynamic> rowData) async {
    isEdit.value = true;
    editingRowData.value = rowData;

    title.text = rowData['title']?.toString() ?? '';
    description.text = rowData['description']?.toString() ?? '';
    tododate.text = rowData['tododate']?.toString() ?? '';
    duedate.text = rowData['duedate']?.toString() ?? '';

    while (customerList.isEmpty ||
        assignedToList.isEmpty ||
        eventList.isEmpty ||
        bizCategoryList.isEmpty ||
        targetCategoryList.isEmpty) {
      await Future.delayed(const Duration(milliseconds: 50));
    }

    // Assign selections safely (lists may already be populated)
    if (customerList.isNotEmpty) {
      selectedCustomer.value = customerList.firstWhereOrNull(
        (c) => c.tallyRetailerCode == rowData['customer_id'],
      );
    }

    if (assignedToList.isNotEmpty) {
      selectedAssignedTo.value = assignedToList.firstWhereOrNull(
        (u) => u.userEmailid == rowData['assigned_to_id'],
      );
    }

    if (eventList.isNotEmpty) {
      selectedEvent.value = eventList.firstWhereOrNull(
        (e) => e.categoryid == rowData['event_id'],
      );
    }

    if (bizCategoryList.isNotEmpty) {
      selectedBizCategory.value = bizCategoryList.firstWhereOrNull(
        (q) => q.businessopportunityid == rowData['business_opportunity_id'],
      );
    }

    if (targetCategoryList.isNotEmpty) {
      selectedTargetCategory.value = targetCategoryList.firstWhereOrNull(
        (o) => o.categoryid == rowData['target_category_id'],
      );
    }
    //  FIXED SOURCE LOGIC
    final rowSource = rowData['source']?.toString();

    if (rowSource != null && rowSource.isNotEmpty) {
      selectedSource.value = sourceList.firstWhereOrNull(
        (s) => s.toLowerCase().trim() == rowSource.toLowerCase().trim(),
      );
    }

    //  Fallback if not matched OR null
    if (selectedSource.value == null) {
      if (sourceList.length == 1) {
        selectedSource.value = sourceList.first;
      }
    }

    if (divisioncategoryList.isNotEmpty) {
      selectedDivision.value = divisioncategoryList.firstWhereOrNull(
        (d) => d == rowData['division_category'],
      );
    }
    if (rowData['status'] != null) {
      selectedstatus.value = statusNameToId.entries
          .firstWhere(
            (entry) => entry.value == rowData['status'].toString(),
            orElse: () => MapEntry('', ''), // default if not found
          )
          .key;

      // If key is empty string, set to null
      if (selectedstatus.value == '') selectedstatus.value = null;
    } else {
      selectedstatus.value = null;
    }
  }

  Future<bool> validateProduct() async {
    if (selectedCustomer.value == null) {
      // Utility.showErrorSnackBar("Customer Name required");
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Customer Name required",
      );
      return false;
    }

    if (selectedEvent.value == null) {
      // Utility.showErrorSnackBar("Event required");
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Event required",
      );
      return false;
    }

    if (selectedstatus.value == null) {
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Status required",
      );
      return false;
    }

    if (selectedDivision.value == null) {
      // Utility.showErrorSnackBar("Division Category required");
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Division Category required",
      );
      return false;
    }

    if (selectedTargetCategory.value == null) {
      // Utility.showErrorSnackBar("Target Category required");
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Target Category required",
      );
      return false;
    }

    if (title.text.trim().isEmpty) {
      // Utility.showErrorSnackBar("Title required");
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Title required",
      );
      return false;
    }

    if (tododate.text.trim().isEmpty || duedate.text.trim().isEmpty) {
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: 'Please select dates',
      );
      return false;
    }

    if (selectedAssignedTo.value == null) {
      // Utility.showErrorSnackBar("Assigned User required");
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Assigned User required",
      );
      return false;
    }
    return true;
  }

  String formatDate(String input) {
    try {
      DateTime date = DateTime.parse(input);
      return DateFormat('yyyy/MM/dd').format(date);
    } catch (e) {
      return '';
    }
  }

  Future<void> submitSalesTask() async {
    bool isValid = await validateProduct();
    if (!isValid) return;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      TaskBoardEntity salestask = TaskBoardEntity();

      salestask.salesTaskId = isEdit.value && editingRowData.value != null
          ? editingRowData.value!['id']?.toString() ?? ""
          : "";
      salestask.companyId = Utility.companyId;
      salestask.emailId = Utility.email;
      salestask.retailerCode = selectedCustomer.value?.tallyRetailerCode;
      salestask.assignedUserTo = selectedAssignedTo.value?.userEmailid;
      salestask.title = title.text.trim();
      salestask.description = description.text.trim();
      salestask.categoryId = selectedEvent.value?.categoryid;
      salestask.status = statusNameToId[selectedstatus.value] ?? "0";
      salestask.todoDate = formatDate(tododate.text.trim());
      salestask.dueDate = formatDate(duedate.text.trim());
      salestask.bizModel = selectedSource.value ?? '';
      salestask.bizModelId = selectedBizCategory.value?.businessopportunityid;
      // salestask.divisionCategory = selectedDivision.toString();
      salestask.divisionCategory = selectedDivision.value ?? '';
      salestask.targetCategory = selectedTargetCategory.value?.categoryid;

      /// ---------------- STATUS LOGIC ----------------
      final oldStatusId = editingRowData.value?['status']
          ?.toString(); // old from DB

      final newStatusId =
          statusNameToId[selectedstatus.value] ?? "0"; // new from UI

      /// Reverse map (ID -> Name)
      final Map<String, String> statusIdToName = {
        for (var e in statusNameToId.entries) e.value: e.key,
      };

      final oldStatusName = statusIdToName[oldStatusId];
      final newStatusName = statusIdToName[newStatusId];

      salestask.activity = isEdit.value && editingRowData.value != null
          ? (oldStatusId != newStatusId
                ? 'Task Status Updated'
                : 'Task Updated')
          : 'Task Created';
      salestask.activityDescription =
          isEdit.value && editingRowData.value != null
          // ? 'Task updated by ${Utility.companyName} (${Utility.email}) successfully.'
          ? (oldStatusId != newStatusId
                ? 'Task updated status ($oldStatusName -> $newStatusName) by ${Utility.companyName} (${Utility.email}) successfully.'
                : 'Task updated by ${Utility.companyName} (${Utility.email}) successfully.')
          : 'Task created by ${Utility.companyName} (${Utility.email}) successfully.';

      List<Map<String, dynamic>> salesTaskEditListMap = [salestask.toMap()];

      final response = await ApiCall.postSalesTaskApi(salesTaskEditListMap);
      if (kDebugMode) {
        print("API RESPONSE: $response");
      }
      if (Get.isDialogOpen ?? false) Get.back();

      String message;

      try {
        final Map<String, dynamic> resJson = json.decode(response);
        message = resJson['message'] ?? response.toString();
      } catch (e) {
        message = response.toString();
      }

      if (message == 'Data Inserted Successfully') {
        await Utility.showAlert(
          icons: Icons.check,
          iconcolor: Colors.green,
          title: 'Status',
          msg: 'Data Inserted Successfully',
        );
        await Future.delayed(const Duration(milliseconds: 50));
        if (isEdit.value && editingRowData.value != null) {
          //Instant UI update from form values
          updateEditingRowFromForm();
        }
        final taskController = Get.find<TaskController>();
        await taskController.getSalesTaskData();
        Get.back(result: true);
      } else {
        await Utility.showAlert(
          icons: Icons.close,
          iconcolor: Colors.red,
          title: 'Error',
          msg: 'Oops there is an error!',
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();

      await Utility.showAlert(
        icons: Icons.close,
        iconcolor: Colors.red,
        title: 'Error',
        msg: e.toString(),
      );
    }
  }

  void updateEditingRowFromForm() {
    if (editingRowData.value == null) return;
    if (kDebugMode) {
      print("before Row Data: ${editingRowData.value}");
    }
    final currentRow = Map<String, dynamic>.from(editingRowData.value!);
    //Update all changed fields
    currentRow['title'] = title.text.trim();
    currentRow['description'] = description.text.trim();
    currentRow['tododate'] = tododate.text.trim();
    currentRow['duedate'] = duedate.text.trim();
    currentRow['status'] =
        statusNameToId[selectedstatus.value] ?? currentRow['status'];
    currentRow['event_id'] =
        selectedEvent.value?.categoryid ?? currentRow['event_id'];
    currentRow['event_name'] =
        selectedEvent.value?.name ?? currentRow['event_name'];
    currentRow['assigned_to_id'] =
        selectedAssignedTo.value?.userEmailid ?? currentRow['assigned_to_id'];
    currentRow['assigned_to'] =
        selectedAssignedTo.value?.userName ?? currentRow['assigned_to'];
    currentRow['division_category'] =
        selectedDivision.value ?? currentRow['division_category'];
    currentRow['target_category_id'] =
        selectedTargetCategory.value?.categoryid ??
        currentRow['target_category_id'];
    currentRow['target_categoty_name'] =
        selectedTargetCategory.value?.name ??
        currentRow['target_categoty_name'];
    currentRow['updated_at'] = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).format(DateTime.now());
    editingRowData.value = currentRow;
    editingRowData.refresh();
  }

  Future<void> updateSalesDescriptionOnly(String newDescription) async {
    if (editingRowData.value == null) return; // No row selected

    try {
      TaskBoardEntity salestask = TaskBoardEntity();
      final row = editingRowData.value!;

      salestask.salesTaskId = row['id']?.toString() ?? '';
      salestask.companyId = Utility.companyId;
      salestask.emailId = Utility.email;

      salestask.retailerCode = row['customer_id']?.toString() ?? '';
      salestask.assignedUserTo = row['assigned_to_id']?.toString() ?? '';
      salestask.title = row['title']?.toString() ?? '';
      salestask.description = newDescription.trim();
      salestask.categoryId = row['event_id']?.toString() ?? '';
      salestask.status = row['status']?.toString() ?? "0";
      salestask.todoDate = formatDate(row['tododate']?.toString() ?? '');
      salestask.dueDate = formatDate(row['duedate']?.toString() ?? '');
      salestask.bizModel = row['business_opportunity_name']?.toString() ?? '';
      salestask.bizModelId = row['business_opportunity_id']?.toString() ?? '';
      salestask.divisionCategory = row['division_category']?.toString() ?? '';
      salestask.targetCategory = row['target_category_id']?.toString() ?? '';

      salestask.activity = 'Task Updated';
      salestask.activityDescription =
          'Task updated by ${Utility.companyName} (${Utility.email}) successfully.';

      List<Map<String, dynamic>> payload = [salestask.toMap()];

      final response = await ApiCall.postSalesTaskApi(payload);
      if (kDebugMode) {
        print("API RESPONSE (description update): $response");
      }

      // Update local row so TextField stays in sync
      editingRowData.update((val) {
        if (val != null) val['description'] = newDescription.trim();
      });
    } catch (e) {
      // Utility.showErrorSnackBar("Error saving description: $e");

      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Error saving description: $e",
      );
    }
  }

  Future<void> updateSalesStatusOnly(String newStatus) async {
    if (editingRowData.value == null) return; // No row selected

    final row = editingRowData.value!;

    TaskBoardEntity task = TaskBoardEntity();
    task.salesTaskId = row['id']?.toString() ?? '';
    task.companyId = Utility.companyId;
    task.emailId = Utility.email;
    task.retailerCode = row['customer_id']?.toString() ?? '';
    task.assignedUserTo = row['assigned_to_id']?.toString() ?? '';
    task.title = row['title']?.toString() ?? '';
    task.description = row['description']?.toString() ?? '';
    task.categoryId = row['event_id']?.toString() ?? '';
    task.status = newStatus;
    task.todoDate = formatDate(row['tododate']?.toString() ?? '');
    task.dueDate = formatDate(row['duedate']?.toString() ?? '');
    task.bizModel = row['business_opportunity_name']?.toString() ?? '';
    task.bizModelId = row['business_opportunity_id']?.toString() ?? '';
    task.divisionCategory = row['division_category']?.toString() ?? '';
    task.targetCategory = row['target_category_id']?.toString() ?? '';

    /// ---------------- STATUS LOGIC ----------------
    final oldStatusId = editingRowData.value?['status']
        ?.toString(); // old from DB

    final newStatusId =
        statusNameToId[selectedstatus.value] ?? "0"; // new from UI

    /// Reverse map (ID -> Name)
    final Map<String, String> statusIdToName = {
      for (var e in statusNameToId.entries) e.value: e.key,
    };

    final oldStatusName = statusIdToName[oldStatusId];
    final newStatusName = statusIdToName[newStatusId];

    task.activity = 'Task Status Updated';
    task.activityDescription =
        'Task updated status ($oldStatusName -> $newStatusName) by ${Utility.companyName} (${Utility.email}) successfully.';

    List<Map<String, dynamic>> payload = [task.toMap()];

    try {
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await ApiCall.postSalesTaskApi(payload);
      if (Get.isDialogOpen ?? false) Get.back();

      String message;
      try {
        final resJson = json.decode(response);
        message = resJson['message'] ?? response.toString();
      } catch (_) {
        message = response.toString();
      }

      if (message == 'Data Inserted Successfully') {
        // ✅ Only update UI after success
        editingRowData.update((val) {
          if (val != null) val['status'] = newStatus;
        });

        final taskController = Get.find<TaskController>();
        final rowIndex = taskController.rows.indexWhere(
          (r) => r.cells['id']?.value == row['id'],
        );

        if (rowIndex != -1) {
          taskController.rows[rowIndex].cells['status']?.value = newStatus;
          taskController.rows.refresh();
        }

        taskController.updateStatusCounts();
        // Utility.showSuccessSnackBar("Status updated successfully");
      } else {
        // ❌ Show API error, do not update UI
        // Utility.showErrorSnackBar("Error updating status: $message");
        Utility.showAlert(
          icons: Icons.error_outline_outlined,
          iconcolor: Colors.redAccent,
          title: 'Alert',
          msg: "Error updating status: $message",
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      // Utility.showErrorSnackBar("Error updating status: $e");
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Error updating status: $e",
      );
    }
  }

  Future<void> updateSalesmarkStatusOnly(String newStatus) async {
    if (editingRowData.value == null) return; // No row selected

    final row = editingRowData.value!;

    TaskBoardEntity task = TaskBoardEntity();
    task.salesTaskId = row['id']?.toString() ?? '';
    task.companyId = Utility.companyId;
    task.emailId = Utility.email;
    task.retailerCode = row['customer_id']?.toString() ?? '';
    task.assignedUserTo = row['assigned_to_id']?.toString() ?? '';
    task.title = row['title']?.toString() ?? '';
    task.description = row['description']?.toString() ?? '';
    task.categoryId = row['event_id']?.toString() ?? '';
    task.status = newStatus;
    task.todoDate = formatDate(row['tododate']?.toString() ?? '');
    task.dueDate = formatDate(row['duedate']?.toString() ?? '');
    task.bizModel = row['business_opportunity_name']?.toString() ?? '';
    task.bizModelId = row['business_opportunity_id']?.toString() ?? '';
    // task.divisionCategory = row['division_category']?.toString() ?? '';
    // task.targetCategory = row['target_category_id']?.toString() ?? '';

    task.divisionCategory = selectedDivision.value ?? '';
    task.targetCategory = selectedTargetCategory.value?.categoryid;

    /// ---------------- STATUS LOGIC ----------------
    final oldStatusId = editingRowData.value?['status']
        ?.toString(); // old from DB

    final newStatusId = "2"; // new from UI

    /// Reverse map (ID -> Name)
    final Map<String, String> statusIdToName = {
      for (var e in statusNameToId.entries) e.value: e.key,
    };

    final oldStatusName = statusIdToName[oldStatusId];
    final newStatusName = statusIdToName[newStatusId];

    task.activity = 'Task Status Updated';
    task.activityDescription =
        'Task updated status ($oldStatusName -> $newStatusName) by ${Utility.companyName} (${Utility.email}) successfully.';

    List<Map<String, dynamic>> payload = [task.toMap()];

    try {
      // Show loading dialog
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final response = await ApiCall.postSalesTaskApi(payload);
      if (Get.isDialogOpen ?? false) Get.back();

      String message;
      try {
        final resJson = json.decode(response);
        message = resJson['message'] ?? response.toString();
      } catch (_) {
        message = response.toString();
      }

      if (message == 'Data Inserted Successfully') {
        // ✅ Only update UI after success
        editingRowData.update((val) {
          if (val != null) val['status'] = newStatus;
        });

        final taskController = Get.find<TaskController>();
        final rowIndex = taskController.rows.indexWhere(
          (r) => r.cells['id']?.value == row['id'],
        );

        if (rowIndex != -1) {
          taskController.rows[rowIndex].cells['status']?.value = newStatus;
          taskController.rows.refresh();
        }

        taskController.updateStatusCounts();
        // Utility.showSuccessSnackBar("Status updated successfully");
      } else {
        //  Show API error, do not update UI
        // Utility.showErrorSnackBar("Error updating status: $message");
        Utility.showAlert(
          icons: Icons.error_outline_outlined,
          iconcolor: Colors.redAccent,
          title: 'Alert',
          msg: "Error updating status: $message",
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      // Utility.showErrorSnackBar("Error updating status: $e");
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Error updating status: $e",
      );
    }
  }

  Future<void> fetchSalesDropdownData() async {
    try {
      isLoading.value = true;

      SalesTaskDropdownModel model = await ApiCall.getSalesDropdownData();

      customerList.assignAll(model.data?.customerlist ?? []);
      eventList.assignAll(model.data?.eventlist ?? []);
      assignedToList.assignAll(model.data?.assignedto ?? []);
      bizCategoryList.assignAll(model.data?.bizopportunity ?? []);
      targetCategoryList.assignAll(model.data?.targetcategory ?? []);
    } catch (e) {
      if (kDebugMode) {
        print('Error fetching dropdown data: $e');
      }
    } finally {
      isLoading.value = false;
    }
  }
}
