import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/api/entity/taskboard/sales_task_dropdown_model.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/controller/opportunities_deals_activity_controller.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/salestaskeditcontroller.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class ActivityAddScreen extends StatelessWidget {
  ActivityAddScreen({super.key});

  final OpportunitiesActivityController controller =
      Get.find<OpportunitiesActivityController>();

  SalesTaskEditController get salesCtrl {
    if (!Get.isRegistered<SalesTaskEditController>()) {
      return Get.put(SalesTaskEditController());
    }
    return Get.find<SalesTaskEditController>();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: SfaCustomAppbar(
        title: 'Add Sales Task',
        showDefaultActions: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// EVENT DROPDOWN
            _label('Event *'),
            Obx(
              () => _dropdown<EventList>(
                hint: 'Select Event',
                items: controller.eventList
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name ?? ''),
                        ))
                    .toList(),
                value: controller.selectedEvent.value,
                onChanged: (v) => controller.selectedEvent.value = v,
              ),
            ),
            const SizedBox(height: 14),

            /// STATUS DROPDOWN
            _label('Status *'),
            Obx(
              () => _dropdown<String>(
                hint: 'Select Status',
                items: salesCtrl.statuslist
                    .map((s) =>
                        DropdownMenuItem(value: s, child: Text(s)))
                    .toList(),
                value: controller.selectedStatus.value,
                onChanged: (v) => controller.selectedStatus.value = v,
              ),
            ),
            const SizedBox(height: 14),

            /// DIVISION DROPDOWN
            _label('Division Category *'),
            Obx(
              () => _dropdown<String>(
                hint: 'Select Division',
                items: controller.divisioncategoryList
                    .map((e) =>
                        DropdownMenuItem(value: e, child: Text(e)))
                    .toList(),
                value: controller.selectedDivision.value?.isEmpty ?? true
                    ? null
                    : controller.selectedDivision.value,
                onChanged: (v) => controller.selectedDivision.value = v,
              ),
            ),
            const SizedBox(height: 14),

            /// TARGET DROPDOWN
            _label('Target Category *'),
            Obx(
              () => _dropdown<TargetCategory>(
                hint: 'Select Target',
                items: controller.targetCategoryList
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name ?? ''),
                        ))
                    .toList(),
                value: controller.selectedTargetCategory.value,
                onChanged: (v) =>
                    controller.selectedTargetCategory.value = v,
              ),
            ),
            const SizedBox(height: 14),

            /// TITLE
            _label('Title *'),
            _textField(
              controller: controller.title,
              hint: 'Enter Title',
            ),
            const SizedBox(height: 14),

            /// ASSIGNED TO DROPDOWN
            _label('Assigned To *'),
            Obx(
              () => _dropdown<AssignedTo>(
                hint: 'Select User',
                items: controller.assignedToList
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.userName ?? ''),
                        ))
                    .toList(),
                value: controller.selectedAssignedTo.value,
                onChanged: (v) =>
                    controller.selectedAssignedTo.value = v,
              ),
            ),
            const SizedBox(height: 14),

            /// TODO DATE
            _label('Todo Date'),
            _textField(
              controller: controller.tododate,
              hint: 'YYYY-MM-DD',
              readOnly: true,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  controller.tododate.text =
                      DateFormat('yyyy-MM-dd').format(picked);
                }
              },
            ),
            const SizedBox(height: 14),

            /// DUE DATE
            _label('Due Date'),
            _textField(
              controller: controller.duedate,
              hint: 'YYYY-MM-DD',
              readOnly: true,
              onTap: () async {
                final picked = await showDatePicker(
                  context: context,
                  initialDate: DateTime.now(),
                  firstDate: DateTime(2020),
                  lastDate: DateTime(2100),
                );
                if (picked != null) {
                  controller.duedate.text =
                      DateFormat('yyyy-MM-dd').format(picked);
                }
              },
            ),
            const SizedBox(height: 14),

            /// DESCRIPTION
            _label('Description'),
            _textField(
              controller: controller.description,
              hint: 'Enter Description',
              maxLines: 4,
            ),
            const SizedBox(height: 24),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await controller.submitActivity();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Activity',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  // ─── HELPERS ──────────────────────────────────────────────────────────────

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600)),
      );

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
    bool readOnly = false,
    VoidCallback? onTap,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      readOnly: readOnly,
      onTap: onTap,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _dropdown<T>({
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required T? value,
    required void Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          hint: Text(hint,
              style:
                  const TextStyle(fontSize: 13, color: Colors.black38)),
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}