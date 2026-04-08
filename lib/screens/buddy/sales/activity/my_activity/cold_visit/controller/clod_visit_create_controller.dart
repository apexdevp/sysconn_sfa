import 'package:flutter/material.dart';
import 'package:geocoding/geocoding.dart';
import 'package:geolocator/geolocator.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/visitAttendanceEntity.dart';

class CreateColdVisitController extends GetxController {
  VisitAttendanceEntity? visitAttendanceList;
  RxList<VisitAttendanceEntity> custSearchList = <VisitAttendanceEntity>[].obs;
  RxInt iscustomerLoad = 0.obs;
  CreateColdVisitController({this.visitAttendanceList});
  RxBool isCustSearch = false.obs;
  RxBool isDataLoad = false.obs;
  RxBool isLoggedIn = false.obs;
  RxBool isInactive = false.obs;
  RxString checkedInTime = ''.obs;
  RxString checkedOutTime = ''.obs;
  RxString totalVisitHrs = ''.obs;
  RxString latitude = ''.obs;
  RxString longitude = ''.obs;
  RxString currentAddress = ''.obs;
  Rx<Position?> currentPosition = Rx<Position?>(null);
  var visitid = "".obs;
  final searchCustController = TextEditingController();
  final customerNameController = TextEditingController();
  final pincodeController = TextEditingController();
  final addressController = TextEditingController();
  final locationController = TextEditingController();
  final mobileNoController = TextEditingController();
  final emailController = TextEditingController();
  final conPersonController = TextEditingController();
  final designationController = TextEditingController();
  final remarkController = TextEditingController();
  final addressController2 = TextEditingController();
  final addressController3 = TextEditingController();
  final stateController = TextEditingController();
  final gstnoController = TextEditingController();
  RxString visitTypeSelected = 'New'.obs;
  RxnString leadStatusSelected = RxnString();
  RxList leadDetailsList = [].obs;
  // RxList custSearchList = [].obs;
  RxInt stateRebuild = 0.obs; // dummy observable to force rebuild

  @override
  void onInit() {
    super.onInit();
    checkApiDet();
  }

  // void checkApiDet() async {
  //   if ((visitAttendanceList == null || visitAttendanceList!.status == 'Open')
  //   //      &&
  //   // Utility.isLocCompulsory
  //   ) {
  //     resetControllers(); // Clear all fields
  //     await _getCurrentLocation();
  //   }

  //   if (visitAttendanceList != null) {
  //     await setRowsEdit().then((value) async {
  //       // await getLeadDetailsVisitApi().then((value) async {

  //       isInactive.value = visitAttendanceList!.status == 'Close';
  //       isDataLoad.value = true;

  //       // getCompanyDataAPI();
  //       // getSharedPref();
  //       // getLeadDetailsVisitApi();

  //       // });
  //     });
  //   } else {
  //     // leadStatusSelected.value = 'Visit';

  //     Utility.isVisitCheckIn = isLoggedIn.value;

  //     isInactive.value = visitAttendanceList != null
  //         ? visitAttendanceList!.status == 'Close'
  //         : false;
  //     isDataLoad.value = true;
  //   }
  // }

  void checkApiDet() async {
    //  await _getCurrentLocation();
    if (visitAttendanceList == null) {
      // NEW VISIT
      resetControllers(); // clear all fields
      // await _getCurrentLocation(); // get current GPS location
      isDataLoad.value = true;
    } else {
      // EXISTING VISIT (from report)
      await setRowsEdit();
      isInactive.value = visitAttendanceList!.status == 'Close';
      isDataLoad.value = true;
    }
    await _getCurrentLocation();
  }

  Future<void> _getCurrentLocation() async {
    await Permission.location.request();

    Position position = await Geolocator.getCurrentPosition(
      locationSettings: LocationSettings(
        accuracy: LocationAccuracy.bestForNavigation,
      ),
    );

    currentPosition.value = position;

    await _getAddressFromLatLng();
  }

  Future<void> _getAddressFromLatLng() async {
    try {
      if (currentPosition.value == null) return;
      List<Placemark> p = await placemarkFromCoordinates(
        currentPosition.value!.latitude,
        currentPosition.value!.longitude,
      );

      Placemark place = p[0];

      // if (Utility.iscomlocationEnable) {
      //   var streets = p.reversed
      //       .map((placemark) => placemark.street)
      //       .where((street) => street != null);

      //   currentAddress.value =
      //       streets.join(', ') +
      //       " ${p.reversed.last.subLocality}, ${p.reversed.last.postalCode}, ${p.reversed.last.administrativeArea}, ${p.reversed.last.country}";
      // } else {
      currentAddress.value =
          "${place.postalCode},${place.subLocality},${place.locality} ${place.administrativeArea} ${place.country}";
      // }

      latitude.value = currentPosition.value!.latitude.toString();
      longitude.value = currentPosition.value!.longitude.toString();
    } catch (e) {
      currentAddress.value = 'Unknown Address';
    }
  }

