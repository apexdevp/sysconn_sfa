import 'dart:io';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:get/get.dart';
import 'package:sysconn_sfa/Utility/app_colors.dart';
import 'package:sysconn_sfa/Utility/image_list.dart';
import 'package:sysconn_sfa/Utility/textstyles.dart';
import 'package:sysconn_sfa/Utility/utility.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/controller/beat_customer_list_controller.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/customer_details.dart';
import 'package:sysconn_sfa/screens/buddy/sales/activity/my_activity/my_customers/view/customer_location.dart';
import 'package:sysconn_sfa/screens/drawer/drawer_view.dart';
import 'package:sysconn_sfa/widgets/nodatafoundwidget.dart';
import 'package:sysconn_sfa/widgets/sfa_custom_appbar.dart';

class BeatCustomerList extends StatelessWidget {
  final String? id;
  final String? filtertype;
  BeatCustomerList({super.key, this.id, this.filtertype});

  Expanded retailerListTitleRow(String title, String value, {double? size}) {
    return Expanded(
      child: Row(
        children: [
          SizedBox(
            width: size,
            child: Text(title, style: kTxtStl13N),
          ),
          Text(': ', style: kTxtStl13GreyN),
          Expanded(child: Text(value, style: kTxtStl13N)),
        ],
      ),
    );
  }

  final BeatCustomerListController controller = Get.put(
    BeatCustomerListController(),
  );

  // onSearchTextChanged(String text) async {
  //   controller.searchResultOfParty.clear();
  //   if (text.isEmpty || text == '') {
  //     controller.isSearch.value = false;
  //     controller.getBeatListAPIDet(filtertype!, id!);

  //     return;
  //   }
  //   controller.customerListData.forEach((data) {
  //     if (data.pARTYNAME!.toLowerCase().contains(text.toLowerCase()) ||
  //         data.cONTACTNUMBER!.toLowerCase().contains(text.toLowerCase()))
  //       controller.searchResultOfParty.add(data);
  //   });

  //   controller.customerListData.value = controller.searchResultOfParty.toList();
  // }

  void _startSearch() {
    print("open search box");

    controller.isSearch.value = true;
  }

  onSearchTextChanged(String text) async {
    controller.searchResultOfParty.clear();

    if (text.isEmpty) {
      controller.isSearch.value = false;

      /// reload original list
      controller.getBeatListAPIDet(filtertype!, id!);
      return;
    }

    controller.isSearch.value = true;

    controller.customerListData.forEach((data) {
      if (data.pARTYNAME!.toLowerCase().contains(text.toLowerCase()) ||
          data.cONTACTNUMBER!.toLowerCase().contains(text.toLowerCase())) {
        controller.searchResultOfParty.add(data);
      }
    });

    /// update UI safely
    controller.customerListData.assignAll(controller.searchResultOfParty);
  }

  List<Widget> _buildActions() {
    if (controller.isSearch.value) {
      return <Widget>[
        IconButton(
          icon: const Icon(Icons.clear),
          onPressed: () {
            controller.searchController.clear();
            onSearchTextChanged('');
            return;
          },
        ),
      ];
    }
    return <Widget>[
      IconButton(icon: Icon(Icons.search), onPressed: _startSearch),
      Container(
        child: Platform.isIOS
            ? CupertinoSwitch(
                value: controller.statustag.value == '1',
                activeTrackColor:  Colors.white,
                onChanged: (bool value) {
                  if (value) {
                    controller.statustag.value = '1';
                  } else {
                    controller.statustag.value = '0';
                  }
                  controller.getBeatListAPIDet(filtertype!, id!);
                },
              )
            : Switch(
                value: controller.statustag.value == '1',
                
                activeThumbColor: Colors.white,
                  //  activeThumbColor: kAppIconColor,
                onChanged: (bool value) {
                  if (value) {
                    controller.statustag.value = '1';
                  } else {
                    controller.statustag.value = '0';
                  }
                  controller.getBeatListAPIDet(filtertype!, id!);
                },
              ),
      ),
    ];
  }

