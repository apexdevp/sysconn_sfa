import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/company/party_contact_entity.dart';
import 'package:sysconn_sfa/api/entity/company/party_designation_entity.dart';

class PartyMasterContactController extends GetxController {
  PartyContactEntity? contactData;
  var isDataLoad = 0.obs;
  var contactId = ''.obs;
  RxList<PartyContactEntity> partyContactListData = <PartyContactEntity>[].obs;
  var firstNameCntrl = TextEditingController();
  var lastNameCntrl = TextEditingController();
  var email1Cntrl = TextEditingController();
  var email2Cntrl = TextEditingController();
  var contact1Cntrl = TextEditingController();
  var contact2Cntrl = TextEditingController();
  var remarkCntrl = TextEditingController();
  final jobTitleList = <PartyDesignationEntity>[].obs;
  final selectedJobTitle = Rxn<PartyDesignationEntity>();
  final isPrimary = false.obs;
  final isPrimaryEditable = true.obs;

  @override
  void onInit() {
    super.onInit();
    getCustomerContactsData();
    if (contactData == null) {
      clearAllFields();
    }
  }

  void onSelectPrimary(bool value) {
    isPrimary.value = value;
  }

  Future<List<PartyContactEntity>> getCustomerContactsData() async {
    partyContactListData.clear();
    isDataLoad.value = 0;

    await ApiCall.getPartyContactsDetAPI().then((response) {
      jobTitleList.value = response.designations;
       // Fix: Re-map selectedJobTitle to the new instance in jobTitleList
    if (selectedJobTitle.value != null) {
      selectedJobTitle.value = jobTitleList.firstWhereOrNull(
        (e) => e.categoryId == selectedJobTitle.value?.categoryId,
      );
    }
      if (response.contacts.isNotEmpty) {
        partyContactListData.assignAll(response.contacts);
        isDataLoad.value = 1;
      } else {
        isDataLoad.value = 2;
      }
    });

    return partyContactListData;
  }

  void clearAllFields() {
    contactId.value = '';
    selectedJobTitle.value = null;
    firstNameCntrl.clear();
    lastNameCntrl.clear();
    email1Cntrl.clear();
    contact1Cntrl.clear();
    email2Cntrl.clear();
    contact2Cntrl.clear();
    remarkCntrl.clear();
    isPrimary.value = false;
  }

  Future setRowsEdit(PartyContactEntity data) async {
    contactId.value = data.contactId ?? '';
    selectedJobTitle.value = jobTitleList.firstWhereOrNull(
      (e) => e.categoryId == data.categoryId,
    );
    firstNameCntrl.text = data.firstName ?? '';
    lastNameCntrl.text = data.lastName ?? '';
    email1Cntrl.text = data.email1 ?? '';
    contact1Cntrl.text = data.contact1 ?? '';
    email2Cntrl.text = data.email2 ?? '';
    contact2Cntrl.text = data.contact2 ?? '';
    remarkCntrl.text = data.remark ?? '';
    isPrimary.value = data.isPrimary == "Yes";
    //}
  }

  Future<bool> validation() async {
    if (firstNameCntrl.text == '') {
      scaffoldMessageValidationBar(Get.context!, 'First name required');
      return false;
    } else if (selectedJobTitle.value == null) {
      scaffoldMessageValidationBar(Get.context!, 'Job title required');
      return false;
    } else if (lastNameCntrl.text == '') {
      scaffoldMessageValidationBar(Get.context!, 'Last name required');
      return false;
    } else {
      return true;
    }
  }

  Future customerContactPostApi() async {
    bool isValid = await validation();

    if (!isValid) return;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      PartyContactEntity partyContactEntity = PartyContactEntity();
      partyContactEntity.companyId = Utility.companyId;
      partyContactEntity.retailerCode = Utility.customerPersonaId;
      partyContactEntity.contactId = contactId.value;
      partyContactEntity.categoryId = selectedJobTitle.value?.categoryId;
      partyContactEntity.firstName = firstNameCntrl.text.trim();
      partyContactEntity.lastName = lastNameCntrl.text.trim();
      partyContactEntity.email1 = email1Cntrl.text.trim();
      partyContactEntity.contact1 = contact1Cntrl.text.trim();
      partyContactEntity.email2 = email2Cntrl.text.trim();
      partyContactEntity.contact2 = contact2Cntrl.text.trim();
      partyContactEntity.remark = remarkCntrl.text.trim();
      //Manisha C 28-03-2026 added
      if (isPrimary.value) {
        partyContactEntity.isPrimary = "1";
        // Reset other primary contacts
        for (var contact in partyContactListData) {
          if (contact.contactId != contactId.value) contact.isPrimary = "0";
        }
      } else {
        bool isEditingPrimary = partyContactListData.any(
          (r) => r.contactId == contactId.value && r.isPrimary == "1",
        );
        if (isEditingPrimary) {
          scaffoldMessageValidationBar(
            Get.context!,
            "At least one primary Contact required",
          );
          return;
        }

        partyContactEntity.isPrimary = "0";
      }

      List<Map<String, dynamic>> contactEditListMap = [
        partyContactEntity.toMap(),
      ];

      // Call API
      final response = await ApiCall.postCustomerContactApi(contactEditListMap);

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
         if (Get.isDialogOpen ?? false) Get.back();
        await Utility.showAlert(
          icons: Icons.check,
          iconcolor: Colors.green,
          title: 'Status',
          msg: 'Contact Added Successfully',
        );
      
        getCustomerContactsData();
          Get.back();
          Get.back();
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

   Future deleteCustomerContact(String? contactId) async {
    PartyContactEntity deletePartyContact = PartyContactEntity();

    deletePartyContact.contactId = contactId;
    deletePartyContact.companyId = Utility.companyId;

    List<Map<String, dynamic>> body = [deletePartyContact.toMap()];

    print('body $body');

    final response = await ApiCall.deleteCustomerContactAPI(body);
    print('response $response');

    if (response.contains('Data Deleted Successfully')) {
      await Utility.showAlert(
        icons: Icons.check,
        iconcolor: Colors.green,
        title: 'Status',
        msg: 'Contact Deleted Successfully',
      );
      // Get.back();
      getCustomerContactsData();
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