  Future setSearchCustRows(VisitAttendanceEntity visitAttendanceEntity) async {
    print(visitAttendanceEntity.toJson());
    customerNameController.text = visitAttendanceEntity.partyname!;
    addressController.text = visitAttendanceEntity.address!;
    addressController2.text = visitAttendanceEntity.address2!;
    addressController3.text = visitAttendanceEntity.address3!;
    stateController.text = visitAttendanceEntity.state!;
    gstnoController.text = visitAttendanceEntity.gstno!;
    pincodeController.text = visitAttendanceEntity.pincode!;
    locationController.text = visitAttendanceEntity.location!;
    conPersonController.text = visitAttendanceEntity.conPerson!;
    designationController.text = visitAttendanceEntity.designation!;
    mobileNoController.text = visitAttendanceEntity.partymobileno!;
    emailController.text = visitAttendanceEntity.emailid!;
    // trigger rebuild for state autocomplete
    stateRebuild.value++;
  }

  Future getSearchCustApi(String custSearchValue) async {
    iscustomerLoad.value = 0;
    custSearchList.clear();
    await ApiCall.getCustomerSearchDataAPI(searchvalue: custSearchValue).then((
      visitvalue,
    ) {
      if (visitvalue.isNotEmpty) {
        custSearchList.value = visitvalue;
        iscustomerLoad.value = 1;
      } else {
        iscustomerLoad.value = 2;
      }
    });
  }

  Future<Null> setRowsEdit() async {
    print(visitAttendanceList!.toJson());
    customerNameController.text = visitAttendanceList!.partyname!;
    addressController.text = visitAttendanceList!.address!;

    addressController2.text = visitAttendanceList!.address2!;
    addressController3.text = visitAttendanceList!.address3!;
    stateController.text = visitAttendanceList!.state!;
    gstnoController.text = visitAttendanceList!.gstno!;
    pincodeController.text = visitAttendanceList!.pincode!;
    locationController.text = visitAttendanceList!.location!;
    conPersonController.text = visitAttendanceList!.conPerson!;
    designationController.text = visitAttendanceList!.designation!;
    mobileNoController.text = visitAttendanceList!.partymobileno!;
    emailController.text = visitAttendanceList!.emailid!;
    // visitTypeSelected.value = visitAttendanceList!.visittype! == ''
    //     ? 'New'
    //     : visitAttendanceList!.visittype!;
    // leadStatusSelected.value = visitAttendanceList!.leadstatus!;
    checkedInTime.value = visitAttendanceList!.checkintime!;
    checkedOutTime.value = visitAttendanceList!.checkouttime!;
    totalVisitHrs.value = visitAttendanceList!.totalhrs!;
    visitid.value = visitAttendanceList!.visitId!;
    isLoggedIn.value = visitAttendanceList!.checkintime != ''
        ? visitAttendanceList!.checkouttime == ''
              ? true
              : false
        : false;
    Utility.isVisitCheckIn = isLoggedIn.value;
    remarkController.text = visitAttendanceList!.remark!;
  }

  Future<bool> validityBoolCheck() async {
    if (currentAddress.value == '' && Utility.isLocCompulsory) {
      scaffoldMessageValidationBar(Get.context!, 'Location is not available');
      return false;
    } else if (customerNameController.text == '') {
      scaffoldMessageValidationBar(Get.context!, 'Please enter customer name');
      return false;
    } else {
      return true;
    }
  }

