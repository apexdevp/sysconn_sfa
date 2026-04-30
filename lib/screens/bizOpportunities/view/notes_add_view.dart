import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/api/entity/company/party_notes_response_entity.dart';
import 'package:sysconn_sfa/screens/bizOpportunities/controller/opportunities_deals_notes_controller.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class NotesAddScreen extends StatelessWidget {
  NotesAddScreen({super.key});

  final OpportunitiesDealsNotesController controller =
      Get.find<OpportunitiesDealsNotesController>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.grey.shade100,
      appBar: SfaCustomAppbar(
        title: 'Add Note',
        showDefaultActions: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// TITLE
            _label('Title *'),
            _textField(
              controller: controller.titleCntrl,
              hint: 'Enter Title',
            ),
            const SizedBox(height: 14),

            /// CATEGORY DROPDOWN
            _label('Category *'),
            Obx(
              () => _dropdown<PartyNotesCategoryEntity>(
                hint: 'Select Category',
                items: controller.notesCategoryList
                    .map((e) => DropdownMenuItem(
                          value: e,
                          child: Text(e.name ?? ''),
                        ))
                    .toList(),
                value: controller.selectedNotesCategory.value,
                onChanged: (v) =>
                    controller.selectedNotesCategory.value = v,
              ),
            ),
            const SizedBox(height: 14),

            /// DESCRIPTION
            _label('Description *'),
            _textField(
              controller: controller.descriptionCntrl,
              hint: 'Enter Description',
              maxLines: 5,
            ),
            const SizedBox(height: 24),

            /// SAVE BUTTON
            SizedBox(
              width: double.infinity,
              child: ElevatedButton(
                onPressed: () async {
                  await controller.customerNotesPostApi();
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.black,
                  padding: const EdgeInsets.symmetric(vertical: 14),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                child: const Text(
                  'Save Note',
                  style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _label(String text) => Padding(
        padding: const EdgeInsets.only(bottom: 6),
        child: Text(text,
            style: const TextStyle(
                fontSize: 13, fontWeight: FontWeight.w600)),
      );

  Widget _textField({
    required TextEditingController controller,
    required String hint,
    int maxLines = 1,
  }) {
    return TextField(
      controller: controller,
      maxLines: maxLines,
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(fontSize: 13, color: Colors.black38),
        contentPadding:
            const EdgeInsets.symmetric(horizontal: 12, vertical: 12),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8)),
        filled: true,
        fillColor: Colors.white,
      ),
    );
  }

  Widget _dropdown<T>({
    required String hint,
    required List<DropdownMenuItem<T>> items,
    required T? value,
    required void Function(T?) onChanged,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12),
      decoration: BoxDecoration(
        color: Colors.white,
        border: Border.all(color: Colors.grey.shade400),
        borderRadius: BorderRadius.circular(8),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          isExpanded: true,
          hint: Text(hint,
              style:
                  const TextStyle(fontSize: 13, color: Colors.black38)),
          value: value,
          items: items,
          onChanged: onChanged,
        ),
      ),
    );
  }
}