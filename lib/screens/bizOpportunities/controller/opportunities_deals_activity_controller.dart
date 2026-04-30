import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/business_opportunity/opportunities_deals_rep_entity.dart';
import 'package:sysconn_sfa/api/entity/taskboard/audit_log_model.dart';
import 'package:sysconn_sfa/api/entity/taskboard/sales_task_dropdown_model.dart';
import 'package:sysconn_sfa/api/entity/taskboard/taskboard_report_entity.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/salestaskeditcontroller.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/taskrptcontroller.dart';

class OpportunitiesActivityController extends GetxController {
  // ── Form controllers ──────────────────────────────────────
  final title = TextEditingController();
  final tododate = TextEditingController();
  final duedate = TextEditingController();
  final description = TextEditingController();

  // ── Dropdown data ──────────────────────────────────────────
  final eventList = <EventList>[].obs;
  final assignedToList = <AssignedTo>[].obs;
  final targetCategoryList = <TargetCategory>[].obs;
  final selectedEvent = Rxn<EventList>();
  final selectedAssignedTo = Rxn<AssignedTo>();
  final selectedTargetCategory = Rxn<TargetCategory>();

  final divisioncategoryList = <String>['Division 1', 'Division 2', 'Division 3'].obs;
  final Rx<String?> selectedDivision = ''.obs;
  final Rx<String?> selectedStatus = Rx<String?>(null);

  // ── Activity list ──────────────────────────────────────────
  final activityList = <Map<String, dynamic>>[].obs;

  // ── Audit logs ─────────────────────────────────────────────
  final isLoading = false.obs;
  final auditLogsList = <Log>[].obs;

  // ── Hidden fields ──────────────────────────────────────────
  var tallyRetailerCode = ''.obs;
  var bizModelId = ''.obs;

  // ── Tab state (0=Activities, 1=Notes, 2=Audit Logs) ────────
  var selectedActivityTab = 0.obs;

  // ── Selected opportunity ───────────────────────────────────
  Rx<OpportunitiesDealsRepEntity> selectedOpportunity =
      OpportunitiesDealsRepEntity().obs;

  final Map<String, String> statusIdToName = {
    '0': 'Pending',
    '1': 'In Progress',
    '2': 'Completed',
    '3': 'On Hold',
    '4': 'Cancelled',
    '5': 'FTC',
  };

  @override
  void onInit() {
    super.onInit();
    fetchDropdownData();
    setDefaultDates();
  }

  // ── Helpers ────────────────────────────────────────────────

  String getStatusText(String? id) => statusIdToName[id] ?? 'Unknown';

  Color getStatusColor(String? id) {
    switch (id) {
      case '0': return Colors.orange;
      case '1': return Colors.blue;
      case '2': return Colors.green;
      case '3': return Colors.purple;
      case '4': return Colors.red;
      case '5': return Colors.teal;
      default:  return Colors.grey;
    }
  }

  void setDefaultDates() {
    final today = DateTime.now();
    tododate.text = DateFormat('yyyy-MM-dd').format(today);
    duedate.text = DateFormat('yyyy-MM-dd').format(today.add(const Duration(days: 7)));
  }

  String _formatDate(String input) {
    try {
      return DateFormat('yyyy/MM/dd').format(DateTime.parse(input));
    } catch (_) {
      return '';
    }
  }

  // ── Initialize ─────────────────────────────────────────────

  void initialize(OpportunitiesDealsRepEntity? data) {
    if (data == null) return;
    selectedOpportunity.value = data;
    tallyRetailerCode.value = data.retailerCode ?? '';
    bizModelId.value = data.businessOpportunityId ?? '';
  }

  // ── Dropdown fetch ─────────────────────────────────────────

  Future<void> fetchDropdownData() async {
    try {
      final model = await ApiCall.getSalesDropdownData();
      eventList.assignAll(model.data?.eventlist ?? []);
      assignedToList.assignAll(model.data?.assignedto ?? []);
      targetCategoryList.assignAll(model.data?.targetcategory ?? []);
    } catch (e) {
      debugPrint('Dropdown error: $e');
    }
  }

  // ── Validation ─────────────────────────────────────────────

