import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/floating_point_action_button.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/party_master_address_controller.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/part_master_address_add.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class PartyMasterAddresses extends StatelessWidget {
  PartyMasterAddresses({super.key});
  final AddressesController controller = Get.put(AddressesController());

  Expanded addressListTitleRow(String title, String value, {double? size}) {
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
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Address Details'),
      floatingActionButton: FloatingButton(
        isExtended: false,
        icon: Icon(Icons.add),
        function: () async {
          await Get.to(() => PartyMasterAddressAdd());
        },
      ),
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Expanded(
              child: Obx(() {
                if (controller.isDataLoad.value == 0) {
                  return Center(child: Utility.processLoadingWidget());
                }

                if (controller.isDataLoad.value == 2) {
                  return Center(child: const NoDataFound());
                }
                return ListView.builder(
                  itemCount: controller.partyAddressesListData.length,
                  itemBuilder: (context, i) {
                    final item = controller.partyAddressesListData[i];
                    return Column(
                      children: [
                        InkWell(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                mainAxisAlignment:
                                    MainAxisAlignment.spaceBetween,
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Expanded(
                                    child: Column(
                                      children: [
                                          if ((item.isPrimary ?? "No") != "Yes")
                                        Row( mainAxisAlignment: MainAxisAlignment.end,
                                          children: [ IconButton(
                                              onPressed: () {
                                                Utility.showAlertYesNo(
                                                  iconData: Icons
                                                      .check_circle_outline,
                                                  iconcolor: Colors.blueAccent,
                                                  title: 'Alert',
                                                  msg:
                                                    "Are you sure you want to delete ${item.address1} ?",
                                                  yesBtnFun: ()async {
                                                     await controller
                                                    .deleteCustomerAddresses(
                                                      item
                                                          .addressId,
                                                    );
                                                  },
                                                  noBtnFun: () {
                                                    Navigator.of(context).pop();
                                                  },
                                                );
                                              },
                                              icon: Icon(
                                                Icons.delete_forever,
                                                color: Colors.red,
                                                size: 19,
                                              ),
                                            ),],),
                                        Row(
                                          children: [
                                            addressListTitleRow(
                                              'Address1 ',
                                              item.address1!,
                                              size: size.width * 0.25,
                                            ),
                                           
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            addressListTitleRow(
                                              'Address2 ',
                                              item.address2!,
                                              size: size.width * 0.25,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            addressListTitleRow(
                                              'Country ',
                                              item.countryName!,
                                              size: size.width * 0.25,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            addressListTitleRow(
                                              'State ',
                                              item.stateName!,
                                              size: size.width * 0.25,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            addressListTitleRow(
                                              'City ',
                                              item.cityName!,
                                              size: size.width * 0.25,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            addressListTitleRow(
                                              'Area ',
                                              item.cityAreaName!,
                                              size: size.width * 0.25,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            addressListTitleRow(
                                              'Locality ',
                                              item.localityName!,
                                              size: size.width * 0.25,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            addressListTitleRow(
                                              'Pincode ',
                                              item.pinCode!,
                                              size: size.width * 0.25,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            addressListTitleRow(
                                              'Geo Latitude ',
                                              item.geoLatitude!,
                                              size: size.width * 0.25,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            addressListTitleRow(
                                              'Geo Longitude ',
                                              item.geoLongitude!,
                                              size: size.width * 0.25,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            addressListTitleRow(
                                              'Is Primary ',
                                              item.isPrimary!,
                                              size: size.width * 0.25,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            addressListTitleRow(
                                              'Updated At ',
                                              item.updatedAt!,
                                              size: size.width * 0.25,
                                            ),
                                          ],
                                        ),
                                      ],
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                          onTap: () async {
                            await Get.to(
                              () => PartyMasterAddressAdd(addressData: item),
                            );
                          },
                        ),
                      ],
                    );
                  },
                );
              }),
            ),
          ],
        ),
      ),
    );
  }
}
