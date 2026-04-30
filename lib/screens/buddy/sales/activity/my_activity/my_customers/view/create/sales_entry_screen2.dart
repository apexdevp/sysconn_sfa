// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:sysconn_sfa/Utility/systemxs_global.dart';
// import 'package:sysconn_sfa/Utility/textstyles.dart';
// import 'package:sysconn_sfa/Utility/utility.dart';
// import 'package:sysconn_sfa/api/entity/buddy/sales/sales_inventory_entity.dart';
// import 'package:sysconn_sfa/api/entity/company/voucherentity.dart';
// import 'package:sysconn_sfa/api/entity/sales/sales_ledger_entity.dart';
// import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/sales_entry_controller.dart';
// import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/create/additional_details.dart';
// import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/create/sales_inventory_create.dart';
// import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/create/sales_ledger_create.dart';
// import 'package:sysconn_sfa/widgets/responsive_button.dart';
// import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
// import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';
// import 'package:sysconn_sfa/widgetscustome/dropdowncontroller.dart';

// class SalesCreateScreen extends StatelessWidget {
//   final String? hedId;
//   final String? vchType;
//   final bool isEdit;
//   final String? partyId;

//   const SalesCreateScreen({
//     super.key,
//     this.hedId,
//     this.vchType,
//     required this.isEdit,
//     this.partyId,
//   });

//   @override
//   Widget build(BuildContext context) {
//     // if (Get.isRegistered<SalesController>()) {
//     //   Get.delete<SalesController>();
//     // }

//     final c = Get.put(
//       SalesController(
//         hedId: hedId,
//         vchType: vchType,
//         isEdit: isEdit,
//         partyId: partyId,
//       ),
//     );

//     final size = MediaQuery.of(context).size;

//     return WillPopScope(
//       onWillPop: c.onWillPop,
//       child: Scaffold(
//         resizeToAvoidBottomInset: true,
//         appBar: SfaCustomAppbar(
//           title:
//               "${c.isTallyEntry.value
//                   ? 'Display'
//                   : hedId == null
//                   ? 'Create'
//                   : 'Update'} $vchType",
//         ),
//         // floatingActionButton: Padding(
//         //   padding: const EdgeInsets.all(8.0),
//         //   child: SizedBox(
//         //       width: size.width * 0.6,
//         //     child: ResponsiveButton(
//         //       title: 'Save',
//         //       function: () async {
//         //         Utility.showCircularLoadingWid(context);
//         //         await c.salesSavePostApi();
//         //       },
//         //     ),
//         //   ),
//         // ),

//         body: Obx(() {
//           if (c.isDataLoad.value == 0) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           return Column(
//             children: [
//               _buildHeader(c, size),

//                Expanded(
//         child: Column(
//           children: [
//             _buildInventory(c, size, context),
//             (c.salesHeaderEntity.value != null && c.hedId != null)
//                 ? _buildLEdger(c, size, context)
//                 : Container(),
//           ],
//         ),
//       ),
//        SafeArea(
//         child: SizedBox(
//           width: size.width * 0.6,
//           child: ResponsiveButton(
//             title: 'Proceed To Buy',
//             function: () async {
//               Utility.showCircularLoadingWid(context);
//               await Get.to(() => AdditionalDetailsScreen(salesHeaderEntity: c.salesHeaderEntity.value!));
//               // await c.salesSavePostApi();
//             },
//           ),
//         ),
//        ),
//         // SizedBox(height: size.height*0.02,)

//             ],
//           );
//         }),
//       ),
//     );
//   }

//   // ================= HEADER =================

//   Widget _buildHeader(SalesController c, Size size) {
//     final isEditMode = c.hedId != null;

//     return SizedBox(
//       width: double.infinity,
//       child: Padding(
//         padding: const EdgeInsets.all(4),
//         child: isEditMode ? _editHeader(c, size) : _createHeader(c, size),
//       ),
//     );
//   }

//   // ================= CREATE HEADER =================

