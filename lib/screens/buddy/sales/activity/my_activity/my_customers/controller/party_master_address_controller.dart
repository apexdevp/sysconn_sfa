import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:http/http.dart' as http;
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/api_url.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/company/customer_city_entity.dart';
import 'package:sysconn_sfa/api/entity/company/customer_master_data_entity.dart';
import 'package:sysconn_sfa/api/entity/company/party_address_entity.dart';

class AddressesController extends GetxController {
  PartyAddressEntity? addressData;
  var isDataLoad = 0.obs;
  RxList<PartyAddressEntity> partyAddressesListData =
      <PartyAddressEntity>[].obs;
  final isPrimaryEditable = true.obs;
  bool isEditMode = false;
  PartyAddressEntity? editData;
    var addressId = ''.obs;
  // Master List
  final countryList = <CountryEntity>[].obs;
  final stateList = <StateEntity>[].obs;
  final cityList = <CustomerCityEntity>[].obs;
  final areaList = <AreaEntity>[].obs;
  final localityList = <LocalityEntity>[].obs;

  // Selected values
  final selectedCountry = Rxn<CountryEntity>();
  final selectedState = Rxn<StateEntity>();
  final selectedCity = Rxn<CustomerCityEntity>();
  final selectedArea = Rxn<AreaEntity>();
  final selectedLocality = Rxn<LocalityEntity>();

  // Filtered child lists
  final filteredStateList = <StateEntity>[].obs;
  final filteredCityList = <CustomerCityEntity>[].obs;
  final filteredAreaList = <AreaEntity>[].obs;
  final filteredLocalityList = <LocalityEntity>[].obs;

  var pinCodeCntrl = TextEditingController();
  var address1Cntrl = TextEditingController();
  var address2Cntrl = TextEditingController();
  var geoCoordinatesCntrl = TextEditingController();

  final isLoading = false.obs;
  final _iconLoading = false.obs;
  bool get iconLoading => _iconLoading.value;
  var lat;
  var lng;

  final isPrimary = false.obs;

  void onSelectPrimary(bool value) {
    isPrimary.value = value;
  }

  String formatNumber(double value) {
    return value
        .toStringAsFixed(3) // 3 decimals (change if needed)
        .replaceAllMapped(
          RegExp(r'(\d)(?=(\d{3})+(?!\d))'),
          (match) => "${match[1]},",
        );
  }

  @override
  void onInit() {
    super.onInit();
    fetchMasterData();
    getCustomerAddressesData();
    if (addressData == null) {
      clearAllFields();
    }
  }

 void clearAllFields() {
    addressId.value = '';
    selectedCountry.value = null;
    selectedState.value = null;
    selectedCity.value = null;
    selectedArea.value = null;
    selectedLocality.value = null;
    pinCodeCntrl.clear();
    address1Cntrl.clear();
    address2Cntrl.clear();
    geoCoordinatesCntrl.clear();
    // isPrimary.value;
    isPrimary.value = false; 
  }

  Future setRowsEdit(PartyAddressEntity data) async {
   addressId.value = data.addressId ?? '';
    if (countryList.isEmpty) return;

    selectedCountry.value = countryList.firstWhereOrNull(
      (c) =>
          c.id == data.countryId || c.name.trim() == data.countryName?.trim(),
    );

    filteredStateList.assignAll(
      stateList.where((s) => s.countryId == selectedCountry.value?.id).toList(),
    );
    selectedState.value = filteredStateList.firstWhereOrNull(
      (s) => s.id == data.stateId || s.name.trim() == data.stateName?.trim(),
    );

    filteredCityList.assignAll(
      cityList.where((c) => c.stateId == selectedState.value?.id).toList(),
    );
    selectedCity.value = filteredCityList.firstWhereOrNull(
      (c) => c.id == data.cityId || c.name.trim() == data.cityName?.trim(),
    );

    filteredAreaList.assignAll(
      areaList.where((a) => a.cityId == selectedCity.value?.id).toList(),
    );
    selectedArea.value = filteredAreaList.firstWhereOrNull(
      (a) =>
          a.id == data.cityAreaId || a.name.trim() == data.cityAreaName?.trim(),
    );

    filteredLocalityList.assignAll(
      localityList.where((l) => l.areaId == selectedArea.value?.id).toList(),
    );
    selectedLocality.value = filteredLocalityList.firstWhereOrNull(
      (l) =>
          l.id == data.localityId || l.name.trim() == data.localityName?.trim(),
    );
    address1Cntrl.text = data.address1 ?? '';
    address2Cntrl.text = data.address2 ?? '';
    pinCodeCntrl.text = data.pinCode ?? '';
    geoCoordinatesCntrl.text =
        '${data.geoLatitude ?? ''} ${data.geoLongitude ?? ''}';
    isPrimary.value = data.isPrimary == "Yes";
  }

