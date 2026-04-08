import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/beat_list_controller.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/beat_customer_list.dart';
import 'package:sysconn_sfa/screens/drawer/drawer_view.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class MyBeatList extends StatelessWidget {
  MyBeatList({super.key});
  final BeatListController controller = Get.put(BeatListController());
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: SfaCustomAppbar(title: 'My Customers'),
      drawer: const DrawerForAll(),
      body: Padding(
        padding: EdgeInsetsGeometry.fromLTRB(
          12,
          8,
          12,
          8,
        ), // const EdgeInsets.all(8.0),
        child: Column(
          children: [
            Card(
              elevation: 3.0,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(12.0),
                side: BorderSide(
                  color: Colors.grey, // Border color
                  width: 1.5, // Border width
                ),
              ),
              child: ListTile(
                title: Text('Quick Search', style: kTxtStl13B),
                trailing: Icon(Icons.search_outlined),
                onTap: () {
    
            Get.to(() =>  BeatCustomerList(filtertype: 'Party',id: '',));
                },
              ),
            ),

            // Card(
            //   elevation: 3,
            //   shape: RoundedRectangleBorder(
            //     borderRadius: BorderRadius.circular(12),
            //   ),
            //   child: Padding(
            //     padding: const EdgeInsets.symmetric(horizontal: 12),
            //     child: Obx(
            //       () => DropdownButtonHideUnderline(
            //         child: DropdownButton<String>(
            //           isExpanded: true,
            //           value: controller.selectedFilterId.value,
            //           items: controller.filterTypeItem.map((item) {
            //             return DropdownMenuItem<String>(
            //               value: item['id'],
            //               child: Text(item['name'] ?? '', style: kTxtStl13N),
            //             );
            //           }).toList(),
            //           onChanged: (value) {
            //             if (value != null) {
            //               controller.changeFilter(value);
            //             }
            //           },
            //         ),
            //       ),
            //     ),
            //   ),
            // ),
            Row(
              children: [
                Expanded(
                  // child: Card(
                  //   elevation: 3.0,
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(12.0),
                  //     side: BorderSide(
                  //       color: Colors.grey, // Border color
                  //       width: 1.5, // Border width
                  //     ),
                  //   ),
                  //   child: ListTile(
                  //     title: Text('Location', style: kTxtStl13B),
                  //     trailing: Icon(Icons.arrow_drop_down),
                  //     onTap: () {
                  //       // Navigator.of(context).push(MaterialPageRoute(builder: (context) => BeatCustomerList(filtertype: 'Party',id: '',)));
                  //     },
                  //   ),
                  // ),
                  child: Card(
                    elevation: 3,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                      side: BorderSide(
                        color: Colors.grey, // Border color
                        width: 1.5, // Border width
                      ),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(horizontal: 12),
                      child: Obx(
                        () => DropdownButtonHideUnderline(
                          child: DropdownButton<String>(
                            isExpanded: true,
                            value: controller.filterTypeIdSelected.value,
                            items: controller.filterTypeItem.map((item) {
                              return DropdownMenuItem<String>(
                                value: item['id'],
                                child: Text(
                                  item['name'] ?? '',
                                  style: kTxtStl13N,
                                ),
                              );
                            }).toList(),
                            onChanged: (value) {
                              if (value != null) {
                                controller.changeFilter(value);
                              }
                            },
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                SizedBox(width: size.width * 0.01),
                SizedBox(width: size.width * 0.15, child: Text('Active')),
                Obx(
                  () => Switch(
                    value: controller.statustag.value == '1',
                    activeThumbColor: kAppIconColor, // Colors.white,
                    onChanged: (bool value) {
                      controller.toggleStatus(value);
                    },
                  ),
                ),
              ],
            ),
            SizedBox(height: size.height * 0.01),
            Expanded(
              child: Obx(() {
                if (controller.isDataLoad.value == 0) {
                  return Center(child: Utility.processLoadingWidget());
                }
                

                if (controller.isDataLoad.value == 2) {
                  return const NoDataFound();
                }
                return ListView.builder(
                  itemCount: controller.beatListData.length,
                  itemBuilder: (context, i) {
                    final item = controller.beatListData[i];

                    return Column(
                      children: [
                        InkWell(
                          child: Padding(
                            padding: const EdgeInsets.all(6.0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // CircleAvatar(
                                //   radius: size.height * 0.02,
                                //   backgroundColor: Colors.grey.shade400,
                                //   child: Container(
                                //     height: size.height * 0.04,
                                //     width: size.width * 0.1,
                                //     padding: EdgeInsets.all(1.0),
                                //     child: Icon(Icons.person),
                                //   ),
                                // ),
                                // SizedBox(width: size.width * 0.02),
                                Expanded(
                                  child: Text(item.nAME!, style: kTxtStl13B),
                                ),
                                controller.filterTypeIdSelected.value != 'Group'?
                                Text(item.count!, style: kTxtStl13B):Container(),
                                Icon(
                                  Icons.chevron_right_sharp,
                                  color: kIconColor,
                                ),
                              ],
                            ),
                          ),
                          onTap: () {
                            Get.to(() => BeatCustomerList(id: item.iD,filtertype:controller.filterTypeIdSelected.value == 'Group'?controller.filterTypeIdSelected.value:controller.selectedFilterName,));
                          },
                        ),
                        Divider(
                          // height: 3,
                          color: kIconColor,
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
// https://sysconnoms-get.umedtallymis.com/Customer/BEATWISE_LIST/Get_Detail?company_id=211225225411003&status=1&filtertype=Area&db_nm=Sysconn_OMS