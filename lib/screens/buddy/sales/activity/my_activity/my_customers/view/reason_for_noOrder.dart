import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/textFormField.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/reason_for_noOrder_controller.dart';
import 'package:sysconn_sfa/screens/drawer/drawer_view.dart';
import 'package:sysconn_sfa/widgets/responsive_button.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class ReasonForNoOrder extends StatelessWidget {
  final String? partyname;
  final String? partyid;
  final String? visitid;
   const ReasonForNoOrder({super.key,this.partyid,this.partyname,this.visitid});
   Container custReasonForNoOrderCon(Size size, int index, ReasonForNoOrderController controller) {
    return Container(
      decoration: BoxDecoration(
        border: Border(
          bottom: BorderSide(
            width: size.width * 0.001,
            color: Colors.grey,
          ),
        ),
      ),
      child: ListTile(
        title: Text( controller.noOrderListItem[index]['reason'],style: kTxtStl13B,),
        trailing: Switch(
          value:  controller.noOrderListItem[index]['value'],
          onChanged: (bool isOn) {
           controller.toggleSwitch(index, isOn);
          },
          activeThumbColor: Colors.orangeAccent,
          
        )
      ),
    );
  }


  @override
  Widget build(BuildContext context) {
    //  final controller = Get.put(
    //   ReasonForNoOrderController(
    //     // partyname: partyname,
    //     // partyid: partyid,
    //     // visitid: visitid,
    //   ),
    // );
        Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'Reason For No Order'),
      drawer: const DrawerForAll(),
      body: GetBuilder<ReasonForNoOrderController>(
          init: ReasonForNoOrderController(partyid: partyid,partyname: partyname,visitid: visitid),
        builder:  (controller) {
          return Padding(
            padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
            child: Column(
              children: [
                 Container(
                  width: size.width,
                  padding: EdgeInsets.all(8.0),
                  decoration: BoxDecoration(
                    // borderRadius: BorderRadius.only(
                    //   topLeft: Radius.circular(40.0),
                    //   topRight: Radius.circular(40.0)
                    //   ),
                    color: Colors.grey.shade300
                  ),
                  child: Text(
                  partyname!,
                  style: kTxtStlB,
                  textAlign: TextAlign.center,
                ),
             
                ),
               Expanded(
                  child: ListView(
                    children: [
                      Column(
                        children: [
                          Card(
                            child: Column(
                              children: [
                                custReasonForNoOrderCon(size, 0,controller),
                                custReasonForNoOrderCon(size, 1,controller),
                                custReasonForNoOrderCon(size, 2,controller),
                                custReasonForNoOrderCon(size, 3,controller),
                                custReasonForNoOrderCon(size, 4,controller),
                                custReasonForNoOrderCon(size, 5,controller),
                                custReasonForNoOrderCon(size, 6,controller),
                              ],
                            
                            ),
                          ),
                          SizedBox(
                            height: size.height * 0.02,
                          ),
                          Row(
                            children: [
                              CustomTextFormFieldView(
                                controller:controller.feedbackController,
                                title: 'Remark',
                              ),
                            ],
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                  ResponsiveButton(title: 'Submit',
              function: () {
               controller.sendReasonForNoOrder(context);
              },
            )
              ],
            ),
          );
        }
      ),
    );
  }
}
