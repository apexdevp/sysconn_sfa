import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:get/get_state_manager/src/simple/get_controllers.dart';
import 'package:sysconn_sfa/api/entity/buddy/customerdetailsentity.dart';
import 'package:sysconn_sfa/api/entity/buddy/visitAttendanceEntity.dart';
import 'package:sysconn_sfa/api/entity/company/partyentity.dart';

class CustomerDetailsController extends GetxController {
  final String? pARTYID;
  final String? pARTYNAME;
  final String? latitude;
  final String? longitude;
  final String? mobileNo;
  final String? priceLevel;
  final String? custclassfication;
  CustomerDetailsController({
    required this.pARTYID,
    required this.pARTYNAME,
    required this.latitude,
    required this.longitude,
    this.mobileNo,
    this.priceLevel,
    this.custclassfication,
  });
  var isLoggedIn = false.obs;

  // Location
  final Geolocator geolocator = Geolocator();
  Rx<Position?> currentPosition = Rx<Position?>(null);
  var currentAddress = "".obs;
  var latitudeStr = "".obs;
  var longitudeStr = "".obs;

  // Visit Info
  var checkedInTime = "".obs;
  var checkedOutTime = "".obs;
  var totalVisitHrs = "".obs;
  var visitid = "".obs;

  RxBool isLoading = true.obs;

  RxList<CustomerDetailGetEntity> customerDetailsData =
      <CustomerDetailGetEntity>[].obs;
TextEditingController designationController = TextEditingController();
  TextEditingController conpersonController = TextEditingController();
  TextEditingController mobileNoController = TextEditingController();
   TextEditingController remarkController = TextEditingController(); 
  PartyEntity partyMasterEntityData = PartyEntity();

  @override
  void onInit() {
    super.onInit();
    // if (pARTYID != null) {
    //   getCustomerDetailsAPIDet(pARTYID!);
    //   getVisitAttendanceDataApi(pARTYID!);
    // }
    // // isLoading.value = false;
    checkAllAPIDet();
  }

