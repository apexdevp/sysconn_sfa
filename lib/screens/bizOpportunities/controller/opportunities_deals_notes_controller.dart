import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/business_opportunity/opportunities_deals_rep_entity.dart';
import 'package:sysconn_sfa/api/entity/company/party_notes_response_entity.dart';

class OpportunitiesDealsNotesController extends GetxController {
  // ── Form ───────────────────────────────────────────────────
  final titleCntrl = TextEditingController();
  final descriptionCntrl = TextEditingController();

  // ── Notes data ─────────────────────────────────────────────
  final notesListData = <PartyNotesDetailsEntity>[].obs;
  final notesCategoryList = <PartyNotesCategoryEntity>[].obs;
  final selectedNotesCategory = Rxn<PartyNotesCategoryEntity>();
  var noteCategoryId = ''.obs;

  // ── Hidden fields ──────────────────────────────────────────
  var tallyRetailerCode = ''.obs;
  var type = ''.obs;
  var typeId = ''.obs;

  Rx<OpportunitiesDealsRepEntity> selectedOpportunity =
      OpportunitiesDealsRepEntity().obs;

  @override
  void onInit() {
    super.onInit();
    fetchNotesCategory();
  }

  // ── Initialize ─────────────────────────────────────────────

  void initialize(OpportunitiesDealsRepEntity? data) {
    if (data == null) return;
    selectedOpportunity.value = data;
    tallyRetailerCode.value = data.retailerCode ?? '';
    type.value = 'Business Opportunities';
    typeId.value = data.businessOpportunityId ?? '';
  }

  // ── Clear form ─────────────────────────────────────────────

  void clearAllFields() {
    noteCategoryId.value = '';
    selectedNotesCategory.value = null;
    titleCntrl.clear();
    descriptionCntrl.clear();
  }

  // ── Validation ─────────────────────────────────────────────

  Future<bool> validation() async {
    if (titleCntrl.text.trim().isEmpty) {
      Utility.showErrorSnackBar('Title required');
      return false;
    }
    if (selectedNotesCategory.value == null) {
      Utility.showErrorSnackBar('Category required');
      return false;
    }
    if (descriptionCntrl.text.trim().isEmpty) {
      Utility.showErrorSnackBar('Description required');
      return false;
    }
    return true;
  }

  // ── Fetch notes ────────────────────────────────────────────

  Future<void> fetchNotesCategory() async {
    try {
      final response = await ApiCall.getOpportunityNotesDetAPI(
        tallyRetailerCode.value,
      );

      notesCategoryList.value = response.category ?? [];

      final allNotes = response.notesdetails ?? [];
      notesListData.value = allNotes
          .where((e) => e.retailerCode == tallyRetailerCode.value)
          .toList();
    } catch (e) {
      debugPrint('ERROR FETCHING NOTES: $e');
    }
  }

  // ── Submit note ────────────────────────────────────────────

  Future<void> customerNotesPostApi() async {
    final isValid = await validation();
    if (!isValid) return;

    try {
      Get.dialog(
        const Center(child: CircularProgressIndicator()),
        barrierDismissible: false,
      );

      final entity = PartyNotesDetailsEntity();
      entity.companyId = Utility.companyId;
      entity.retailerCode = tallyRetailerCode.value;
      entity.noteId = noteCategoryId.value;
      entity.categoryId = selectedNotesCategory.value?.categoryId;
      entity.title = titleCntrl.text.trim();
      entity.description = descriptionCntrl.text.trim();
      entity.emailId = Utility.email;
      entity.type = type.value;
      entity.typeId = typeId.value;

      final response =
          await ApiCall.postCustomerNotesApi([entity.toMap()]);

      if (Get.isDialogOpen ?? false) Get.back();

      String message;
      try {
        message = json.decode(response)['message'] ?? response;
      } catch (_) {
        message = response.toString();
      }

      if (message == 'Data Inserted Successfully') {
        await Utility.showAlert(
          icons: Icons.check,
          iconcolor: Colors.green,
          title: 'Success',
          msg: 'Note Added Successfully',
        );
        await fetchNotesCategory();
        clearAllFields();
        Get.back(result: true);
      } else {
        await Utility.showAlert(
          icons: Icons.close,
          iconcolor: Colors.red,
          title: 'Error',
          msg: 'Oops there is an error!',
        );
      }
    } catch (e) {
      if (Get.isDialogOpen ?? false) Get.back();
      await Utility.showAlert(
        icons: Icons.close,
        iconcolor: Colors.red,
        title: 'Error',
        msg: e.toString(),
      );
    }
  }

  @override
  void onClose() {
    titleCntrl.dispose();
    descriptionCntrl.dispose();
    super.onClose();
  }
}