//   Widget _createHeader(SalesController c, Size size) {
//     return Column(
//       crossAxisAlignment: CrossAxisAlignment.start,
//       children: [
//         /// Date
//         Row(
//           mainAxisAlignment: MainAxisAlignment.end,
//           children: [
//             const Icon(Icons.date_range, size: 18, color: Colors.grey),
//             const SizedBox(width: 6),
//             Text(
//               DateFormat('dd/MM/yyyy').format(c.selectedDate.value),
//               style: const TextStyle(color: Colors.grey),
//             ),
//           ],
//         ),

//         const SizedBox(height: 12),

//         /// Voucher
//         Row(
//           children: [
//             Expanded(
//               child: Obx(
//                 () => DropdownCustomList<VoucherEntity>(
//                   title: "Voucher Name",
//                   hint: "Select Voucher Name",
//                   items: c.vchEntityList
//                       .map(
//                         (item) => DropdownMenuItem<VoucherEntity>(
//                           value: item,
//                           child: Text(item.vchTypeName ?? ''),
//                         ),
//                       )
//                       .toList(),
//                   selectedValue: c.voucherEntitySelected,
//                   onChanged: (value) {
//                     c.setVoucher(value!);
//                   },
//                 ),
//               ),
//             ),
//           ],
//         ),

//         // const SizedBox(height: 12),

//         /// Party
//         ///
//         Row(
//           children: [
//             Expanded(
//               child: DropdownCustomList(
//                 title: "Party Name",
//                 items: const [],
//                 selectedValue: c.partySelectedName,
//                 onSearchApi: (query) async {
//                   await c.customerListData(query);

//                   return c.partyEntityList
//                       .where(
//                         (e) => e.partyName!.toLowerCase().contains(
//                           query.toLowerCase(),
//                         ),
//                       )
//                       .map<DropdownMenuItem<String>>((e) {
//                         return DropdownMenuItem<String>(
//                           value: e.partyName,
//                           child: Text(e.partyName!),
//                         );
//                       })
//                       .toList();
//                 },
//                 onChanged: (value) {
//                   final selectedParty = c.partyEntityList.firstWhere(
//                     (e) => e.partyName == value,
//                   );
//                   c.setParty(selectedParty);
//                   c.partySelectedName.value = selectedParty.partyName!;
//                 },
//                 onClear: () {
//                   c.partySelectedName.value = '';
//                   c.salesHeaderEntity.value = null;
//                 },
//               ),
//             ),
//           ],
//         ),

//         // CustomAutoCompleteFieldView(
//         //   title: 'Party Name',
//         //   isCompulsory: true,
//         //   optionsBuilder: (value) {
//         //     return c.partyEntityList.where((e) =>
//         //         e.partyName!
//         //             .toLowerCase()
//         //             .contains(value.text.toLowerCase()));
//         //   },
//         //   controllerValue: c.partySelectedName.value,
//         //   onSelected: (p) => c.setParty(p),
//         //   closeControllerFun: () {},
//         // ),
//         const SizedBox(height: 12),

//         /// Payment Terms
//         Row(
//           children: [
//             CustomTextFormFieldView(
//               controller: c.paymentTermsController,
//               title: 'Payment Terms',
//             ),
//           ],
//         ),

//         const SizedBox(height: 12),

//         /// Remark
//         Row(
//           children: [
//             CustomTextFormFieldView(
//               controller: c.remarkController,
//               title: 'Remark',
//               maxLines: 3,
//             ),
//           ],
//         ),
//       ],
//     );
//   }

//   // ================= EDIT HEADER =================

//   Widget _editHeader(SalesController c, Size size) {
//     return Column(
//       children: [
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             /// Icon
//             Container(
//               padding: const EdgeInsets.all(10),
//               decoration: BoxDecoration(
//                 color: Colors.orange,
//                 borderRadius: BorderRadius.circular(8),
//               ),
//               child: const Icon(Icons.add_business, color: Colors.white),
//             ),
        
