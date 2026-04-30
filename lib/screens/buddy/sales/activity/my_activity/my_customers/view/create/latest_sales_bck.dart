// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:sysconn_sfa/Utility/app_colors.dart';
// import 'package:sysconn_sfa/Utility/systemxs_global.dart';
// import 'package:sysconn_sfa/Utility/textstyles.dart';
// import 'package:sysconn_sfa/Utility/utility.dart';
// import 'package:sysconn_sfa/api/entity/buddy/sales/sales_inventory_entity.dart';
// import 'package:sysconn_sfa/api/entity/company/voucherentity.dart';
// import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/sales_entry_controller.dart';
// import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/create/sales_inventory_create.dart';
// import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/create/sales_ledger_create.2dart';
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
//         appBar: SfaCustomAppbar(
//           title:
//               "${c.isTallyEntry.value ? 'Display' : hedId == null ? 'Create' : 'Update'} $vchType",
//         ),

//         body: Obx(() {
//           if (c.isDataLoad.value == 0) {
//             return const Center(child: CircularProgressIndicator());
//           }

//           return DefaultTabController(
//             length: 2,
//             child: Column(
//               children: [
//                 /// ================= HEADER =================
//                 _buildHeader(c, size),

//                 /// ================= TAB BAR =================
//                 const TabBar(
//                   tabs: [
//                     Tab(text: "Inventory"),
//                     Tab(text: "Ledger"),
//                   ],
//                 ),

//                 /// ================= TAB VIEW =================
//                 Expanded(
//                   child: TabBarView(
//                     children: [
//                       /// INVENTORY TAB
//                       SingleChildScrollView(
//                         padding: const EdgeInsets.all(8),
//                         child: _buildInventory(c, context),
//                       ),

//                       /// LEDGER TAB
//                       SingleChildScrollView(
//                         padding: const EdgeInsets.all(8),
//                         child: (c.salesHeaderEntity.value != null &&
//                                 c.hedId != null)
//                             ? _buildLedger(c, context)
//                             : const Center(child: Text("No Ledger Available")),
//                       ),
//                     ],
//                   ),
//                 ),

//                 /// ================= SAVE BUTTON =================
//                 SafeArea(
//                   child: Padding(
//                     padding: const EdgeInsets.all(10),
//                     child: SizedBox(
//                       width: size.width * 0.7,
//                       child: ResponsiveButton(
//                         title: 'Save',
//                         function: () async {
//                           Utility.showCircularLoadingWid(context);
//                           await c.salesSavePostApi();
//                         },
//                       ),
//                     ),
//                   ),
//                 ),
//               ],
//             ),
//           );
//         }),
//       ),
//     );
//   }

//   // ================= HEADER =================

//   Widget _buildHeader(SalesController c, Size size) {
//     final isEditMode = c.hedId != null;

//     return Padding(
//       padding:isEditMode?const EdgeInsets.all(0): const EdgeInsets.all(12),
//       child: isEditMode ? _editHeader(c,size) : _createHeader(c,size),
//     );
//   }

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

//   Widget _editHeader(SalesController c, Size size) {
//     return Column(
//       children: [
//                   Row(
//                     children: [
//                       Expanded(
//                         child: Card(
//                                   child: Padding(
//                                     padding: const EdgeInsets.all(8.0),
//                                     child: Column(
//                                       children: [
//                                         Text('Total Amount', style: kTxtStl14B),
//                                         Obx(
//                         () => Text(
//                           indianRupeeFormat(c.totalAmount.value),
//                           style: TextStyle(
//                             fontSize: 19,
//                             fontWeight: FontWeight.w600,
//                             color: kAppColor,
//                           ),
//                         ),
//                                         ),
//                                       ],
//                                     ),
//                                   ),
//                                 ),
//                       ),
//                     ],
//                   ),
//         Row(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Expanded(
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   /// Top Info
//                   // Text(
//                   //   c.partySelectedName.value,
//                   //   style: const TextStyle(
//                   //     fontWeight: FontWeight.bold,
//                   //     fontSize: 16,
//                   //   ),
//                   // ),
//                   // Text("Invoice No: ${c.salesHeaderEntity.value?.invoiceNo ?? ''}"),
//                   // Text(
//                   //   "Type: ${c.salesHeaderEntity.value?.voucherTypeName ?? ''} | Pricelist: ${c.priceList.value} ",
//                   // ),
//                   // Text("Mobile: ${c.partyMobileNo.value}"),
//                   // Text("Created: ${c.selectedDate.value}"),
        
