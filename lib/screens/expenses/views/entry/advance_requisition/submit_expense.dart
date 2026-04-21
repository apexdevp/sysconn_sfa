import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:get/get_core/src/get_main.dart';
import 'package:sysconn_sfa/Utility/image_list.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/widgets/custom_appbar.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class ExpenseAdvanceSubmitScreen extends StatelessWidget {
  // const ExpenseAdvanceSubmitScreen({super.key});
    const ExpenseAdvanceSubmitScreen({
    super.key,
    required this.title,
    required this.totalamount,
    required this.date,
  });

  final String title;
  final String totalamount;
  final String date;

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: _onwillpopPress,
      child: Scaffold(
        appBar: SfaCustomAppbar(title: 'Advance Request'),
        floatingActionButton: Padding(
          padding: EdgeInsets.fromLTRB(
            size.width * 0.15,
            0,
            size.width * 0.15,
            8,
          ),
          child: ResponsiveButton(
            title: 'Close',
            function: () async {
              Get.back();
              Get.back();
              Get.back();
            },
          ),
        ),
        floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
        body: Column(children: [Expanded(child: _expList(size))]),
      ),
    );
  }

  Widget _expList(Size size) {
    return ListView(
      padding: const EdgeInsets.all(16),
      children: [
        SizedBox(height: size.height * 0.04),
        Image.asset(ImageList.expSuccessImage,height: size.height * 0.12,width: size.width*0.12,),
    
        SizedBox(height: size.height * 0.03),
        Padding(
          padding: const EdgeInsets.fromLTRB(15, 20, 15, 20),
          child: Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              border: Border.all(color: Colors.grey.shade400),
              borderRadius: BorderRadius.circular(14),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Text(
                    '$title ',
                     style: kTxtStl17B),   
                ),
                Divider(color: Colors.grey.shade300),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                  
                    children: [
                      Text('Total Amount', style: kTxtStl12GreyN),
                      Text(
                        indianRupeeFormat(double.parse(
                          totalamount
                          )),
                        style: kTxtStl17B,
                      ),
                    ],
                  ),
                ),
                Divider(color: Colors.grey.shade300),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text('Transaction Date', style: kTxtStl12GreyN),
                      Text(
                        date, 
                      style: kTxtStl14N),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
        SizedBox(height: size.height * 0.05),
        Text(
          // 'submitted',
          '$title Submitted',
          style: kTxtStl17B,
          textAlign: TextAlign.center,
        ),
        SizedBox(height: size.height * 0.01),
        Text(  
          // 'Your has been submitted \n  and ready to be reviewed',
          'Your $title has been submitted \n  and ready to be reviewed',
          style: kTxtStl14GreyN,
          textAlign: TextAlign.center,
        ),
      ],
    );
  }
   void _onwillpopPress(bool didPop, Object? result) {
    if (didPop) return;

    Get.back();
    Get.back();
    Get.back();
  }
}
