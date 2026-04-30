// import 'package:flutter/material.dart';
// import 'package:get/get.dart';
// import 'package:intl/intl.dart';
// import 'package:sysconn_sfa/Utility/systemxs_global.dart';
// import 'package:sysconn_sfa/Utility/utility.dart';
// import 'package:sysconn_sfa/api/apicall.dart';
// import 'package:sysconn_sfa/api/entity/buddy/sales/sales_inventory_entity.dart';
// import 'package:sysconn_sfa/api/entity/company/godown_master_entity.dart';
// import 'package:sysconn_sfa/api/entity/company/ledger_entity.dart';
// import 'package:sysconn_sfa/api/entity/company/stock_item_entity.dart';

// class InventoryDetailsController extends GetxController {
//   // Incoming parameters
//   String? uniqueId;
//   String? title;
//   SalesInventoryEntity? itemlist;
//   String? vchType;

//   InventoryDetailsController({
//     this.uniqueId,
//     this.title,
//     this.itemlist,
//     this.vchType,
//   });

//   // -------------------- REACTIVE VARIABLES --------------------

//   var stockItemList = <StockItemEntity>[].obs;

//   TextEditingController dateController =
//       TextEditingController(text: DateFormat("yyyy-MM-dd").format(DateTime.now()));

//   SalesInventoryEntity salesInvEntity = SalesInventoryEntity();

//   var itemName = ''.obs;

//   TextEditingController itemRemarkController = TextEditingController();
//   TextEditingController quantityTextController = TextEditingController();
//   TextEditingController rateTextController = TextEditingController();
//   TextEditingController discountTextController = TextEditingController();
//   TextEditingController cashDiscController = TextEditingController(text: '0');
//   TextEditingController schemeDiscController = TextEditingController(text: '0');
//   TextEditingController freeQtyController = TextEditingController();
//   TextEditingController totalQtyController = TextEditingController();

//   List<String> unitPerList = ['Base Units', 'Alt Units'];
//   var perSelected = 'Base Units'.obs;

//   var isAddUnitApplicable = false.obs;
//   num conversion = 0;
//   num denominator = 0;

//   var itemTotalNetAmount = ''.obs;

//   var postingLedgerlist = <LedgerMasterEntity>[].obs;
//   var postingledgername = ''.obs;
//   var postingledgerid = ''.obs;

//   var godownDatalist = <GodownMasterEntity>[].obs;
//   var godownname = ''.obs;
//   var godownid = ''.obs;

//   var isdataLoad = 0.obs;

//   // -------------------- INIT --------------------

//   @override
//   void onInit() {
//     super.onInit();

//     salesLedgerMasterList().then((_) async {
//       await getGodownMasterDataApi();
//     });

//     if (itemlist != null) {
//       setRowsEdit();
//     }
//   }

//   // -------------------- ORIGINAL METHODS WITH NO CHANGE --------------------

//   void setRowsEdit() {
//     salesInvEntity = itemlist!;
//     itemName.value = itemlist!.itemName!;

//     itemRemarkController.text = itemlist!.remark!;
//     quantityTextController.text = itemlist!.qty!;
//     rateTextController.text = itemlist!.rate!;
//     discountTextController.text = itemlist!.discount!;

//     isAddUnitApplicable.value =
//         itemlist!.altQtyPer == 'Base Units' ? false : true;

//     num billQty = quantityTextController.text.trim() == ''
//         ? 0
//         : num.parse(quantityTextController.text);

//     freeQtyController.text = '0';
//     totalQtyController.text = (billQty).toString();

//     postingledgerid.value = itemlist!.postingledgerid!;
//     postingledgername.value = itemlist!.postingledgerName!;
//     godownid.value = itemlist!.godownid!;
//     godownname.value = itemlist!.godownName!;
//   }

//   Future itemsListData(String itemNameText) async {
//     stockItemList.clear();
//     await ApiCall.itemListApi(
//             itemName: itemNameText,
//             date: DateFormat('yyyy-MM-dd')
//                 .format(DateTime.parse(dateController.text)),
//             pricelist: '')
//         .then((itemVal) {
//       if (itemVal.isNotEmpty) {
//         stockItemList.assignAll(itemVal);
//       }
//     });
//   }

//   SalesInventoryEntity calTotalAmountValue({
//     required String invRate,
//     required String invQty,
//     required String invDisc,
//     required String taxRate,
//   }) {
//     SalesInventoryEntity entity = SalesInventoryEntity();

//     num rate = invRate != '' ? num.parse(invRate) : 0.0;
//     num disc = invDisc != '' ? num.parse(invDisc) : 0.0;
//     num qty = invQty != '' ? num.parse(invQty) : 1;
//     num amount = rate * qty;
//     num discAmt = amount - ((amount * disc) / 100);
//     num gstRate = taxRate != '' ? num.parse(taxRate) : 0.0;

