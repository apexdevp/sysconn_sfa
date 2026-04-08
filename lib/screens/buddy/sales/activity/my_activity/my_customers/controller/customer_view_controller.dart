import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/company/categoty_type_enity.dart';
import 'package:sysconn_sfa/api/entity/company/company_profile_entity.dart';
import 'package:sysconn_sfa/api/entity/company/party_address_entity.dart';
import 'package:sysconn_sfa/api/entity/company/party_contact_entity.dart';
import 'package:sysconn_sfa/api/entity/company/party_designation_entity.dart';
import 'package:sysconn_sfa/api/entity/company/partyentity.dart';
import 'package:sysconn_sfa/api/entity/company/persona_entity.dart';

class OverviewController extends GetxController {
  Rxn<PartyEntity> party = Rxn<PartyEntity>();
  var isLoading = true.obs;
  var companyDataMap = <String, String>{}.obs;
  var companyProfileList = <CompanyProfileEntity>[].obs;
  Map<String, TextEditingController> dynamicControllers = {};

  RxMap<String, List<String>> selectedPersona = <String, List<String>>{}.obs;
  //For Persona
  RxList<Personacategory> personacat = <Personacategory>[].obs;
  RxString categoryTypeId = ''.obs;
  RxInt allowedLevel = 0.obs;
  RxList<PartyContactEntity> contacts = <PartyContactEntity>[].obs;
  RxList<PartyDesignationEntity> designations = <PartyDesignationEntity>[].obs;
  RxList<PartyAddressEntity> addresses = <PartyAddressEntity>[].obs;

  //   @override
  //   void onInit() {
  //     super.onInit();
  //     isLoading.value = true;
  //     categoryTypeId.value = "4";
  //     // final data = Get.arguments as PartyEntity?;
  //     // if (data != null) {
  //     //   party.value = data;
  //     //   Utility.customerPersonaId = data.partyId!;
  //     //   loadAllData();
  //     // }
  //     final partyId = Get.arguments as String?;

  //     if (partyId != null) {
  //       Utility.customerPersonaId = partyId;
  // fetchCustomerDetails();
  //       loadAllData();
  //     }

  //     isLoading.value = false;
  //   }

  @override
  void onInit() {
    super.onInit();
    // Get partyId from arguments
    final arg = Get.arguments;
    categoryTypeId.value = "4";
    if (arg != null && arg is String) {
      final partyId = arg;
      Utility.customerPersonaId = partyId;
      fetchData();
    } else {
      isLoading.value = false; // no data
    }
  }

  Future<void> fetchData() async {
    isLoading.value = true;

    try {
      await fetchCustomerDetails();
      await loadAllData();
    } catch (e) {
      print("Error fetching data: $e");
    } finally {
      isLoading.value = false;
    }
  }

