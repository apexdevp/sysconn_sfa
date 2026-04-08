import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/image_list.dart';
import 'package:sysconn_sfa/Utility/report_menu.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/expenses/controllers/expenses_menu_controller.dart';
import 'package:sysconn_sfa/widgets/menuCard.dart';

class PosVanMenuView extends StatelessWidget {
  PosVanMenuView({super.key});

  final ExpensesMenuController controller = Get.put(ExpensesMenuController());

  Widget activityButtonRow(BuildContext context, Size size) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
        children: [
          MenuCardView(
            image: Image.asset(ImageList.posImage),
            title: 'POS Sale',
            function: () {},
          ),

          SizedBox(width: size.width * 0.02),
          MenuCardView(
            image: Image.asset(ImageList.deliverychallanImage),
            title: 'Delivery Challan',
            function: () {},
          ),
        ],
      ),
    );
  }

  Widget reportsTile(BuildContext context) {
    return Expanded(
      child: ListView(
        padding: const EdgeInsets.all(8),
        children: [
          ReportMenu(title: 'POS Sales/Register Summary', function: () {}),
          ReportMenu(title: 'POS Sales/Register Details', function: () {}),
        
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      // appBar: customAppbar(context: context, title: 'Expenses'),
      //AppBar(title: Text('Expenses'),),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.fromLTRB(16, 8, 16, 8),
          child: Obx(
            () => controller.isDataLoad.value == false
                ? Center(child: Utility.processLoadingWidget())
                : Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Row(
                        children: [
                          Text('Hello, ', style: kTxtStl17N),
                          Text(' ${Utility.companyName} !', style: kTxtStl17B),
                        ],
                      ),
                      SizedBox(height: size.height * 0.01),

                      //  Text(
                      //   '${DateFormat('d MMM yyyy,').format(DateTime.now())}  ${controller.timeString.value}',
                      //   style: kTxtStl14GreyN,
                      // ),
                      Row(
                        children: [
                          Text('Have a nice day !', style: kTxtStl14B),
                          SizedBox(width: size.width * 0.12),
                          Text(
                            '${DateFormat('d MMM yyyy').format(DateTime.now())} | ${controller.timeString.value}',
                            style: kTxtStl14GreyN,
                          ),
                        ],
                      ),
                      SizedBox(height: size.height * 0.03),
                      activityButtonRow(context, size),
                      SizedBox(height: size.height * 0.03),
                      reportsTile(context),
                    ],
                  ),
          ),
        ),
      ),
    );
  }
}
