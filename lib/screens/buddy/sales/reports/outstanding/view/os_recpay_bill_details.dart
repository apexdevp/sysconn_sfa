import 'dart:io';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:intl/intl.dart';
import 'package:sysconn_sfa/Utility/floating_point_action_button.dart';
import 'package:sysconn_sfa/Utility/systemxs_global.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/outstanding/controller/os_recpay_bill_controller.dart';
import 'package:sysconn_sfa/screens/buddy/sales/reports/outstanding/view/payment_followup_list.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';
import 'package:url_launcher/url_launcher.dart';

class OutstandingRecPayBillDetails extends StatelessWidget {
  final String? partyId;
  final String? partyName;
  final String? type;
  final String? ageFilter;
  final String? osAgeBySelectedFilter;
  const OutstandingRecPayBillDetails({
    super.key,
    this.ageFilter,
    this.osAgeBySelectedFilter,
    this.partyId,
    this.partyName,
    this.type,
  });
  Column partyOSColumn(Size size, String maintitle, String subtitle) {
    return Column(
      children: [
        Container(
          padding: EdgeInsets.all(size.width * 0.01),
          width: size.width,
          height: size.height * 0.05,
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey),
              right: BorderSide(color: Colors.grey),
              left: maintitle.contains('Outstanding')
                  ? BorderSide(color: Colors.grey)
                  : BorderSide.none,
            ),
            color: Colors.lightBlue.shade50,
          ),
          child: Text(maintitle, style: kTxtStl12N),
        ),
        Container(
          padding: EdgeInsets.all(size.width * 0.01),
          decoration: BoxDecoration(
            border: Border(
              top: BorderSide(color: Colors.grey),
              bottom: BorderSide(color: Colors.grey),
              right: BorderSide(color: Colors.grey),
              left: maintitle.contains('Outstanding')
                  ? BorderSide(color: Colors.grey)
                  : BorderSide.none,
            ),
            color: Colors.lightBlue.shade50,
          ),
          width: size.width,
          child: Text(
            subtitle != '' ? num.parse(subtitle).toStringAsFixed(1) : subtitle,
            style: kTxtStl12B,
            textAlign: TextAlign.right,
          ),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final controller = Get.put(
      OutstandingRecPayBillDetailsController(
        ageFilter: ageFilter,
        osAgeBySelectedFilter: osAgeBySelectedFilter,
        partyid: partyId,
        partyname: partyName,
      ),
    );
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Bills',
      // showDefaultActions:false,
      actions: [ 
        //  IconButton(
        //             icon: Icon(Platform.isIOS?Icons.ios_share:Icons.share,color: Colors.white,    // FontAwesomeIcons.whatsapp    // komal // 26-2-2025 // whatsapp icon removed bcze it's plugin has been removed
        //             ),
        //             onPressed: () async{
        //               Utility.showCircularLoadingWid(context);  
        //               await ExportPDF.buildPDFForReceivableDetails(outrecpaybillwiseValue,'Outstanding ${widget.type}','Bills',
        //               widget.partyname!,bankName,accountNo,branch,ifscCode,true).then((value) async {
        //                 await shareFile().then((value){
        //                   Navigator.pop(context);
        //                 });
        //               });
        //             }),
               
                IconButton(
                    icon: Icon(
                      Icons.call,
                      color: Colors.white,
                    ),
                    tooltip: 'Make call',
                    onPressed: () async {
                      if (controller.contactNo.value != '') {
                        if (await canLaunchUrl(
                            Uri.parse('tel:+91 ${controller.contactNo.value}'))) {
                          await launchUrl(Uri.parse('tel:+91 ${controller.contactNo.value}'));
                        } else {
                          throw 'Could not launch tel:+91 ${controller.contactNo.value}';
                        }
                      }
                    },
                  )
              ,
          // IconButton(icon: Icon(Icons.mail,color: Colors.white,),   //snehal 6-03-2023 add email for attchment send
          // onPressed: () {
          //   ExportPDF.buildPDFForReceivableDetails(outrecpaybillwiseValue,'Outstanding ${widget.type}','Bills',
          //   widget.partyname!,bankName,accountNo,branch,ifscCode,true).then((value) => sendEmail());
          // })
         
         ],),
      floatingActionButton: 
      FloatingButton(title: 'Followup Details', icon: Icon(Icons.call,),function: (){
        
      Get.to(() => PaymentFollowupList(partyId: partyId));
      },),
      body: Obx(() =>Column(
        children: [
          Container(
            width: size.width,
            decoration: BoxDecoration(
              // borderRadius: BorderRadius.only(
              //   topLeft: Radius.circular(40.0),
              //   topRight: Radius.circular(40.0),
              // ),
              color: Colors.orange.shade50,
            ),
            padding: EdgeInsets.all(9.0),
            child: Column(
              children: [
                Text(partyName!, style: kTxtStlB, textAlign: TextAlign.center),
                 controller.emailId.value != ''
                            ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.email_outlined, color: Colors.grey),
                    SizedBox(width: size.width * 0.02),
                    Text(controller.emailId.value, style: kTxtStl12N),
                  ],
                )
                : Container(),
                  controller.contactNo.value != ''
                ?
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Icon(Icons.call, color: Colors.grey),
                    SizedBox(width: size.width * 0.02),
                    Text(controller.contactNo.value, style: kTxtStl12N),
                  ],
                )
                : Container(),
              ],
            ),
          ),
          
          Row(
            children: [
              Expanded(
                child: partyOSColumn(
                  size,
                  'Outstanding Amt',
                  // '11',
                  controller.outstandingAmount.toString(),
                ),
              ),
              Expanded(
                child: partyOSColumn(
                  size,
                  'Overdue Amt',

                  controller.overdueAmount.toString(),
                ),
              ),
              Expanded(
                child: partyOSColumn(
                  size,
                  'Credit Limits',

                  controller.creditLimit.toString(),
                ),
              ),
              Expanded(
                child: partyOSColumn(
                  size,
                  'Credit Days',

                  controller.creditDays.toString(),
                ),
              ),
            ],
          ),
          SizedBox(height: size.height * 0.01),
          Expanded(
            child: Obx(() {
              if (controller.isDataLoad.value == 0) {
                return Center(
                  child:Utility.processLoadingWidget()
                );
              }

              if (controller.isDataLoad.value == 2) {
                return Center(child: Text('No Data'));
              }
              return ListView.builder(
                itemCount: controller.outRecPayBillwiseValue.isEmpty
                    ? 0
                    : controller.outRecPayBillwiseValue.length,
                itemBuilder: (context, i) {
                  final item = controller.outRecPayBillwiseValue[i];
                  return Column(
                    children: [
                      ListTile(
                        leading: CircleAvatar(
                          radius: size.width * 0.06,
                          backgroundColor: Colors.green.shade50,
                          foregroundColor: Colors.green,
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Text('Days', style: kTxtStl12N),
                              Text(
                                osAgeBySelectedFilter == 'Invoice Date' &&
                                        item.billdate != ''
                                    ? (controller.osDate
                                              .difference(
                                                DateTime.parse(
                                                 item
                                                      .billdate
                                                      .toString(),
                                                ),
                                              )
                                              .inDays)
                                          .toString()
                                    : osAgeBySelectedFilter ==
                                              'Due Date' &&
                                        item.duedate !=
                                              ''
                                    ? (controller.osDate
                                              .difference(
                                                DateTime.parse(
                                               item
                                                      .duedate
                                                      .toString(),
                                                ),
                                              )
                                              .inDays)
                                          .toString()
                                    : '',
                                style: kTxtStl12N,
                              ),
                            ],
                          ),
                        ),
                        title: Row(
                          children: [
                            Text(
                              item.billno!,
                              style: kTxtStl13B,
                            ),

                            SizedBox(width: size.width * 0.02),
                          item.masterid != ''
                                ? Icon(
                                    Icons.check_circle_rounded,
                                    color: Colors.green,
                                    size: 15.0,
                                  )
                                : Container(),
                          ],
                        ),
                        subtitle: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                         item.billdate == ''
                                ? Text('Bill Date: ', style: kTxtStl13GreyN)
                                : Text(
                                    'Bill Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(item.billdate!))}',
                                    style: kTxtStl13GreyN,
                                  ),
                            item.duedate == ''
                                ? Text('Due Date: ', style: kTxtStl13GreyN)
                                : Text(
                                    'Due Date: ${DateFormat('dd-MM-yyyy').format(DateTime.parse(item.duedate!))}',
                                    style: kTxtStl13GreyN,
                                  ),
                          ],
                        ),
                        trailing: Text(
                          indianRupeeFormat(
                           item.pendingamount!,
                          ),
                          style: kTxtStl13B,
                        ),

                        onTap: () {
                          // if (item.masterid!.isNotEmpty) {
                          //   if (item.vchtype == 'Sales' ||
                          //     item.vchtype ==
                          //           'Credit Note' ||
                          //       item.vchtype ==
                          //           'Purchase' ||
                          //      item.vchtype ==
                          //           'Debit Note' //||
                          //           ) {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => SalesVoucherDashboard(
                              //       vouchertype:
                              //       item.vchtype,
                              //       masterid:
                              //           item.masterid,
                              //     ),
                              //   ),
                              // );
                            // } else {
                              // Navigator.of(context).push(
                              //   MaterialPageRoute(
                              //     builder: (context) => RecieptVoucherDashboard(
                              //       vouchertype:
                              //          item.vchtype,
                              //       masterid:
                              //           item.masterid,
                              //     ),
                              //   ),
                              // );
                            // }
                          // }
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
    ));
  }
}
