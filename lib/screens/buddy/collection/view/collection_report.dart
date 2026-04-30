import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/floating_point_action_button.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/collection/controller/collection_report_controller.dart';
import 'package:sysconn_sfa/screens/buddy/collection/view/collection_create.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class CollectionReport extends StatelessWidget {
  final String type;
  CollectionReport({super.key, required this.type});

  Row subtitleVoucherRow(String title, String value) {
    return Row(
      children: [
        Container(
          width: MediaQuery.of(Get.context!).size.width * 0.30,
          child: Text(
            title,
            style: TextStyle(fontSize: 13.0, fontWeight: FontWeight.bold),
          ),
        ),
        Text(': '),
        Expanded(child: Text(value, style: TextStyle(fontSize: 13.0))),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final CollectionReportController controller = Get.put(
      CollectionReportController(type),
    );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Collection Register'),
      floatingActionButton: FloatingButton(
        isExtended: false,
        icon: Icon(Icons.add),
        function: () async {
          await Get.to(() => CollectionCreate(vchType: type));
        },
      ),
      body: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 8.0),
            child: Container(
              width: size.width,
              height: size.height * 0.1,
              margin: EdgeInsets.fromLTRB(
                size.width * 0.1,
                0,
                size.width * 0.1,
                10,
              ),
              padding: EdgeInsets.all(9.0),
              decoration: BoxDecoration(
                borderRadius: BorderRadius.circular(14.0),
                color: Colors.grey.shade300,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [                  
                  Icon(
                    FontAwesomeIcons.indianRupeeSign,
                    size: size.height * 0.06,
                    color: Colors.orangeAccent,
                  ),
                  Column(
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    children: [
                      Text('Toal amount', style: kTxtStl13GreyN),
                      Obx(
                        () => Text(
                          '${indianRupeeFormat(controller.totalAmount.value)}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.w600,
                            color: Colors.orangeAccent,
                          ),
                          textAlign: TextAlign.center,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          Expanded(
            child: Obx(() {
              if (controller.isDataLoad.value == 0) {
                return Center(
                  child: Utility.processLoadingWidget()
                );
              }

              if (controller.isDataLoad.value == 2) {
                return Center(child: NoDataFound());
              }
              return ListView.builder(
                itemCount: controller.collectionDetailsList.length,
                itemBuilder: (context, i) {
                  final item = controller.collectionDetailsList[i];
                  return Card(
                    child: ListTile(
                      title: Text(item.invoiceno!, style: kTxtStl13B),
                      subtitle: Column(
                        children: [
                          subtitleVoucherRow('Voucher Name', item.vouchername!),
                          subtitleVoucherRow('Date', item.date!),
                        ],
                      ),
                      trailing: Text(
                        indianRupeeFormat(double.parse(item.totalammount!)),
                        style: kTxtStl13B,
                      ),
                      onTap: () {
                        Get.to(
                          () => CollectionCreate(
                            hedId: item.uniqueid,
                            vchType: type,
                          ),
                        );
                      },
                    ),
                  );
                },
              );
            }),
          ),
        ],
      ),
    );
  }
}