//                   // const SizedBox(height: 5),
        
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
//                     children: [
//                       CustomTextFormFieldView(
//                         controller: c.remarkController,
//                         title: 'Narration',
//                         maxLines: 2,
//                       ),
//                     ],
//                   ),
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

//   Widget _buildInventory(SalesController c, BuildContext context) {
//     final header = c.salesHeaderEntity.value;

//     if (header == null && c.hedId == null) {
//       return Center(
//         child: ResponsiveButton(
//           title: 'Next',
//           function: () async {
//             Utility.showCircularLoadingWid(context);
//             await c.salesHeaderPostApi();
//           },
//         ),
//       );
//     }

//     final items = header?.items ?? [];

//     return Column(
//       children: [
//         /// HEADER
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text("Inventory Details",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             IconButton(
//               icon: const Icon(Icons.add),
//               onPressed: () async {
//                 await Get.to(() => SalesInventoryScreen());
//                 await c.getSalesDataAPI();
//               },
//             ),
//           ],
//         ),

//         /// LIST
//         Card(
//           child: items.isEmpty
//               ? const Padding(
//                   padding: EdgeInsets.all(12),
//                   child: Text("No Inventory Added"),
//                 )
//               : ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: items.length,
//                   itemBuilder: (_, i) {
//                     final item = items[i];
//                     return ListTile(
//                       title: Text(item.itemName ?? ''),
//                       subtitle:
//                            Text(
//                                       "Qty: ${item.qty} | Rate: ${item.rate} | Disc: ${item.discount ?? 0}%",
//                                       style: kTxtStl12N,
//                                     ),
//                       trailing: SizedBox(
//         width: 120, // VERY IMPORTANT
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.end,
//           mainAxisAlignment: MainAxisAlignment.center,
//           children: [
//             Text(
//               indianRupeeFormat(
//                 double.tryParse(item.totalvalue ?? '0') ?? 0,
//               ),
//               style: kTxtStl13N,
//             ),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.end,
//               children: [
//                 IconButton(
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(),
//                   icon: const Icon(Icons.edit, size: 18, color: Colors.green),
//                   onPressed: () {
//                     navigateInventory(data: item, c: c);
//                   },
//                 ),
//                 IconButton(
//                   padding: EdgeInsets.zero,
//                   constraints: const BoxConstraints(),
//                   icon: const Icon(Icons.delete, size: 18, color: Colors.red),
//                   onPressed: () async {
//                     await c.deleteItemPostApi(
//                       invId: item.invId ?? '',
//                     );
//                     c.salesHeaderEntity.refresh();
//                   },
//                 ),
//               ],
//             ),
//         ]))  );
//                   },
//                 ),
//         ),
//       ],
//     );
//   }

//   // ================= LEDGER =================

//   Widget _buildLedger(SalesController c, BuildContext context) {
//     final list = c.salesLedgerList;

//     return Column(
//       children: [
//         /// HEADER
//         Row(
//           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//           children: [
//             const Text("Ledger Details",
//                 style: TextStyle(fontWeight: FontWeight.bold)),
//             IconButton(
//               icon: const Icon(Icons.add),
//               onPressed: () async {
//                 await Get.to(() => SalesLedgerScreen());
//                 await c.getSalesDataAPI();
//               },
//             ),
//           ],
//         ),

//         /// LIST
//         Card(
//           child: list.isEmpty
//               ? const Padding(
//                   padding: EdgeInsets.all(12),
//                   child: Text("No Ledger Added"),
//                 )
//               : ListView.builder(
//                   shrinkWrap: true,
//                   physics: const NeverScrollableScrollPhysics(),
//                   itemCount: list.length,
//                   itemBuilder: (_, i) {
//                     final l = list[i];
//                     return ListTile(
//                       title: Text(l.ledgerName ?? ''),
//                       trailing: Text(
//                         indianRupeeFormat(
//                             double.tryParse(l.amount ?? '0') ?? 0),
//                       ),
//                     );
//                   },
//                 ),
//         ),
//       ],
//     );
//   }
// }
