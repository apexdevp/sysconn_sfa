import 'dart:convert';

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
import 'package:sysconn_sfa/api/entity/taskboard/support_task_dropdown_model.dart';
import 'package:sysconn_sfa/api/entity/taskboard/task_bizopportunity_get_model.dart';
import 'package:sysconn_sfa/api/entity/taskboard/taskboard_report_entity.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/taskrptcontroller.dart';

class SupportTaskEditController extends GetxController {
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
  final queryCategoryList = <QueryCategory>[].obs;
  final subQueryCategoryList = <SubQueryCategory>[].obs;
  final ownershipCategoryList = <OwnershipCategory>[].obs;
  final filteredSubQueryCategoryList = <SubQueryCategory>[].obs;

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
  final selectedQueryCategory = Rxn<QueryCategory>();
  final selectedSubQueryCategory = Rxn<SubQueryCategory>();
  final selectedOwnershipCategory = Rxn<OwnershipCategory>();
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
  bool isEdit = false;

  final bizOpList = <BizOpportunityListModel>[].obs;
  final isBizOpLoading = false.obs;
  RxList<Log> indexData = <Log>[].obs;
  

  @override
  void onInit() {
    super.onInit();
    print("Controller Initialized");
    fetchSupportDropdownData();

    ever(editingRowData, (row) {
      if (row != null) {
        getSupportTaskBizOpList();
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

  Future<void> getSupportTaskBizOpList() async {
    try {
      isBizOpLoading.value = true;

      final taskId = editingRowData.value?['id']?.toString() ?? '';
      final screenType = 'support';

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
    isEdit = false;
    title.clear();
    description.clear();
    final today = DateTime.now();
    final dueDate = DateTime.now();
    tododate.text = DateFormat('yyyy-MM-dd').format(today);
    duedate.text = DateFormat('yyyy-MM-dd').format(dueDate);
    selectedEvent.value = null;
    selectedAssignedTo.value = null;
    selectedQueryCategory.value = null;
    selectedSubQueryCategory.value = null;
    selectedOwnershipCategory.value = null;
    selectedstatus.value = statuslist.first;

    if (editingRowData.value != null &&
        customerList.isNotEmpty &&
        followUpTask) {
      final row = editingRowData.value!;
      selectedCustomer.value = customerList.firstWhereOrNull(
        (c) => c.tallyRetailerCode == row['customer_id'],
      );
    } else {
      selectedCustomer.value = null;
    }
  }

  void onQueryCategoryChanged(QueryCategory? value) {
    selectedQueryCategory.value = value;

    if (value != null) {
      filteredSubQueryCategoryList.value = subQueryCategoryList
          .where((sub) => sub.categoriesid?.trim() == value.categoryid?.trim())
          .toList();
    } else {
      filteredSubQueryCategoryList.clear();
    }

    // Reset selected subcategory
    selectedSubQueryCategory.value = null;
  }

  Future<void> loadTaskForEdit(Map<String, dynamic> rowData) async {
    isEdit = true;
    editingRowData.value = rowData;

    title.text = rowData['title']?.toString() ?? '';
    description.text = rowData['description']?.toString() ?? '';
    tododate.text = rowData['tododate']?.toString() ?? '';
    duedate.text = rowData['duedate']?.toString() ?? '';

    while (customerList.isEmpty ||
        assignedToList.isEmpty ||
        eventList.isEmpty ||
        queryCategoryList.isEmpty ||
        subQueryCategoryList.isEmpty ||
        ownershipCategoryList.isEmpty) {
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

    if (queryCategoryList.isNotEmpty) {
      selectedQueryCategory.value = queryCategoryList.firstWhereOrNull(
        (q) => q.categoryid == rowData['query_category_id'],
      );
    }

    // Filter subcategories only if query category exists
    if (selectedQueryCategory.value != null &&
        subQueryCategoryList.isNotEmpty) {
      filteredSubQueryCategoryList.value = subQueryCategoryList
          .where(
            (sub) =>
                sub.categoriesid == selectedQueryCategory.value!.categoryid,
          )
          .toList();

      selectedSubQueryCategory.value = filteredSubQueryCategoryList
          .firstWhereOrNull(
            (s) => s.subcategoryid == rowData['subquery_category_id'],
          );
    }

    if (ownershipCategoryList.isNotEmpty) {
      selectedOwnershipCategory.value = ownershipCategoryList.firstWhereOrNull(
        (o) => o.categoryid == rowData['ownership_category_id'],
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

    if (selectedQueryCategory.value == null) {
      // Utility.showErrorSnackBar("Query Category required");
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Query Category required",
      );
      return false;
    }

    if (selectedSubQueryCategory.value == null) {
      // Utility.showErrorSnackBar("Sub Query Category required");
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Sub Query Category required",
      );
      return false;
    }

    if (selectedOwnershipCategory.value == null) {
      // Utility.showErrorSnackBar("Pending Ownership required");
      Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Pending Ownership required",
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

  Future<void> submitSupportTask() async {
    bool isValid = await validateProduct();
    if (!isValid) return;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      TaskBoardEntity supporttask = TaskBoardEntity();
      supporttask.supportTaskId = isEdit && editingRowData.value != null
          ? editingRowData.value!['id']?.toString() ?? ""
          : "";
      supporttask.companyId = Utility.companyId;
      supporttask.emailId = Utility.email;
      supporttask.retailerCode = selectedCustomer.value?.tallyRetailerCode;
      supporttask.assignedUserTo = selectedAssignedTo.value?.userEmailid;
      supporttask.title = title.text.trim();
      supporttask.description = description.text.trim();
      supporttask.categoryId = selectedEvent.value?.categoryid;
      supporttask.status = statusNameToId[selectedstatus.value] ?? "0";
      supporttask.todoDate = formatDate(tododate.text.trim());
      supporttask.dueDate = formatDate(duedate.text.trim());
      supporttask.ownershipCategoryId =
          selectedOwnershipCategory.value?.categoryid;
      supporttask.supportCategoryId = selectedQueryCategory.value?.categoryid;
      supporttask.supportSubCategoryId =
          selectedSubQueryCategory.value?.subcategoryid;

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

      supporttask.activity = isEdit && editingRowData.value != null
          ? (oldStatusId != newStatusId
                ? 'Task Status Updated'
                : 'Task Updated')
          : 'Task Created';
      supporttask.activityDescription = isEdit && editingRowData.value != null
          ? (oldStatusId != newStatusId
                ? 'Task updated status ($oldStatusName -> $newStatusName) by ${Utility.companyName} (${Utility.email}) successfully.'
                : 'Task updated by ${Utility.companyName} (${Utility.email}) successfully.')
          : 'Task created by ${Utility.companyName} (${Utility.email}) successfully.';

      final response = await ApiCall.postSupportTaskApi([supporttask.toMap()]);

      if (Get.isDialogOpen ?? false) Get.back();

      String message;
      try {
        final resJson = json.decode(response);
        message = resJson['message'] ?? response.toString();
      } catch (_) {
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
        if (isEdit && editingRowData.value != null) {
          //Instant UI update from form values
          updateEditingRowFromForm();
        }
        final taskController = Get.find<TaskController>();
        await taskController.getSupportTaskData();
        Get.back(result: true); // close dialog
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
    currentRow['query_category_id'] =
        selectedQueryCategory.value?.categoryid ??
        currentRow['query_category_id'];
    currentRow['query_category_name'] =
        selectedQueryCategory.value?.name ?? currentRow['query_category_name'];
    currentRow['subquery_category_id'] =
        selectedSubQueryCategory.value?.subcategoryid ??
        currentRow['subquery_category_id'];
    currentRow['subquery_category_name'] =
        selectedSubQueryCategory.value?.name ??
        currentRow['subquery_category_name'];
    currentRow['ownership_category_id'] =
        selectedOwnershipCategory.value?.categoryid ??
        currentRow['ownership_category_id'];
    currentRow['ownership_category_name'] =
        selectedOwnershipCategory.value?.name ??
        currentRow['ownership_category_name'];
    currentRow['updated_at'] = DateFormat(
      'yyyy-MM-dd HH:mm',
    ).format(DateTime.now());
    editingRowData.value = currentRow;
    editingRowData.refresh();
  }

  Future<void> updateDescriptionOnly(String newDescription) async {
    if (editingRowData.value == null) return; // No row selected

    try {
      TaskBoardEntity supporttask = TaskBoardEntity();
      final row = editingRowData.value!;

      supporttask.supportTaskId = row['id']?.toString() ?? '';
      supporttask.companyId = Utility.companyId;
      supporttask.emailId = Utility.email;

      supporttask.retailerCode = row['customer_id']?.toString() ?? '';
      supporttask.assignedUserTo = row['assigned_to_id']?.toString() ?? '';
      supporttask.title = row['title']?.toString() ?? '';
      supporttask.description = newDescription.trim();
      supporttask.categoryId = row['event_id']?.toString() ?? '';
      supporttask.status = row['status']?.toString() ?? "0";
      supporttask.todoDate = formatDate(row['tododate']?.toString() ?? '');
      supporttask.dueDate = formatDate(row['duedate']?.toString() ?? '');
      supporttask.ownershipCategoryId =
          row['ownership_category_id']?.toString() ?? '';
      supporttask.supportCategoryId =
          row['query_category_id']?.toString() ?? '';
      supporttask.supportSubCategoryId =
          row['subquery_category_id']?.toString() ?? '';
      supporttask.activity = 'Task Updated';
      supporttask.activityDescription =
          'Task updated by ${Utility.companyName} (${Utility.email}) successfully.';

      List<Map<String, dynamic>> payload = [supporttask.toMap()];

      final response = await ApiCall.postSupportTaskApi(payload);
      print("API RESPONSE (description update): $response");

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

  Future<void> updateStatusOnly(String newStatus) async {
    if (editingRowData.value == null) return; // No row selected

    final row = editingRowData.value!;

    TaskBoardEntity task = TaskBoardEntity();
    task.supportTaskId = row['id']?.toString() ?? '';
    task.companyId = Utility.companyId;
    task.emailId = Utility.email;

    task.retailerCode = row['customer_id']?.toString() ?? '';
    task.assignedUserTo = row['assigned_to_id']?.toString() ?? '';
    task.title = row['title']?.toString() ?? '';
    task.description = row['description']?.toString() ?? '';
    task.categoryId = row['event_id']?.toString() ?? '';
    task.status = newStatus; // <-- only change
    task.todoDate = formatDate(row['tododate']?.toString() ?? '');
    task.dueDate = formatDate(row['duedate']?.toString() ?? '');
    task.ownershipCategoryId = row['ownership_category_id']?.toString() ?? '';
    task.supportCategoryId = row['query_category_id']?.toString() ?? '';
    task.supportSubCategoryId = row['subquery_category_id']?.toString() ?? '';

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

      final response = await ApiCall.postSupportTaskApi(payload);
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

  Future<void> updateMarkStatusOnly(String newStatus) async {
    if (editingRowData.value == null) return; // No row selected

    final row = editingRowData.value!;

    TaskBoardEntity task = TaskBoardEntity();
    task.supportTaskId = row['id']?.toString() ?? '';
    task.companyId = Utility.companyId;
    task.emailId = Utility.email;

    task.retailerCode = row['customer_id']?.toString() ?? '';
    task.assignedUserTo = row['assigned_to_id']?.toString() ?? '';
    task.title = row['title']?.toString() ?? '';
    task.description = row['description']?.toString() ?? '';
    task.categoryId = row['event_id']?.toString() ?? '';
    task.status = newStatus; // <-- only change
    task.todoDate = formatDate(row['tododate']?.toString() ?? '');
    task.dueDate = formatDate(row['duedate']?.toString() ?? '');
    // task.ownershipCategoryId = row['ownership_category_id']?.toString() ?? '';
    // task.supportCategoryId = row['query_category_id']?.toString() ?? '';
    // task.supportSubCategoryId = row['subquery_category_id']?.toString() ?? '';
    task.ownershipCategoryId = selectedOwnershipCategory.value?.categoryid;
    task.supportCategoryId = selectedQueryCategory.value?.categoryid;
    task.supportSubCategoryId = selectedSubQueryCategory.value?.subcategoryid;

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

      final response = await ApiCall.postSupportTaskApi(payload);
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

  Future<void> fetchSupportDropdownData() async {
    try {
      isLoading.value = true;

      SupportTaskDropdownModel model = await ApiCall.getSupportDropdownData();

      customerList.assignAll(model.data?.customerlist ?? []);
      eventList.assignAll(model.data?.eventlist ?? []);
      assignedToList.assignAll(model.data?.assignedto ?? []);
      queryCategoryList.assignAll(model.data?.querycategory ?? []);
      subQueryCategoryList.assignAll(model.data?.subquerycategory ?? []);
      ownershipCategoryList.assignAll(model.data?.ownershipcategory ?? []);
    } catch (e) {
      print('Error fetching dropdown data: $e');
    } finally {
      isLoading.value = false;
    }
  }
}