  Future<void> checkAllAPIDet() async {
    isLoading.value = true;
    try {
      await getCustomerDetailsAPIDet(pARTYID!);
      await getVisitAttendanceDataApi(pARTYID!);
      await getPartyDetailsApi(); // party master data call
 Utility.customerPersonaId = pARTYID!;//add for overview address tab api
      // if (Utility.isLocCompulsory) {
      await _getCurrentLocation(); // fetch address if location is compulsory
      // }
    } catch (e) {
      print("Error in: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> _getCurrentLocation() async {
    await Permission.location.request();

    try {
      Position position = await Geolocator.getCurrentPosition(
        locationSettings: const LocationSettings(
          accuracy: LocationAccuracy.bestForNavigation,
        ),
      );

      currentPosition.value = position;
      print('_currentPosition ${currentPosition.value}');
      await _getAddressFromLatLng();
    } catch (e) {
      print(e);
    }
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      if (currentPosition.value == null) return;

      List<Placemark> p = await placemarkFromCoordinates(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
      );

      Placemark place = p[0];

      var streets = p.reversed
          .map((placemark) => placemark.street)
          .where((street) => street != null);
      //     if (Utility.iscomlocationEnable) {
      //   currentAddress.value = streets.join(', ');
      //   currentAddress.value +=
      //       " ${p.reversed.last.subLocality}, ${p.reversed.last.postalCode}, ${p.reversed.last.administrativeArea}, ${p.reversed.last.country}";
      // } else {
      currentAddress.value =
          "${place.postalCode},${place.subLocality},${place.locality} ${place.administrativeArea} ${place.country}";
      // }

      latitudeStr.value = currentPosition.value!.latitude.toString();
      longitudeStr.value = currentPosition.value!.longitude.toString();
    } catch (e) {
      currentAddress.value = "Unknown Address";
      print(e);
    }
  }

  Future<void> getCustomerDetailsAPIDet(String partyid) async {
    isLoading.value = true;
    try {
      final customerDataList = await ApiCall.getCustomerDetails(partyid);
      if (customerDataList.isNotEmpty) {
        customerDetailsData.assignAll(customerDataList);
      }
    } catch (e) {
      print("Error fetching customer details: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future getVisitAttendanceDataApi(String partyid) async {
    try {
      await ApiCall.getVisitAttendance(partyid: partyid).then((
        visitDetailsValue,
      ) {
        if (visitDetailsValue.isNotEmpty) {
          VisitAttendanceEntity visitAttendanceEntity =
              VisitAttendanceEntity.fromJson(visitDetailsValue[0]);
          checkedInTime.value = visitAttendanceEntity.checkintime!;
          checkedOutTime.value = visitAttendanceEntity.checkouttime!;
          totalVisitHrs.value = visitAttendanceEntity.totalhrs!;
          visitid.value = visitAttendanceEntity.visitId!;
          isLoggedIn.value = visitAttendanceEntity.checkintime != ''
              ? visitAttendanceEntity.checkouttime == ''
                    ? true
                    : false
              : false;
          Utility.isVisitCheckIn = isLoggedIn.value;
        } else {
          isLoggedIn.value = false;
          Utility.isVisitCheckIn = isLoggedIn.value;
        }
      });
    } catch (ex) {
      print(ex);
    }
  }

  Future<int> getPartyDetailsApi() async {
    try {
      await ApiCall.getPartyDetailsApi(partyid: pARTYID!).then((partyEntity) {
        partyMasterEntityData = partyEntity!;
        conpersonController.text = partyEntity.contactPerson!;
        mobileNoController.text = partyEntity.partyMobNo!;
      });
    } catch (ex) {
      print(ex);
    }

    return 1;
  }

  Future<bool> checkValidBool() async {
    if (currentAddress.value == '') {
      scaffoldMessageValidationBar(Get.context!,'Location is not available');
      //  snackbarMessageBar('Location is not available', isError: true);
      return false;
    } else {
      return true;
    }
  }

  Future<bool> checkInPostCall() async {
    bool ok = await checkValidBool();
    if (!ok) return false;

    VisitAttendanceEntity visitAttendanceEntity = VisitAttendanceEntity();
    visitAttendanceEntity.companyId = Utility.companyId;
    visitAttendanceEntity.partyid = pARTYID;
    visitAttendanceEntity.checkinlocation = currentAddress.value;
    visitAttendanceEntity.inLatitude = latitudeStr.value;
    visitAttendanceEntity.inLongitude = longitudeStr.value;
    visitAttendanceEntity.customertype = 'Existing';
    visitAttendanceEntity.visittype = '';
    visitAttendanceEntity.partyname = pARTYNAME;
    visitAttendanceEntity.address = partyMasterEntityData.address1;
    visitAttendanceEntity.pincode = partyMasterEntityData.pinCode;
    visitAttendanceEntity.location = '';
    visitAttendanceEntity.partymobileno = mobileNoController.text;
    visitAttendanceEntity.emailid = partyMasterEntityData.email;
    visitAttendanceEntity.leadstatus = ''; //Snehal 11-1-2022
    visitAttendanceEntity.conPerson = conpersonController.text;
    visitAttendanceEntity.designation = designationController.text;
    visitAttendanceEntity.remark = remarkController.text;
   
    visitAttendanceEntity.address2 =  partyMasterEntityData.address2;
    visitAttendanceEntity.address3 =  partyMasterEntityData.city;//partyMasterEntityData.address3;
    visitAttendanceEntity.state = partyMasterEntityData.state;
    visitAttendanceEntity.gstno = partyMasterEntityData.gstIn;

    var response = await ApiCall.postvisitInAPI(visitAttendanceEntity);

    if (response['message'] == 'You Are Already Logged In') {
      Utility.showAlert(
        icons: Icons.error,
        iconcolor: Colors.orangeAccent,
        title: 'Alert',
        msg: 'You Are Already Logged In for ${response['partyname']}',
      );
    }  else if (response['message'] == "Visit Request Send Successfully") {
          checkedInTime.value = DateFormat('HH:mm:ss').format(DateTime.now());
          isLoggedIn.value = true;
          Utility.isVisitCheckIn = isLoggedIn.value;
          // visitid.value = response['visitId'];
          Utility.showAlert(icons:  Icons.check_circle_outline,iconcolor:  Colors.green,title:  'Done',msg:  'Logged In Successfully');
        } 
    else {
      await Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Oops there is an error.",
      );
    }

    return true;
  }

  Future<bool> checkOutPostCall() async {
    bool ok = await checkValidBool();
    if (!ok) return false;

   VisitAttendanceEntity visitAttendanceEntity = VisitAttendanceEntity();
      visitAttendanceEntity.checkoutlocation = currentAddress.value;
      visitAttendanceEntity.outLatitude = latitudeStr.value;
      visitAttendanceEntity.outLongitude = longitudeStr.value;
      visitAttendanceEntity.visittype = '';
      visitAttendanceEntity.partyname = pARTYNAME;
      visitAttendanceEntity.address = partyMasterEntityData.address1;
      visitAttendanceEntity.pincode = partyMasterEntityData.pinCode;
      visitAttendanceEntity.location = '';
      visitAttendanceEntity.conPerson = conpersonController.text;
      visitAttendanceEntity.designation = designationController.text;
      visitAttendanceEntity.emailid = partyMasterEntityData.email;
      visitAttendanceEntity.leadstatus = '';
      visitAttendanceEntity.partymobileno = mobileNoController.text; 
      visitAttendanceEntity.remark = remarkController.text; 
      visitAttendanceEntity.address2 = partyMasterEntityData.address2;
      visitAttendanceEntity.address3 = partyMasterEntityData.city;
      visitAttendanceEntity.state = partyMasterEntityData.state;
      visitAttendanceEntity.gstno = partyMasterEntityData.gstIn;

    var response = await ApiCall.postvisitOutPI(visitAttendanceEntity,visitid.value);

    if (response['message'] == 'Visit Closed Successfully') {
      checkedOutTime.value = DateFormat('HH:mm:ss').format(DateTime.now());
          totalVisitHrs.value = DateFormat('hh:mm:ss').parse(checkedOutTime.value).difference(DateFormat('hh:mm:ss').parse(checkedInTime.value)).toString()
          .split('.').first.padLeft(8, "0");
          isLoggedIn.value = false;
          Utility.isVisitCheckIn = isLoggedIn.value;
      Utility.showAlert(
        icons: Icons.check_circle_outline,
        iconcolor: Colors.green,
        title: 'Done',
        msg: 'Logged Out Successfully',
      );
    }   
    else {
      await Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Oops there is an error.",
      );
    }

    return true;
  }
}

 

  // Future<List<CustomerDetailGetEntity>> getCustomerDetailsAPIDet(
  //   String partyid,
  // ) async {
  //   customerDetailsData.clear();

  //   await ApiCall.getCustomerDetails(partyid).then((customerDataList) {
  //     if (customerDataList.isNotEmpty) {
  //       customerDetailsData.assignAll(customerDataList);
  //     }
  //   });

  //   return customerDetailsData;
  // }
// }