//     num netValue = discAmt;
//     num gstValue = (netValue * ((gstRate / 2) / 100)).round() +
//         (netValue * ((gstRate / 2) / 100)).round();
//     num totalValue = netValue + gstValue;

//     entity.netValue = netValue.toStringAsFixed(2);
//     entity.gstvalue = gstValue.toStringAsFixed(2);
//     entity.value = totalValue.toStringAsFixed(2);

//     return entity;
//   }

//   Future checkValidIssueItemBool(
//       String? itemId, String? qtyText, String? rateText) async {
//     if (itemId == '') {
//       scaffoldMessageBar( 'Please enter item name');
//       return false;
//     } else if (qtyText == null) {
//       scaffoldMessageBar( 'Please enter quantity');
//       return false;
//     } else if (rateText == null) {
//       scaffoldMessageBar( 'Please enter rate');
//       return false;
//     }
//     return true;
//   }

//   Future salesItemPost({required SalesInventoryEntity itemSelectedEntity}) async {
//     bool isValid = await checkValidIssueItemBool(
//         itemSelectedEntity.itemId, itemSelectedEntity.qty, itemSelectedEntity.rate);

//     if (isValid) {
//       SalesInventoryEntity itementity = SalesInventoryEntity();
//       itementity.companyid = Utility.companyId;
//       itementity.mobileno = Utility.cmpmobileno;
//       itementity.invId = itemSelectedEntity.invId ?? '';
//       itementity.hedUniqueId = uniqueId;

//       itementity.itemId = itemSelectedEntity.itemId;
//       itementity.qty = itemSelectedEntity.qty;
//       itementity.rate = itemSelectedEntity.rate;
//       itementity.discount = itemSelectedEntity.discount ?? '';
//       itementity.value = itemSelectedEntity.value;
//       itementity.gstrate = itemSelectedEntity.gstrate ?? '';
//       itementity.cessrate = itemSelectedEntity.cessrate ?? '';
//       itementity.gstvalue = itemSelectedEntity.gstvalue ?? '';
//       itementity.cessvalue = itemSelectedEntity.cessvalue ?? '';
//       itementity.netValue = itemSelectedEntity.netValue ?? '';
//       itementity.remark = itemSelectedEntity.remark ?? '';
//       itementity.altQtyPer = itemSelectedEntity.altQtyPer ?? '';
//       itementity.altQty = itemSelectedEntity.altQty ?? '';

//       itementity.postingledgerid = postingledgerid.value;
//       itementity.godownid = godownid.value;

//       List<Map<String, dynamic>> itemList = [];
//       itemList.add(itementity.toMap());

//       await ApiCall.salesInvDetPostApi(itemList).then((response) async {
//         Navigator.of(Get.context!).pop();
//         if (response == 'Data Inserted Successfully') {
//           Navigator.of(Get.context!).pop(true);
//         } else {
//           await Utility.showAlert(
//               icons:  Icons.close,iconcolor:  Colors.red,title:  'Error',msg:  'Oops there is an error!');
//         }
//       });
//     }
//   }

//   Future deleteItemPostApi({required String invId}) async {
//     SalesInventoryEntity delEntity = SalesInventoryEntity();
//     delEntity.companyid = Utility.companyId;
//     delEntity.mobileno = Utility.cmpmobileno;
//     delEntity.invId = invId;
//     delEntity.hedUniqueId = uniqueId;

//     List<Map<String, dynamic>> list = [];
//     list.add(delEntity.toMap());

//     await ApiCall.deleteItemSalesApi(salesInvEntityListMap: list).then((response) async {
//       Navigator.of(Get.context!).pop();
//       if (response == 'Data Deleted Successfully') {
//         await Utility.showAlert(
//                 icons:  Icons.check,iconcolor:  Colors.green,title:  'Status',msg:  'Data Deleted Successfully')
//             .then((value) => Navigator.of(Get.context!).pop());
//       } else {
//         await Utility.showAlert(
//             icons:  Icons.close,iconcolor:  Colors.red,title:  'Error',msg:  'Oops there is an error!');
//       }
//     });
//   }

//   Future getGodownMasterDataApi() async {
//     isdataLoad.value = 0;
//     await ApiCall.getGodownmasterApi(godown: '').then((data) {
//       if (data.isNotEmpty) {
//         godownDatalist.assignAll(data);
//         isdataLoad.value = 1;
//       } else {
//         isdataLoad.value = 2;
//       }
//     });
//   }

//   Future salesLedgerMasterList() async {
//     postingLedgerlist.clear();

//     String ledgerType = vchType == 'Sales' || vchType == 'Credit Note'
//         ? "('Sales Accounts','Direct Incomes','Indirect Incomes')"
//         : "('Purchase Accounts','Direct Expenses','Indirect Expenses')";

//     await ApiCall.getLedgerDetCMPApi(ledgerType: ledgerType).then((ledgerList) {
//       if (ledgerList.isNotEmpty) {
//         postingLedgerlist.assignAll(ledgerList);
//       }
//     });
//   }
// }
