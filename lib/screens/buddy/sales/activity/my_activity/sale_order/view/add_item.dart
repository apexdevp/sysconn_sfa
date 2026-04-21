import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/order/so_inv_report_entity.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/sale_order/controller/so_create_controller.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';
import 'package:sysconn_sfa/widgetscustome/dropdowncontroller.dart';
import 'package:sysconn_sfa/widgetscustome/responsive_button.dart';

class AddItem extends StatelessWidget {
  final CreateSoController controller;
  final SOInvReportEntity? soInv;
  AddItem({super.key, required this.controller, this.soInv});

  @override
  Widget build(BuildContext context) {
    final Size size = MediaQuery.of(context).size;
    if (soInv != null) {
      controller.setEditItem(soInv!); //  PREFILL DATA
    }
    return Scaffold(
      appBar: SfaCustomAppbar(
        title: 'Add Item',
        showDefaultActions: false,
        actions: [
          soInv != null
              ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Utility.showAlertYesNo(
                      iconData: Icons.help_outline_rounded,
                      iconcolor: Colors.blueAccent,
                      title: 'Alert',
                      msg: 'Do you want to delete this item ?',
                      yesBtnFun: () async {
                        await controller.deleteInventoryItem(soInv!.invId!);
                      },
                      noBtnFun: () {
                        Get.back();
                      },
                    );
                  },
                )
              : Container(),
        ],
      ),
      body: Column(
        children: [
          Expanded(
            child: Padding(
              padding: const EdgeInsets.all(8.0),
              child: ListView(
                children: [
                  Container(
                    width: size.width,
                    padding: EdgeInsets.all(8.0),
                    child: Row(
                      children: [
                        Icon(FontAwesomeIcons.boxOpen),
                        SizedBox(width: 10.0),
                        Text('Stock Item', style: kTxtStlB),
                      ],
                    ),
                  ),
                  Card(
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Column(
                        children: [
                          Row(
                            children: [
                              // Obx(
                              //   () =>
                              Expanded(
                                child: DropdownCustomList(
                                  title: "Item Name",
                                  selectedValue: controller.itemName,
                                  items: const [],
                                  onSearchApi: (query) async {
                                    await controller.itemsListData(query);

                                    return controller.stockItemList.map((e) {
                                      return DropdownMenuItem(
                                        value: e.itemName,
                                        child: Text(e.itemName!),
                                      );
                                    }).toList();
                                  },
                                  onChanged: (value) {
                                    final selectedItem = controller
                                        .stockItemList
                                        .firstWhere((e) => e.itemName == value);

                                    controller.onItemSelected(selectedItem);
                                  },
                                ),
                              ),
                              // ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.01),
                          Row(
                            children: [
                              CustomTextFormFieldView(
                                controller: controller.qtyCtrl,
                                title: "Billed Qty",
                                keyboardType: TextInputType.number,
                                onChanged: (val) {
                                  // inv.update((i) => i!.qty = val);
                                  // recalcTotalQty();
                                  // updateAmount();
                                  controller.onQtyChanged(val);
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.01),
                          Row(
                            children: [
                              Obx(
                                () => CustomTextFormFieldView(
                                  controller: controller.rateCtrl,
                                  title: "Rate",
                                  enabled: controller.ispricelistrate.value,
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    // inv.update((i) => i!.rate = val);
                                    // updateAmount();
                                    controller.onRateChanged(val);
                                  },
                                ),
                              ),
                              SizedBox(width: 10),
                              Obx(
                                () => CustomTextFormFieldView(
                                  controller: controller.discCtrl,
                                  title: "Discount",
                                  enabled: controller.ispricelistrate.value,
                                  keyboardType: TextInputType.number,
                                  onChanged: (val) {
                                    controller.onDiscountChanged(val);
                                    // inv.update((i) => i!.discount = val);
                                    // updateAmount();
                                  },
                                ),
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.01),
                          Row(
                            children: [
                              CustomTextFormFieldView(
                                controller: controller.itemRemarkCtrl,
                                maxLines: 3,
                                title: "Item Description",
                                onChanged: (val) {
                                  // inv.value.remark = itemRemark.text;
                                  controller.onRemarkChanged;
                                },
                              ),
                            ],
                          ),
                          SizedBox(height: size.height * 0.01),
                          Row(
                            children: [
                              Text("Amount : ", style: kTxtStl12B),
                              Obx(
                                () => Text(
                                  controller.inv.value.value ?? "0",
                                  style: kTxtStl13B,
                                ),
                              ),
                            ],
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
          Container(
            width: size.width * 0.6,
            padding: const EdgeInsets.all(4),
            child: ResponsiveButton(
              title: 'Save',
              function: () async {
                final success = await controller.soInventoryDetailsPost(
                  salesOrderEntity: controller.inv.value,
                );
                if (success) {
                  if (kDebugMode) {
                    debugPrint("Saved successfully");
                  }
                }
              },
            ),
          ),
        ],
      ),
    );
  }
}
