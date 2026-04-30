// import 'dart:io';
// import 'package:flutter/cupertino.dart';
// import 'package:flutter/material.dart';
// import 'package:intl/intl.dart';
// import 'package:get/get.dart';
// import 'package:sysconn_sfa/Utility/floating_point_action_button.dart';
// import 'package:sysconn_sfa/Utility/systemxs_global.dart';
// import 'package:sysconn_sfa/Utility/textstyles.dart';
// import 'package:sysconn_sfa/Utility/utility.dart';
// import 'package:sysconn_sfa/api/apicall.dart';
// import 'package:sysconn_sfa/api/entity/sales/sales_register_rep_entity.dart';
// import 'package:sysconn_sfa/screens/buddy/sales/sales_entry_screen.dart';
// import 'package:sysconn_sfa/widgets/calendar_view.dart';

// // ------------------------ GetX Controller ------------------------
// class SalesBillsDashDetailsController extends GetxController {
//   var isdataLoad = 0.obs;
//   var salesbillswiseValue = <SalesRegisterReportEntity>[].obs;
//   var searchResultOfInvoice = <SalesRegisterReportEntity>[].obs;
//   var isSearch = false.obs;

//   TextEditingController searchController = TextEditingController();

//   DateTime fromDate = Utility.findStartOfThisMonth(DateTime.now());
//   DateTime toDate = Utility.findLastOfThisMonth(DateTime.now());

//   Future salesListApiDet(String? id, String? type) async {
//     salesbillswiseValue.clear();
//     isdataLoad.value = 0;

//     var salesRegisterRepListData =
//         await ApiCall.getSalesRegisterReport(fromDate.toString(), toDate.toString(), id, type);

//     if (salesRegisterRepListData.isNotEmpty) {
//       salesbillswiseValue.value = salesRegisterRepListData;
//       isdataLoad.value = 1;
//     } else {
//       isdataLoad.value = 2;
//     }
//   }

//   void onSearchTextChanged(String text, String? id, String? type) {
//     searchResultOfInvoice.clear();
//     if (text.isEmpty) {
//       isSearch.value = false;
//       salesListApiDet(id, type);
//       return;
//     }

//     for (var salesData in salesbillswiseValue) {
//       if (salesData.invoiceno!.toLowerCase().contains(text.toLowerCase())) {
//         searchResultOfInvoice.add(salesData);
//       }
//     }
//     salesbillswiseValue.value = searchResultOfInvoice.toList();
//     isSearch.value = true;
//   }
// }

// // ------------------------ UI ------------------------
// class SalesBillsDashDetails extends StatelessWidget {
//   final String? salessummarytype;
//   final String? name;
//   final String? id;
//   final String? type;
//   final String? dashboardNavTo;

//   SalesBillsDashDetails(
//       {super.key, this.salessummarytype, this.name, this.id, this.type, this.dashboardNavTo});

//   final SalesBillsDashDetailsController controller =
//       Get.put(SalesBillsDashDetailsController());

//   @override
//   Widget build(BuildContext context) {
//     Size size = MediaQuery.of(context).size;

//     // Initial data load
//     controller.salesListApiDet(id, type);

//     Widget buildSearchField() {
//       return TextField(
//         controller: controller.searchController,
//         autofocus: true,
//         decoration: const InputDecoration(
//           hintStyle: TextStyle(color: Colors.white),
//           hintText: "Search",
//         ),
//         style: const TextStyle(color: Colors.white),
//         onChanged: (text) => controller.onSearchTextChanged(text, id, type),
//       );
//     }