  Future<List<PartyAddressEntity>> getCustomerAddressesData() async {
    partyAddressesListData.clear();
    isDataLoad.value = 0;

    await ApiCall.getPartyAddressesDetAPI().then((customerDataList) {
      if (customerDataList.isNotEmpty) {
        partyAddressesListData.assignAll(customerDataList);
        isDataLoad.value = 1;
      } else {
        isDataLoad.value = 2;
      }
    });

    return partyAddressesListData;
  }

  Future<void> getCurrentLocation() async {
    try {
      _iconLoading(true);

      bool serviceEnabled = await Geolocator.isLocationServiceEnabled();

      if (!serviceEnabled) {
        _iconLoading(false);
        scaffoldMessageValidationBar(
          Get.context!,
          'Location services are disabled',
        );
        return;
      }

      LocationPermission permission = await Geolocator.checkPermission();

      if (permission == LocationPermission.denied) {
        permission = await Geolocator.requestPermission();
      }

      if (permission == LocationPermission.denied ||
          permission == LocationPermission.deniedForever) {
        _iconLoading(false);

        scaffoldMessageValidationBar(
          Get.context!,
          'Location permission denied',
        );
        return;
      }

      Position position = await Geolocator.getCurrentPosition(
        desiredAccuracy: LocationAccuracy.high,
      );

      lat = formatNumber(position.latitude);
      lng = formatNumber(position.longitude);

      geoCoordinatesCntrl.text = "$lat, $lng";

      update();
    } catch (e) {
      scaffoldMessageValidationBar(Get.context!, e.toString());
    } finally {
      _iconLoading(false);
    }
  }

  Future<void> fetchMasterData() async {
    try {
      isLoading.value = true;
      final data = await getMasterData();

      countryList.assignAll(data.countries);
      stateList.assignAll(data.states);
      cityList.assignAll(data.cities);
      areaList.assignAll(data.areas);
      localityList.assignAll(data.localities);

      if (isEditMode && editData != null) {
        populateDropdownsForEdit(editData!);
      }
      setupReactiveFilters();
    } catch (e) {
      print('Error fetching master data: $e');
    } finally {
      isLoading.value = false;
    }
  }

  void setupReactiveFilters() {
    ever(selectedCountry, (_) {
      if (!isEditMode) {
        filteredStateList.assignAll(
          stateList
              .where((s) => s.countryId == selectedCountry.value?.id)
              .toList(),
        );
        selectedState.value = null;
        selectedCity.value = null;
        selectedArea.value = null;
        selectedLocality.value = null;
        filteredCityList.clear();
        filteredAreaList.clear();
        filteredLocalityList.clear();
      }
    });

    ever(selectedState, (_) {
      if (!isEditMode) {
        filteredCityList.assignAll(
          cityList.where((c) => c.stateId == selectedState.value?.id).toList(),
        );
        selectedCity.value = null;
        selectedArea.value = null;
        selectedLocality.value = null;
        filteredAreaList.clear();
        filteredLocalityList.clear();
      }
    });
    ever(selectedCity, (_) {
      if (!isEditMode) {
        filteredAreaList.assignAll(
          areaList.where((a) => a.cityId == selectedCity.value?.id).toList(),
        );
        selectedArea.value = null;
        selectedLocality.value = null;
        filteredLocalityList.clear();
      }
    });

    ever(selectedArea, (_) {
      if (!isEditMode) {
        filteredLocalityList.assignAll(
          localityList
              .where((l) => l.areaId == selectedArea.value?.id)
              .toList(),
        );
        selectedLocality.value = null;
      }
    });
  }

