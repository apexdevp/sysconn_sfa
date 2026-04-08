import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/company/partyentity.dart';
import 'package:trina_grid/trina_grid.dart';

class MyCustomerListController extends GetxController {
    var isDataLoad = 0.obs;
  var rows = <TrinaRow>[].obs;
  
  RxList<PartyEntity> partyList = <PartyEntity>[].obs;
  final String partyGroup;
  TrinaGridStateManager? stateManager;
  MyCustomerListController({required this.partyGroup});
  @override
  void onInit() {
    super.onInit();
   
    getPartyData();
  }

   void getPartyData() {
    isDataLoad.value = 0;
    rows.clear();
   
    ApiCall.getPartyDetCMPApi(partyType: partyGroup).then((partyDataList) {
      if (partyDataList.isNotEmpty) {
        //Manisha C 18-03-2026
        partyList.assignAll(partyDataList);
        for (int i = 0; i < partyDataList.length; i++) {
          rows.addAll([
            TrinaRow(
              cells: {
          
                'action': TrinaCell(value: i),
                'state': TrinaCell(value: partyDataList[i].state ?? ''),
                'party_code': TrinaCell(value: partyDataList[i].partyId ?? ''),
                'party_name': TrinaCell(
                  value:
                      partyDataList[i].retailerName ??
                      '', //partyDataList[i].partyName ?? '',
                ),
                'constitution': TrinaCell(
                  value: partyDataList[i].constitutionname ?? '',
                ),
                'active': TrinaCell(value: partyDataList[i].active ?? ''),
                'group': TrinaCell(
                  value: partyDataList[i].partyGroupName ?? '',
                ),
                'isbilled': TrinaCell(value: partyDataList[i].isBilled ?? ''),
                'pricelist': TrinaCell(value: partyDataList[i].pricelist ?? ''),
                'city': TrinaCell(value: partyDataList[i].city ?? ''),
               
                'area': TrinaCell(value: partyDataList[i].cityAreaName ?? ''),
                'locality': TrinaCell(
                  value: partyDataList[i].localityName ?? '',
                ),
                'gst_no': TrinaCell(value: partyDataList[i].gstIn ?? ''),
                'pan_no': TrinaCell(value: partyDataList[i].panno ?? ''),
                'incorporation_date': TrinaCell(
                  value: partyDataList[i].incorporationDate ?? '',
                ),
                'reffered_by': TrinaCell(
                  value: partyDataList[i].influencerUserName ?? '',
                ),
                'date_of_retailer': TrinaCell(
                  value: partyDataList[i].partyCreatedDate ?? '',
                ),
              
                'tallystatus': TrinaCell(
                  value: partyDataList[i].tallystatus ?? '',
                ), 
                'tallysyncdate': TrinaCell(
                  value: partyDataList[i].tallysyncdate ?? '',
                ),
              },
            ),
          ]);
        }
        isDataLoad.value = 1;
      } else {
        isDataLoad.value = 2;
      }
    });
  }

}