//             const SizedBox(width: 12),
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Top Info
//                   Text(
//                     c.partySelectedName.value,
//                     style: const TextStyle(
//                       fontWeight: FontWeight.bold,
//                       fontSize: 16,
//                     ),
//                   ),
//                   Text("Invoice No: ${c.salesHeaderEntity.value?.invoiceNo ?? ''}"),
//                   // Text(
//                   //   "Type: ${c.salesHeaderEntity.value?.voucherTypeName ?? ''} | Pricelist: ${c.priceList.value} ",
//                   // ),
//                   // Text("Mobile: ${c.partyMobileNo.value}"),
//                   // Text("Created: ${c.selectedDate.value}"),
        
//                   const SizedBox(height: 2),
        
//                   /// Remark FULL WIDTH
                  
//                 ],
//               ),
//             ),
        
//             const SizedBox(width: 12),
        
//             /// Delete Button
//             IconButton(
//               icon: const Icon(Icons.delete, color: Colors.red),
//               onPressed: () {
//                 Utility.showAlertYesNo(
//                   title: "Alert",
//                   msg: "Do you want to delete this?",
//                   yesBtnFun: () => c.deleteAllSalesApi(),
//                   noBtnFun: () => Get.back(),
//                 );
//               },
//             ),
//           ],
//         ),
//         Row(
//                 children: [
//                   CustomTextFormFieldView(
//                     controller: c.remarkController,
//                     title: 'Narration',
//                     maxLines: 2,
//                   ),
//                 ],
//               ),
//       ],
//     );
//   }

//   // ================= INVENTORY =================

//   //navigate
//   void navigateInventory({
//     SalesInventoryEntity? data,
//     required SalesController c,
//   }) async {
//     await Get.to(() => SalesInventoryScreen(salesInventoryEntity: data));
//     await c.getSalesDataAPI();
//   }

//   Widget _buildInventory(SalesController c, Size size, BuildContext context) {
//     final header = c.salesHeaderEntity.value;

//     if (header == null && c.hedId == null) {
//       return Center(
//         child: SizedBox(
//           width: size.width * 0.5,
//           child: ResponsiveButton(
//             title: 'Next',
//             function: () async {
//               Utility.showCircularLoadingWid(context);
//               await c.salesHeaderPostApi();
//             },
//           ),
//         ),
//       );
//     }

//     final items = header?.items ?? [];

//     return SizedBox(
//       // color: Colors.grey.shade50,
//       height: size.height * 0.32,
//       child: Column(
//         children: [
//           /// HEADER
//           Padding(
//             padding: const EdgeInsets.all(10),
//             child: Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 Row(
//                   children: [
//                     Icon(Icons.add_business, color: Colors.black),
//                     SizedBox(width: 10),
//                     const Text(
//                       'Inventory Details',
//                       style: TextStyle(fontWeight: FontWeight.bold),
//                     ),
//                   ],
//                 ),
//                 GestureDetector(
//                   onTap: () {
//                     navigateInventory(c: c);
//                     //     showInventoryDialog(context: context);
//                   },
//                   child: Icon(
//                     Icons.add_circle_outline,
//                     color: Colors.red,
//                     size: 25,
//                   ),
//                 ),
//               ],
//             ),
//           ),

//           /// CARD + LIST
//           Expanded(
//             child: Card(
//               child: items.isNotEmpty
//                   ? ListView.builder(
//                       itemCount: items.length,
//                       padding: const EdgeInsets.all(2),
//                       itemBuilder: (context, i) {
//                         final item = items[i];

//                         return Padding(
//                           padding: const EdgeInsets.symmetric(
//                             vertical: 3,
//                             horizontal: 6,
//                           ),
//                           child: Row(
//                             children: [
//                               /// LEFT SIDE
//                               Expanded(
//                                 flex: 6,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       item.itemId ?? '',
//                                       style: const TextStyle(
//                                         fontSize: 11,
//                                         fontWeight: FontWeight.w600,
//                                         color: Colors.blueAccent,
//                                       ),
//                                     ),
//                                     Text(
//                                       item.itemName ?? '',
//                                       style: kTxtStl13N,
//                                     ),
//                                     const SizedBox(height: 2),
//                                     Text(
//                                       "Qty: ${item.qty} | Rate: ${item.rate} | Disc: ${item.discount ?? 0}%",
//                                       style: kTxtStl12N,
//                                     ),
//                                     Divider(thickness: 5),
//                                   ],
//                                 ),
//                               ),