  void populateDropdownsForEdit(PartyAddressEntity data) {
    isEditMode = true;

    // Country
    selectedCountry.value = countryList.firstWhereOrNull(
      (c) =>
          c.id == data.countryId || c.name.trim() == data.countryName?.trim(),
    );

    // State
    filteredStateList.assignAll(
      stateList.where((s) => s.countryId == selectedCountry.value?.id).toList(),
    );
    selectedState.value = filteredStateList.firstWhereOrNull(
      (s) => s.id == data.stateId || s.name.trim() == data.stateName?.trim(),
    );

    // City
    filteredCityList.assignAll(
      cityList.where((c) => c.stateId == selectedState.value?.id).toList(),
    );
    selectedCity.value = filteredCityList.firstWhereOrNull(
      (c) => c.id == data.cityId || c.name.trim() == data.cityName?.trim(),
    );

    // Area
    filteredAreaList.assignAll(
      areaList.where((a) => a.cityId == selectedCity.value?.id).toList(),
    );
    selectedArea.value = filteredAreaList.firstWhereOrNull(
      (a) =>
          a.id == data.cityAreaId || a.name.trim() == data.cityAreaName?.trim(),
    );

    // Locality
    filteredLocalityList.assignAll(
      localityList.where((l) => l.areaId == selectedArea.value?.id).toList(),
    );
    selectedLocality.value = filteredLocalityList.firstWhereOrNull(
      (l) =>
          l.id == data.localityId || l.name.trim() == data.localityName?.trim(),
    );

    isEditMode = false; // Done with initial edit population
  }

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
 Future<bool> validation() async {
    if (address1Cntrl.text == '') {
      scaffoldMessageValidationBar(Get.context!,'Address 1 required');
      return false;
    } else if (selectedCountry.value == null) {
      scaffoldMessageValidationBar(Get.context!,'Country required');
      return false;
    } else if (selectedState.value == null) {
      scaffoldMessageValidationBar(Get.context!,'State required');
      return false;
    } else if (selectedCity.value == null) {
      scaffoldMessageValidationBar(Get.context!,'City required');
      return false;
    } else if (selectedArea.value == null) {
      scaffoldMessageValidationBar(Get.context!,'Area required');
      return false;
    } else if (selectedLocality.value == null) {
      scaffoldMessageValidationBar(Get.context!,'Locality required');
      return false;
    } else if (address2Cntrl.text == '') {
      scaffoldMessageValidationBar(Get.context!,'Address 2 required');
      return false;
    } else if (pinCodeCntrl.text == '') {
      scaffoldMessageValidationBar(Get.context!,'Pin code required');
      return false;
    } else {
      return true;
    }
  }

  Future customerAddressesPostApi() async {
    bool isValid = await validation();

    if (!isValid) return;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      PartyAddressEntity partyAddressEntity = PartyAddressEntity();
      partyAddressEntity.companyId = Utility.companyId;
      partyAddressEntity.retailerCode = Utility.customerPersonaId;
      partyAddressEntity.addressId = addressId.value;
      
      if (isPrimary.value) {
        partyAddressEntity.isPrimary = "1";
        for (var address in partyAddressesListData) {
                    if (address.addressId != addressId.value) address.isPrimary = "0";
        }
      } else {
        // bool isEditingPrimary = rows.any(
        //   (r) =>
        //       r.cells['addressid']?.value == addressId.value &&
        //       r.cells['isprimary']?.value == "1",
        // );

                bool isEditingPrimary = partyAddressesListData.any(
          (r) => r.addressId == addressId.value && r.isPrimary == "1",);

        if (isEditingPrimary) {
          scaffoldMessageValidationBar(Get.context!,"At least one primary address required");
          return;
        }

        partyAddressEntity.isPrimary = "0";
      }
      partyAddressEntity.address1 = address1Cntrl.text.trim();
      partyAddressEntity.address2 = address2Cntrl.text.trim();
      partyAddressEntity.countryId = selectedCountry.value?.id;
      partyAddressEntity.stateId = selectedState.value?.id;
      partyAddressEntity.cityId = selectedCity.value?.id;
      partyAddressEntity.cityAreaId = selectedArea.value?.id;
      partyAddressEntity.localityId = selectedLocality.value?.id;
      partyAddressEntity.pinCode = pinCodeCntrl.text.trim();
      partyAddressEntity.geoLatitude = lat;
      partyAddressEntity.geoLongitude = lng;

      List<Map<String, dynamic>> addressesEditListMap = [
        partyAddressEntity.toMap(),
      ];

      // Call API
      final response = await ApiCall.postCustomerAddressApi(
        addressesEditListMap,
      );

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
        await Utility.showAlert(
          icons: Icons.check,
          iconcolor: Colors.green,
          title: 'Status',
          msg: 'Address Added Successfully',
        );
       Get.back();
        Get.back(); 
        getCustomerAddressesData();
        
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

  Future deleteCustomerAddresses(String? contactId) async {
    PartyAddressEntity deleteAddressEntity = PartyAddressEntity();

    deleteAddressEntity.addressId = contactId;
    deleteAddressEntity.companyId = Utility.companyId;

    List<Map<String, dynamic>> body = [deleteAddressEntity.toMap()];

    print('body $body');

    final response = await ApiCall.deleteCustomerAddressAPI(body);
    print('response $response');

    if (response.contains('Data Deleted Successfully')) {
      await Utility.showAlert(
        icons: Icons.check,
        iconcolor: Colors.green,
        title: 'Status',
        msg: 'Address Deleted Successfully',
      );
      Get.back();
      getCustomerAddressesData();
    } else {
      await Utility.showAlert(
        icons: Icons.close,
        iconcolor: Colors.red,
        title: 'Error',
        msg: 'Oops there is an error!',
      );
      return false;
    }
  }

}
