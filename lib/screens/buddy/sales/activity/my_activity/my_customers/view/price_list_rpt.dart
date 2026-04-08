import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/price_list_controller.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class PriceList extends StatelessWidget {
  const PriceList({super.key});

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    final controller = Get.put(PriceListController());
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Price List'),
      body: Obx(() {
        if (controller.isDataLoad.value == 0) {
          return const Center(child: CircularProgressIndicator());
        }

        if (controller.isDataLoad.value == 2) {
          return const Center(child: Text("No Data Found"));
        }

        return Column(
          children: [
            Expanded(
              child: SingleChildScrollView(
                child: DataTable(
                  dataRowMaxHeight: size.height * 0.09,
                  headingRowColor: WidgetStatePropertyAll(Colors.grey.shade100),
                  columns: [
                    DataColumn(label: Text('Stock Item', style: kTxtStl13B)),
                    DataColumn(
                      label: Text('Rate', style: kTxtStl13B),
                      numeric: true,
                    ),
                  ],
                  rows: controller.priceLevelList
                      .map(
                        ((i) => DataRow(
                          cells: <DataCell>[
                            DataCell(
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(i.itemname!, style: kTxtStl13N),
                                  Text(
                                    'Disc : ${i.discount.toString()}',
                                    style: kTxtStl13GreyN,
                                  ),
                                ],
                              ),
                            ),
                            DataCell(
                              Text(
                                i.pricelistrate.toString(),
                                style: kTxtStl13N,
                              ),
                            ),
                          ],
                        )),
                      )
                      .toList(),
                ),
              ),
            ),
          ],
        );
      }),
    );
  }
}