//                               /// RIGHT SIDE
//                               Expanded(
//                                 flex: 4,
//                                 child: Column(
//                                   crossAxisAlignment: CrossAxisAlignment.end,
//                                   children: [
//                                     Text(
//                                       indianRupeeFormat(
//                                         double.tryParse(
//                                               item.totalvalue ?? '0',
//                                             ) ??
//                                             0,
//                                       ),
//                                       style: kTxtStl13N,
//                                     ),

//                                     Row(
//                                       mainAxisAlignment: MainAxisAlignment.end,
//                                       children: [
//                                         IconButton(
//                                           icon: const Icon(
//                                             Icons.edit,
//                                             size: 18,
//                                             color: Colors.green,
//                                           ),
//                                           onPressed: () {
//                                             //commented
//                                             navigateInventory(data: item, c: c);
//                                             // showInventoryDialog(
//                                             //   salesInventoryEntity: item,
//                                             //   context: context,
//                                             // );
//                                           },
//                                         ),
//                                         IconButton(
//                                           icon: const Icon(
//                                             Icons.delete,
//                                             size: 18,
//                                             color: Colors.red,
//                                           ),
//                                           onPressed: () async {
//                                             await c.deleteItemPostApi(
//                                               invId: item.invId ?? '',
//                                             );
//                                             c.salesHeaderEntity.refresh();
//                                           },
//                                         ),
//                                       ],
//                                     ),
//                                   ],
//                                 ),
//                               ),
//                             ],
//                           ),
//                         );
//                       },
//                     )
//                   : const Center(child: Text('No Inventory Added')),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   //   /// -------------------- LEDGER  --------------------

//   void navigateLedger({
//     SalesLedgerEntity? data,
//     required SalesController c,
//   }) async {
//     await Get.to(() => SalesLedgerScreen(salesLedgerEntity: data));
//     await c.getSalesDataAPI();
//   }

//   Widget _buildLEdger(SalesController c, Size size, BuildContext context) {
//   final ledgerList = c.salesLedgerList;

//   return Container(
//     color: Colors.grey.shade50,
//     height: size.height * 0.30,
//     child: Column(
//       children: [
//         /// HEADER
//         Padding(
//           padding: const EdgeInsets.all(10),
//           child: Row(
//             mainAxisAlignment: MainAxisAlignment.spaceBetween,
//             children: [
//               Row(
//                 children: const [
//                   Icon(Icons.add_card_outlined, color: Colors.black),
//                   SizedBox(width: 10),
//                   Text(
//                     'Ledger Details',
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                 ],
//               ),
//               GestureDetector(
//                 onTap: () {
//                   navigateLedger(c: c);
//                 },
//                 child: Icon(
//                     Icons.add_circle_outline,
//                     color: Colors.red,
//                     size: 25,
//                   ),
//               ),
//             ],
//           ),
//         ),

//         /// LIST CARD
//         Card(
//           margin: EdgeInsets.zero, 
//           child: Obx(() {
//             if (ledgerList.isEmpty) {
//               return const Padding(
//                 padding: EdgeInsets.all(12),
//                 child: Text('No Ledger Added'),
//               );
//             }

//             return ListView.builder(
//               itemCount: ledgerList.length,
//               shrinkWrap: true,
//               physics: const NeverScrollableScrollPhysics(),
//               padding: EdgeInsets.zero,
//               itemBuilder: (context, i) {
//                 final ledger = ledgerList[i];
//                 final amount = double.tryParse(ledger.amount ?? '') ?? 0;

//                 return Column(
//                   children: [
//                     Padding(
//                       padding: EdgeInsets.zero,
//                       child: Row(
//                         children: [
//                           /// NAME
//                           Expanded(
//                             flex: 6,
//                             child: Text(
//                               ledger.ledgerName ?? '',
//                               style: kTxtStl12N,
//                             ),
//                           ),

//                           /// AMOUNT
//                           Expanded(
//                             flex: 4,
//                             child: Text(
//                               indianRupeeFormat(amount),
//                               textAlign: TextAlign.right,
//                               style: kTxtStl12N,
//                             ),
//                           ),

