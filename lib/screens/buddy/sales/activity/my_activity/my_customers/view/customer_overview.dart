import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/custome_dialogbox.dart';
import 'package:sysconn_sfa/Utility/textFormField.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/company/persona_entity.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/customer_view_controller.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/customer_edit.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class OverviewView extends StatelessWidget {
  const OverviewView({super.key});

  Expanded infoRow(String title, String value, {double? size}) {
    return Expanded(
      child: Row(
        children: [
          SizedBox(
            width: size,
            child: Text(title, style: kTxtStl13N),
          ),
          Text(': ', style: kTxtStl13N),
          Expanded(child: Text(value, style: kTxtStl13N)),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(OverviewController());
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Overview'),

      body: Obx(() {
        /// 🔄 Loading
        if (controller.isLoading.value) {
          return const Center(child: CircularProgressIndicator());
        }

        /// ❌ No Data
        if (controller.party.value == null) {
          return const Center(child: NoDataFound());
        }

        /// ✅ Main UI
        return Padding(
          padding: const EdgeInsets.all(8.0),
          child: ListView(
            children: [
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Assigned Customer', style: kTxtStl13B),
                          TextButton(
                            // onPressed: () {
                            //   Get.to(
                            //     () => CustomerEdit(
                            //       partyId: controller.party.value!.partyId,
                            //     ),
                            //   );
                            // },
                            onPressed: () async {
                              final result = await Get.to(
                                () => CustomerEdit(
                                  partyId: controller.party.value!.partyId,
                                ),
                              );

                              if (result == true) {
                                controller.fetchCustomerDetails();
                              }
                            },
                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFEF7A00),
                              ),
                            ),
                          ),
                        ],
                      ),

                      // SizedBox(height: size.height * 0.01),
                      Row(
                        children: [
                          infoRow(
                            'Rating',
                            '${controller.rating} ⭐',
                            size: size.width * 0.25,
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          infoRow(
                            "Constitution",
                            controller.constitution,
                            size: size.width * 0.25,
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          infoRow(
                            "Segment",
                            controller.segment,
                            size: size.width * 0.25,
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          infoRow(
                            "Date of Incorporation",
                            controller.incorporationDate,
                            size: size.width * 0.25,
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          infoRow(
                            "Referred By",
                            controller.referredBy,
                            size: size.width * 0.25,
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          infoRow(
                            "Is Billed",
                            controller.isBilled,
                            size: size.width * 0.25,
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          infoRow(
                            "GST No",
                            controller.gstNo,
                            size: size.width * 0.25,
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          infoRow(
                            "City",
                            controller.city,
                            size: size.width * 0.25,
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          infoRow(
                            "Area",
                            controller.area,
                            size: size.width * 0.25,
                          ),
                        ],
                      ),

                      Row(
                        children: [
                          infoRow(
                            "Locality",
                            controller.locality,
                            size: size.width * 0.25,
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ),
              Card(
                child: Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      /// Header
                      Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          Text('Company Profile', style: kTxtStl13B),
                          TextButton(
                            onPressed: () {
                              showcompanyeditDialog(controller);
                            },
                            child: const Text(
                              "Edit",
                              style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Color(0xFFEF7A00),
                              ),
                            ),
                          ),
                        ],
                      ),

                      SizedBox(height: size.height * 0.01),

                      /// 🔥 Dynamic Company Profile Fields
                      controller.companyProfileList.isEmpty
                          ? const Text("No Company Data")
                          : Column(
                              children: controller.companyProfileList.map((
                                item,
                              ) {
                                return Row(
                                  children: [
                                    infoRow(
                                      item.label ?? "",
                                      controller.getProfileValue(item.label),
                                      size: size.width * 0.4,
                                    ),
                                  ],
                                );
                              }).toList(),
                            ),
                    ],
                  ),
                ),
              ),

              personaCard(controller, size),
              remarkCard(controller),
            ],
          ),
        );
      }),
    );
  }

  Widget personaCard(OverviewController controller, Size size) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Obx(
          () => Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// Header
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text('Persona', style: kTxtStl13B),
                  TextButton(
                    onPressed: () {
                      controller.categoryTypeId.value = "4";
                      controller.allowedLevel.value = 2;
                      showPersonaDialog(controller);
                    },
                    child: const Text(
                      "Edit",
                      style: TextStyle(
                        fontWeight: FontWeight.w600,
                        color: Color(0xFFEF7A00),
                      ),
                    ),
                  ),
                ],
              ),

              SizedBox(height: size.height * 0.01),

              /// ❌ Empty State
              controller.selectedPersona.isEmpty
                  ? const Center(child: Text("No persona added yet!"))
                  /// ✅ Persona Data
                  : Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: controller.selectedPersona.entries.map((entry) {
                        if (entry.value.isEmpty) return const SizedBox();

                        return Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            /// Category Title
                            Text(entry.key, style: kTxtStl13N),

                            /// Chips
                            Wrap(
                              spacing: 4,
                              // runSpacing: 4,
                              children: entry.value.map((e) {
                                return Chip(
                                  label: Text(e, style: kTxtStl13N),
                                  backgroundColor: Colors.grey.shade200,
                                  shape: RoundedRectangleBorder(
                                    borderRadius: BorderRadius.circular(20),
                                  ),
                                );
                              }).toList(),
                            ),
                          ],
                        );
                      }).toList(),
                    ),
            ],
          ),
        ),
      ),
    );
  }

  Future<dynamic> showPersonaDialog(OverviewController controller) async {
    final isMobile = Get.width < 600;

    if (isMobile) {
      /// 📱 MOBILE → Bottom Sheet
      return Get.bottomSheet(
        Container(
          padding: const EdgeInsets.all(16),
          decoration: const BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.vertical(top: Radius.circular(16)),
          ),
          child: SafeArea(
            child: Column(
              children: [
                /// Header
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    const Text(
                      "Edit Persona",
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                    IconButton(
                      icon: const Icon(Icons.close),
                      onPressed: () => Get.back(),
                    ),
                  ],
                ),

                const SizedBox(height: 10),

                /// Scrollable Content
                Expanded(
                  child: Obx(
                    () => SingleChildScrollView(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          /// Add Persona Button
                          // Align(
                          //   alignment: Alignment.centerRight,
                          //   child: TextButton.icon(
                          //     onPressed: () async {
                          //       // await Get.to(
                          //       //   () => CustomerGroupReport(
                          //       //     categorytypeId:
                          //       //         controller.categoryTypeId.value,
                          //       //     allowedLevel: controller.allowedLevel.value
                          //       //         .toString(),
                          //       //   ),
                          //       // );

                          //       // await controller.fetchPersona(
                          //       //   controller.categoryTypeId.value,
                          //       // );
                          //     },
                          //     icon: const Icon(
                          //       Icons.add,
                          //       color: Color(0xFFEF7A00),
                          //     ),
                          //     label: const Text(
                          //       "Add Persona",
                          //       style: TextStyle(color: Color(0xFFEF7A00)),
                          //     ),
                          //   ),
                          // ),

                          // const SizedBox(height: 10),

                          ...controller.personacat
                              .where(
                                (p) =>
                                    p.subcategories != null &&
                                    p.subcategories!.isNotEmpty,
                              )
                              .map(
                                (persona) => Padding(
                                  padding: const EdgeInsets.only(bottom: 20),
                                  child: personaEditSection(
                                    persona,
                                    controller,
                                  ),
                                ),
                              ),
                        ],
                      ),
                    ),
                  ),
                ),

                ResponsiveButton(title: 'Update', function: ()async {
                     await controller.updatePersona();
                }),
              ],
            ),
          ),
        ),
        isScrollControlled: true,
      );
    } else {}
  }

  Widget remarkCard(OverviewController controller) {
    return Card(
      elevation: 2,
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Obx(() {
          final primaryContact = controller.contacts.isEmpty
              ? null
              : controller.contacts.firstWhere(
                  (c) => c.isPrimary == "Yes",
                  orElse: () => controller.contacts.first,
                );

          return Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              /// 🔹 Remark Title
              const Text(
                "Remark",
                style: TextStyle(fontSize: 15, fontWeight: FontWeight.w600),
              ),

              const SizedBox(height: 6),

              /// 🔹 Remark Text
              Text(
                (controller.party.value?.remark?.isNotEmpty ?? false)
                    ? controller.party.value!.remark!
                    : "N/A",
                style: kTxtStl13B,
              ),

              const SizedBox(height: 16),

              /// 🔹 Contact Row
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  SizedBox(
                    width: 100,
                    child: Text("Contacts", style: kTxtStl13N),
                  ),

                  Expanded(
                    child: primaryContact == null
                        ? const Text(
                            "No contacts available",
                            style: TextStyle(fontSize: 12, color: Colors.grey),
                          )
                        : Row(
                            children: [
                              Expanded(
                                child: Text(
                                  "${primaryContact.firstName ?? ''} ${primaryContact.lastName ?? ''} (${primaryContact.categoryName ?? ''})",
                                  style: kTxtStl13N,
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                              const SizedBox(width: 6),
                              const Icon(
                                Icons.phone,
                                size: 15,
                                color: Colors.orange,
                              ),
                              const SizedBox(width: 10),
                              const Icon(
                                Icons.email_outlined,
                                size: 15,
                                color: Colors.orange,
                              ),
                            ],
                          ),
                  ),
                ],
              ),

              const SizedBox(height: 12),

              /// 🔹 Address Section (your existing method)
              addressSection(controller),
            ],
          );
        }),
      ),
    );
  }

  Widget addressSection(OverviewController controller) {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        SizedBox(width: 100, child: Text("Address", style: kTxtStl13N)),
        Expanded(
          child: Obx(() {
            if (controller.addresses.isEmpty) {
              return Text("No Address Available", style: kTxtStl13N);
            }
            // final address = controller.addresses.first;
            final address = controller.addresses.firstWhere(
              (a) => a.isPrimary == "Yes",
              orElse: () => controller.addresses.first,
            );

            String fullAddress =
                [
                      address.address1,
                      address.address2,
                      address.localityName,
                      address.cityAreaName,
                      address.cityName,
                      address.stateName,
                      address.countryName,
                      address.pinCode,
                    ]
                    .where((e) => e != null && e.toString().trim().isNotEmpty)
                    .join(", ");

            return Text(fullAddress, style: kTxtStl13N);
          }),
        ),
      ],
    );
  }
  //  Future<dynamic> showPersonaDialog( OverviewController controller) async {
  //   return Get.dialog(
  //     CustomeDialogbox(
  //       maxHeight: 800,
  //       maxWidth: 900,
  //       minWidth: 600,
  //       buttontitle: 'Update',
  //       title: 'Edit Persona',
  //       function: () async {
  //         // await controller.updatePersona();
  //       },
  //       content: Obx(
  //         () => SingleChildScrollView(
  //           child: Column(
  //             crossAxisAlignment: CrossAxisAlignment.start,
  //             children: [
  //               Align(
  //                 alignment: Alignment.centerRight,
  //                 child: ElevatedButton.icon(
  //                   style: ElevatedButton.styleFrom(
  //                     backgroundColor: Colors.transparent,
  //                     shadowColor: Colors.transparent,
  //                     elevation: 0,
  //                   ),
  //                   onPressed: () async {
  //                   //   await Get.to(
  //                   //     () => CustomerGroupReport(
  //                   //       categorytypeId: controller.categoryTypeId.value,
  //                   //       allowedLevel: controller.allowedLevel.value
  //                   //           .toString(),
  //                   //     ),
  //                   //   );

  //                   //   await controller.fetchPersona(
  //                   //     controller.categoryTypeId.value,
  //                   //   );
  //                   },
  //                   icon: const Icon(
  //                     Icons.add,
  //                     size: 18,
  //                     color: Color(0xFFEF7A00),
  //                   ),
  //                   label: const Text(
  //                     "Add Persona",
  //                     style: TextStyle(
  //                       // color: Colors.black,
  //                       color: Color(0xFFEF7A00),
  //                       fontWeight: FontWeight.w600,
  //                     ),
  //                   ),
  //                 ),
  //               ),

  //               const SizedBox(height: 20),
  //               ...controller.personacat
  //                   .where(
  //                     (persona) =>
  //                         persona.subcategories != null &&
  //                         persona.subcategories!.isNotEmpty,
  //                   )
  //                   .map(
  //                     (persona) => Padding(
  //                       padding: const EdgeInsets.only(bottom: 25),
  //                       child: personaEditSection(persona,controller),
  //                     ),
  //                   ),
  //             ],
  //           ),
  //         ),
  //       ),
  //     ),
  //   );
  // }
  Widget personaEditSection(
    Personacategory persona,
    OverviewController controller,
  ) {
    String category = persona.categoryName ?? "";

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          category,
          style: const TextStyle(fontSize: 13, fontWeight: FontWeight.bold),
        ),

        const SizedBox(height: 10),

        Wrap(
          spacing: 6,
          runSpacing: 6,
          children: persona.subcategories!.map((sub) {
            return Obx(() {
              bool isSelected =
                  controller.selectedPersona[category]?.contains(
                    sub.subCategoryName,
                  ) ??
                  false;

              return ChoiceChip(
                label: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    if (isSelected)
                      const Icon(Icons.check, size: 16, color: Colors.black),
                    if (isSelected) const SizedBox(width: 4),

                    Text(
                      sub.subCategoryName ?? "",
                      style: TextStyle(
                        fontSize: 11,
                        // fontWeight: isSelected
                        //     ? FontWeight.w600
                        //     : FontWeight.normal,
                        // color: Colors.black,
                      ),
                    ),
                  ],
                ),

                selected: isSelected,

                backgroundColor: Colors.grey.shade100,
                selectedColor: Colors.orange.shade100,

                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(20),
                  side: BorderSide(color: Colors.grey.shade300, width: 0.6),
                ),

                showCheckmark: false,
                labelStyle: TextStyle(
                  color: Colors.black87,
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  fontSize: 11,
                ),

                onSelected: (_) {
                  controller.togglePersona(category, sub.subCategoryName ?? "");
                },
              );
            });
          }).toList(),
        ),
      ],
    );
  }

  Future<dynamic> showcompanyeditDialog(OverviewController controller) {
    return Get.dialog(
      AlertDialog(
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Edit Company Profile', style: kTxtStl16B),
            IconButton(
              padding: EdgeInsets.zero,
              iconSize: 19,
              onPressed: () => Get.back(),
              icon: Icon(Icons.close, color: Colors.red),
            ),
          ],
        ),
        content: SingleChildScrollView(
          child: Column(
            children: controller.companyProfileList.map((item) {
              String label = item.label ?? "";
              TextEditingController textController = controller
                  .getControllerByLabel(label);

              return Padding(
                padding: const EdgeInsets.only(bottom: 12),

                child: Row(
                  children: [
                    // Expanded(
                    //child:
                    CustomTextFormFieldView(
                      controller: textController,
                      title: label,
                    ),
                    // ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          ResponsiveButton(
            title: 'Update',
            function: () async {
              Utility.showCircularLoadingWid(Get.context!);
               await controller.updateCompanyProfile(); //Sakshi 20/03/2026
          Get.back();           },
          ),
        ],
      ),
      //  barrierDismissible: false,
    );
  }
}
