import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/outstanding/os_rec_pay_entity.dart';

class OutstandingRecPayBillDetailsController extends GetxController {
  final String? partyid;
  final String? partyname;
  // final String? type;
  final String? ageFilter;
  final String? osAgeBySelectedFilter;

  OutstandingRecPayBillDetailsController({
    this.partyid,
    this.partyname,
    // this.type,
    this.ageFilter,
    this.osAgeBySelectedFilter,
  });
  RxDouble overdueAmount = 0.0.obs;
  RxDouble outstandingAmount = 0.0.obs;
  RxString creditDays = ''.obs;
  RxString creditLimit = ''.obs;
  RxString contactNo = ''.obs;
  RxString emailId = ''.obs;
  var isDataLoad = 0.obs; // 0=loading, 1=data loaded, 2=no data
  var outRecPayBillwiseValue = <OutstandingRecPayEntity>[].obs;
  final osDate =
      // Utility.lastTallySyncDate == ''
      //       ?
      DateTime.now();
  // : DateTime.parse(
  //     DateFormat(
  //       'yyyy-MM-dd',
  //     ).format(DateFormat('dd/MM/yyyy').parse(Utility.lastTallySyncDate)),
  // );

  @override
  void onInit() {
    super.onInit();
    _getOutRecPayBillWiseAPI(partyId: partyid!);
    getPartyDetailsDataAPI();
  }

  Future _getOutRecPayBillWiseAPI({required String partyId}) async {
    isDataLoad.value = 0;
    outRecPayBillwiseValue.clear();
    overdueAmount.value = 0;
    outstandingAmount.value = 0;

    final outrecpaybillwiseData = await ApiCall.getOsRecBillwiseDataAPI(
      partyId: partyId,
    );

    if (outrecpaybillwiseData.isNotEmpty) {
      for (int i = 0; i < outrecpaybillwiseData.length; i++) {
        OutstandingRecPayEntity outstandingRecPayEntity =
            OutstandingRecPayEntity.fromJson(outrecpaybillwiseData[i]);

        final dueDate = outstandingRecPayEntity.duedate != ''
            ? DateTime.parse(outstandingRecPayEntity.duedate!)
            : null;
        final billDate = outstandingRecPayEntity.billdate != ''
            ? DateTime.parse(outstandingRecPayEntity.billdate!)
            : null;

        int overDueDays = 0;
        if (osAgeBySelectedFilter == 'Invoice Date') {
          overDueDays = billDate != null
              ? osDate.difference(billDate).inDays
              : 0;
        } else {
          overDueDays = dueDate != null ? osDate.difference(dueDate).inDays : 0;
        }

        //=================================
        bool addToList = false;

        if (ageFilter != null) {
          if (ageFilter == 'Due' && overDueDays >= 0) {
            addToList = true;
          } else if (ageFilter == 'Not Due' && overDueDays < 0)
            addToList = true;
          else if (ageFilter == '<30' && overDueDays <= 30)
            addToList = true;
          else if (ageFilter == '31-60' &&
              overDueDays >= 31 &&
              overDueDays <= 60)
            addToList = true;
          else if (ageFilter == '61-90' &&
              overDueDays >= 61 &&
              overDueDays <= 90)
            addToList = true;
          else if (ageFilter == '91-120' &&
              overDueDays >= 91 &&
              overDueDays <= 120)
            addToList = true;
          else if (ageFilter == '121-180' &&
              overDueDays >= 121 &&
              overDueDays <= 180)
            addToList = true;
          else if (ageFilter == '>180' && overDueDays >= 181)
            addToList = true;
          else if (ageFilter == 'ALL')
            addToList = true;
        } else {
          addToList = true;
        }

        if (addToList) {
          outRecPayBillwiseValue.add(outstandingRecPayEntity);
          if (overDueDays > 0) {
            overdueAmount.value += outstandingRecPayEntity.pendingamount ?? 0;
          }
          outstandingAmount.value += outstandingRecPayEntity.pendingamount ?? 0;
        }
      }

      // Sort the list
      outRecPayBillwiseValue.sort((a, b) {
        if (osAgeBySelectedFilter == 'Invoice Date') {
          return a.billdate!.compareTo(b.billdate!);
        } else {
          return a.duedate!.compareTo(b.duedate!);
        }
      });

      isDataLoad.value = 1;
    } else {
      isDataLoad.value = 2;
    }
  }

    Future<int> getPartyDetailsDataAPI() async {
    try {
      await ApiCall.getPartyDetailsApi(partyid: partyid!).then((
        partyEntity,
      ) {
        // creditDays = partyEntity!.creditdays!.toString();
        // creditLimit = partyEntity.creditlimit!.toString();
        // contactNo = partyEntity.contactNo!;
        // emailId = partyEntity.email!;
        creditDays.value = partyEntity!.creditdays?.toString() ?? '';
        creditLimit.value = partyEntity.creditlimit?.toString() ?? '';
        contactNo.value = partyEntity.contactNo ?? '';
        emailId.value = partyEntity.email ?? '';
      });
    } catch (ex) {
      print(ex);
    }
    
    return 1;
  }
}
