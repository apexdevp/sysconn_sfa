import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/company/voucherentity.dart';
import 'package:sysconn_sfa/screens/buddy/sale_order/controller/salesorder_pdfcontroller.dart';
import 'package:sysconn_sfa/screens/buddy/sale_order/controller/so_create_controller.dart';
import 'package:sysconn_sfa/screens/buddy/sale_order/view/add_business_opportunity.dart';
import 'package:sysconn_sfa/screens/buddy/sale_order/view/add_item.dart';
import 'package:sysconn_sfa/screens/buddy/sale_order/view/sales_order_pdf_view.dart';
import 'package:sysconn_sfa/screens/buddy/sale_order/view/so_additional_details.dart';
import 'package:sysconn_sfa/widgets/customautocompletefield.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';
import 'package:sysconn_sfa/widgetscustome/dropdowncontroller.dart';
import 'package:sysconn_sfa/widgetscustome/responsive_button.dart';

class SoCreate extends StatelessWidget {
  final String? hedId;
  SoCreate({super.key, this.hedId});

  Row subtitleRow(String title, String value) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(Get.context!).size.width * 0.30,
          child: Text(
            title,
            style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
          ),
        ),
        Text(': '),
        Expanded(child: Text(value, style: TextStyle(fontSize: 13.0))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final CreateSoController controller = Get.put(
      CreateSoController(hedId: hedId),
    );
    final Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: SfaCustomAppbar(
        title:
            "${(hedId == null || hedId == '') ? 'Create' : 'Update'} Sales Order",
        showDefaultActions: false,
        actions: [
          hedId != null
              ? IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    Utility.showAlertYesNo(
                      iconData: Icons.help_outline_rounded,
                      iconcolor: Colors.blueAccent,
                      title: 'Alert',
                      msg: 'Do you want to delete this?',
                      yesBtnFun: () async {
                        await controller.deleteOrder();
                      },
                      noBtnFun: () {
                        Get.back();
                      },
                    );
                  },
                )
              : Container(),
          IconButton(icon: new Icon(Icons.send), onPressed: () {  Get.to(
              () => SalesOrderPDFView(),
              binding: BindingsBuilder(() {
                Get.put(
                  SalesOrderPdfController(
                    soHeaderEntity: controller.salesOrderHeaderEntity.value,
                    vchType:
                        controller.vchSelectedName.value, // ?? 'Sales Order',
                  ),
                );
                //     debugPrint('gbdb${controller.salesOrderHeaderEntity.value!.termncondition}');
              }),
            );}),
        ],
      ),
      body: Column(
        children: [
          Padding(
            padding: EdgeInsets.all(8.0),
            child: Container(
              width: size.width,
              height: size.height * 0.1,
              margin: EdgeInsets.fromLTRB(
                size.width * 0.1,
                0,
                size.width * 0.1,
                10,
              ),
              padding: EdgeInsets.all(9.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                color: Colors.grey.shade300,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    Icons.receipt_long,
                    size: size.height * 0.06,
                    color: Colors.orangeAccent,
                  ),
                  SizedBox(width: 10.0),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Total amount', style: kTxtStl13GreyN),
                      Obx(
                        () => Text(
                          '${indianRupeeFormat(controller.itemTotalNetAmount.value)}',

                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.orangeAccent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Column(
              children: [
                Expanded(
                  child: Obx(() {
                    if (controller.isDataLoad.value == 0) {
                      return Center(child: Utility.processLoadingWidget());
                    }
                    return ListView(
                      children: [
                        Column(
                          children: [
                            Container(
                              width: size.width,
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Icon(Icons.assignment_outlined),
                                  SizedBox(width: 10.0),
                                  Text(
                                    '${(hedId == null || hedId == '') ? 'Create' : 'Update'} Sales Order',
                                    style: kTxtStlB,
                                  ),
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
                                        CustomTextFormFieldView(
                                          enabled:
                                              (controller
                                                  .salesOrderHeaderEntity
                                                  .value ==
                                              null),
                                          controller: controller.dateController,
                                          title: 'Date',
                                          onTap: () async {
                                            FocusScope.of(context).unfocus();
                                            final date = await selectDateSingle(
                                              dateSelected:
                                                  controller.selectedDate.value,
                                            );
                                            controller.selectedDate.value =
                                                date;
                                            controller.dateController.text =
                                                DateFormat(
                                                  'yyyy-MM-dd',
                                                ).format(date);
                                          },
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Expanded(
                                          child: Column(
                                            children: [
                                              Obx(
                                                () => DropdownCustomList<VoucherEntity>(
                                                  title: "Voucher Name",
                                                  hint: "Select Voucher Name",
                                                  items: controller
                                                      .vchEntityList
                                                      .map((item) {
                                                        return DropdownMenuItem<
                                                          VoucherEntity
                                                        >(
                                                          value: item,
                                                          child: Text(
                                                            item.vchTypeName ??
                                                                '',
                                                          ),
                                                        );
                                                      })
                                                      .toList(),
                                                  selectedValue: controller
                                                      .voucherEntitySelected,
                                                  onChanged: (value) {
                                                    if (value != null) {
                                                      controller.setVoucher(
                                                        value,
                                                      );
                                                    }
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
                                        Obx(
                                          () => CustomAutoCompleteFieldView(
                                            title: 'Party Name',
                                            enabled:
                                                (controller
                                                    .salesOrderHeaderEntity
                                                    .value ==
                                                null),
                                            optionsBuilder: (value) =>
                                                controller.partyEntityList
                                                    .where(
                                                      (e) => e.partyName!
                                                          .toLowerCase()
                                                          .contains(
                                                            value.text
                                                                .toLowerCase(),
                                                          ),
                                                    )
                                                    .toList(),
                                            controllerValue: controller
                                                .partySelectedName
                                                .value,
                                            closeControllerFun: () =>
                                                controller
                                                        .partySelectedName
                                                        .value =
                                                    '',
                                            displayStringForOption: (p) =>
                                                p.partyName!,
                                            onSelected: (p) =>
                                                controller.setParty(p),
                                          ),
                                        ),
                                      ],
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    subtitleRow(
                                      'Price List',
                                      controller.priceList.value,
                                    ),
                                    SizedBox(height: size.height * 0.01),
                                    subtitleRow(
                                      'Mobile',
                                      controller.partyMobileNo.value,
                                    ),
                                    Row(
                                      children: [
                                        CustomTextFormFieldView(
                                          controller:
                                              controller.remarkController,
                                          title: 'Order Narration',
                                          maxLines: 3,
                                          countertext: true,
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                            ),
                            ((hedId == null || hedId == '') &&
                                    !controller.isHeaderSaved.value)
                                ? Container(
                                    width: size.width * 0.6,
                                    padding: const EdgeInsets.all(4),
                                    child: ResponsiveButton(
                                      title: 'Next',
                                      function: () async {
                                        await controller.postSOExtHeaderAPI();
                                      },
                                    ),
                                  )
                                : Container(),
                            controller.isHeaderSaved.value
                                ? Row(
                                    mainAxisAlignment: MainAxisAlignment.end,
                                    children: <Widget>[
                                      ElevatedButton(
                                        style: ElevatedButton.styleFrom(
                                          elevation: 2.0,
                                          shape: RoundedRectangleBorder(
                                            borderRadius: BorderRadius.circular(
                                              5.0,
                                            ),
                                          ),
                                          backgroundColor: Colors.lime.shade50,
                                          foregroundColor: Colors.black,
                                          padding: const EdgeInsets.all(8.0),
                                        ),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.add_business,
                                              color: Theme.of(
                                                context,
                                              ).colorScheme.secondary,
                                            ),
                                            SizedBox(width: 10.0),
                                            Text(
                                              "Additional Details",
                                              style: kTxtStl13B,
                                            ),
                                          ],
                                        ),
                                        onPressed: () {
                                          Get.to(
                                            () => SoAdditionalDetails(
                                              socontroller: controller,
                                            ),
                                          );
                                        },
                                      ),
                                    ],
                                  )
                                : Container(),
                            controller.isHeaderSaved.value
                                ? Column(
                                    children: [
                                      Container(
                                        width: size.width,
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(FontAwesomeIcons.boxOpen),
                                            SizedBox(width: 10.0),
                                            Text('Inventory', style: kTxtStlB),
                                          ],
                                        ),
                                      ),
                                      Card(
                                        child: Padding(
                                          padding: EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                color: Colors.grey.shade200,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: [
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.fromLTRB(
                                                            4,
                                                            0,
                                                            0,
                                                            0,
                                                          ),
                                                      child: Text(
                                                        'Add Items',
                                                        style: kTxtStl13B,
                                                      ),
                                                    ),
                                                    // IconButton(
                                                    //   icon: new Icon(
                                                    //     Icons
                                                    //         .add_circle_outline,
                                                    //     color: Colors.red,
                                                    //   ),
                                                    //   onPressed: () async {
                                                    //     controller.clearAll();
                                                    //     Get.to(
                                                    //       () => AddItem(
                                                    //         controller:
                                                    //             controller,
                                                    //       ),
                                                    //     );
                                                    //   },
                                                    // ),
                                                    PopupMenuButton<String>(
                                                      icon: Icon(
                                                        Icons
                                                            .add_circle_outline,
                                                        color: Colors.red,
                                                      ),
                                                      onSelected: (value) {
                                                        if (value ==
                                                            'product') {
                                                          controller.clearAll();
                                                          Get.to(
                                                            () => AddItem(
                                                              controller:
                                                                  controller,
                                                            ),
                                                          );
                                                        } else {
                                                          Get.to(
                                                            () =>
                                                                BusinessTrackingScreen(
                                                                  controller:
                                                                      controller,
                                                                ),
                                                          );
                                                        }
                                                      },
                                                      itemBuilder: (context) => [
                                                        const PopupMenuItem(
                                                          value: 'product',
                                                          child: Text(
                                                            'Single Product',
                                                          ),
                                                        ),
                                                        if (hedId == null ||
                                                            hedId == "")
                                                          PopupMenuItem(
                                                            value: 'business',
                                                            child: Text(
                                                              'Business Opportunity Picker',
                                                            ),
                                                          ),
                                                      ],
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              Obx(() {
                                                final itemList =
                                                    controller
                                                        .salesOrderHeaderEntity
                                                        .value
                                                        ?.inventory ??
                                                    [];
                                                return itemList.isEmpty
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                              0,
                                                              10,
                                                              0,
                                                              10,
                                                            ),
                                                        child: Text(
                                                          'No Item Added.',
                                                        ),
                                                      )
                                                    : ListView.builder(
                                                        itemCount:
                                                            itemList.length,
                                                        shrinkWrap: true,
                                                        physics:
                                                            ClampingScrollPhysics(),
                                                        itemBuilder: (context, i) {
                                                          final header =
                                                              itemList;
                                                          return InkWell(
                                                            child: Padding(
                                                              padding:
                                                                  const EdgeInsets.all(
                                                                    4.0,
                                                                  ),
                                                              child: Row(
                                                                children: [
                                                                  Expanded(
                                                                    child: Column(
                                                                      crossAxisAlignment:
                                                                          CrossAxisAlignment
                                                                              .start,
                                                                      children: [
                                                                        Text(
                                                                          header[i]
                                                                              .itemName!,
                                                                          style:
                                                                              kTxtStl13N,
                                                                        ),
                                                                        Row(
                                                                          children: [
                                                                            Expanded(
                                                                              child: Text(
                                                                                // komal // alternate unit quantity added
                                                                                'Qty : ${header[i].qty} ${header[i].unitname} '
                                                                                '| Rate : ₹ ${header[i].rate} | ',
                                                                                style: kTxtStl12GreyN,
                                                                              ),
                                                                            ),
                                                                          ],
                                                                        ),
                                                                        Row(
                                                                          children:
                                                                              <
                                                                                Widget
                                                                              >[
                                                                                Expanded(
                                                                                  child: Text(
                                                                                    'TAX : ${header[i].gstRate}% | HSN/SAC : ${header[i].hsncode}',
                                                                                    style: kTxtStl12GreyN,
                                                                                  ),
                                                                                ),
                                                                              ],
                                                                        ),
                                                                      ],
                                                                    ),
                                                                  ),
                                                                  SizedBox(
                                                                    width:
                                                                        size.width *
                                                                        0.2,
                                                                    child: Text(
                                                                      indianRupeeFormat(
                                                                        double.parse(
                                                                          header[i]
                                                                              .value!,
                                                                        ),
                                                                      ),
                                                                      style:
                                                                          kTxtStl13B,
                                                                      textAlign:
                                                                          TextAlign
                                                                              .right,
                                                                    ),
                                                                  ),
                                                                ],
                                                              ),
                                                            ),
                                                            onTap: () {
                                                              Get.to(
                                                                () => AddItem(
                                                                  controller:
                                                                      controller,
                                                                  soInv:
                                                                      header[i],
                                                                ),
                                                              );
                                                            },
                                                          );
                                                        },
                                                      );
                                              }),
                                              Divider(),
                                              Row(
                                                children: [
                                                  Expanded(
                                                    child: Text('Net Amount'),
                                                  ),
                                                  SizedBox(
                                                    width: size.width * 0.2,
                                                    child: Text(
                                                      '${indianRupeeFormat(controller.itemTotalNetAmount.value)}',
                                                      style: kTxtStl13B,
                                                      textAlign:
                                                          TextAlign.right,
                                                    ),
                                                  ),
                                                ],
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container(),
                          ],
                        ),
                      ],
                    );
                  }),
                ),
                controller.isHeaderSaved.value
                    ? Container(
                        width: size.width * 0.6,
                        padding: const EdgeInsets.all(4),
                        child: ResponsiveButton(
                          title: 'Save',
                          function: () async {
                            await controller.sOSavePostApi();
                          },
                        ),
                      )
                    : Container(),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
