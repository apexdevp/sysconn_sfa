import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:google_maps_flutter/google_maps_flutter.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/sales/ledger_attribute_entity.dart';
import 'package:sysconn_sfa/api/entity/company/partyentity.dart';

class EditCustomerController extends GetxController {
  final String? partyid;
  final String? partyname;
  final String? latitudeOld;
  final String? longitudeOld;
  final String? custclassfication;

  EditCustomerController({
    this.partyid,
    this.partyname,
    this.custclassfication,
    this.latitudeOld,
    this.longitudeOld,
  });

  // Observable variables
  var latitude = ''.obs;
  var longitude = ''.obs;
  var currentAddress = ''.obs;
  var city = ''.obs;
  var currentPosition = LatLng(0, 0).obs;
  var isDataLoad = false.obs;
  // PartyEntity partyEntity = PartyEntity();
  var partyEntity = PartyEntity().obs;
  TextEditingController feedbackController = TextEditingController();

  // @override
  // void onInit() {
  //   super.onInit();
  //   callInitFun();
  // }

  @override
  void onReady() {
    super.onReady();
    callInitFun();
  }

  void callInitFun() async {
    await getCurrentLocation();
    await _getAddressFromLatLng();
    await getPartyDetailsApi();
    isDataLoad.value = true;
  }

  Future<void> getCurrentLocation() async {
    await Permission.location.request();
    var position = await GeolocatorPlatform.instance.getCurrentPosition(
      locationSettings: const LocationSettings(accuracy: LocationAccuracy.best),
    );
    latitude.value = position.latitude.toString();
    longitude.value = position.longitude.toString();
    scaffoldMessageValidationBar(
      Get.context!,
      'Address Captured',
      isError: false,
    );
    currentPosition.value = LatLng(position.latitude, position.longitude);
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      List<Placemark> p = await placemarkFromCoordinates(
        currentPosition.value.latitude,
        currentPosition.value.longitude,
      );
      Placemark place = p[0];
      currentAddress.value =
          "${place.postalCode} ${place.subLocality},${place.locality}, ${place.administrativeArea}, ${place.country}";
      city.value = place.locality ?? '';
    } catch (e) {
      print(e);
    }
  }

  /// Fetch party details from API
  Future<int> getPartyDetailsApi() async {
    try {
      PartyEntity? fetchedParty = await ApiCall.getPartyDetailsApi(
        partyid: partyid!,
      );
      if (fetchedParty != null) {
        // partyEntity = fetchedParty;
        partyEntity.value = fetchedParty;
      }
    } catch (e) {
      print("Error fetching party details: $e");
    }
    return 1;
  }

  void editCustomerPostCall() async {
    LedgerAttributeEntity ledgerAttributeEntity = LedgerAttributeEntity();
    ledgerAttributeEntity.companyId = Utility.companyId;
    ledgerAttributeEntity.partyId = partyid;
    ledgerAttributeEntity.latitude = latitude.value;
    ledgerAttributeEntity.longitude = longitude.value;
    ledgerAttributeEntity.locationCity = city.value;
    ledgerAttributeEntity.constitutionId = '1';
    ledgerAttributeEntity.isbilled = '1';
    ledgerAttributeEntity.rating = '1';
    List<Map<String, dynamic>> editList = [];
    editList.add(ledgerAttributeEntity.toJson());
    ApiCall.editCustomerLocationPostApiCall(partyid!, editList).then((
      value,
    ) async {
      Get.back();
      if (value == 'Data Saved Successfully' || value == 'No Row Affected') {
        Utility.showAlert(
          icons: Icons.check_circle_outline,
          iconcolor: Colors.green,
          title: 'Done',
          msg: 'Data Inserted Successfully!',
        ).then((value) {
          Get.back();
          // Navigator.pop(context, false);
        });
      } else {
        Utility.showAlert(
          icons: Icons.error_outline_outlined,
          iconcolor: Colors.red,
          title: 'Error',
          msg: 'Oops there is an error!',
        );
      }
    });
  }
}
