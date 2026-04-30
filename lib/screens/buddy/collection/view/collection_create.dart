import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/company/voucherentity.dart';
import 'package:sysconn_sfa/screens/buddy/collection/controller/collection_create_controller.dart';
import 'package:sysconn_sfa/screens/buddy/collection/view/collection_add_ledger.dart';
import 'package:sysconn_sfa/widgets/customautocompletefield.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';
import 'package:sysconn_sfa/widgetscustome/responsive_button.dart';

class CollectionCreate extends StatelessWidget {
  final String? hedId;
  final String? vchType;
  CollectionCreate({super.key, this.hedId, this.vchType});

  @override
  Widget build(BuildContext context) {
    final CreateCollectionController controller = Get.put(
      CreateCollectionController(hedId: hedId, vchType: vchType),
    );

    final Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(
        title:
            "${(hedId == null || hedId == '') ? 'Create' : 'Update'} $vchType",
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
                          '${indianRupeeFormat(controller.ledgerTotalAmount.value)}',
                          // '${indianRupeeFormat(controller.amntRcvdCntrl.text == '' ? 0.0 : double.parse(controller.amntRcvdCntrl.text))}',
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
                  child:
                      //  controller.isDataLoad.value
                      Obx(() {
                        if (controller.isDataLoad.value == 0) {
                          return Center(
                            child: Utility.processLoadingWidget()
                          );
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
                                        '${(hedId == null || hedId == '') ? 'Create' : 'Alter'} Receipt',
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
                                                  controller
                                                      .receiptHeaderEntity
                                                      .value ==
                                                  null,
                                              controller:
                                                  controller.dateController,
                                              title: 'Date',
                                              onTap: () async {
                                                FocusScope.of(
                                                  context,
                                                ).unfocus();
                                                //final date =
                                                await selectDateSingle(
                                                  dateSelected: controller
                                                      .selectedDate
                                                      .value,
                                                  firstDate: DateTime.now(),
                                                  lastDate: DateTime.now().add(
                                                    const Duration(days: 365),
                                                  ),
                                                );
                                              },
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: size.height * 0.01),
                                        Row(
                                          children: [
                                            Obx(
                                              () => CustomAutoCompleteFieldView(
                                                enabled:
                                                    controller
                                                        .receiptHeaderEntity
                                                        .value ==
                                                    null,
                                                title: 'Voucher Type',
                                                controllerValue: controller
                                                    .vchNameSelected
                                                    .value,
                                                optionsBuilder: (v) => controller
                                                    .vchTypeEntityList
                                                    .where(
                                                      (e) => e.vchTypeName!
                                                          .toLowerCase()
                                                          .contains(
                                                            v.text
                                                                .toLowerCase(),
                                                          ),
                                                    )
                                                    .toList(),
                                                displayStringForOption:
                                                    (VoucherEntity e) =>
                                                        e.vchTypeName!,
                                                onSelected:
                                                    controller.selectVoucher,
                                                closeControllerFun: () {
                                                  controller
                                                          .vchNameSelected
                                                          .value =
                                                      '';
                                                  controller
                                                          .vchIdSelected
                                                          .value =
                                                      '';
                                                  controller
                                                          .vchPrefixSelected
                                                          .value =
                                                      '';
                                                },
                                              ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: size.height * 0.01),
                                        Row(
                                          children: [
                                            Obx(
                                              () =>
                                                  //  controller.isTallyEntry.value
                                                  //     ? const SizedBox()
                                                  //     :
                                                  CustomAutoCompleteFieldView(
                                                    enabled:
                                                        controller
                                                            .receiptHeaderEntity
                                                            .value ==
                                                        null,
                                                    title: 'Bank Ledger',
                                                    controllerValue: controller
                                                        .bankLedgerNameSelected
                                                        .value,
                                                    optionsBuilder: (v) => controller
                                                        .bankLedgerEntityData
                                                        .where(
                                                          (e) => e.ledgerName!
                                                              .toLowerCase()
                                                              .contains(
                                                                v.text
                                                                    .toLowerCase(),
                                                              ),
                                                        )
                                                        .toList(),
                                                    displayStringForOption:
                                                        (e) => e.ledgerName!,
                                                    onSelected: (e) {
                                                      controller
                                                          .bankLedgerNameSelected
                                                          .value = e
                                                          .ledgerName!;
                                                      controller
                                                          .bankLedgerIdSelected
                                                          .value = e
                                                          .ledgerId!;
                                                      FocusScope.of(
                                                        context,
                                                      ).unfocus();
                                                    },
                                                    closeControllerFun: () {
                                                      controller
                                                              .bankLedgerNameSelected
                                                              .value =
                                                          '';
                                                      controller
                                                              .bankLedgerIdSelected
                                                              .value =
                                                          '';
                                                    },
                                                  ),
                                            ),
                                          ],
                                        ),
                                        SizedBox(height: size.height * 0.01),
                                        Row(
                                          children: [
                                            CustomTextFormFieldView(
                                              controller:
                                                  controller.remarkController,
                                              title: 'Narration',
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                Container(
                                  width: size.width,
                                  padding: EdgeInsets.all(8.0),
                                  child: Row(
                                    children: [
                                      Icon(Icons.account_balance),
                                      SizedBox(width: 10.0),
                                      Text('Bank Allocations', style: kTxtStlB),
                                    ],
                                  ),
                                ),
                                Card(
                                  child: Padding(
                                    padding: EdgeInsets.all(8.0),
                                    child: Column(
                                      children: [
                                        Obx(
                                          () => Row(
                                            children: [
                                              CustomAutoCompleteFieldView(
                                                title: 'Mode',
                                                enabled:
                                                    controller
                                                        .receiptHeaderEntity
                                                        .value ==
                                                    null,
                                                controllerValue: controller
                                                    .modeSelected
                                                    .value,
                                                optionsBuilder: (v) => controller
                                                    .modelist
                                                    .where(
                                                      (e) => e
                                                          .toLowerCase()
                                                          .contains(
                                                            v.text
                                                                .toLowerCase(),
                                                          ),
                                                    )
                                                    .toList(),
                                                onSelected: controller.setMode,
                                                closeControllerFun: () {
                                                  controller
                                                          .modeSelected
                                                          .value =
                                                      '';
                                                  controller.modeFlag.value =
                                                      true;
                                                },
                                              ),
                                            ],
                                          ),
                                        ),
                                        controller.modeFlag.value
                                            ? const SizedBox()
                                            : SizedBox(
                                                height: size.height * 0.01,
                                              ),
                                        controller.modeFlag.value
                                            ? const SizedBox()
                                            : Row(
                                                children: [
                                                  CustomTextFormFieldView(
                                                    enabled:
                                                        controller
                                                            .receiptHeaderEntity
                                                            .value ==
                                                        null,
                                                    controller: controller
                                                        .bankNameCntrl,
                                                    title: 'Bank Name',
                                                  ),
                                                ],
                                              ),
                                        SizedBox(height: size.height * 0.01),
                                        Row(
                                          children: [
                                            CustomTextFormFieldView(
                                              enabled:
                                                  controller
                                                      .receiptHeaderEntity
                                                      .value ==
                                                  null,
                                              controller:
                                                  controller.instruNoCntrl,
                                              keyboardType:
                                                  TextInputType.number,
                                              title: 'Instrument Number',
                                            ),
                                            SizedBox(width: size.width * 0.02),
                                            CustomTextFormFieldView(
                                              enabled:
                                                  controller
                                                      .receiptHeaderEntity
                                                      .value ==
                                                  null,
                                              controller:
                                                  controller.instruDateCntrl,
                                              title: 'Instrument Date',
                                              onTap: () async {
                                                FocusScope.of(
                                                  context,
                                                ).unfocus();
                                                final date =
                                                    await selectDateSingle(
                                                      dateSelected: controller
                                                          .selectedDate
                                                          .value,
                                                      firstDate: DateTime.now(),
                                                      lastDate: DateTime.now()
                                                          .add(
                                                            const Duration(
                                                              days: 365,
                                                            ),
                                                          ),
                                                    );
                                                controller
                                                    .instruDateCntrl
                                                    .text = DateFormat(
                                                  'yyyy-MM-dd',
                                                ).format(date);
                                              },
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                                //  ( controller.isHeaderSaved.value && hedId != null)
                                ((hedId == null || hedId == '') &&
                                        !controller.isHeaderSaved.value)
                                    ? Container(
                                        width: size.width * 0.6,
                                        padding: EdgeInsets.all(4),
                                        child: ResponsiveButton(
                                          title: 'Next',
                                          function: () async {
                                            await controller
                                                .collectionHedInsertPostApi();
                                          },
                                        ),
                                      )
                                    : Container(),
                                controller.isHeaderSaved.value
                                    ? Container(
                                        width: size.width,
                                        padding: EdgeInsets.all(8.0),
                                        child: Row(
                                          children: [
                                            Icon(Icons.leaderboard),
                                            SizedBox(width: 10.0),
                                            Text(
                                              'Ledger/Party',
                                              style: kTxtStlB,
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),
                                controller.isHeaderSaved.value
                                    ? Card(
                                        child: Padding(
                                          padding: const EdgeInsets.all(8.0),
                                          child: Column(
                                            children: [
                                              Container(
                                                color: Colors.grey.shade200,
                                                child: Row(
                                                  mainAxisAlignment:
                                                      MainAxisAlignment
                                                          .spaceBetween,
                                                  children: <Widget>[
                                                    Padding(
                                                      padding:
                                                          const EdgeInsets.fromLTRB(
                                                            4,
                                                            0,
                                                            0,
                                                            0,
                                                          ),
                                                      child: Text(
                                                        'Add Ledger/Party',
                                                        style: kTxtStl13B,
                                                      ),
                                                    ),
                                                    // IconButton(
                                                    //   icon: new Icon(
                                                    //     Icons.add_circle_outline,
                                                    //     color: Colors.red,
                                                    //   ),
                                                    //   onPressed: () async {
                                                    //     await Get.to(
                                                    //       () => CollectionAddLedger(),
                                                    //     );
                                                    //     // _navigateReceiptLedger(receiptid!,'Create Ledger', '0', 0, 0.0);
                                                    //   },
                                                    // ),
                                                    PopupMenuButton<String>(
                                                      icon: Icon(
                                                        Icons
                                                            .add_circle_outline,
                                                        color: Colors.red,
                                                      ),
                                                      onSelected: (value) {
                                                        if (value == 'ledger') {
                                                          Get.to(
                                                            () =>
                                                                CollectionAddLedger(
                                                                  type:
                                                                      'Ledger',
                                                                  controller:
                                                                      controller,
                                                                ),
                                                          );
                                                        } else {
                                                          Get.to(
                                                            () =>
                                                                CollectionAddLedger(
                                                                  type: 'Party',
                                                                  controller:
                                                                      controller,
                                                                ),
                                                          );
                                                        }
                                                      },
                                                      itemBuilder: (context) =>
                                                          [
                                                            const PopupMenuItem(
                                                              value: 'ledger',
                                                              child: Text(
                                                                'Add Ledger',
                                                              ),
                                                            ),
                                                            const PopupMenuItem(
                                                              value: 'party',
                                                              child: Text(
                                                                'Add Party',
                                                              ),
                                                            ),
                                                          ],
                                                    ),
                                                  ],
                                                ),
                                              ),

                                              // controller
                                              //         .receiptHeaderEntity
                                              //         .value!
                                              //         .recLedger!
                                              //         .isEmpty
                                              //     ? Padding(
                                              //         padding:
                                              //             EdgeInsets.fromLTRB(
                                              //               0,
                                              //               10,
                                              //               0,
                                              //               10,
                                              //             ),
                                              //         child: Text(
                                              //           'No Ledger Added.',
                                              //         ),
                                              //       )
                                              //     : ListView.builder(
                                              //         itemCount: controller
                                              //             .receiptHeaderEntity
                                              //             .value!
                                              //             .recLedger!
                                              //             .length,
                                              //         shrinkWrap: true,
                                              //         physics:
                                              //             ClampingScrollPhysics(),
                                              //         itemBuilder: (context, i) {
                                              //           final header = controller
                                              //               .receiptHeaderEntity
                                              //               .value!
                                              //               .recLedger;
                                              //           return InkWell(
                                              //             child: Padding(
                                              //               padding:
                                              //                   const EdgeInsets.all(
                                              //                     4.0,
                                              //                   ),
                                              //               child: Row(
                                              //                 children: [
                                              //                   Expanded(
                                              //                     child: Column(
                                              //                       crossAxisAlignment:
                                              //                           CrossAxisAlignment
                                              //                               .start,
                                              //                       children: [
                                              //                         Text(
                                              //                           header![i]
                                              //                               .name!,
                                              //                           style:
                                              //                               kTxtStl13N,
                                              //                         ),
                                              //                       ],
                                              //                     ),
                                              //                   ),
                                              //                   SizedBox(
                                              //                     width:
                                              //                         size.width *
                                              //                         0.2,
                                              //                     child: Text(
                                              //                       indianRupeeFormat(
                                              //                         double.parse(
                                              //                           header[i]
                                              //                               .amount!,
                                              //                         ),
                                              //                       ),
                                              //                       style:
                                              //                           kTxtStl13B,
                                              //                       textAlign:
                                              //                           TextAlign
                                              //                               .right,
                                              //                     ),
                                              //                   ),
                                              //                 ],
                                              //               ),
                                              //             ),
                                              //             onTap: () {
                                              //               // _navigateReceiptLedger(receiptid!,'Update Ledgers',

                                              //               // PartyEntity.map(receiptledgerDBList[index]).id!,
                                              //               // ReceiptLedgerEntity.map(receiptledgerDBList[index]).receiptledgeridpk!,
                                              //               // ReceiptLedgerEntity.map(receiptledgerDBList[index]).ledgeramount!);
                                              //             },
                                              //           );
                                              //         },
                                              //       ),
                                              Obx(() {
                                                final ledgerList =
                                                    controller
                                                        .receiptHeaderEntity
                                                        .value
                                                        ?.recLedger ??
                                                    [];

                                                return ledgerList.isEmpty
                                                    ? Padding(
                                                        padding:
                                                            EdgeInsets.fromLTRB(
                                                              0,
                                                              10,
                                                              0,
                                                              10,
                                                            ),
                                                        child: Text(
                                                          'No Ledger Added.',
                                                        ),
                                                      )
                                                    : ListView.builder(
                                                        itemCount:
                                                            ledgerList.length,
                                                        shrinkWrap: true,
                                                        physics:
                                                            ClampingScrollPhysics(),
                                                        itemBuilder: (context, i) {
                                                          final header =
                                                              ledgerList;

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
                                                                          header[i].name ??
                                                                              '',
                                                                          style:
                                                                              kTxtStl13N,
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
                                                                        double.tryParse(
                                                                              header[i].amount ??
                                                                                  '0',
                                                                            ) ??
                                                                            0,
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
                                                            //   onTap: (){
                                                            //      Get.to(
                                                            //   () =>
                                                            //       CollectionAddLedger(
                                                            //         type:
                                                            //             'Ledger',
                                                            //         controller:
                                                            //             controller,
                                                            //       ),
                                                            // );
                                                            //   },
                                                            onTap: () {
                                                              final item =
                                                                  header[i];

                                                              //  Clear previous values
                                                              controller
                                                                      .partyNameSelected
                                                                      .value =
                                                                  '';
                                                              controller
                                                                      .partyIdSelected
                                                                      .value =
                                                                  '';
                                                              controller
                                                                      .ledgerNameSelected
                                                                      .value =
                                                                  '';
                                                              controller
                                                                      .ledgerIdSelected
                                                                      .value =
                                                                  '';
                                                              controller
                                                                  .amtController
                                                                  .clear();

                                                              Get.to(
                                                                () => CollectionAddLedger(
                                                                  type:
                                                                      item.type ==
                                                                          'P'
                                                                      ? 'Party'
                                                                      : 'Ledger',
                                                                  controller:
                                                                      controller,

                                                                  // 👉 PASS DATA FOR PREFILL
                                                                  initialName:
                                                                      item.name,
                                                                  initialId:
                                                                      item.type ==
                                                                          'P'
                                                                      ? item.partyId
                                                                      : item.ledgerId,
                                                                  initialAmount:
                                                                      item.amount,
                                                                  initialuniqueid:
                                                                      item.uniqueId,
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
                                                    child: Text(
                                                      'Total Ledger Amount',
                                                    ),
                                                  ),
                                                  SizedBox(
                                                    width: size.width * 0.2,
                                                    child: Text(
                                                      '${indianRupeeFormat(controller.ledgerTotalAmount.value)}',
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
                        padding: EdgeInsets.all(4),
                        child: ResponsiveButton(
                          title: 'Save',
                          function: () async {
                            await controller.collectionPostApi();
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