  // List<Widget> _buildActions() {
  //   if (controller.isSearch.value) {
  //     return <Widget>[
  //       SizedBox(
  //         width: 200,
  //         child: TextField(
  //           controller: controller.searchController,
  //           autofocus: true,
  //           style: TextStyle(color: Colors.white),
  //           decoration: InputDecoration(
  //             hintText: 'Search...',
  //             hintStyle: TextStyle(color: Colors.white54),
  //             border: InputBorder.none,
  //           ),
  //           onChanged: onSearchTextChanged,
  //         ),
  //       ),
  //       IconButton(
  //         icon: const Icon(Icons.clear),
  //         onPressed: () {
  //           controller.searchController.clear();
  //           onSearchTextChanged('');
  //         },
  //       ),
  //     ];
  //   }

  //   return <Widget>[
  //     IconButton(icon: Icon(Icons.search), onPressed: _startSearch),

  //     Container(
  //       child: Platform.isIOS
  //           ? CupertinoSwitch(
  //               value: controller.statustag.value == '1',
  //               onChanged: (value) {
  //                 controller.statustag.value = value ? '1' : '0';
  //                 controller.getBeatListAPIDet(filtertype!, id!);
  //               },
  //             )
  //           : Switch(
  //               value: controller.statustag.value == '1',
  //               onChanged: (value) {
  //                 controller.statustag.value = value ? '1' : '0';
  //                 controller.getBeatListAPIDet(filtertype!, id!);
  //               },
  //             ),
  //     ),
  //   ];
  // }

