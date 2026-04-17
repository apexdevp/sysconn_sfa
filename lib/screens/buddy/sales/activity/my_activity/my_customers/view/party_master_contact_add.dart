import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/company/party_contact_entity.dart';
import 'package:sysconn_sfa/api/entity/company/party_designation_entity.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/party_master_contact_controller.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart';
import 'package:sysconn_sfa/widgetscustome/dropdowncontroller.dart';


class PartyMasterContactAdd extends StatelessWidget {
  final PartyContactEntity? contactData;
  PartyMasterContactAdd({super.key, this.contactData});
  final PartyMasterContactController controller = Get.put(
    PartyMasterContactController(),
  );
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (contactData != null) {
      controller.contactData = contactData;
      controller.setRowsEdit(contactData!);
      controller.isPrimaryEditable.value = true; // editable when editing
    } else {
      // if(controller.contactId.value.isEmpty) {
      // controller.clearAllFields();}
      bool isFirst = controller.partyContactListData.isEmpty;
      if (isFirst) {
        controller.isPrimary.value = true;
        controller.isPrimaryEditable.value =
            false; // first contact is primary and cannot be deselected
      } else {
        controller.isPrimary.value = false;
        controller.isPrimaryEditable.value = true;
      }
    }
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Contact Add'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => DropdownCustomList<PartyDesignationEntity>(
                            title: "Job Title",
                            hint: "Select Job Title",
                            isCompulsory: true,
                            items: controller.jobTitleList
                                .map(
                                  (item) =>
                                      DropdownMenuItem<PartyDesignationEntity>(
                                        value: item,
                                        child: Text(item.name ?? ''),
                                      ),
                                )
                                .toList(),
                            selectedValue: controller.selectedJobTitle,
                            onChanged: (value) {
                              controller.selectedJobTitle.value = value;
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.firstNameCntrl,
                        keyboardType: TextInputType.name,
                        title: 'First Name',
                        isCompulsory: true,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.lastNameCntrl,
                        keyboardType: TextInputType.name,
                        title: 'Last Name',
                        isCompulsory: true,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.email1Cntrl,
                        keyboardType: TextInputType.emailAddress,
                        title: 'Email 1',
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.contact1Cntrl,
                        keyboardType: TextInputType.number,
                        title: 'Contact No. 1',

                        maxLength: 10,
                        countertext: true,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.email2Cntrl,
                        keyboardType: TextInputType.emailAddress,
                        title: 'Email 2',
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.contact2Cntrl,
                        keyboardType: TextInputType.number,
                        title: 'Contact No. 2',

                        maxLength: 10,
                        countertext: true,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.remarkCntrl,
                        keyboardType: TextInputType.text,
                        title: 'Remark',

                        maxLines: 5,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      const SizedBox(width: 8),
                      RichText(
                        text: TextSpan(
                          text: 'Is Primary',
                          style: kTxtStl13N,
                          children: [
                            TextSpan(
                              text: ' *',
                              style: TextStyle(
                                color: Colors.red,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          ],
                        ),
                      ),

                      const SizedBox(width: 10),
                      Obx(
                        () => Row(
                          children: [
                            Transform.scale(
                              scale: 0.9,
                              child: Switch.adaptive(
                                value: controller.isPrimary.value,
                                onChanged: controller.isPrimaryEditable.value
                                    ? (value) {
                                        controller.onSelectPrimary(value);
                                      }
                                    : null,
                                activeTrackColor: Colors.orange,
                                inactiveTrackColor: Colors.grey.shade400,
                                thumbColor:
                                    WidgetStateProperty.resolveWith<Color>((
                                      states,
                                    ) {
                                      if (states.contains(
                                        WidgetState.selected,
                                      )) {
                                        return Colors.orange;
                                      }
                                      return Colors.black;
                                    }),
                              ),
                            ),
                            const SizedBox(width: 8),
                            Text(
                              controller.isPrimary.value ? "YES" : "NO",
                              style: TextStyle(
                                fontSize: 12,
                                color: Colors.grey.shade600,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            Container(
               width: size.width * 0.6,
              padding: EdgeInsets.all(4),
              child: ResponsiveButton(
                title: contactData != null ? 'Update' : 'Save',
                function: () async {
                  Utility.showCircularLoadingWid(context);
                  await controller.customerContactPostApi();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
