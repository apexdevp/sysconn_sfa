import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/collection/controller/collection_create_controller.dart';
import 'package:sysconn_sfa/widgets/customautocompletefield.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';

class CollectionAddLedger extends StatefulWidget {
  final String? type;
  final CreateCollectionController controller;
  final String? initialName;
  final String? initialId;
  final String? initialAmount;
  final String? initialuniqueid;
  CollectionAddLedger({
    super.key,
    required this.type,
    required this.controller,
    this.initialName,
    this.initialId,
    this.initialAmount,
    this.initialuniqueid,
  });

  @override
  State<CollectionAddLedger> createState() => _CollectionAddLedgerState();
}

class _CollectionAddLedgerState extends State<CollectionAddLedger> {
  @override
  void initState() {
    super.initState();

    final controller = widget.controller;

    // 🔹 PREFILL DATA (THIS IS MAIN LOGIC)
    if (widget.type == 'Party') {
      controller.partyNameSelected.value = widget.initialName ?? '';
      controller.partyIdSelected.value = widget.initialId ?? '';
      controller.detailUniqueId.value = widget.initialuniqueid??'';
    } else {
      controller.ledgerNameSelected.value = widget.initialName ?? '';
      controller.ledgerIdSelected.value = widget.initialId ?? '';
      controller.detailUniqueId.value = widget.initialuniqueid??'';
    }
    controller.amtController.text = widget.initialAmount ?? '';

    //    // update so that AutoComplete shows the text properly
    // WidgetsBinding.instance.addPostFrameCallback((_) {
    //   controller.partyNameSelected.refresh();
    //   controller.partyIdSelected.refresh();
    //   controller.ledgerNameSelected.refresh();
    //   controller.ledgerIdSelected.refresh();
    // });
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Add ${widget.type}'),
      body: Column(
        children: [
          Expanded(
            child: Column(
              children: [
                Container(
                  width: size.width,
                  padding: EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Icon(Icons.leaderboard),
                      SizedBox(width: 10.0),
                      Text(widget.type!, style: kTxtStlB),
                    ],
                  ),
                ),
                Card(
                  child: Padding(
                    padding: const EdgeInsets.all(8.0),
                    child: Column(
                      children: [
                        Obx(
                          () => Row(
                            children: [
                              widget.type == 'Party'
                                  ? CustomAutoCompleteFieldView(
                                      title: 'Party Name',
                                      controllerValue: widget
                                          .controller
                                          .partyNameSelected
                                          .value,
                                      optionsBuilder: (v) => widget
                                          .controller
                                          .partyGetEntityData
                                          .where(
                                            (e) => e.partyName!
                                                .toLowerCase()
                                                .contains(v.text.toLowerCase()),
                                          )
                                          .toList(),
                                      displayStringForOption: (e) =>
                                          e.partyName!,
                                      onSelected: (e) {
                                        widget
                                                .controller
                                                .partyNameSelected
                                                .value =
                                            e.partyName!;
                                        widget
                                                .controller
                                                .partyIdSelected
                                                .value =
                                            e.partyId!;
                                        widget.controller.partyMobileNo.value =
                                            e.partyMobNo!;
                                        FocusScope.of(context).unfocus();
                                      },
                                      closeControllerFun: () {
                                        widget
                                                .controller
                                                .partyNameSelected
                                                .value =
                                            '';
                                        widget
                                                .controller
                                                .partyIdSelected
                                                .value =
                                            '';
                                        widget.controller.partyMobileNo.value =
                                            '';
                                      },
                                    )
                                  : CustomAutoCompleteFieldView(
                                      title: 'Ledger Name',
                                      controllerValue: widget
                                          .controller
                                          .ledgerNameSelected
                                          .value,
                                      optionsBuilder: (v) => widget
                                          .controller
                                          .ledgerGetEntityData
                                          .where(
                                            (e) => e.ledgerName!
                                                .toLowerCase()
                                                .contains(v.text.toLowerCase()),
                                          )
                                          .toList(),
                                      displayStringForOption: (e) =>
                                          e.ledgerName!,
                                      onSelected: (e) {
                                        widget
                                                .controller
                                                .ledgerNameSelected
                                                .value =
                                            e.ledgerName!;
                                        widget
                                                .controller
                                                .ledgerIdSelected
                                                .value =
                                            e.ledgerId!;
                                        FocusScope.of(context).unfocus();
                                      },
                                      closeControllerFun: () {
                                        widget
                                                .controller
                                                .ledgerNameSelected
                                                .value =
                                            '';
                                        widget
                                                .controller
                                                .ledgerIdSelected
                                                .value =
                                            '';
                                      },
                                    ),
                            ],
                          ),
                        ),
                        SizedBox(height: size.height * 0.01),
                        Row(
                          children: [
                            CustomTextFormFieldView(
                              controller: widget.controller.amtController,
                              title: 'Amount',
                              keyboardType:
                                  const TextInputType.numberWithOptions(
                                    decimal: true,
                                    signed: true,
                                  ),
                              onChanged: (text) {
                                widget.controller.amount.value = text;
                              },
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

          Padding(
            padding: const EdgeInsets.only(bottom: 8.0, left: 8, right: 8),
            child: Row(
              children: <Widget>[
                // widget.title == 'Create Ledger'?
                // Expanded(
                //   child: ElevatedButton(
                //     child: Text("Add More", style: kTxtStl16B),
                //     style: ElevatedButton.styleFrom(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(30),
                //       ),
                //       padding: EdgeInsets.all(9.0),
                //       elevation: 6.0,
                //       backgroundColor: Colors.lightGreen.shade400,
                //     ),
                //     onPressed: () async {
                //       widget.controller.isAddMoreClk.value = true;
                //       // Utility.showCircularLoadingWid(context);
                //       await widget.controller.postLedgerDataApi(
                //         partyId: widget.controller.partyIdSelected.value,
                //         ledgerId: widget.controller.ledgerIdSelected.value,
                //         amount: widget.controller.amtController.text,
                //         type: widget.type == 'Party' ? 'P' : 'L',
                //       );
                //       scaffoldMessageValidationBar(Get.context!,'Ledger Added.', isError: false);
                //       widget.controller.amountTextEditingControllerBlank();
                //     },
                //   ),
                // ),
                // // : Container(),
                // SizedBox(width: size.width * 0.02),
                // Expanded(
                //   child: ElevatedButton(
                //     child: Text("Done", style: kTxtStl16B),
                //     style: ElevatedButton.styleFrom(
                //       shape: RoundedRectangleBorder(
                //         borderRadius: BorderRadius.circular(30),
                //       ),
                //       padding: EdgeInsets.all(9.0),
                //       elevation: 6.0,
                //       backgroundColor: Colors.cyan.shade300,
     
                //     ),
                //     onPressed: () {
                //       widget.controller.isAddMoreClk.value = false;
                //       Utility.showCircularLoadingWid(context);
                //       widget.controller.postLedgerDataApi(
                //         partyId: widget.controller.partyIdSelected.value,
                //         ledgerId: widget.controller.ledgerIdSelected.value,
                //         amount: widget.controller.amtController.text,
                //         type: widget.type == 'Party' ? 'P' : 'L',
                //       );
                //     },
                //   ),
                // ),

                Expanded(
  child: ElevatedButton(
    child: Text("Add More", style: kTxtStl16B),
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.all(9.0),
      elevation: 6.0,
      backgroundColor: Colors.lightGreen.shade400,
    ),
    onPressed: () async {
      widget.controller.isAddMoreClk.value = true;

      await widget.controller.postLedgerDataApi(
        partyId: widget.controller.partyIdSelected.value,
        ledgerId: widget.controller.ledgerIdSelected.value,
        amount: widget.controller.amtController.text,
        type: widget.type == 'Party' ? 'P' : 'L',
      );

   
    },
  ),
),
SizedBox(width: size.width*0.02,),
Expanded(
  child: ElevatedButton(
    child: Text("Done", style: kTxtStl16B),
    style: ElevatedButton.styleFrom(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(5),
      ),
      padding: EdgeInsets.all(9.0),
      elevation: 6.0,
      backgroundColor: Colors.cyan.shade300,
    ),
    onPressed: () async {
      widget.controller.isAddMoreClk.value = false;

    
      await widget.controller.postLedgerDataApi(
        partyId: widget.controller.partyIdSelected.value,
        ledgerId: widget.controller.ledgerIdSelected.value,
        amount: widget.controller.amtController.text,
        type: widget.type == 'Party' ? 'P' : 'L',
      );

     
    },
  ),
),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
