import 'dart:convert';
import 'dart:convert' as convert;
import 'package:get/get.dart';
import 'package:http/http.dart' as http;
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/api_url.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/beatwiselistentity.dart';
import 'package:sysconn_sfa/api/entity/company/customer_category_entity.dart';
import 'package:sysconn_sfa/api/entity/company/customer_master_data_entity.dart';

class BeatListController extends GetxController {
  var filterTypeItem = [
    {'name': 'Group', 'id': 'Group'},
    // {'name': 'Route', 'id': 'Route'},
    // {'name': 'Beat', 'id': 'Beat'},
    {'name': 'Area', 'id': 'Area'},
    // {'name': 'Customer Type', 'id': 'CustomerType'},
    // {'name': 'Sales Person', 'id': 'Sales_Person'},
    // {'name': 'Customer Classification', 'id': 'Customer_Classification'},
  ].obs;

  /// Default selected id
  var filterTypeIdSelected = 'Area'.obs;
  var isDataLoad = 0.obs;
  // final isLoading = false.obs;

  /// Get selected name easily
  String get selectedFilterName =>
      filterTypeItem.firstWhere(
        (element) => element['id'] == filterTypeIdSelected.value,
      )['name'] ??
      '';
  RxList<BeatListEntity> beatListData = <BeatListEntity>[].obs;
  final groupList = <CustomerCategoryEntity>[].obs;

  @override
  void onInit() {
    super.onInit();
    getBeatListAPIDet();
  }

  void changeFilter(String newId) {
    filterTypeIdSelected.value = newId;

    /// Call API based on selection
    beatListData.clear();
    isDataLoad.value = 0;
    if (newId == 'Group') {
      // ledgerGroupDataAPI();
      fetchMasterData();
    } else {
      getBeatListAPIDet();
    }
  }

  var statustag = '0'.obs; // RxString

  void toggleStatus(bool value) {
    statustag.value = value ? '1' : '0';
    checkInternetDet(); // Call your method
  }

  void checkInternetDet() {
    if (filterTypeIdSelected.value == 'Group') {
      //filterTypeNameSelected
      fetchMasterData();
    } else {
      getBeatListAPIDet();
    }
  }

  Future<List<BeatListEntity>> getBeatListAPIDet() async {
    beatListData.clear();
    isDataLoad.value = 0;
    await ApiCall.getBeatListData(
      statustag.value,
      filterTypeIdSelected.value,
    ).then((advExpenseItemDataList) {
      if (advExpenseItemDataList.isNotEmpty) {
        beatListData.assignAll(advExpenseItemDataList);
        isDataLoad.value = 1;
      } else {
        isDataLoad.value = 2;
      }
    });

    return beatListData;
  }

  // Future<void> fetchMasterData() async {
  //   try {
  //     // isLoading.value = true;
  //     final data = await getMasterData();

  //     groupList.assignAll(data.group);
  //   } catch (e) {
  //     print('Error fetching master data: $e');
  //   }
  // }

  Future<void> fetchMasterData() async {
    try {
      isDataLoad.value = 0;
      beatListData.clear();

      final data = await getMasterData();

      if (data.group == null || data.group.isEmpty) {
        isDataLoad.value = 2;
        return;
      }

      // ✅ Add ALL option
      beatListData.add(
        BeatListEntity()
          ..iD = 'ALL'
          ..nAME = 'ALL'
          ..count = '',
      );

      // ✅ Map group → beatListData
      for (var group in data.group) {
        beatListData.add(
          BeatListEntity()
            ..iD = group.categoryId ?? ''
            ..nAME = group.name ?? '',
        );
      }

      isDataLoad.value = 1;
    } catch (e) {
      isDataLoad.value = 2;
      print('Error fetching master data: $e');
    }
  }

  static Future<CustomerMasterDataEntity> getMasterData() async {
    var masterDataUrl =
        '${ApiUrl.partyMasterGetUrl}company_id=${Utility.companyId}&db_nm=${Utility.sysDbName}';
    print(masterDataUrl);
    final response = await http
        .get(
          Uri.parse(masterDataUrl),
          headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),
        )
        .timeout(const Duration(seconds: Utility.tIMEOUTDURATION));

    if (response.statusCode == 200) {
      final jsonData = jsonDecode(response.body);
      return CustomerMasterDataEntity.fromJson(jsonData);
    } else {
      throw Exception('Failed to load master data');
    }
  }

  // Future<Null> fetchMasterData() async {
  //   var masterDataUrl =
  //       '${ApiUrl.partyMasterGetUrl}company_id=${Utility.companyId}&db_nm=${Utility.sysDbName}';
  //    print(masterDataUrl);
  //   final ledgerGroupDataResponse = await http.get(Uri.parse(masterDataUrl),
  //       headers: Utility.getSystemxsDmsHeaders(token: Utility.loginDmsToken),);
  //   print(ledgerGroupDataResponse.statusCode);
  //   if (ledgerGroupDataResponse.statusCode == 200) {
  //     beatListData.clear();
  //     // BeatListData. beatListDataAll = BeatListData();
  //     // beatListDataAll.nAME = 'ALL';
  //     // beatListDataAll.iD = 'ALL';
  //     // beatListData.add(beatListDataAll);
  //     var ledgerGroupDataValue = convert.jsonDecode(ledgerGroupDataResponse.body)['data'];
  //     print(ledgerGroupDataResponse.body.toString());
  //     if (ledgerGroupDataValue.isNotEmpty) {
  //       for (int i = 0; i < ledgerGroupDataValue.length; i++) {
  //         CustomerMasterDataEntity ledgerGroupDetailModel = CustomerMasterDataEntity.fromJson(ledgerGroupDataValue[i].group);
  //         BeatListEntity beatListDataEntity = BeatListEntity();
  //         beatListDataEntity.iD = ledgerGroupDetailModel.group.first.categoryId;
  //         beatListDataEntity.nAME = ledgerGroupDetailModel.group.first.name;
  //         beatListData.add(beatListDataEntity);
  //       }
  //       // isDataLoad = 1;
  //     } else {
  //       // isDataLoad = 2;
  //     }
  //   } else {
  //     // isDataLoad = 2;
  //   }

  // }
}