//                           /// ACTIONS (NO EXTRA GAP)
//                           Row(
//                             mainAxisSize: MainAxisSize.min, 
//                             children: [
//                               IconButton(
//                                 iconSize: 18,
//                                 padding: EdgeInsets.zero,
//                                 constraints: const BoxConstraints(),
//                                 icon: const Icon(
//                                   Icons.edit,
//                                   color: Colors.green,
//                                 ),
//                                 onPressed: () {
//                                   navigateLedger(c: c, data: ledger);
//                                 },
//                               ),
//                               IconButton(
//                                 iconSize: 18,
//                                 padding: EdgeInsets.zero,
//                                 constraints: const BoxConstraints(),
//                                 icon: const Icon(
//                                   Icons.delete,
//                                   color: Colors.red,
//                                 ),
//                                 onPressed: () async {
//                                   Utility.showAlertYesNo(
//                                     title: 'Delete Ledger',
//                                     msg: 'Delete this ledger?',
//                                     yesBtnFun: () async {
//                                       Utility.showCircularLoadingWid(context);
//                                       await c.deleteLedgerPostApi(ledger);
//                                       Get.back();
//                                     },
//                                     noBtnFun: () => Get.back(),
//                                   );
//                                 },
//                               ),
//                             ],
//                           ),
//                         ],
//                       ),
//                     ),

//                   ],
//                 );
//               },
//             );
//           }),
//         ),
//       ],
//     ),
//   );
// }

//   Widget ledgerDetails(Size size, SalesController c) {
//     return Column(
//       children: [
//         SizedBox(
//           height: size.width * 0.1,
//           child: Obx(() {
//             return ListView.builder(
//               padding: EdgeInsets.zero,
//               itemCount: c.salesLedgerList.length,
//               itemBuilder: (context, i) {
//                 return ledgerDisplayRow(i, size, c, context);
//               },
//             );
//           }),
//         ),
//       ],
//     );
//   }

//   Widget ledgerDisplayRow(
//     int index,
//     Size size,
//     SalesController c,
//     BuildContext context,
//   ) {
//     final ledger = c.salesLedgerList[index];

//     final amount = double.tryParse(ledger.amount ?? '') ?? 0;

//     return Padding(
//       padding: const EdgeInsets.symmetric(vertical: 6, horizontal: 4),
//       child: SizedBox(
//         width: size.width * 0.35,
//         child: Row(
//           children: [
//             // DELETE
//             SizedBox(
//               width: 18,
//               height: 18,
//               child: IconButton(
//                 padding: EdgeInsets.zero,
//                 splashRadius: 10,
//                 iconSize: 14,
//                 icon: const Icon(Icons.remove_circle, color: Colors.red),
//                 onPressed: () async {
//                   Utility.showAlertYesNo(
//                     title: 'Delete Ledger',
//                     msg: 'Do you want to delete this ledger?',
//                     yesBtnFun: () async {
//                       Utility.showCircularLoadingWid(context);
//                       await c.deleteLedgerPostApi(ledger);
//                       Get.back();
//                     },
//                     noBtnFun: () => Get.back(),
//                   );
//                 },
//               ),
//             ),

//             const SizedBox(width: 4),

//             // EDIT
//             SizedBox(
//               width: 18,
//               height: 18,
//               child: IconButton(
//                 padding: EdgeInsets.zero,
//                 splashRadius: 10,
//                 iconSize: 14,
//                 icon: const Icon(Icons.edit, color: Colors.green),
//                 onPressed: () {
//                   // showLedgerDialog(context, c: c, salesLedgerEntity: ledger);
//                 },
//               ),
//             ),

//             const SizedBox(width: 4),

//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Text(
//                     ledger.ledgerName ?? '',
//                     style: kTxtStl12N,
//                   ), //'Scheme/Discount'
//                 ],
//               ), //Cash/Discount
//             ),

//             Expanded(
//               child: Text(
//                 indianRupeeFormat(amount),
//                 style: kTxtStl12N,
//                 textAlign: TextAlign.right,
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }
