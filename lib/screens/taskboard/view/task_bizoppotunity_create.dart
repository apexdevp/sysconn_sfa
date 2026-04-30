import 'package:flutter/material.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:get/get_instance/src/extension_instance.dart';
import 'package:get/get_state_manager/src/rx_flutter/rx_obx_widget.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/taskboard/task_opportunity_create_entity.dart';
import 'package:sysconn_sfa/screens/taskboard/controller/task_bicopportunity_create_controller.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';
import 'package:sysconn_sfa/widgetscustome/custome_dialogbox.dart';
import 'package:sysconn_sfa/widgetscustome/dropdowncontroller.dart';

// ignore: must_be_immutable
class TaskBizOpportunitiesCreate extends StatelessWidget {
  final Size size;
  final String? retailerCode;
  final String? taskid;
  final String? screenTypeMove;

  TaskBizOpportunitiesCreateEntity? opportunitiesEntity;
  final bool isCustomerReadOnly;
  final TaskBizOpportunitiesCreateController opportunitiesEditController =
      Get.find<TaskBizOpportunitiesCreateController>();

  TaskBizOpportunitiesCreate(
    this.size, {
    super.key,
    this.opportunitiesEntity,
    this.isCustomerReadOnly = false,
    this.retailerCode,
    this.taskid,
    this.screenTypeMove,
  });

  @override
  Widget build(BuildContext context) {
    // return CustomeDialogbox(
    //   title: 'Add Biz Opportunity',
    //   buttontitle: 'Save',
    //   maxHeight: 900,
    //   maxWidth: 1100,
    //   minWidth: 900, //850,
    //   function: () async {
    //     Utility.processLoadingWidget();
    //     await opportunitiesEditController.saveOpportunitiesApi();
    //   },

    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Add Biz Opportunity'),
      body: SingleChildScrollView(
        child: Column(
          children: [
            Padding(
              padding: const EdgeInsets.all(8),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Completely hidden
                            Visibility(
                              visible: false,
                              child: Obx(
                                () =>
                                    DropdownCustomList<
                                      TaskOpportunitiesCustomerEntity
                                    >(
                                      title: "Customer",
                                      hint: "Select Customer",
                                      isCompulsory: true,
                                      items: opportunitiesEditController
                                          .customerList
                                          .map(
                                            (item) => DropdownMenuItem(
                                              value: item,
                                              child: Text(
                                                item.retailerName ?? '',
                                              ),
                                            ),
                                          )
                                          .toList(),
                                      selectedValue: opportunitiesEditController
                                          .selectedCustomer,
                                      onChanged: (value) {
                                        opportunitiesEditController
                                                .selectedCustomer
                                                .value =
                                            value;
                                        opportunitiesEditController
                                                .retailerName
                                                .text =
                                            value?.retailerName ?? '';
                                        opportunitiesEditController
                                                .retailerCode
                                                .text =
                                            value?.retailerCode ?? '';
                                        opportunitiesEditController
                                                .customerPriceList =
                                            value?.priceList ?? '';
                                      },
                                    ),
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
                        child: DropdownCustomList<String>(
                          title: "Product",
                          hint: "Select/Search Product",

                          items: const [], // initially empty
                          selectedValue:
                              opportunitiesEditController.selectedProductName,
                          onSearchApi: (query) async {
                            await opportunitiesEditController.fetchItemMaster(
                              query,
                            );

                            return opportunitiesEditController.stockItemList
                                .map((item) {
                                  return DropdownMenuItem<String>(
                                    value: item.itemName,
                                    child: Text(item.itemName ?? ''),
                                  );
                                })
                                .toList();
                          },
                          onChanged: (value) async {
                            if (value == null || value.isEmpty) return;

                            final selectedItem = opportunitiesEditController
                                .stockItemList
                                .firstWhere((e) => e.itemName == value);

                            // Set product info
                            opportunitiesEditController.productDesc.text =
                                selectedItem.itemName ?? '';
                            opportunitiesEditController.productCode.text =
                                selectedItem.itemId ?? '';

                            // Handle rate
                            final rateText =
                                selectedItem.priceListRate?.toString() ?? '';
                            if (rateText.isEmpty) {
                              // No auto rate → allow user typing
                              opportunitiesEditController.rateController
                                  .clear();
                              opportunitiesEditController.isRateEditable.value =
                                  true;

                              // Keep customer price list for manual rate or set default
                              // opportunitiesEditController.selectedPriceListId =
                              //     opportunitiesEditController.customerPriceList;
                            } else {
                              // Auto-fill rate and lock editing if needed
                              opportunitiesEditController.rateController.text =
                                  rateText;
                              opportunitiesEditController.isRateEditable.value =
                                  false;

                              // Set the price list from the product
                              opportunitiesEditController.selectedPriceListId =
                                  opportunitiesEditController.customerPriceList;
                            }

                            // Set product info for API
                            opportunitiesEditController.selectedProductId =
                                selectedItem.itemId ?? '';
                            opportunitiesEditController
                                    .selectedProductNameForApi =
                                selectedItem.itemName ?? '';

                            // Recalculate total automatically
                            opportunitiesEditController.calculateTotal();

                            // Debug print
                            debugPrint(
                              "Rate: ${opportunitiesEditController.rateController.text.trim()}",
                            );
                            debugPrint(
                              "PriceListID: ${opportunitiesEditController.selectedPriceListId}",
                            );
                          },
                          onClear: () {
                            opportunitiesEditController.productDesc.clear();
                            opportunitiesEditController.productCode.clear();
                            opportunitiesEditController.rateController.clear();
                            opportunitiesEditController.isRateEditable.value =
                                true;
                            opportunitiesEditController.selectedProductId = '';
                            opportunitiesEditController
                                    .selectedProductNameForApi =
                                '';
                            opportunitiesEditController.selectedPriceListId =
                                '';
                            opportunitiesEditController.selectedRate = '0';
                          },
                        ),
                      ),

                      // const SizedBox(width: 12),

                      // Expanded(
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       // Obx(
                      //       //   () =>
                      //       DropdownCustomList<int>(
                      //         title: 'Source',
                      //         // isCompulsory:true,
                      //         hint: "Select Source",
                      //         items: opportunitiesEditController
                      //             .sourceList
                      //             .entries
                      //             .map(
                      //               (source) => DropdownMenuItem<int>(
                      //                 value: source.key,
                      //                 child: Text(source.value),
                      //               ),
                      //             )
                      //             .toList(),
                      //         selectedValue:
                      //             opportunitiesEditController.selectedSourceId,
                      //         onChanged: (int? newKey) {
                      //           opportunitiesEditController
                      //                   .selectedSourceId
                      //                   .value =
                      //               newKey; // Save key, not value
                      //         },
                      //       ),
                      //       // ),
                      //     ],
                      //   ),
                      // ),
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
                            // Obx(
                            //   () =>
                            DropdownCustomList<int>(
                              title: 'Source',
                              // isCompulsory:true,
                              hint: "Select Source",
                              items: opportunitiesEditController
                                  .sourceList
                                  .entries
                                  .map(
                                    (source) => DropdownMenuItem<int>(
                                      value: source.key,
                                      child: Text(source.value),
                                    ),
                                  )
                                  .toList(),
                              selectedValue:
                                  opportunitiesEditController.selectedSourceId,
                              onChanged: (int? newKey) {
                                opportunitiesEditController
                                        .selectedSourceId
                                        .value =
                                    newKey; // Save key, not value
                              },
                            ),
                            // ),
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
                            DropdownCustomList(
                              title: "Stage",
                              hint: "Select Stage",
                              items: opportunitiesEditController
                                  .stageList
                                  .entries
                                  .map(
                                    (stage) => DropdownMenuItem<int>(
                                      value: stage.key,
                                      child: Text(stage.value),
                                    ),
                                  )
                                  .toList(),
                              selectedValue:
                                  opportunitiesEditController.selectedStageId,
                              onChanged: (int? newKey) {
                                opportunitiesEditController
                                        .selectedStageId
                                        .value =
                                    newKey;

                                print("SELECTED KEY: $newKey");
                                print(
                                  "SELECTED TEXT: ${opportunitiesEditController.stageList[newKey]}",
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(width: 10),
                      // Expanded(
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       DropdownCustomList(
                      //         title: "Status",
                      //         hint: "Select Status",
                      //         items: opportunitiesEditController
                      //             .statusList
                      //             .entries
                      //             .map(
                      //               (status) => DropdownMenuItem<int>(
                      //                 value: status.key,
                      //                 child: Text(status.value),
                      //               ),
                      //             )
                      //             .toList(),
                      //         selectedValue:
                      //             opportunitiesEditController.selectedStatusId,
                      //         onChanged: (int? newKey) {
                      //           opportunitiesEditController
                      //                   .selectedStatusId
                      //                   .value =
                      //               newKey;
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      // Expanded(
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       DropdownCustomList(
                      //         title: "Stage",
                      //         hint: "Select Stage",
                      //         items: opportunitiesEditController
                      //             .stageList
                      //             .entries
                      //             .map(
                      //               (stage) => DropdownMenuItem<int>(
                      //                 value: stage.key,
                      //                 child: Text(stage.value),
                      //               ),
                      //             )
                      //             .toList(),
                      //         selectedValue:
                      //             opportunitiesEditController.selectedStageId,
                      //         onChanged: (int? newKey) {
                      //           opportunitiesEditController
                      //                   .selectedStageId
                      //                   .value =
                      //               newKey;

                      //           print("SELECTED KEY: $newKey");
                      //           print(
                      //             "SELECTED TEXT: ${opportunitiesEditController.stageList[newKey]}",
                      //           );
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(width: 10),
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            DropdownCustomList(
                              title: "Status",
                              hint: "Select Status",
                              items: opportunitiesEditController
                                  .statusList
                                  .entries
                                  .map(
                                    (status) => DropdownMenuItem<int>(
                                      value: status.key,
                                      child: Text(status.value),
                                    ),
                                  )
                                  .toList(),
                              selectedValue:
                                  opportunitiesEditController.selectedStatusId,
                              onChanged: (int? newKey) {
                                opportunitiesEditController
                                        .selectedStatusId
                                        .value =
                                    newKey;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormFieldView(
                              controller:
                                  opportunitiesEditController.qtyController,
                              title: 'Quantity',
                              isCompulsory: true,
                              hinttext: 'Enter Quantity',
                              keyboardType: TextInputType.number,
                            ),
                          ],
                        ),
                      ),
                      // const SizedBox(width: 5),

                      // Expanded(
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Obx(
                      //         //Shweta 26-03-26
                      //         () => CustomTextFormFieldView(
                      //           controller:
                      //               opportunitiesEditController.rateController,
                      //           title: 'Rate',
                      //           isCompulsory: true,
                      //           hinttext: 'Enter Rate',
                      //           readOnly: !opportunitiesEditController
                      //               .isRateEditable
                      //               .value,
                      //           fillColor:
                      //               opportunitiesEditController
                      //                   .isRateEditable
                      //                   .value
                      //               ? Colors.white
                      //               : Colors.grey.shade200,
                      //           keyboardType: TextInputType.number,
                      //           // inputFormatters: [
                      //           //   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                      //           // ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // const SizedBox(width: 5),

                      // Expanded(
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       CustomTextFormFieldView(
                      //         controller:
                      //             opportunitiesEditController.totalController,
                      //         title: 'Total',
                      //         hinttext: 'Total',
                      //         isCompulsory: true,
                      //         // enabled: false,
                      //         readOnly: true,
                      //         fillColor: Colors.grey.shade200,
                      //         // suffixIcon: const Icon(
                      //         //   Icons.percent,
                      //         //   color: Color(0xFF000000),
                      //         // ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),

                  SizedBox(height: size.height * 0.01),
Row(
                    children: [
                      // Expanded(
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       CustomTextFormFieldView(
                      //         controller:
                      //             opportunitiesEditController.qtyController,
                      //         title: 'Quantity',
                      //         isCompulsory: true,
                      //         hinttext: 'Enter Quantity',
                      //         keyboardType: TextInputType.number,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(width: 5),

                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Obx(
                              //Shweta 26-03-26
                              () => CustomTextFormFieldView(
                                controller:
                                    opportunitiesEditController.rateController,
                                title: 'Rate',
                                isCompulsory: true,
                                hinttext: 'Enter Rate',
                                readOnly: !opportunitiesEditController
                                    .isRateEditable
                                    .value,
                                fillColor:
                                    opportunitiesEditController
                                        .isRateEditable
                                        .value
                                    ? Colors.white
                                    : Colors.grey.shade200,
                                keyboardType: TextInputType.number,
                                // inputFormatters: [
                                //   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                                // ],
                              ),
                            ),
                          ],
                        ),
                      ),

                      // const SizedBox(width: 5),

                      // Expanded(
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       CustomTextFormFieldView(
                      //         controller:
                      //             opportunitiesEditController.totalController,
                      //         title: 'Total',
                      //         hinttext: 'Total',
                      //         isCompulsory: true,
                      //         // enabled: false,
                      //         readOnly: true,
                      //         fillColor: Colors.grey.shade200,
                      //         // suffixIcon: const Icon(
                      //         //   Icons.percent,
                      //         //   color: Color(0xFF000000),
                      //         // ),
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
Row(
                    children: [
                      // Expanded(
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       CustomTextFormFieldView(
                      //         controller:
                      //             opportunitiesEditController.qtyController,
                      //         title: 'Quantity',
                      //         isCompulsory: true,
                      //         hinttext: 'Enter Quantity',
                      //         keyboardType: TextInputType.number,
                      //       ),
                      //     ],
                      //   ),
                      // ),
                      // const SizedBox(width: 5),

                      // Expanded(
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       Obx(
                      //         //Shweta 26-03-26
                      //         () => CustomTextFormFieldView(
                      //           controller:
                      //               opportunitiesEditController.rateController,
                      //           title: 'Rate',
                      //           isCompulsory: true,
                      //           hinttext: 'Enter Rate',
                      //           readOnly: !opportunitiesEditController
                      //               .isRateEditable
                      //               .value,
                      //           fillColor:
                      //               opportunitiesEditController
                      //                   .isRateEditable
                      //                   .value
                      //               ? Colors.white
                      //               : Colors.grey.shade200,
                      //           keyboardType: TextInputType.number,
                      //           // inputFormatters: [
                      //           //   FilteringTextInputFormatter.allow(RegExp(r'^\d*\.?\d*$')),
                      //           // ],
                      //         ),
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // const SizedBox(width: 5),

                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormFieldView(
                              controller:
                                  opportunitiesEditController.totalController,
                              title: 'Total',
                              hinttext: 'Total',
                              isCompulsory: true,
                              // enabled: false,
                              readOnly: true,
                              fillColor: Colors.grey.shade200,
                              // suffixIcon: const Icon(
                              //   Icons.percent,
                              //   color: Color(0xFF000000),
                              // ),
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
                              controller: opportunitiesEditController.title,
                              title: 'User Remark',
                              hinttext: 'Enter User Remark',
                              // isCompulsory: true,
                            ),
                          ],
                        ),
                      ),

                      // const SizedBox(width: 5),

                      // Expanded(
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       // Obx(
                      //       //   () => DropdownCustomList<String>(
                      //       DropdownCustomList<String>(
                      //         title: "Priority",
                      //         hint: "Select Priority",
                      //         isCompulsory: true,
                      //         items: opportunitiesEditController.arrPriority
                      //             .map(
                      //               (item) => DropdownMenuItem<String>(
                      //                 value: item,
                      //                 child: Text(item),
                      //               ),
                      //             )
                      //             .toList(),
                      //         selectedValue:
                      //             opportunitiesEditController.selectedPriority,
                      //         onChanged: (value) {
                      //           opportunitiesEditController
                      //                   .selectedPriority
                      //                   .value =
                      //               value;
                      //         },
                      //       ),
                      //     ],
                      //   ),
                      // ),
                    ],
                  ),

                  SizedBox(
                    height: size.height * 0.01,
                  ), 
                  //shweta 09-03-26 to here

                  Row(
                    children: [
                      // Expanded(
                      //   child: Column(
                      //     mainAxisSize: MainAxisSize.min,
                      //     crossAxisAlignment: CrossAxisAlignment.start,
                      //     children: [
                      //       CustomTextFormFieldView(
                      //         controller: opportunitiesEditController.title,
                      //         title: 'User Remark',
                      //         hinttext: 'Enter User Remark',
                      //         // isCompulsory: true,
                      //       ),
                      //     ],
                      //   ),
                      // ),

                      // const SizedBox(width: 5),

                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            // Obx(
                            //   () => DropdownCustomList<String>(
                            DropdownCustomList<String>(
                              title: "Priority",
                              hint: "Select Priority",
                              isCompulsory: true,
                              items: opportunitiesEditController.arrPriority
                                  .map(
                                    (item) => DropdownMenuItem<String>(
                                      value: item,
                                      child: Text(item),
                                    ),
                                  )
                                  .toList(),
                              selectedValue:
                                  opportunitiesEditController.selectedPriority,
                              onChanged: (value) {
                                opportunitiesEditController
                                        .selectedPriority
                                        .value =
                                    value;
                              },
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),

                  SizedBox(
                    height: size.height * 0.01,
                  ), //shweta 09-03-26 to here


                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            CustomTextFormFieldView(
                              controller:
                                  opportunitiesEditController.description,
                              keyboardType: TextInputType.text,
                              title: 'Customer Remark',
                              maxLines: 5,
                              hinttext: 'Enter Customer Remark',
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
      bottomNavigationBar: SafeArea(
        child: Container(
          padding: const EdgeInsets.all(12),
          child: SizedBox(
            width: size.width * 0.2,
            child: ResponsiveButton(
              title: 'Save',
              function: () async {
                Utility.processLoadingWidget();
                await opportunitiesEditController.saveOpportunitiesApi();
              },
            ),
          ),
        ),
      ),
    );
  }
}
