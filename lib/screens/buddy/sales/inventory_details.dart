import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:sysconn_sfa/Utility/textFormField.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/controllers/buddy/sales/inventory_controller.dart';
import 'package:sysconn_sfa/api/entity/buddy/sales/sales_inventory_entity.dart';
import 'package:sysconn_sfa/widgets/custom_appbar.dart';
import 'package:sysconn_sfa/widgets/customautocompletefield.dart';
import 'package:sysconn_sfa/widgets/dropdownlist.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';


class InventoryDetails extends StatelessWidget {
  final String? uniqueId;
  final String? title;
  final String? vchType;
  final SalesInventoryEntity? itemlist;

  const InventoryDetails({
    super.key,
    this.uniqueId,
    this.title,
    this.itemlist,
    this.vchType,
  });

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      InventoryDetailsController(
        uniqueId: uniqueId,
        title: title,
        itemlist: itemlist,
        vchType: vchType,
      ),
    );

    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: customAppbar(
        context: context,
        title: title!,
        actions: [
          title == 'Add Item'
              ? Container()
              : IconButton(
                  icon: const Icon(Icons.delete, color: Colors.white),
                  onPressed: () {
                    Utility.showAlertYesNo(
                        title: 'Alert',
                        msg: 'Do you want to delete ?',
                        yesBtnFun: () async {
                          Navigator.pop(context);
                          await controller.deleteItemPostApi(
                              invId: itemlist!.itemId!);
                        },
                        noBtnFun: () => Navigator.pop(context));
                  },
                ),
        ],
      ),

      body:  ListView(
            children: [
              // ------------------ STOCK ITEM ------------------
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  const Icon(FontAwesomeIcons.boxOpen),
                  const SizedBox(width: 10),
                  Text('Stock Item', style: kTxtStlB),
                ]),
              ),

              // ------------------ ITEM CARD ------------------
              Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  child: Column(children: [
                    Row(children: [
                      CustomAutoCompleteFieldView(
                        isCompulsory: true,
                        title: 'Item Name',
                        controllerValue: controller.itemName.value,
                        optionsBuilder: (value) {
                          return controller.stockItemList
                              .where((e) => e.itemName!
                                  .toLowerCase()
                                  .contains(value.text.toLowerCase()))
                              .toList();
                        },
                        displayStringForOption: (stock) => stock.itemName!,
                        closeControllerFun: () {
                          controller.itemName.value = '';
                          controller.salesInvEntity.itemId = '';
                          controller.salesInvEntity.itemName = '';
                          controller.salesInvEntity.gstrate = '';
                          controller.salesInvEntity.cessrate = '';
                        },
                        onTextChanged: (txt) async {
                          await controller.itemsListData(txt);
                        },
                        onSelected: (stockItem) {
                          controller.salesInvEntity.itemId = stockItem.itemId;
                          controller.salesInvEntity.itemName = stockItem.itemName;
                          controller.salesInvEntity.gstrate = stockItem.taxRate;
                          controller.salesInvEntity.cessrate = stockItem.cess;
                          controller.itemName.value = stockItem.itemName!;
                      
                          controller.isAddUnitApplicable.value =
                              stockItem.additionalUnitApplicable == 'Yes';
                      
                          controller.conversion =
                              stockItem.conversion == '' ? 0 : num.parse(stockItem.conversion!);
                      
                          controller.denominator =
                              stockItem.denominator == '' ? 0 : num.parse(stockItem.denominator!);
                      
                          controller.salesInvEntity.rate = stockItem.priceListRate;
                          controller.salesInvEntity.discount =
                              stockItem.priceListDiscount;
                      
                          controller.rateTextController.text =
                              stockItem.priceListRate ?? "0";
                          controller.discountTextController.text =
                              stockItem.priceListDiscount ?? "0";
                      
                          controller.cashDiscController.text =
                              stockItem.cashDiscount ?? "0";
                          controller.schemeDiscController.text =
                              stockItem.schemeDiscount ?? "0";
                        },
                      )
                    ]),

                    const SizedBox(height: 10),

                    Row(children: [
                      CustomTextFormFieldView(
                        controller: controller.itemRemarkController,
                        title: 'Remark',
                        onChanged: (text) =>
                            controller.salesInvEntity.remark = text,
                      ),
                    ]),
                  ]),
                ),
              ),

              // ------------------ ENTRY HEADER ------------------
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(children: [
                  const Icon(Icons.money),
                  const SizedBox(width: 10),
                  Text('Entry', style: kTxtStlB),
                ]),
              ),

              // ------------------ ENTRY CARD ------------------
              Padding(
                padding: const EdgeInsets.all(8),
                child: Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(children: [
                      // ---------- QUANTITY ----------
                      Row(children: [
                        CustomTextFormFieldView(
                          controller: controller.quantityTextController,
                          isCompulsory: true,
                          title: 'Quantity(Base Unit)',
                          keyboardType: TextInputType.number,
                          onChanged: (text) {
                            controller.salesInvEntity.qty = text;
                        
                            if (text.trim().isNotEmpty) {
                              num freeQty = controller.freeQtyController.text.trim().isEmpty
                                  ? 0
                                  : num.parse(controller.freeQtyController.text);
                        
                              controller.totalQtyController.text =
                                  (num.parse(text) + freeQty).toString();
                            }
                        
                            var cal = controller.calTotalAmountValue(
                              invRate: controller.rateTextController.text,
                              invQty: controller.quantityTextController.text,
                              invDisc: controller.discountTextController.text,
                              taxRate: controller.salesInvEntity.gstrate!,
                            );
                        
                            controller.salesInvEntity.gstvalue = cal.gstvalue;
                            controller.salesInvEntity.netValue = cal.netValue;
                            controller.salesInvEntity.cessvalue = cal.cessvalue;
                            controller.salesInvEntity.value = cal.value;
                        
                            if (controller.salesInvEntity.itemId != null &&
                                controller.isAddUnitApplicable.value &&
                                text.trim().isNotEmpty) {
                              controller.salesInvEntity.altQty =
                                  (controller.denominator /
                                          controller.conversion *
                                          num.parse(text))
                                      .toStringAsFixed(2);
                            }
                          },
                        ),
                      ]),

                      const SizedBox(height: 12),

                      // ---------- RATE + ALT QTY ----------
                      Row(children: [
                        CustomTextFormFieldView(
                          controller: controller.rateTextController,
                          isCompulsory: true,
                          title: 'Rate',
                          keyboardType: TextInputType.number,
                          onChanged: (text) {
                            controller.salesInvEntity.rate = text;
                        
                            var cal = controller.calTotalAmountValue(
                              invRate: text,
                              invQty: controller.quantityTextController.text,
                              invDisc: controller.discountTextController.text,
                              taxRate: controller.salesInvEntity.gstrate!,
                            );
                        
                            controller.salesInvEntity.gstvalue = cal.gstvalue;
                            controller.salesInvEntity.netValue = cal.netValue;
                            controller.salesInvEntity.cessvalue = cal.cessvalue;
                            controller.salesInvEntity.value = cal.value;
                          },
                        ),

                        const SizedBox(width: 10),

                         SizedBox(
                              width: size.width * 0.3,
                              height: 40,
                              child: InputDecorator(
                                decoration: InputDecoration(
                                  labelText: 'Quantity\n(Alternate Units)',
                                  labelStyle: kTxtStl11GreyB,
                                  enabledBorder: OutlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.grey.shade400)),
                                ),
                                child: Text(
                                  controller.salesInvEntity.altQty ?? "",
                                  style: kTxtStl11GreyN,
                                ),
                              ),
                            ),
                      ]),

                      const SizedBox(height: 12),

                      // ---------- DISCOUNT ----------
                      Row(children: [
                        CustomTextFormFieldView(
                          controller: controller.discountTextController,
                          isCompulsory: true,
                          title: 'Total Discount',
                          keyboardType: TextInputType.number,
                          onChanged: (text) {
                            controller.salesInvEntity.discount = text;
                        
                            var cal = controller.calTotalAmountValue(
                              invRate: controller.rateTextController.text,
                              invQty: controller.quantityTextController.text,
                              invDisc: text,
                              taxRate: controller.salesInvEntity.gstrate!,
                            );
                        
                            controller.salesInvEntity.gstvalue = cal.gstvalue;
                            controller.salesInvEntity.netValue = cal.netValue;
                            controller.salesInvEntity.cessvalue = cal.cessvalue;
                            controller.salesInvEntity.value = cal.value;
                          },
                        ),
                      ]),

                      const SizedBox(height: 12),

                      // ---------- PER DROPDOWN ----------
                      Obx(() => Row(children: [
                            DropdownCustomList(
                              title: 'Per',
                              value: controller.perSelected.value,
                              items: controller.unitPerList
                                  .map((e) =>
                                      DropdownMenuItem(value: e, child: Text(e)))
                                  .toList(),
                              onChanged: (val) {
                                controller.perSelected.value = val!;
                                controller.salesInvEntity.altQtyPer = val;

                                var cal = controller.calTotalAmountValue(
                                  invRate: controller.rateTextController.text,
                                  invQty: val == 'Base Units'
                                      ? controller.quantityTextController.text
                                      : controller.salesInvEntity.altQty!,
                                  invDisc: controller.discountTextController.text,
                                  taxRate: controller.salesInvEntity.gstrate!,
                                );

                                controller.salesInvEntity.gstvalue = cal.gstvalue;
                                controller.salesInvEntity.netValue = cal.netValue;
                                controller.salesInvEntity.cessvalue = cal.cessvalue;
                                controller.salesInvEntity.value = cal.value;
                              },
                            ),
                          ])),

                      const SizedBox(height: 12),

                      // ---------- FREE QTY ----------
                      Row(children: [
                        CustomTextFormFieldView(
                          controller: controller.freeQtyController,
                          title: 'Free Quantity',
                          keyboardType: TextInputType.number,
                          onChanged: (txt) {
                            if (txt.trim().isNotEmpty) {
                              num billQty = controller
                                      .quantityTextController.text
                                      .trim()
                                      .isEmpty
                                  ? 0
                                  : num.parse(
                                      controller.quantityTextController.text);
                        
                              controller.totalQtyController.text =
                                  (billQty + num.parse(txt)).toString();
                            }
                          },
                        ),

                        const SizedBox(width: 10),

                        CustomTextFormFieldView(
                          enabled: false,
                          controller: controller.quantityTextController,
                          title: 'Billed Quantity',
                        ),
                      ]),

                      const SizedBox(height: 12),

                      Row(children: [
                        CustomTextFormFieldView(
                          enabled: false,
                          controller: controller.totalQtyController,
                          title: 'Total Quantity',
                        ),
                      ]),

                      const SizedBox(height: 12),

                      // ---------- GODOWN ----------
                      Row(children: [
                        CustomAutoCompleteFieldView(
                          isCompulsory: true,
                          title: "Godown List",
                          controllerValue: controller.godownname.value,
                          optionsBuilder: (value) {
                            return controller.godownDatalist
                                .where((g) => g.godownName!
                                    .toLowerCase()
                                    .contains(value.text.toLowerCase()))
                                .toList();
                          },
                          displayStringForOption: (g) => g.godownName!,
                          closeControllerFun: () {
                            controller.godownname.value = '';
                            controller.godownid.value = '';
                          },
                          onSelected: (godown) {
                            controller.godownname.value = godown.godownName!;
                            controller.godownid.value = godown.godownId!;
                          },
                        ),
                      ]),

                      const SizedBox(height: 16),

                      // ---------- AMOUNT ----------
                      Row(mainAxisAlignment: MainAxisAlignment.end, children: [
                        Text('Amount : ', style: kTxtStl11B),
                        Text(
                          controller.salesInvEntity.value ?? "0",
                          style: kTxtStl12B,
                        ),
                      ]),

                      const SizedBox(height: 12),

                      // ---------- SAVE BUTTON ----------
                      SizedBox(
                        width: size.width * 0.3,
                        child: ResponsiveButton(
                          title: 'Save',
                          function: () async {
                            Utility.showCircularLoadingWid(context);
                            await controller.salesItemPost(
                                itemSelectedEntity: controller.salesInvEntity);
                          },
                        ),
                      ),
                    ]),
                  ),
                ),
              ),
            ],
          ),
    );
  }
}
