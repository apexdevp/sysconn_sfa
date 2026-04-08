import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/api_url.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/company/customer_category_entity.dart';
import 'package:sysconn_sfa/api/entity/company/customer_city_entity.dart';
import 'package:sysconn_sfa/api/entity/company/customer_master_data_entity.dart';
import 'package:sysconn_sfa/api/entity/company/customer_pricelist_entity.dart';
import 'package:sysconn_sfa/api/entity/company/customer_refferedby_entity.dart';
import 'package:sysconn_sfa/api/entity/company/group_master_entity.dart';
import 'package:sysconn_sfa/api/entity/company/partyentity.dart';

class CustomerEditDetailsController extends GetxController {
  final String? custGroup;
  final String? initialPartyId;
  CustomerEditDetailsController({this.custGroup, this.initialPartyId});
  var nameCntrl = TextEditingController();
  var mailingnameCntrl = TextEditingController();
  var add1Cntrl = TextEditingController();
  var stateCntrl = TextEditingController();
  var pinCodeCntrl = TextEditingController();
  var gstinCntrl = TextEditingController();
  var contactNameCntrl = TextEditingController();
  var contactNumCntrl = TextEditingController();
  var mobNumCntrl = TextEditingController();
  var panNumCntrl = TextEditingController();
  var partyGrpCntrl = TextEditingController();
  var emailCntrl = TextEditingController();
  var pricelistCntrl = TextEditingController();
  var creditdaysCntrl = TextEditingController();
  var creditlimitCntrl = TextEditingController();
  var cityCntrl = TextEditingController();
  var bbpsB2BIdCntrl = TextEditingController();
  var dateCntrl = TextEditingController();
  var remarkCntrl = TextEditingController();
  String? partygroupID;

  var isDataLoad = false.obs;

  var pricelistname = <String>[].obs;
  List groupMasterEntityData = [];
  List priceListEntityData = [];

  var partyTypeItem = <String>['Customer', 'Supplier'].obs;
  var selectedpartyType = Rx<String?>(null);

  var partyGroupId = ''.obs;
  var partyGroupNameSelected = ''.obs;
  var partyId = ''.obs;
  var groupEntityList = <GroupMasterEntity>[].obs;
  var custgrouptype = ''.obs;

  // Manoj 23-02-2026
  final isBilled = false.obs;
  final selectedRating = 1.obs;

  void onSelectRating(int value) {
    selectedRating.value = value;
  }

  void onSelectBilled(bool value) {
    isBilled.value = value;
  }

  final isLoading = false.obs;

  final constitutionList = <CustomerCategoryEntity>[].obs;
  final segmentList = <CustomerCategoryEntity>[].obs;
  final groupList = <CustomerCategoryEntity>[].obs;
  final priceList = <CustomerPricelistEntity>[].obs;
  final refferedList = <CustomerRefferedbyEntity>[].obs;

  final selectedConstitution = Rxn<CustomerCategoryEntity>();
  final selectedSegment = Rxn<CustomerCategoryEntity>();
  final selectedGroup = Rxn<CustomerCategoryEntity>();
  final selectedPriceList = Rxn<CustomerPricelistEntity>();
  final selectedRefferedList = Rxn<CustomerRefferedbyEntity>();

  final selectedCity = Rxn<CustomerCityEntity>();
  final selectedArea = Rxn<AreaEntity>();
  final selectedLocality = Rxn<LocalityEntity>();

  final cityList = <CustomerCityEntity>[].obs;
  final areaList = <AreaEntity>[].obs; // full list
  final localityList = <LocalityEntity>[].obs; // full list

  final filteredAreaList = <AreaEntity>[].obs;
  final filteredLocalityList = <LocalityEntity>[].obs;

  @override
  // void onInit() {
  //   fetchMasterData();
  //   dateCntrl.text = DateFormat(
  //     'yyyy-MM-dd',
  //   ).format(DateTime.now());
  //   super.onInit();
  //   partyId.value = initialPartyId ?? '';
  //   initFunCall();
  // }
  @override
  void onInit() async {
    super.onInit();

    dateCntrl.text = DateFormat('yyyy-MM-dd').format(DateTime.now());
    partyId.value = initialPartyId ?? '';

    await fetchMasterData(); // WAIT for master data
    await initFunCall(); // THEN set edit data
  }

