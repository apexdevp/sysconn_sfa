import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/floating_point_action_button.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/party_master_contact_controller.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/party_master_contact_add.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class PartyMasterContacts extends StatelessWidget {
  PartyMasterContacts({super.key});
  final PartyMasterContactController controller = Get.put(
    PartyMasterContactController(),
  );
  Expanded contactListTitleRow(String title, String value, {double? size}) {
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
      appBar: SfaCustomAppbar(title: 'Contact Details'),
      floatingActionButton: FloatingButton(
        isExtended: false,
        icon: Icon(Icons.add),
        function: () async {
          await Get.to(() => PartyMasterContactAdd());
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
                  itemCount: controller.partyContactListData.length,
                  itemBuilder: (context, i) {
                    final item = controller.partyContactListData[i];
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
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item.categoryName!,
                                              style: kTxtStl13B,
                                            ),
                                            IconButton(
                                              onPressed: () {
                                                Utility.showAlertYesNo(
                                                  iconData: Icons
                                                      .check_circle_outline,
                                                  iconcolor: Colors.blueAccent,
                                                  title: 'Alert',
                                                  msg:
                                                      "Are you sure you want to delete ${item.firstName} ${item.lastName} ?",
                                                  yesBtnFun: () async {
                                                    await controller
                                                      .deleteCustomerContact(
                                                        item
                                                            .contactId,
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
                                            ),
                                          ],
                                        ),

                                        Row(
                                          children: [
                                            contactListTitleRow(
                                              'First Name ',
                                              item.firstName!,
                                              size: size.width * 0.35,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            contactListTitleRow(
                                              'Last Name ',
                                              item.lastName!,
                                              size: size.width * 0.35,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            contactListTitleRow(
                                              'Status ',
                                              item.status!,
                                              size: size.width * 0.35,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            contactListTitleRow(
                                              'Primary Email ',
                                              item.email1!,
                                              size: size.width * 0.35,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            contactListTitleRow(
                                              'Primary Contact ',
                                              item.contact1!,
                                              size: size.width * 0.35,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            contactListTitleRow(
                                              'Secondary Email ',
                                              item.email2!,
                                              size: size.width * 0.35,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            contactListTitleRow(
                                              'Secondary Contact ',
                                              item.contact2!,
                                              size: size.width * 0.35,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            contactListTitleRow(
                                              'IS Primary ',
                                              item.isPrimary!,
                                              size: size.width * 0.35,
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
                              () => PartyMasterContactAdd(contactData: item),
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
