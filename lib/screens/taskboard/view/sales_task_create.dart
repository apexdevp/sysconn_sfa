import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/taskboard/sales_task_dropdown_model.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/salestaskeditcontroller.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';
import 'package:sysconn_sfa/widgetscustome/custome_dialogbox.dart';
import 'package:sysconn_sfa/widgetscustome/dropdowncontroller.dart';

// ignore: must_be_immutable
class SalesTaskCreateDialog extends StatelessWidget {
  final Size size;
  final Map<String, dynamic>? rowData;
  final bool hideCustomerSourceBiz;
  final bool followUpTask;

  final SalesTaskEditController salesTaskController = Get.find();
  bool get isEdit => rowData != null;

  SalesTaskCreateDialog(
    this.size, {
    super.key,
    this.rowData,
    this.hideCustomerSourceBiz = false,
    this.followUpTask = false,
  }) {
    if (rowData != null) {
      //Edit
      salesTaskController.editingRowData.value = rowData;
      salesTaskController.loadTaskForEdit(rowData!);
    } else {
      //Add
      salesTaskController.clearFields(followUpTask: followUpTask);
    }
  }

  @override
  Widget build(BuildContext context) {
    return CustomeDialogbox(
      title: isEdit
          ? 'Update Sales Task'
          : followUpTask
          ? 'Add Follow-up Sales Task'
          : 'Add Sales Task',
      buttontitle: isEdit ? 'Update' : 'Save',
      maxHeight: 750,
      maxWidth: 850,
      function: () async {
        Utility.processLoadingWidget();
        await salesTaskController.submitSalesTask();
      },
      content: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!hideCustomerSourceBiz &&
                                !followUpTask &&
                                !isEdit)
                              Obx(
                                () => DropdownCustomList<CustomerList>(
                                  title: "Customer",
                                  hint: "Select Customer",
                                  isCompulsory: true,
                                  items: salesTaskController.customerList
                                      .map(
                                        (item) =>
                                            DropdownMenuItem<CustomerList>(
                                              value: item,
                                              child: Text(
                                                item.retailerName ?? '',
                                              ),
                                            ),
                                      )
                                      .toList(),
                                  selectedValue:
                                      salesTaskController.selectedCustomer,
                                  onChanged: (value) {
                                    salesTaskController.selectedCustomer.value =
                                        value;
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            if (!hideCustomerSourceBiz && !followUpTask)
                              Obx(
                                () => DropdownCustomList<String>(
                                  title: "Source",
                                  hint: "Select Source",
                                  items: salesTaskController.sourceList
                                      .map(
                                        (item) => DropdownMenuItem<String>(
                                          value: item,
                                          child: Text(item),
                                        ),
                                      )
                                      .toList(),
                                  selectedValue:
                                      salesTaskController.selectedSource,
                                  onChanged: (value) {
                                    salesTaskController.selectedSource.value =
                                        value;
                                  },
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      if (!hideCustomerSourceBiz && !followUpTask)
                        Expanded(
                          child: Column(
                            mainAxisSize: MainAxisSize.min,
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              if (!hideCustomerSourceBiz)
                                Obx(
                                  () => DropdownCustomList<BizCategory>(
                                    title: "Business Opportunity",
                                    hint: "Select Opportunity",
                                    items: salesTaskController.bizCategoryList
                                        .map(
                                          (item) =>
                                              DropdownMenuItem<BizCategory>(
                                                value: item,
                                                child: Text(item.title ?? ''),
                                              ),
                                        )
                                        .toList(),
                                    selectedValue:
                                        salesTaskController.selectedBizCategory,
                                    onChanged: (value) {
                                      salesTaskController
                                              .selectedBizCategory
                                              .value =
                                          value;
                                    },
                                  ),
                                ),
                            ],
                          ),
                        ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.01),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => DropdownCustomList<EventList>(
                                title: 'Event',
                                isCompulsory: true,
                                hint: "Select Event",
                                items: salesTaskController.eventList
                                    .map(
                                      (item) => DropdownMenuItem<EventList>(
                                        value: item,
                                        child: Text(item.name ?? ''),
                                      ),
                                    )
                                    .toList(),
                                selectedValue:
                                    salesTaskController.selectedEvent,
                                onChanged: (value) {
                                  salesTaskController.selectedEvent.value =
                                      value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      // if (isEdit)
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => DropdownCustomList<String>(
                                title: "Status",
                                hint: "Select Status",
                                isCompulsory: true,
                                items: salesTaskController.statuslist
                                    .map(
                                      (item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      ),
                                    )
                                    .toList(),
                                selectedValue:
                                    salesTaskController.selectedstatus,
                                onChanged: (value) {
                                  salesTaskController.selectedstatus.value =
                                      value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => DropdownCustomList<String>(
                                title: "Division Category",
                                hint: "Select Category",
                                isCompulsory: true,
                                items: salesTaskController.divisioncategoryList
                                    .map(
                                      (item) => DropdownMenuItem<String>(
                                        value: item,
                                        child: Text(item),
                                      ),
                                    )
                                    .toList(),
                                selectedValue:
                                    salesTaskController.selectedDivision,
                                onChanged: (value) {
                                  salesTaskController.selectedDivision.value =
                                      value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => DropdownCustomList<TargetCategory>(
                                title: "Target Category",
                                hint: "Select Category",
                                isCompulsory: true,
                                items: salesTaskController.targetCategoryList
                                    .map(
                                      (item) =>
                                          DropdownMenuItem<TargetCategory>(
                                            value: item,
                                            child: Text(item.name ?? ''),
                                          ),
                                    )
                                    .toList(),
                                selectedValue:
                                    salesTaskController.selectedTargetCategory,
                                onChanged: (value) {
                                  salesTaskController
                                          .selectedTargetCategory
                                          .value =
                                      value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormFieldView(
                              controller: salesTaskController.title,
                              title: 'Title',
                              isCompulsory: true,
                              hinttext: 'Enter Title',
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 12),

                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              () => DropdownCustomList<AssignedTo>(
                                title: 'Assigned To',
                                isCompulsory: true,
                                hint: "Select User",
                                items: salesTaskController.assignedToList
                                    .map(
                                      (item) => DropdownMenuItem<AssignedTo>(
                                        value: item,
                                        child: Text(item.userName ?? ''),
                                      ),
                                    )
                                    .toList(),
                                selectedValue:
                                    salesTaskController.selectedAssignedTo,
                                onChanged: (value) {
                                  salesTaskController.selectedAssignedTo.value =
                                      value;
                                },
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormFieldView(
                              controller: salesTaskController.tododate,
                              title: 'ToDo Date',
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  salesTaskController.tododate.text =
                                      DateFormat(
                                        'yyyy-MM-dd',
                                      ).format(pickedDate);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormFieldView(
                              controller: salesTaskController.duedate,
                              title: 'Due Date',
                              onTap: () async {
                                final pickedDate = await showDatePicker(
                                  context: context,
                                  initialDate: DateTime.now(),
                                  firstDate: DateTime(2020),
                                  lastDate: DateTime(2100),
                                );
                                if (pickedDate != null) {
                                  salesTaskController.duedate.text = DateFormat(
                                    'yyyy-MM-dd',
                                  ).format(pickedDate);
                                }
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormFieldView(
                              controller: salesTaskController.description,
                              keyboardType: TextInputType.text,
                              title: 'Description',
                              hinttext: 'Enter Description',
                              maxLines: 5,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