  bool validate() {
    if (selectedEvent.value == null) {
      Utility.showErrorSnackBar('Event required'); return false;
    }
    if (selectedDivision.value == null || selectedDivision.value!.isEmpty) {
      Utility.showErrorSnackBar('Division required'); return false;
    }
    if (selectedTargetCategory.value == null) {
      Utility.showErrorSnackBar('Target required'); return false;
    }
    if (title.text.trim().isEmpty) {
      Utility.showErrorSnackBar('Title required'); return false;
    }
    if (selectedAssignedTo.value == null) {
      Utility.showErrorSnackBar('Assign user required'); return false;
    }
    if (selectedStatus.value == null || selectedStatus.value!.isEmpty) {
      Utility.showErrorSnackBar('Status required'); return false;
    }
    return true;
  }

  // ── Submit ─────────────────────────────────────────────────

  Future<void> submitActivity() async {
    if (!validate()) return;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      /// Ensure SalesTaskEditController is available for statusNameToId
      SalesTaskEditController salesCtrl;
      if (Get.isRegistered<SalesTaskEditController>()) {
        salesCtrl = Get.find<SalesTaskEditController>();
      } else {
        salesCtrl = Get.put(SalesTaskEditController());
        await Future.delayed(const Duration(milliseconds: 300));
      }

      final task = TaskBoardEntity();
      task.salesTaskId = '';
      task.companyId = Utility.companyId;
      task.retailerCode = tallyRetailerCode.value;
      task.bizModelId = bizModelId.value;
      task.bizModel = 'Business Opportunities';
      task.title = title.text.trim();
      task.description = description.text.trim();
      task.categoryId = selectedEvent.value?.categoryid ?? '';
      task.assignedUserTo = selectedAssignedTo.value?.userEmailid ?? '';
      task.todoDate = _formatDate(tododate.text);
      task.dueDate = _formatDate(duedate.text);
      task.divisionCategory = selectedDivision.value ?? '';
      task.targetCategory = selectedTargetCategory.value?.categoryid ?? '';
      task.emailId = Utility.email;
      task.status = salesCtrl.statusNameToId[selectedStatus.value] ?? '0';
      task.activity = 'Task Created';
      task.activityDescription =
          'Task created by ${Utility.companyName} (${Utility.email}) successfully.';

      final response = await ApiCall.postSalesTaskApi([task.toMap()]);

      if (Get.isDialogOpen ?? false) Get.back();

      String message;
      try {
        final resJson = json.decode(response);
        message = resJson.containsKey('data')
            ? 'Data Inserted Successfully'
            : (resJson['message']?.toString() ?? response);
      } catch (_) {
        message = response.toString();
      }

      if (message == 'Data Inserted Successfully') {
        await Utility.showAlert(
          icons: Icons.check,
          iconcolor: Colors.green,
          title: 'Success',
          msg: 'Activity Added Successfully',
        );

        /// Refresh task list
        TaskController taskCtrl = Get.isRegistered<TaskController>()
            ? Get.find<TaskController>()
            : Get.put(TaskController());
        await taskCtrl.getSalesTaskData();

        await loadActivitiesFromApi();
        clearForm();
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
      Utility.showErrorSnackBar(e.toString());
    }
  }

  void clearForm() {
    title.clear();
    description.clear();
    selectedEvent.value = null;
    selectedAssignedTo.value = null;
    selectedDivision.value = '';
    selectedTargetCategory.value = null;
    selectedStatus.value = null;
    setDefaultDates();
  }

  // ── Load activities ────────────────────────────────────────

  Future<void> loadActivitiesFromApi() async {
    try {
      activityList.clear();
      final data = await ApiCall.getSalesTaskForOpportunity(
        modelId: bizModelId.value,
      );
      for (final task in data) {
        activityList.add({
          'event': task.categoryName ?? '',
          'title': task.title ?? '',
          'todoDate': task.todoDate ?? '',
          'dueDate': task.dueDate ?? '',
          'createdAt': task.createdAt ?? '',
          'assigned': task.assignedUserName ?? '',
          'status': task.status ?? '',
          'description': task.description ?? '',
        });
      }
    } catch (e) {
      debugPrint('ERROR FETCHING ACTIVITIES: $e');
    }
  }

  // ── Load audit logs ────────────────────────────────────────

  Future<void> getAuditLogs({
    required String model,
    required String modelId,
  }) async {
    try {
      isLoading.value = true;
      auditLogsList.value =
          await ApiCall.getAuditLogs(model: model, modelId: modelId);
    } catch (e) {
      debugPrint('Audit log error: $e');
      auditLogsList.clear();
    } finally {
      isLoading.value = false;
    }
  }

  @override
  void onClose() {
    title.dispose();
    tododate.dispose();
    duedate.dispose();
    description.dispose();
    super.onClose();
  }
}