//     return Scaffold(
//       appBar: AppBar(
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back_ios, size: 18, color: Colors.white),
//           onPressed: () => Navigator.maybePop(context),
//         ),
//         title: Obx(() =>
//             controller.isSearch.value ? buildSearchField() : Text('$salessummarytype Wise $type Bills')),
//         actions: [
//           Obx(() {
//             if (controller.isSearch.value) {
//               return IconButton(
//                 icon: const Icon(Icons.clear, color: Colors.white),
//                 onPressed: () {
//                   controller.searchController.clear();
//                   controller.isSearch.value = false;
//                   controller.salesListApiDet(id, type);
//                 },
//               );
//             } else {
//               return IconButton(
//                 icon: const Icon(Icons.search, color: Colors.white),
//                 onPressed: () => controller.isSearch.value = true,
//               );
//             }
//           }),
//         ],
//         flexibleSpace: Container(
//           decoration: const BoxDecoration(
//             gradient: LinearGradient(
//               begin: Alignment.topLeft,
//               end: Alignment.bottomRight,
//               colors: <Color>[
//                 // Color.fromRGBO(134, 36, 35, 1),
//                 // Color.fromRGBO(226, 121, 105, 1),
//                 // Color.fromRGBO(143, 46, 42, 1),
//                 // Color.fromRGBO(231, 126, 109, 1),
//                 // Color.fromRGBO(134, 36, 35, 1),
//                 Color(0xffF54749),
//                 Color(0xffF54749),
//               ],
//             ),
//           ),
//         ),
//         bottom: PreferredSize(
//           preferredSize: const Size.fromHeight(60.0),
//           child: Column(
//             children: [
//               Row(
//                 mainAxisAlignment: MainAxisAlignment.end,
//                 children: [
//                   CalendarView(
//                     fromDate: controller.fromDate,
//                     toDate: controller.toDate,
//                     function: () async {
//                       await selectDateRange( controller.fromDate, controller.toDate)
//                           .then((dateTimeRange) {
//                         controller.fromDate = dateTimeRange.start;
//                         controller.toDate = dateTimeRange.end;
//                         controller.salesListApiDet(id, type);
//                       });
//                     },
//                   ),
//                 ],
//               ),
//               SizedBox(height: size.height * 0.01),
//             ],
//           ),
//         ),
//       ),
//       floatingActionButton: id != ''
//           ? null
//           : FloatingButton(
//               isExtended: false,
//               title: null,
//               icon: const Icon(Icons.add),
//               function: () async {
//                 // await Navigator.of(context)
//                 //     .push(MaterialPageRoute(builder: (context) => CreateSales(vchType: type!, partyid: '')));
//                     Get.to(() => CreateSales(vchType: type!, partyid: ''));
//                 controller.salesListApiDet(id, type);
//               },
//             ),
//       body: Container(
//         padding: const EdgeInsets.fromLTRB(4, 4, 4, 9),
//         decoration: BoxDecoration(
//           borderRadius: const BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
//           color: Colors.grey[50],
//         ),
//         child: Column(
//           children: [
//             if (name != null)
//               Container(
//                 width: size.width,
//                 decoration: BoxDecoration(
//                     borderRadius:
//                         const BorderRadius.only(topLeft: Radius.circular(40.0), topRight: Radius.circular(40.0)),
//                     color: Colors.grey.shade200),
//                 padding: const EdgeInsets.all(9.0),
//                 child: Text(name!, style: kTxtStlB, textAlign: TextAlign.center),
//               ),
//             Expanded(
//               child: Obx(() {
//                 if (controller.isdataLoad.value == 0) {
//                   return Center(
//                     child: Platform.isIOS
//                         ? const CupertinoActivityIndicator()
//                         : const CircularProgressIndicator(),
//                   );
//                 } else if (controller.isdataLoad.value == 2) {
//                   return const Center(child: Text('No Data'));
//                 } else {
//                   return ListView.builder(
//                     itemCount: controller.salesbillswiseValue.length,
//                     itemBuilder: (context, i) {
//                       var sales = controller.salesbillswiseValue[i];
//                       return Column(
//                         children: [
//                           ListTile(
//                             title: Text(sales.partyName!, style: kTxtStl13B),
//                             subtitle: Column(
//                               children: [
//                                 Row(
//                                   children: [
//                                     SizedBox(
//                                         width: size.width * 0.30,
//                                         child: Text('Invoice No ', style: kTxtStl13GreyN)),
//                                      SizedBox(child: Text(': ', style: kTxtStl13GreyN)),
//                                     Expanded(child: Text(sales.invoiceno!, style: kTxtStl13GreyN)),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     SizedBox(
//                                         width: size.width * 0.30,
//                                         child: Text('Voucher Type ', style: kTxtStl13GreyN)),
//                                      SizedBox(child: Text(': ', style: kTxtStl13GreyN)),
//                                     Expanded(child: Text(sales.vouchertype!, style: kTxtStl13GreyN)),
//                                   ],
//                                 ),
//                                 Row(
//                                   children: [
//                                     SizedBox(width: size.width * 0.30, child: Text('Date ', style: kTxtStl13GreyN)),
//                                      SizedBox(child: Text(': ', style: kTxtStl13GreyN)),
//                                     Expanded(
//                                         child: Text(
//                                             sales.date == ''
//                                                 ? ''
//                                                 : DateFormat('dd-MM-yyyy')
//                                                     .format(DateTime.parse(sales.date!)),
//                                             style: kTxtStl13GreyN)),
//                                   ],
//                                 ),
//                                 if (sales.type != 'Receipt' && sales.type != 'Payment')
//                                   Row(
//                                     children: [
//                                       SizedBox(width: size.width * 0.30, child: Text('Total Qty ', style: kTxtStl13GreyN)),
//                                        SizedBox(child: Text(': ', style: kTxtStl13GreyN)),
//                                       Expanded(child: Text(sales.totalqty!, style: kTxtStl13GreyN)),
//                                     ],
//                                   ),
//                               ],
//                             ),
//                             trailing: Text(
//                               indianRupeeFormat(double.parse(sales.totalammount.toString())),
//                               style: kTxtStl13B,
//                             ),
//                             onTap: () async {
//                               // await Navigator.of(context).push(MaterialPageRoute(
//                               //     builder: (context) => CreateSales(vchType: 'Sales', hedId: sales.uniqueid)));
//                               Get.to(() => CreateSales(vchType: 'Sales', hedId: sales.uniqueid));    
//                               controller.salesListApiDet(id, type);
//                             },
//                           ),
//                           const Divider(thickness: 1.0),
//                         ],
//                       );
//                     },
//                   );
//                 }
//               }),
//             )
//           ],
//         ),
//       ),
//     );
//   }
// }
