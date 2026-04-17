import 'dart:math';

import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/entity/company/customer_city_entity.dart';
import 'package:sysconn_sfa/api/entity/company/party_address_entity.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/party_master_address_controller.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:sysconn_sfa/widgetscustome/custom_textfield.dart'
    show CustomTextFormFieldView;
import 'package:sysconn_sfa/widgetscustome/dropdowncontroller.dart'
    show DropdownCustomList;
import 'package:sysconn_sfa/widgetscustome/responsive_button.dart'
    show ResponsiveButton;

class PartyMasterAddressAdd extends StatelessWidget {
  final PartyAddressEntity? addressData;
  PartyMasterAddressAdd({super.key, this.addressData});

  final AddressesController controller = Get.put(AddressesController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (addressData != null) {
      controller.addressData = addressData; // pass object
      controller.setRowsEdit(addressData!); // fill UI
      controller.isPrimaryEditable.value = true;
    } else {
      // addressId.value = '';

      bool isFirst = controller.partyAddressesListData.isEmpty;

      if (isFirst) {
        controller.isPrimary.value = true;
        controller.isPrimaryEditable.value = false;
      } else {
        controller.isPrimary.value = false;
        controller.isPrimaryEditable.value = false;
      }
    }
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Address Add'),
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
                          () => DropdownCustomList<CountryEntity>(
                            title: "Country",
                            hint: "Select Country",
                            isCompulsory: true,
                            items: controller.countryList
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c.name),
                                  ),
                                )
                                .toList(),
                            selectedValue: controller.selectedCountry,
                            onChanged: (value) =>
                                controller.selectedCountry.value = value,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => DropdownCustomList<StateEntity>(
                            title: "State",
                            hint: "Select State",
                            isCompulsory: true,
                            items: controller.filteredStateList
                                .map(
                                  (c) => DropdownMenuItem(
                                    value: c,
                                    child: Text(c.name),
                                  ),
                                )
                                .toList(),
                            selectedValue: controller.selectedState,
                            onChanged: (value) =>
                                controller.selectedState.value = value,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => DropdownCustomList<CustomerCityEntity>(
                            title: "City",
                            hint: "Select City",
                            isCompulsory: true,
                            items: controller.filteredCityList
                                .map(
                                  (item) =>
                                      DropdownMenuItem<CustomerCityEntity>(
                                        value: item,
                                        child: Text(item.name),
                                      ),
                                )
                                .toList(),
                            selectedValue: controller.selectedCity,
                            onChanged: (value) =>
                                controller.selectedCity.value = value,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => DropdownCustomList<AreaEntity>(
                            title: "Area",
                            hint: "Select Area",
                            isCompulsory: true,
                            items: controller.filteredAreaList
                                .map(
                                  (item) => DropdownMenuItem<AreaEntity>(
                                    value: item,
                                    child: Text(item.name),
                                  ),
                                )
                                .toList(),
                            selectedValue: controller.selectedArea,
                            onChanged: (value) =>
                                controller.selectedArea.value = value,
                          ),
                        ),
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      Expanded(
                        child: Obx(
                          () => DropdownCustomList<LocalityEntity>(
                            title: "Locality",
                            hint: "Select Locality",
                            isCompulsory: true,
                            items: controller.filteredLocalityList
                                .map(
                                  (item) => DropdownMenuItem<LocalityEntity>(
                                    value: item,
                                    child: Text(item.name),
                                  ),
                                )
                                .toList(),
                            selectedValue: controller.selectedLocality,
                            onChanged: (value) =>
                                controller.selectedLocality.value = value,
                          ),
                        ),
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.pinCodeCntrl,
                        isCompulsory: true,
                        keyboardType: TextInputType.number,
                        title: 'Pin Code',

                        maxLength: 6,
                        countertext: true,
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.address1Cntrl,
                        keyboardType: TextInputType.text,
                        isCompulsory: true,
                        title: 'Address Line 1',
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.address2Cntrl,
                        keyboardType: TextInputType.text,
                        isCompulsory: true,
                        title: 'Address Line 2',
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      CustomTextFormFieldView(
                        controller: controller.geoCoordinatesCntrl,
                        keyboardType: TextInputType.text,
                        title: 'Geo Co-ordinates',
                      ),
                    ],
                  ),
                  SizedBox(height: size.height * 0.01),
                  Row(
                    children: [
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          RichText(
                            text: TextSpan(
                              text: 'Take Live Coordinates',
                              style: kTxtStl13N,
                            ),
                          ),
                          SizedBox(height: 2),
                          IconButton(
                            icon: controller.iconLoading == false
                                ? Icon(
                                    Icons.location_on_outlined,
                                    color: kcPrimary,
                                    size: 25,
                                  )
                                : Icon(
                                    Icons.refresh,
                                    color: Colors.black,
                                    size: 18,
                                  ),
                            tooltip: "Take Live Coordinates",
                            onPressed: () {
                              controller.getCurrentLocation();
                            },
                          ),
                        ],
                      ),
                      SizedBox(width: 40),
                      Column(
                        mainAxisSize: MainAxisSize.min,
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
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
                          SizedBox(height: 6),
                          Obx(
                            () => Row(
                              children: [
                                Transform.scale(
                                  scale: 0.9,

                                  child: Switch.adaptive(
                                    value: controller.isPrimary.value,
                                    onChanged:
                                        controller.isPrimaryEditable.value
                                        ? (value) {
                                            controller.onSelectPrimary(value);
                                          }
                                        : null,

                                    activeTrackColor: Colors.orangeAccent,
                                    inactiveTrackColor: Colors.grey.shade400,

                                    thumbColor:
                                        WidgetStateProperty.resolveWith<Color>((
                                          states,
                                        ) {
                                          if (states.contains(
                                            WidgetState.selected,
                                          )) {
                                            return Colors.orangeAccent;
                                          }
                                          return Colors.black;
                                        }),
                                  ),
                                ),
                                const SizedBox(width: 8),
                                Text(
                                  controller.isPrimary.value ? "YES" : "NO",
                                  style: kTxtStl12N,
                                ),
                              ],
                            ),
                          ),
                        ],
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
                title: addressData != null ? 'Update' : 'Save',
                function: () async {
                  Utility.showCircularLoadingWid(context);
                  await controller.customerAddressesPostApi();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