  Future<void> initFunCall() async {
    isDataLoad.value = false;

    await setRowsEdit();
    isDataLoad.value = true;
  }

  Future<void> fetchMasterData() async {
    try {
      isLoading.value = true;
      final data = await getMasterData();

      constitutionList.assignAll(data.constitution);
      segmentList.assignAll(data.segment);
      groupList.assignAll(data.group);
      priceList.assignAll(data.priceList);
      refferedList.assignAll(data.refferedBy);

      cityList.assignAll(data.cities);
      areaList.assignAll(data.areas);
      localityList.assignAll(data.localities);
    } catch (e) {
      print('Error fetching master data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setConstitutionById(String id) {
    selectedConstitution.value = constitutionList.firstWhereOrNull(
      (e) => e.categoryId == id,
    );
  }

  void setSegmentById(String id) {
    selectedSegment.value = segmentList.firstWhereOrNull(
      (e) => e.categoryId == id,
    );
  }

  void setPriceListById(String id) {
    selectedPriceList.value = priceList.firstWhereOrNull((e) => e.itemId == id);
  }

  void setGroupById(String id) {
    selectedGroup.value = groupList.firstWhereOrNull((e) => e.categoryId == id);
  }

  // Manoj 25-02-2026
  void filterAreaByCity(String cityId, {String? selectedAreaId}) {
    // Set selected city
    selectedCity.value = cityList.firstWhereOrNull((c) => c.id == cityId);

    // Filter areas for this city
    final filtered = areaList.where((a) => a.cityId == cityId).toList();
    filteredAreaList.assignAll(filtered);

    // Set selected area after filtering
    if (selectedAreaId != null) {
      selectedArea.value = filteredAreaList.firstWhereOrNull(
        (a) => a.id == selectedAreaId,
      );
    } else {
      selectedArea.value = null;
    }

    // Reset localities
    filteredLocalityList.clear();
    selectedLocality.value = null;
  }

  // Manoj 25-02-2026
  void filterLocalityByArea(String areaId, {String? selectedLocalityId}) {
    selectedArea.value = filteredAreaList.firstWhereOrNull(
      (a) => a.id == areaId,
    );

    // Filter locality list for this area
    final filtered = localityList.where((l) => l.areaId == areaId).toList();
    filteredLocalityList.assignAll(filtered);

    // Set selected locality after filtering
    if (selectedLocalityId != null) {
      selectedLocality.value = filteredLocalityList.firstWhereOrNull(
        (l) => l.id == selectedLocalityId,
      );
    } else {
      selectedLocality.value = null;
    }
  }

  // Manoj 25-02-2026
  void setSelectedConstitutionByName(String? name) {
    if (name == null || constitutionList.isEmpty) {
      selectedConstitution.value = null;
      return;
    }

    final match = constitutionList.where((e) => e.name == name).toList();

    if (match.isNotEmpty) {
      selectedConstitution.value = match.first;
    } else {
      selectedConstitution.value = null;
    }
  }

  void setSelectedSegmentByName(String? name) {
    if (name == null || segmentList.isEmpty) {
      selectedSegment.value = null;
      return;
    }

    final match = segmentList.where((e) => e.name == name).toList();

    if (match.isNotEmpty) {
      selectedSegment.value = match.first;
    } else {
      selectedSegment.value = null;
    }
  }

  void setSelectedGroupByName(String? name) {
    if (name == null || groupList.isEmpty) {
      selectedGroup.value = null;
      return;
    }

    final match = groupList.where((e) => e.name == name).toList();

    if (match.isNotEmpty) {
      selectedGroup.value = match.first;
    } else {
      selectedGroup.value = null;
    }
  }

  void setSelectedPriceListByName(String? name) {
    if (name == null || priceList.isEmpty) {
      selectedPriceList.value = null;
      return;
    }

    final match = priceList.where((e) => e.priceListName == name).toList();

    if (match.isNotEmpty) {
      selectedPriceList.value = match.first;
    } else {
      selectedPriceList.value = null;
    }
  }

  void setSelectedRefferedByName(String? name) {
    if (name == null || refferedList.isEmpty) {
      selectedRefferedList.value = null;
      return;
    }

    final match = refferedList.where((e) => e.companyName == name).toList();

    if (match.isNotEmpty) {
      selectedRefferedList.value = match.first;
    } else {
      selectedRefferedList.value = null;
    }
  }

  // Manoj 23-02-2026 Add Clear fields to refresh session when edit
  void clearAllFields() {
    // Clear text controllers
    partyId.value = '';

    nameCntrl.clear();
    mailingnameCntrl.clear();
    add1Cntrl.clear();
    stateCntrl.clear();
    creditdaysCntrl.clear();
    creditlimitCntrl.clear();
    pinCodeCntrl.clear();
    contactNameCntrl.clear();
    contactNumCntrl.clear();
    mobNumCntrl.clear();
    panNumCntrl.clear();
    gstinCntrl.clear();
    emailCntrl.clear();
    pricelistCntrl.clear();
    bbpsB2BIdCntrl.clear();
    cityCntrl.clear();
    remarkCntrl.clear();
    selectedRating.value = 0;
    isBilled.value = false;

    // Clear old selections for dropdowns
    selectedpartyType.value = '';
    // partyGroupNameSelected.value = '';
    // partyGroupId.value = '';

    // Clear all new dropdowns
    selectedConstitution.value = null;
    selectedSegment.value = null;
    selectedPriceList.value = null;
    selectedGroup.value = null;
    selectedRefferedList.value = null;

    selectedCity.value = null;
    selectedArea.value = null;
    selectedLocality.value = null;

    filteredAreaList.clear();
    filteredLocalityList.clear();
  }

  Future setRowsEdit() async {
    if (partyId.value.isNotEmpty) {
      final partyMaster = await ApiCall.getPartyDetCMPApi(
        partyId: partyId.value,
      );

      if (partyMaster.isEmpty) return;

      final data = partyMaster[0];
      nameCntrl.text = data.retailerName ?? '';
      mailingnameCntrl.text = data.mailingname ?? '';
      setSelectedConstitutionByName(data.constitutionname);
      setSelectedSegmentByName(data.segmentName);
      dateCntrl.text = data.incorporationDate ?? '';
      setSelectedGroupByName(data.partyGroupName);
      setSelectedPriceListByName(data.pricelist);
      contactNameCntrl.text = data.contactPerson ?? '';
      contactNumCntrl.text = data.contactNo ?? '';
      mobNumCntrl.text = data.partyMobNo ?? '';
      emailCntrl.text = data.email ?? '';
      if (cityList.isNotEmpty) {
        // Set city first
        selectedCity.value = cityList.firstWhereOrNull(
          (c) => c.name.trim() == data.city?.trim(),
        );

        // Filter areas for this city
        final filteredAreas = areaList
            .where((a) => a.cityId == selectedCity.value?.id)
            .toList();
        filteredAreaList.assignAll(filteredAreas);

        // Set selected area
        selectedArea.value = filteredAreaList.firstWhereOrNull(
          (a) => a.name.trim() == data.cityAreaName?.trim(),
        );

        // Filter localities for this area
        final filteredLocalities = localityList
            .where((l) => l.areaId == selectedArea.value?.id)
            .toList();
        filteredLocalityList.assignAll(filteredLocalities);

        // Set selected locality
        selectedLocality.value = filteredLocalityList.firstWhereOrNull(
          (l) => l.name.trim() == data.localityName?.trim(),
        );
      }
      setSelectedRefferedByName(data.influencerUserName);
      gstinCntrl.text = data.gstIn ?? '';
      panNumCntrl.text = data.panno ?? '';
      bbpsB2BIdCntrl.text = data.existingId ?? '';
      creditdaysCntrl.text = data.creditdays.toString();
      creditlimitCntrl.text = data.creditlimit.toString();
      remarkCntrl.text = data.remark ?? '';
      isBilled.value = data.isBilled == "Yes";
      selectedRating.value = int.tryParse(data.rating ?? '') ?? 0;

      partyId.value = data.partyId ?? '';
      selectedpartyType.value = data.partyType;
      partyGroupNameSelected.value = data.partyGroupName ?? '';
      partyGroupId.value = data.partygroup ?? '';
    } else {
      selectedpartyType.value = custGroup;
    }
  }

  // Manoj 23-02-2026 Add Get Master Data and Location Data
  static Future<CustomerMasterDataEntity> getMasterData() async {
    var masterDataUrl =
        '${ApiUrl.partyMasterGetUrl}company_id=${Utility.companyId}&db_nm=${Utility.sysDbName}';

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

  Future<bool> onBtnClickFun() async {
    if (nameCntrl.text == '') {
      // Manoj 23-02-2026 Comment bcoz scaffold messenger cannot seen when custom dialog is open
      //scaffoldMessageBar(Get.context!, '${custGroup} required');
      scaffoldMessageValidationBar(Get.context!, '$custGroup required');
      return false;
    } else if (selectedConstitution.value == null) {
      scaffoldMessageValidationBar(Get.context!, 'Constitution required');
      return false;
    } else if (selectedGroup.value == null) {
      scaffoldMessageValidationBar(Get.context!, 'Group required');
      return false;
    } else if (selectedRating.value == 0) {
      scaffoldMessageValidationBar(Get.context!, 'Rating required');
      return false;
    } else {
      return true;
    }
  }

  Future partyEditPostApi() async {
    bool isValid = await onBtnClickFun(); // simpler than then()

    if (!isValid) return; // stop if validation fails

    try {
      // Show loader
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      // Prepare payload
      PartyEntity partyentity = PartyEntity();
      //partyentity.partyId = partyId.value;
      //partyentity.distributorCode = Utility.companyId;
      partyentity.companyId = Utility.companyId;
      partyentity.retailerCode = partyId.value;
      partyentity.retailerName = nameCntrl.text.trim();
      partyentity.constitutionId = selectedConstitution.value?.categoryId
          ?.toString();
      partyentity.segmentId = selectedSegment.value?.categoryId?.toString();
      partyentity.partygroup = selectedGroup.value?.categoryId?.toString();
      partyentity.pricelist = selectedPriceList.value?.priceListName;
      partyentity.cityId = selectedCity.value?.id;
      partyentity.cityAreaId = selectedArea.value?.id;
      partyentity.localityId = selectedLocality.value?.id;
      partyentity.stateId = selectedCity.value?.stateId;
      partyentity.countryId = selectedCity.value?.id;
      partyentity.influencerUserId = selectedRefferedList.value?.companyId;
      partyentity.gstIn = gstinCntrl.text.trim();
      partyentity.remark = remarkCntrl.text.trim();
      partyentity.isBilled = isBilled.value ? "1" : "0";
      partyentity.rating = selectedRating.value.toString();
      partyentity.mailingname = mailingnameCntrl.text.trim();
      partyentity.contactPerson = contactNameCntrl.text.trim();
      partyentity.partyMobNo = mobNumCntrl.text.trim();
      partyentity.contactNo = contactNumCntrl.text.trim();
      partyentity.email = emailCntrl.text.trim();
      partyentity.panno = panNumCntrl.text.trim();
      partyentity.creditdays = creditdaysCntrl.text;
      partyentity.creditlimit = creditlimitCntrl.text;
      partyentity.existingId = bbpsB2BIdCntrl.text.trim();
      partyentity.incorporationDate = dateCntrl.text.trim();

      List<Map<String, dynamic>> partyEditListMap = [partyentity.toMap()];

      // Call API
      final response = await ApiCall.postPartyMasterApi(partyEditListMap);

      // Close loader
      if (Get.isDialogOpen ?? false) Get.back();

      // Parse JSON response
      String message;

      try {
        // Try parsing as JSON
        final Map<String, dynamic> resJson = json.decode(response);
        message = resJson['message'] ?? response.toString();
      } catch (e) {
        // If parsing fails, assume response is plain string
        message = response.toString();
      }

      // Handle response based on message
      if (message == 'Data Inserted Successfully') {
        Get.back();
        await Utility.showAlert(
          icons: Icons.check,
          iconcolor: Colors.green,
          title: 'Status',
          msg: 'Customer Added Successfully',
        );
        //Get.back();
        await setRowsEdit();
        Get.back(result: true);
      } else if (message == 'Customer already exist') {
        await Utility.showAlert(
          icons: Icons.close,
          iconcolor: Colors.red,
          title: 'Error',
          msg: 'Customer already exist',
        );
      } else {
        await Utility.showAlert(
          icons: Icons.close,
          iconcolor: Colors.red,
          title: 'Error',
          msg: 'Oops there is an error!',
        );
      }
    } catch (e) {
      await Utility.showAlert(
        icons: Icons.close,
        iconcolor: Colors.red,
        title: 'Error',
        msg: e.toString(),
      );
    }
  }
}
