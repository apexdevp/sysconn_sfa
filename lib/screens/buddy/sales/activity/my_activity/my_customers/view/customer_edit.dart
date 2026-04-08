import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/textFormField.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/company/customer_category_entity.dart';
import 'package:sysconn_sfa/api/entity/company/customer_city_entity.dart';
import 'package:sysconn_sfa/api/entity/company/customer_pricelist_entity.dart';
import 'package:sysconn_sfa/api/entity/company/customer_refferedby_entity.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/customer_edit_controller.dart';
import 'package:sysconn_sfa/widgets/dropdownlist.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class CustomerEdit extends StatelessWidget {
  final String? partyId;
  CustomerEdit({super.key, this.partyId});

  // final CustomerEditDetailsController controller = Get.put(
  //   CustomerEditDetailsController(initialPartyId: partyId),
  // );
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final controller = Get.put(
      CustomerEditDetailsController(initialPartyId: partyId),
    );
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Update Customer'),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: ListView(
                children: [
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.nameCntrl,
                        keyboardType: TextInputType.name,
                        title: 'Name',

                        enabled: controller.initialPartyId == null,
                        onChanged: (text) {
                          controller.mailingnameCntrl.text = text;
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.mailingnameCntrl,
                        keyboardType: TextInputType.name,
                        title: 'Mailing Name',
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(
                        () => DropdownCustomList<CustomerCategoryEntity>(
                          title: "Constitution",
                          hint: "Select Constitution",
                          isCompulsory: true,
                          items: controller.constitutionList
                              .map(
                                (item) =>
                                    DropdownMenuItem<CustomerCategoryEntity>(
                                      value: item,
                                      child: Text(item.name ?? ''),
                                    ),
                              )
                              .toList(),
                          value: controller.selectedConstitution.value,
                          onChanged: (value) {
                            controller.selectedConstitution.value = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(
                        () => DropdownCustomList<CustomerCategoryEntity>(
                          title: "Segment",
                          hint: "Select Segment",
                          items: controller.segmentList
                              .map(
                                (item) =>
                                    DropdownMenuItem<CustomerCategoryEntity>(
                                      value: item,
                                      child: Text(item.name ?? ''),
                                    ),
                              )
                              .toList(),
                          value: controller.selectedSegment.value,
                          onChanged: (value) {
                            controller.selectedSegment.value = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.dateCntrl,
                        title: 'Date of Incorporation',
                        onTap: () async {
                          final pickedDate = await showDatePicker(
                            context: context,
                            initialDate: DateTime.now(),
                            firstDate: DateTime(2020),
                            lastDate: DateTime(2100),
                          );
                          if (pickedDate != null) {
                            controller.dateCntrl.text = DateFormat(
                              'yyyy-MM-dd',
                            ).format(pickedDate);
                          }
                        },
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      Obx(
                        () => DropdownCustomList<CustomerCategoryEntity>(
                          title: "Group",
                          hint: "Select Group",
                          isCompulsory: true,
                          items: controller.groupList
                              .map(
                                (item) =>
                                    DropdownMenuItem<CustomerCategoryEntity>(
                                      value: item,
                                      child: Text(item.name ?? ''),
                                    ),
                              )
                              .toList(),
                          value: controller.selectedGroup.value,
                          onChanged: (value) {
                            controller.selectedGroup.value = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(
                        () => DropdownCustomList<CustomerPricelistEntity>(
                          title: "Price List",
                          hint: "Select Price List",
                          items: controller.priceList
                              .map(
                                (item) =>
                                    DropdownMenuItem<CustomerPricelistEntity>(
                                      value: item,
                                      child: Text(item.priceListName ?? ''),
                                    ),
                              )
                              .toList(),
                          value: controller.selectedPriceList.value,
                          onChanged: (value) {
                            controller.selectedPriceList.value = value;
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(
                        () => DropdownCustomList<CustomerCityEntity>(
                          title: "City",
                          hint: "Select City",
                          items: controller.cityList
                              .map(
                                (c) => DropdownMenuItem(
                                  value: c,
                                  child: Text(c.name),
                                ),
                              )
                              .toList(),
                          value: controller.selectedCity.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.filterAreaByCity(value.id);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(
                        () => DropdownCustomList<AreaEntity>(
                          title: "Area",
                          hint: "Select Area",
                          items: controller.filteredAreaList
                              .map(
                                (a) => DropdownMenuItem(
                                  value: a,
                                  child: Text(a.name),
                                ),
                              )
                              .toList(),
                          value: controller.selectedArea.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.filterLocalityByArea(value.id);
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(
                        () => DropdownCustomList<LocalityEntity>(
                          title: "Locality",
                          hint: "Select Locality",
                          items: controller.filteredLocalityList
                              .map(
                                (l) => DropdownMenuItem(
                                  value: l,
                                  child: Text(l.name),
                                ),
                              )
                              .toList(),
                          value: controller.selectedLocality.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedLocality.value = value;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Obx(
                        () => DropdownCustomList<CustomerRefferedbyEntity>(
                          title: "Reffered By",
                          hint: "Select Reffered By",
                          items: controller.refferedList
                              .map(
                                (item) =>
                                    DropdownMenuItem<CustomerRefferedbyEntity>(
                                      value: item,
                                      child: Text(item.companyName ?? ''),
                                    ),
                              )
                              .toList(),
                          value: controller.selectedRefferedList.value,
                          onChanged: (value) {
                            if (value != null) {
                              controller.selectedRefferedList.value = value;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.gstinCntrl,
                        keyboardType: TextInputType.text,
                        title: 'GST No.',
                        maxLength: 15,
                        countertext: true,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.panNumCntrl,
                        keyboardType: TextInputType.text,
                        title: 'Pan No.',
                        countertext: true,
                        maxLength: 10,
                      ),
                      SizedBox(width: size.width * 0.02),
                      CustomTextFormFieldView(
                        controller: controller.bbpsB2BIdCntrl,
                        title: 'Existing Id',
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.creditdaysCntrl,
                        keyboardType: TextInputType.text,
                        title: 'Credit Days',
                      ),
                      SizedBox(width: size.width * 0.02),
                      CustomTextFormFieldView(
                        controller: controller.creditlimitCntrl,
                        keyboardType: TextInputType.text,
                        title: 'Credit Limit',
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
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text('Is Billed', style: kTxtStl13N),
                            SizedBox(height: 8),
                            Obx(
                              () => Row(
                                children: [
                                  Transform.scale(
                                    scale: 0.9,
                                    child: Switch.adaptive(
                                      activeColor: Colors.orange,
                                      inactiveThumbColor: Colors.black,
                                      inactiveTrackColor: Colors.grey,
                                      value: controller.isBilled.value,
                                      onChanged: controller.onSelectBilled,
                                    ),
                                  ),
                                  const SizedBox(width: 8),
                                  Text(
                                    controller.isBilled.value ? "YES" : "NO",
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
                      ),

                      SizedBox(width: 15),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            RichText(
                              text: TextSpan(
                                text: 'Rating',
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
                            SizedBox(height: 8),
                            Obx(
                              () => Row(
                                children: List.generate(5, (index) {
                                  return GestureDetector(
                                    onTap: () {
                                      controller.onSelectRating(index + 1);
                                    },
                                    child: Icon(
                                      index < controller.selectedRating.value
                                          ? Icons.star
                                          : Icons.star_border,
                                      color: Colors.amber,
                                      size: 28,
                                    ),
                                  );
                                }),
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
            ResponsiveButton(
              title: 'Update',
              function: () async {
                Utility.showCircularLoadingWid(context);
                await controller.partyEditPostApi();
              },
            ),
          ],
        ),
      ),
    );
  }
}