  Widget _buildSearchField() {
    return TextField(
      controller: controller.searchController,
      autofocus: true,
      decoration: InputDecoration(
        hintText: 'Search...',
        border: InputBorder.none,
        hintStyle: const TextStyle(color: Colors.white30),
      ),
      style: TextStyle(color: Colors.white, fontSize: 16.0),
      onChanged: (text) {
        if (text == '') {
          controller.isSearch.value = false;
          onSearchTextChanged('');
        } else {
          onSearchTextChanged(text);

          controller.isSearch.value = true;
        }
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    if (filtertype!.toUpperCase() != 'PARTY' &&
        controller.isDataLoad.value == 0) {
      controller.getBeatListAPIDet(filtertype!, id!);
    }
    return Scaffold(
      // appBar: SfaCustomAppbar(
      //   title: controller.isSearch.value? _buildSearchField(): Text('Customer List',),//'Customer List',
      //   showDefaultActions: false,
      //   actions: filtertype == 'Party'
      //       ? null
      //       : [Obx(() => Row(children: _buildActions()))],
      // ),
      appBar: AppBar(
        flexibleSpace: Container(
          decoration: BoxDecoration(
            image: DecorationImage(
              image: AssetImage(ImageList.appbarImage),
              fit: BoxFit.cover,
            ),
          ),
        ),
        title: Obx(
          () => controller.isSearch.value
              ? _buildSearchField()
              : Text('Customer List'),
        ),
        actions: filtertype == 'Party'
            ? null
            : [Obx(() => Row(children: _buildActions()))],
      ),
      drawer: const DrawerForAll(),
      body: Padding(
        padding: EdgeInsets.fromLTRB(12, 8, 12, 8),
        child: Column(
          children: [
            filtertype == 'Party'
                ?
                  // Card(
                  //   shape: RoundedRectangleBorder(
                  //     borderRadius: BorderRadius.circular(12.0),
                  //   ),
                  //   child: Padding(
                  //     padding: EdgeInsets.all(3.0),
                  //     child: Column(
                  //       children: [
                  //         Row(
                  //           children: [
                  //             IconButton(
                  //               onPressed: () {
                  //                 Navigator.pop(context);
                  //               },
                  //               icon: Icon(Icons.arrow_back_ios_new_outlined,color: Colors.grey,size: 20.0,),
                  //             ),
                  //             Expanded(
                  //               child: TextFormField(
                  //                 textInputAction: TextInputAction.search,
                  //                 controller: partyNameController,
                  //                 decoration: InputDecoration(
                  //                   border: InputBorder.none,
                  //                   hintText: 'Search Customer',
                  //                   hintStyle: kTxtStl13B,
                  //                 ),
                  //                 keyboardType: TextInputType.text,
                  //                 autofocus: true,
                  //                 enabled: true,
                  //                 onFieldSubmitted: (value) {
                  //                   getBeatCustomerListApiDet(
                  //                 'Party', partyNameController.text);
                  //                 },
                  //                 style: kTxtStl13N,
                  //                 onChanged: (value) {
                  //                   setState(() {
                  //                     searchPartyChange = value != '' ? true : false;
                  //                   });
                  //                 },
                  //               ),
                  //             ),
                  //             searchPartyChange?
                  //             Row(
                  //               mainAxisSize: MainAxisSize.min,
                  //               children: [
                  //                 IconButton(
                  //                   onPressed: () {
                  //                     partyNameController.text = '';
                  //                     isDataLoad = 2;
                  //                     searchPartyChange = false;
                  //                     setState(() {});
                  //                   },
                  //                   icon: Icon(Icons.close,size: 18,color: Color.fromARGB(255, 8, 5, 5),)
                  //                 ),
                  //                 IconButton(
                  //                   onPressed: () {
                  //                     getBeatCustomerListApiDet('Party',partyNameController.text);
                  //                   },
                  //                   icon: Icon(Icons.search)
                  //                 ),
                  //               ],
                  //             )
                  //             : Container(
                  //               child: Icon(Icons.search,color: Colors.grey,),
                  //             ),
                  //           ]
                  //         ),
                  //       ],
                  //     ),
                  //   ),
                  // )
                  Obx(
                    () => Card(
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12.0),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(3.0),
                        child: Row(
                          children: [
                            IconButton(
                              onPressed: () => Get.back(),
                              icon: Icon(
                                Icons.arrow_back_ios_new_outlined,
                                color: Colors.grey,
                                size: 20,
                              ),
                            ),

                            Expanded(
                              child: TextFormField(
                                controller: controller.partyNameController,
                                textInputAction: TextInputAction.search,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  hintText: 'Search Customer',
                                ),
                                onFieldSubmitted: (value) {
                                  controller.searchParty('Party');
                                },
                                onChanged: (value) {
                                  controller.searchPartyChange.value =
                                      value.isNotEmpty;
                                },
                              ),
                            ),

                            controller.searchPartyChange.value
                                ? Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      IconButton(
                                        icon: Icon(Icons.close, size: 18),
                                        onPressed: controller.clearSearch,
                                      ),
                                      IconButton(
                                        icon: Icon(Icons.search),
                                        onPressed: () {
                                          controller.searchParty('Party');
                                        },
                                      ),
                                    ],
                                  )
                                : Icon(Icons.search, color: Colors.grey),
                          ],
                        ),
                      ),
                    ),
                  )
                : Container(),
            // Row(
            //   children: [
            //     SizedBox(width: size.width * 0.20, child: Text('Location')),
            //     Expanded(
            //       child: Card(
            //         elevation: 3.0,
            //         shape: RoundedRectangleBorder(
            //           borderRadius: BorderRadius.circular(12.0),
            //           side: BorderSide(
            //             color: Colors.grey, // Border color
            //             width: 1.5, // Border width
            //           ),
            //         ),
            //         child: ListTile(
            //           title: Text('Ghatkopar', style: kTxtStl13B),
            //           trailing: Icon(Icons.arrow_drop_down),
            //           onTap: () {},
            //         ),
            //       ),
            //     ),
            //   ],
            // ),
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
                  itemCount: controller.customerListData.length,
                  itemBuilder: (context, i) {
                    final item = controller.customerListData[i];
                    return Column(
                      children: [
                        InkWell(
                          child: Card(
                            child: Padding(
                              padding: EdgeInsets.all(8.0),
                              child: Row(
                                children: [
                                  Expanded(
                                    child: Column(
                                      mainAxisAlignment:
                                          MainAxisAlignment.start,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          mainAxisAlignment:
                                              MainAxisAlignment.spaceBetween,
                                          children: [
                                            Text(
                                              item.pARTYNAME!,
                                              style: kTxtStl13B,
                                            ),
                                            item.lONGITUDE! == '' &&
                                                    item.lATITUDE! == ''
                                                ? Container()
                                                : InkWell(
                                                    child: Image.asset(
                                                      ImageList.googleMapImage,
                                                      height:
                                                          size.height * 0.03,
                                                      width: size.width * 0.1,
                                                    ),
                                                    onTap: () {
                                                      Get.to(
                                                        () => GetCurrentLocation(
                                                          latitude:
                                                              item.lATITUDE!,
                                                          longitude:
                                                              item.lONGITUDE!,
                                                          partyname:
                                                              item.pARTYNAME!,
                                                          custclassfication: item
                                                              .cUSTCLASSIFICATION!,
                                                        ),
                                                      );
                                                    },
                                                  ),
                                          ],
                                        ),
                                        SizedBox(height: size.height * 0.01),
                                        Row(
                                          children: [
                                            retailerListTitleRow(
                                              'Mobile No. ',
                                              item.cONTACTNUMBER!,
                                              size: size.width * 0.25,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            retailerListTitleRow(
                                              'Classification',
                                              item.cUSTCLASSIFICATION!,
                                              size: size.width * 0.25,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            retailerListTitleRow(
                                              'Price Level',
                                              item.pRICELEVEL!,
                                              size: size.width * 0.25,
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            retailerListTitleRow(
                                              'Curr Month',
                                              Utility.formattedNumber.format(
                                                item.sALESCURRENTMONTH!,
                                              ),
                                              size: size.width * 0.25,
                                            ),
                                            retailerListTitleRow(
                                              'Last Month',
                                              Utility.formattedNumber.format(
                                                item.sALESCURRENTMONTH!,
                                              ),
                                            ),
                                          ],
                                        ),
                                        // Row(
                                        //   children: [
                                        //     retailerListTitleRow(
                                        //       'Growth %',
                                        //       '${item.gROWTH! == 0 ? 'NA' : item.gROWTH!.toString()}',

                                        //       // 'NA',
                                        //       size: size.width * 0.25,
                                        //     ),
                                        //   ],
                                        // ),
                                        Row(
                                          children: [
                                            Container(
                                              width: size.width * 0.25,
                                              child: Text(
                                                'Growth %',
                                                style: kTxtStl13N,
                                              ),
                                            ),
                                            Text(': ', style: kTxtStl13N),
                                            Text(
                                              '${item.gROWTH! == 0.0 ? 'NA' : item.gROWTH!.toStringAsFixed(2)}',
                                              style: TextStyle(
                                                fontSize: 13.0,
                                                color: item.gROWTH != 0.0
                                                    ? (item.gROWTH!.isNegative)
                                                          ? Colors.red
                                                          : Colors.green
                                                    : Colors.black,
                                              ),
                                            ),

                                            Text(
                                              '${item.gROWTH != 0.0
                                                  ? (item.gROWTH!.isNegative)
                                                        ? '↓'
                                                        : '↑'
                                                  : ''}',
                                              style: TextStyle(
                                                fontSize: 19.0,
                                                fontWeight: FontWeight.w900,
                                                color: item.gROWTH != 0.0
                                                    ? (item.gROWTH!.isNegative)
                                                          ? Colors.red
                                                          : Colors.green
                                                    : null,
                                              ),
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
                            var navValue = await Get.to(
                              () => RetailerDetails(
                                pARTYID: controller.customerListData[i].pARTYID,
                                pARTYNAME:
                                    controller.customerListData[i].pARTYNAME,
                                latitude:
                                    controller.customerListData[i].lATITUDE,
                                longitude:
                                    controller.customerListData[i].lONGITUDE,
                                mobileNo: controller
                                    .customerListData[i]
                                    .cONTACTNUMBER,
                                priceLevel:
                                    controller.customerListData[i].pRICELEVEL,
                                custclassfication: controller
                                    .customerListData[i]
                                    .cUSTCLASSIFICATION,
                              ),
                            );

                            if (navValue != null) {
                              controller.getBeatListAPIDet(filtertype!, id!);
                            }
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