  Future<bool> checkColdVisitInPostCall() async {
    bool ok = await validityBoolCheck();
    if (!ok) return false;
    VisitAttendanceEntity visitAttendanceEntity = VisitAttendanceEntity();
    visitAttendanceEntity.companyId = Utility.companyId;
    visitAttendanceEntity.customertype = 'Cold Visit';
    visitAttendanceEntity.visittype = ''; // visitTypeSelected;
    visitAttendanceEntity.partyname = customerNameController.text;
    visitAttendanceEntity.address = addressController.text;
    visitAttendanceEntity.pincode = pincodeController.text;
    visitAttendanceEntity.location = locationController.text;
    visitAttendanceEntity.conPerson = conPersonController.text;
    visitAttendanceEntity.designation = designationController.text;
    visitAttendanceEntity.emailid = emailController.text;
    visitAttendanceEntity.leadstatus = ''; //leadStatusSelected;
    visitAttendanceEntity.partymobileno = mobileNoController.text;
    visitAttendanceEntity.partyid = '';
    visitAttendanceEntity.checkinlocation = currentAddress.value;
    visitAttendanceEntity.inLatitude = latitude.value;
    visitAttendanceEntity.inLongitude = longitude.value;
    visitAttendanceEntity.remark = remarkController.text;
    visitAttendanceEntity.address2 = addressController2.text;
    visitAttendanceEntity.address3 = addressController3.text;
    visitAttendanceEntity.state = stateController.text;
    visitAttendanceEntity.gstno = gstnoController.text;
    var response = await ApiCall.postvisitInAPI(visitAttendanceEntity);

    if (response['message'] == 'You Are Already Logged In') {
      Utility.showAlert(
        icons: Icons.error,
        iconcolor: Colors.orangeAccent,
        title: 'Alert',
        msg: 'You Are Already Logged In for ${response['partyname']}',
      );
    } else if (response['message'] == "Visit Request Send Successfully") {
      checkedInTime.value = DateFormat('HH:mm:ss').format(DateTime.now());
      isLoggedIn.value = true;
      Utility.isVisitCheckIn = isLoggedIn.value;
      visitid.value = response['visitId'].toString();
      Utility.showAlert(
        icons: Icons.check_circle_outline,
        iconcolor: Colors.green,
        title: 'Done',
        msg: 'Logged In Successfully',
      );
    } else {
      await Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Oops there is an error.",
      );
    }

    return true;
  }

  Future<bool> checkColdVisitOutPostCall() async {
    // await _getCurrentLocation();
    bool ok = await validityBoolCheck();
    if (!ok) return false;
    VisitAttendanceEntity visitAttendanceEntity = VisitAttendanceEntity();
    visitAttendanceEntity.checkoutlocation = currentAddress.value;
    visitAttendanceEntity.outLatitude = latitude.value;
    visitAttendanceEntity.outLongitude = longitude.value;
    visitAttendanceEntity.visittype = ''; //visitTypeSelected;
    visitAttendanceEntity.partyname = customerNameController.text;
    visitAttendanceEntity.address = addressController.text;
    visitAttendanceEntity.pincode = pincodeController.text;
    visitAttendanceEntity.location = locationController.text;
    visitAttendanceEntity.conPerson = conPersonController.text;
    visitAttendanceEntity.designation = designationController.text;
    visitAttendanceEntity.emailid = emailController.text;
    visitAttendanceEntity.leadstatus = ''; // leadStatusSelected;
    visitAttendanceEntity.partymobileno = mobileNoController.text;
    visitAttendanceEntity.remark = remarkController.text;

    visitAttendanceEntity.address2 = addressController2.text;
    visitAttendanceEntity.address3 = addressController3.text;
    visitAttendanceEntity.state = stateController.text;
    visitAttendanceEntity.gstno = gstnoController.text;
    var response = await ApiCall.postvisitOutPI(
      visitAttendanceEntity,
      visitid.value,
    );
    Get.back();
    if (response['message'] == 'Visit Closed Successfully') {
      checkedOutTime.value = DateFormat('HH:mm:ss').format(DateTime.now());
      totalVisitHrs.value = DateFormat('hh:mm:ss')
          .parse(checkedOutTime.value)
          .difference(DateFormat('hh:mm:ss').parse(checkedInTime.value))
          .toString()
          .split('.')
          .first
          .padLeft(8, "0");
      isLoggedIn.value = false;
      Utility.isVisitCheckIn = isLoggedIn.value;
      Utility.showAlert(
        icons: Icons.check_circle_outline,
        iconcolor: Colors.green,
        title: 'Done',
        msg: 'Logged Out Successfully',
      );
    } else {
      await Utility.showAlert(
        icons: Icons.error_outline_outlined,
        iconcolor: Colors.redAccent,
        title: 'Alert',
        msg: "Oops there is an error.",
      );
    }

    return true;
  }

  void resetControllers() {
    customerNameController.clear();
    addressController.clear();
    addressController2.clear();
    addressController3.clear();
    stateController.clear();
    gstnoController.clear();
    pincodeController.clear();
    locationController.clear();
    conPersonController.clear();
    designationController.clear();
    mobileNoController.clear();
    emailController.clear();
    remarkController.clear();
    checkedInTime.value = '';
    checkedOutTime.value = '';
    totalVisitHrs.value = '';
    latitude.value = '';
    longitude.value = '';
    currentAddress.value = '';
    visitid.value = '';
    isLoggedIn.value = false;
    isInactive.value = false;
  }

  Future deleteHeaderDet() async {
    await ApiCall.visitDeletePostData(visitid: visitAttendanceList!.visitId!).then((response) async {
      if (response == 'Data Deleted Successfully') {
      } else {
        scaffoldMessageValidationBar(Get.context!, 'Opps there is an error!');
      }
    });
  }
}