  Future<void> fetchCustomerDetails() async {
    isLoading.value = true;

    try {
      final data = await ApiCall.getPartyDetCMPApi(
        partyId: Utility.customerPersonaId,
      );

      if (data.isNotEmpty) {
        party.value = data.first;
      }
    } catch (e) {
      print("Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  TextEditingController getControllerByLabel(String label) {
    String key = label.toLowerCase().trim();

    if (!dynamicControllers.containsKey(key)) {
      dynamicControllers[key] = TextEditingController(
        text: companyDataMap[key] ?? "",
      );
    }

    return dynamicControllers[key]!;
  }
  // void setPartyData(PartyEntity data) {
  //   if (party.value?.partyId == data.partyId) return;

  //   party.value = data;

  //   if (data.partyId != null) {
  //     // contacts.clear();
  //     // addresses.clear();
  //     // designations.clear();
  //     // personacat.clear();
  //     // selectedPersona.clear();

  //     Utility.customerPersonaId = data.partyId!;

  //     loadAllData();
  //   }
  // }

  Future<void> loadAllData() async {
    try {
      if (Utility.customerPersonaId.isEmpty) {
        debugPrint("customerPersonaId is empty");
        return;
      }

      isLoading.value = true;

      await Future.wait([
        getContacts(),
        getAddresses(),
        fetchPersona(categoryTypeId.value),
        getCompanyProfile(),
      ]);
    } catch (e) {
      debugPrint("Load All Error: $e");
    } finally {
      isLoading.value = false;
    }
  }

  String getValue(String? value) {
    if (value == null || value.trim().isEmpty) {
      return "N/A";
    }
    return value;
  }

  String get rating => getValue(party.value?.rating);
  String get constitution => getValue(party.value?.constitutionname);
  String get segment => getValue(party.value?.segmentName);
  String get incorporationDate => getValue(party.value?.incorporationDate);
  String get referredBy => getValue(party.value?.influencerUserName);
  String get isBilled => getValue(party.value?.isBilled);
  String get gstNo => getValue(party.value?.gstIn);
  String get city => getValue(party.value?.city);
  String get area => getValue(party.value?.cityAreaName);
  String get locality => getValue(party.value?.localityName);

  String getProfileValue(String? key) {
    if (key == null || key.trim().isEmpty) return "N/A";
    String value = companyDataMap[key.toLowerCase().trim()] ?? "";
    return value.isEmpty ? "N/A" : value;
  }

  String get totalEmployees => getProfileValue("Total Employees");
  String get salesTeam => getProfileValue("Sales Team");
  String get tallyUser => getProfileValue("Tally User");
  String get noOfYearBusiness => getProfileValue("No Of year Business");
  String get companyTurnover => getProfileValue("Company Turnover");
  String get tallySrNo => getProfileValue("Tally Sr No");
  String get sliver => getProfileValue("Silver");
  String get gold => getProfileValue("Gold");
  String get auditorVersion => getProfileValue("Auditor Version");

  Future<void> getCompanyProfile() async {
    try {
      companyDataMap.clear();
      companyProfileList.clear();
      dynamicControllers.clear();

      List<CompanyProfileEntity> response =
          await ApiCall.getCompanyProfileAPI();

      companyProfileList.assignAll(response);

      for (var item in response) {
        if (item.label != null) {
          companyDataMap[item.label!.toLowerCase().trim()] = item.value ?? "";
        }
      }
    } catch (e) {
      print("Error: $e");
    }
  }

  void togglePersona(String category, String sub) {
    selectedPersona.putIfAbsent(category, () => []);

    if (selectedPersona[category]!.contains(sub)) {
      selectedPersona[category]!.remove(sub);
    } else {
      selectedPersona[category]!.add(sub);
    }

    selectedPersona.refresh();
  }

  Future<void> fetchPersona(String categorytypeId) async {
    try {
      final response = await ApiCall.getCustCategoriesHierarchyAPI(
        categorytypeId: categorytypeId,
      );
      // print("CompanyId => ${Utility.companyId}");
      // print("RetailerCode => ${Utility.customerPersonaId}");

      List<CategoryTypeCategoryEntity> data = response;

      Map<String, Personacategory> categoryMap = {};

      for (var item in data) {
        if (item.categoriesid == null || item.categoriesid!.isEmpty) {
          categoryMap[item.categoryid!] = Personacategory(
            categoryName: item.name,
            subcategories: [],
          );
        }
      }

      for (var item in data) {
        if (item.categoriesid != null && item.categoriesid!.isNotEmpty) {
          if (categoryMap.containsKey(item.categoriesid)) {
            categoryMap[item.categoriesid]!.subcategories!.add(
              Subcategory(
                subCategoryName: item.name,
                subCategoryId: item.categoryid,
              ),
            );
          }
        }
      }

      personacat.assignAll(categoryMap.values.toList());

      final savedData = await ApiCall.getCustomerPersonaAPI(
        companyId: Utility.companyId,
        retailerCode: Utility.customerPersonaId,
      );
      // print("SAVED DATA => $savedData");
      // for (var p in savedData) {
      //   print("CATEGORY => ${p.categoryName}");
      //   print(
      //     "SUBS => ${p.subcategories?.map((e) => e.subCategoryName).toList()}",
      //   );
      // }

      selectedPersona.clear();

      for (var persona in savedData) {
        String categoryName = persona.categoryName ?? "";

        if (categoryName.isEmpty) continue;

        selectedPersona[categoryName] = persona.subcategories!
            .map((e) => e.subCategoryName ?? "")
            .where((e) => e.isNotEmpty)
            .toList();
      }
      selectedPersona.refresh();
    } catch (e) {
      debugPrint("Persona Fetch Error: $e");
    }
  }

  Future<void> getContacts() async {
    try {
      final response = await ApiCall.getPartyContactsDetAPI();
      contacts.assignAll(response.contacts);
      designations.assignAll(response.designations);
    } catch (e) {
      debugPrint("Contact API Error: $e");
    }
  }

  Future<void> getAddresses() async {
    try {
      final response = await ApiCall.getPartyAddressesDetAPI();
      addresses.assignAll(response);
    } catch (e) {
      debugPrint("Address API Error: $e");
    }
  }

  Future<void> updateCompanyProfile() async {
    try {
      List<Map<String, dynamic>> finalList = [];

      for (var item in companyProfileList) {
        String key = item.label?.toLowerCase().trim() ?? "";
        String value = dynamicControllers[key]?.text ?? "";

        finalList.add({
          "company_id": Utility.companyId,
          "party_id": Utility.customerPersonaId,
          "Customerfieldid": item.customerfieldid?.toString(),
          "customerattributeid": item.customerattributeid ?? "",
          "value": value,
        });
      }
      final body = {"data": finalList};

      String message = await ApiCall.updateCompanyProfileAPI(body: body);

      if (message == 'Data Inserted Successfully') {
        await Utility.showAlert(
          icons: Icons.check,
          iconcolor: Colors.green,
          title: 'Status',
          msg: 'Company Profile Updated Successfully',
        );

        await getCompanyProfile();
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
      debugPrint("Update Error: $e");
    }
  }
   Future<void> updatePersona() async {
    try {
      List<String> selectedSubIds = [];

      for (var cat in personacat) {
        for (var sub in cat.subcategories!) {
          if (selectedPersona[cat.categoryName]?.contains(
                sub.subCategoryName,
              ) ??
              false) {
            selectedSubIds.add(sub.subCategoryId.toString());
          }
        }
      }

      final body = {
        "data": [
          {
            "company_id": Utility.companyId,
            "retailer_code": Utility.customerPersonaId,
            "subcategory_id": selectedSubIds.join(","),
          },
        ],
      };

      // print("BODY => $body");

      bool success = await ApiCall.saveCustomerPersonaAPI(body: body);

      if (!success) {
        scaffoldMessageValidationBar(Get.context!, "Failed to update persona");
        return;
      }

      await fetchPersona(categoryTypeId.value);

      Get.back();
    } catch (e) {
      debugPrint("Update Persona Error: $e");
    }
  }

}
