import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/api/apicall.dart';
import 'package:sysconn_sfa/api/entity/buddy/outstanding/os_ageing_sum_entity.dart';
import 'package:trina_grid/trina_grid.dart';

class OutstandingPartyGroupLedgerController extends GetxController {
  final String? ageBy;
  final String? osType;
  OutstandingPartyGroupLedgerController({this.ageBy, this.osType});
  List xAxisData = [];
  List<int> yAxisData = [];

  // int isDataLoad = 0;
  var isDataLoad = 0.obs;
  List<OutstandingRecPayAgeSumEntity> outstandingRecPayDashboardDataList = [];
  RxInt touchedIndex = (-1).obs;
  var rows = <TrinaRow>[].obs;
  TrinaGridStateManager? stateManager;
  @override
  void onInit() {
    super.onInit();
    getOutstandingRecPayGroupLedgerDataAPI();
  }

  List<PieChartSectionData> showsections(int touchedIndex) {
    if (outstandingRecPayDashboardDataList.isEmpty) {
      return [
        PieChartSectionData(value: 1, color: Colors.white, title: 'No Data'),
      ];
    } else {
      return outstandingRecPayDashboardDataList
          .asMap()
          .map<int, PieChartSectionData>((index, osrecPayDatalist) {
            final employeeTouched = index == touchedIndex;
            final double radius = employeeTouched ? 60 : 40;
            final double convertedValue = double.parse(
              osrecPayDatalist.pENDINGAMOUNT.toString(),
            );
            final value = PieChartSectionData(
              showTitle: true,
              color: colordata[index],
              value: convertedValue,

              title: employeeTouched
                  ? '${osrecPayDatalist.nAME}: ${num.parse(convertedValue.toStringAsFixed(2))}'
                  : '${num.parse(convertedValue.toStringAsFixed(2))}',

              radius: radius,
              titleStyle: const TextStyle(
                color: Colors.black,
                fontWeight: FontWeight.bold,
              ), // kTxtStl10B,
            );
            return MapEntry(index, value);
          })
          .values
          .toList();
    }
  }

  List<Color> colordata = [
    const Color.fromARGB(255, 236, 53, 47),
    const Color.fromARGB(255, 230, 124, 37),
    const Color.fromARGB(248, 153, 26, 3),
    const Color.fromARGB(248, 236, 117, 48),
    const Color.fromARGB(248, 170, 172, 84),
    const Color.fromARGB(249, 252, 74, 4),
    const Color.fromARGB(250, 223, 142, 36),
    const Color.fromARGB(250, 194, 151, 59),
    const Color.fromARGB(248, 223, 241, 241),
    const Color.fromARGB(249, 105, 83, 81),
    const Color.fromARGB(249, 161, 95, 117),
    const Color.fromARGB(250, 221, 164, 7),
    const Color.fromARGB(249, 178, 210, 216),
    const Color.fromARGB(250, 216, 212, 3),
    const Color.fromRGBO(114, 128, 21, 5),
    const Color.fromARGB(250, 228, 139, 169),
    const Color.fromRGBO(129, 205, 77, 5),
    const Color.fromARGB(220, 110, 91, 89),
    const Color.fromARGB(250, 226, 92, 8),
    const Color.fromARGB(249, 230, 152, 50),
    const Color.fromARGB(250, 238, 240, 115),
    const Color.fromRGBO(124, 128, 21, 5),
    const Color.fromRGBO(133, 128, 56, 5),
    const Color.fromRGBO(179, 205, 77, 5),
  ];

  Future getOutstandingRecPayGroupLedgerDataAPI() async {
    isDataLoad.value = 0;
    rows.clear();

    await ApiCall.getOsRecPayLedgerDataAPI(
      ageby: ageBy!,
      subtype: osType!,
    ).then((saleseData) {
      if (saleseData.isNotEmpty) {
        outstandingRecPayDashboardDataList = saleseData;
        for (int i = 0; i < outstandingRecPayDashboardDataList.length; i++) {
          rows.addAll([
            TrinaRow(
              cells: {
                'name': TrinaCell(
                  value: outstandingRecPayDashboardDataList[i].nAME,
                ),
                'date': TrinaCell(
                  value:
                      outstandingRecPayDashboardDataList[i].nEXTFOLLOWUPDATE ==
                          null
                      ? ''
                      : outstandingRecPayDashboardDataList[i].nEXTFOLLOWUPDATE,
                ),
                'amount': TrinaCell(
                  value: Utility.dashAmtScaleSelected == 'Actuals'
                      ? outstandingRecPayDashboardDataList[i].pENDINGAMOUNT
                      : amtFormat(
                          value: outstandingRecPayDashboardDataList[i]
                              .pENDINGAMOUNT
                              .toString(),
                        ),
                ),
                'id': TrinaCell(
                  value: outstandingRecPayDashboardDataList[i].iD,
                ),
                'followup_type': TrinaCell(
                  value: outstandingRecPayDashboardDataList[i].followUpType,
                ),
              },
            ),
          ]);
        }
        isDataLoad.value = 1;
      } else {
        isDataLoad.value = 2;
      }
    });
    return isDataLoad.value;
  }
}
