import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/sales_order_rpt/controller/sales_order_register_controller.dart';
import 'package:sysconn_sfa/widgets/calendarsingleview.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class SalesOrderRegister extends StatelessWidget {
  SalesOrderRegister({super.key});
  final SalesOrderRegisterController controller = Get.put(
    SalesOrderRegisterController(),
  );

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    // final controller = Get.put(SalesOrderRegisterController());
    return Scaffold(
      appBar: SfaCustomAppbar(
        title: 'Sales Order Register',
        bottom: PreferredSize(
          preferredSize: Size.fromHeight(60.0),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
               Obx(
                    () =>    CalendarSingleView(
                    fromDate: controller.fromDate.value,
                    toDate: controller.toDate.value,
                    function: () async {
                      await selectDateRange(
                        controller.fromDate.value,
                        controller.toDate.value,
                      ).then((dateTimeRange) {
                        controller.fromDate.value = dateTimeRange.start;
                        controller.toDate.value = dateTimeRange.end;
                      });
                      controller.getSalesOrderRegisterAPI();
                    },
                  )),
                ],
              ),
              SizedBox(height: size.height * 0.01),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          Expanded(
            child: Obx(() {
              if (controller.isDataLoad.value == 0) {
                return Center(
                  child: Platform.isIOS
                      ? CupertinoActivityIndicator()
                      : CircularProgressIndicator(),
                );
              }

              if (controller.isDataLoad.value == 2) {
                return Center(child: NoDataFound());
              }
              return ListView.builder(
                itemCount: controller.salesOrderRegisterValue.isEmpty
                    ? 0
                    : controller.salesOrderRegisterValue.length,
                itemBuilder: (context, i) {
                  final item = controller.salesOrderRegisterValue[i];
                  return InkWell(
                    child: Card(
                      elevation: 2,
                      child: Container(
                        padding: EdgeInsets.all(size.height * 0.01),
                        child: Row(
                          children: [
                            Expanded(
                              child: Column(
                                children: [
                                  Column(
                                    crossAxisAlignment:
                                        CrossAxisAlignment.stretch,
                                    children: [
                                      Text(item.partyName!, style: kTxtStl13B),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: size.width * 0.28, //0.25,
                                        child: Text(
                                          'Order No. ',
                                          style: kTxtStl13GreyN,
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          ': ',
                                          style: kTxtStl13GreyN,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item.invoiceNo!,
                                          style: kTxtStl13GreyN,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: size.width * 0.28, //0.25,
                                        child: Text(
                                          'Date ',
                                          style: kTxtStl13GreyN,
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          ': ',
                                          style: kTxtStl13GreyN,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          "${item.date == '' ? '' : DateFormat('dd-MM-yyyy').format(DateTime.parse(item.date!))}",
                                          style: kTxtStl13GreyN,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: size.width * 0.28, //0.25,
                                        child: Text(
                                          'Sales Person ',
                                          style: kTxtStl13GreyN,
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          ': ',
                                          style: kTxtStl13GreyN,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item.salesPerson!,
                                          style: kTxtStl13GreyN,
                                        ),
                                      ),
                                    ],
                                  ),
                                  Row(
                                    children: [
                                      Container(
                                        width: size.width * 0.28, //0.25,
                                        child: Text(
                                          'Quantity ',
                                          style: kTxtStl13GreyN,
                                        ),
                                      ),
                                      SizedBox(
                                        child: Text(
                                          ': ',
                                          style: kTxtStl13GreyN,
                                        ),
                                      ),
                                      Expanded(
                                        child: Text(
                                          item.quantity.toString(),
                                          style: kTxtStl13GreyN,
                                        ),
                                      ),
                                    ],
                                  ),

                                  // Row(
                                  //   children: [
                                  //     Container(
                                  //       width: size.width * 0.28,
                                  //       child: Text('User Remark ',style: kTxtStl13GreyN,),
                                  //     ),
                                  //     SizedBox(
                                  //       child: Text(': ',style: kTxtStl13GreyN,),
                                  //     ),
                                  //     Expanded(
                                  //       child: Text(item.narration!,style: kTxtStl13GreyN,)
                                  //     ),
                                  //   ],
                                  // ),
                                  // Row(
                                  //   children: [
                                  //     Container(
                                  //       width: size.width * 0.28,
                                  //       child: Text('Approver Remark',style: kTxtStl13GreyN,),
                                  //     ),
                                  //     SizedBox(
                                  //       child: Text(': ',style: kTxtStl13GreyN,),
                                  //     ),
                                  //     Expanded(
                                  //       child: Text(item.approvalRemark!,style: kTxtStl13GreyN,)
                                  //     ),
                                  //   ],
                                  // ),
                                ],
                              ),
                            ),
                            Column(
                              children: [
                                Text(indianRupeeFormat(double.parse(item.totalAmount!)),style: kTxtStl13B,),
                                SizedBox(height: size.height * 0.02),
                                // SizedBox(
                                //   width: size.width * 0.27,
                                //   child: widget.vchtype == 'Sales Order' && item.approver == Utility.cmpmobileno ?
                                //   ElevatedButton(
                                //     style: ElevatedButton.styleFrom(
                                //       backgroundColor: item.approvalStatus! == 'Approved'?
                                //       Colors.green.shade50: item.approvalStatus! == ''?
                                //       Theme.of(context).colorScheme.secondary: Colors.red.shade50,
                                //       shape: RoundedRectangleBorder(
                                //         borderRadius: BorderRadius.circular(10.0),
                                //       ),
                                //       elevation: 6.0
                                //     ),
                                //     onPressed: () async{
                                //       if(item.approvalStatus == 'Pending' ||
                                //      item.approvalStatus == '')
                                //       {
                                //         await approveStatusBtnFun(size, i).then((value) {
                                //           _getSalesOrderRegisterAPI();
                                //         });
                                //       }
                                //     },
                                //     child: Text(item.approvalStatus!,
                                //     style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,
                                //     color: item.approvalStatus! == 'Approved'? Colors.green: Colors.red),
                                //     textAlign: TextAlign.center,),
                                //   )
                                //   // komal // 10-4-2023 // status of so should display of all entries
                                //   :Container(
                                //     padding: EdgeInsets.all(8.0),
                                //     decoration: BoxDecoration(
                                //       color: Colors.grey.shade200,
                                //       borderRadius: BorderRadius.circular(10)
                                //     ),
                                //     child: Text(item.approvalStatus!,
                                //     style: TextStyle(fontSize: 13,fontWeight: FontWeight.w600,
                                //     color:item.approvalStatus! == 'Approved'? Colors.green: Colors.red.shade300),
                                //     textAlign: TextAlign.center,),
                                //   )
                                // ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                    onTap: () async {
                      // await Navigator.of(context).push(MaterialPageRoute(builder: (context) =>
                      // DeliveryEditReport(
                      //   uniqueId: salesOrderRegisterValue[i].uniqueId!,
                      //   mobileNo: salesOrderRegisterValue[i].mobileNo!,
                      //   vchtype: salesOrderRegisterValue[i].parent!,
                      //   isEditable: salesOrderRegisterValue[i].approvalStatus == 'Pending' || salesOrderRegisterValue[i].approvalStatus == ''?
                      //   true:false,)));
                      // _getSalesOrderRegisterAPI();
                    },
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
